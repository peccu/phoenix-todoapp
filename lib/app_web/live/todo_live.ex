defmodule AppWeb.TodoLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias App.Todos
  require Logger

  # pattern is from https://github.com/bryanwoods/autolink-js/blob/master/autolink.js
  @url_pattern ~r/(^|[\s\n]|<[A-Za-z]*\/?>)((?:https?|ftp):\/\/[\-A-Za-z0-9+@#\/%?=()~_|!:,.;]*[\-A-Za-z0-9+@#\/%=~()_|])/

  def url_to_safelink(_all, prev, url) do
    link =
      Phoenix.HTML.Link.link(url, to: url, target: "_blank")
      |> Phoenix.HTML.safe_to_string()

    prev <> link
  end

  def autolinker(text) do
    safe_text =
      text
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()

    @url_pattern
    |> Regex.replace(safe_text, &url_to_safelink/3)
  end

  def render(assigns) do
    ~L"""
      <div>
      <%= if @show_done do %>
        <center><button phx-click="hide_done">Hide Done</button></center>
      <% else %>
        <center><button phx-click="show_done">Show Done</button></center>
      <% end %>
      </div>
      <table>
        <tr>
          <th>Done</th>
          <th>ID</th>
          <th>Title</th>
          <th>Action</th>
        </tr>
      <%= for todo <- @todos do %>
        <%= if @show_done || not todo.done do %>
        <tr>
          <td><%= checkbox(:todo, :done, phx_click: "toggle_done", phx_value_id: todo.id, value: todo.done) %></td>
          <td><%= todo.id %></td>
          <%= if @in_edit != todo.id do %>
          <td><%= todo.title |> autolinker |> raw %></td>
          <td>
            <center>
              <%= if @in_edits |> Enum.member?(todo.id) do %>
              <button phx-click="start_edit" phx-value-id="<%= todo.id %>" disabled>Someone is Editing</button>
              <% else %>
              <button phx-click="start_edit" phx-value-id="<%= todo.id %>">Edit</button>
              <% end %>
            </center>
          </td>
          <% else %>
          <td colspan=2>
            <form action="#" phx-submit="save">
              <%= hidden_input :todo, :id, value: todo.id %>
              <%= text_input :todo, :title, value: todo.title %>
              <%= submit "Save", phx_disable_with: "Saving..." %>
              <button type="cancel" onclick="return false;" phx-click="discard" phx-value-id="<%= todo.id %>">Discard</button>
            </form>
          </td>
          <% end %>
        </tr>
        <% end %>
      <% end %>
      </table>
      <form action="#" phx-submit="add">
        <%= text_input :todo, :title, placeholder: "What do you want to get done?" %>
        <%= submit "Add", phx_disable_with: "Adding..." %>
      </form>
    """
  end

  def mount(_session, socket) do
    Todos.subscribe()

    {:ok, socket |> put_default() |> put_date()}
  end

  # PubSub Topic
  def handle_info({Todos, [:todo, :start_editing], id}, socket) do
    Logger.info("START EDIT ID:#{id} by others")

    socket =
      socket
      |> assign(in_edits: socket.assigns.in_edits ++ [id])
      |> put_date()

    {:noreply, socket}
  end

  def handle_info({Todos, [:todo, :end_editing], id}, socket) do
    Logger.info("END EDIT ID:#{id} by others")

    socket =
      socket
      |> assign(in_edits: socket.assigns.in_edits -- [id])
      |> put_date()

    {:noreply, socket}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, put_date(socket)}
  end

  # LiveView Events
  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    {:noreply, socket |> put_default() |> put_date()}
  end

  # toggle list
  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, put_date(socket)}
  end

  def handle_event("show_done", _, socket) do
    {:noreply, put_date(assign(socket, show_done: true))}
  end

  def handle_event("hide_done", _, socket) do
    {:noreply, put_date(assign(socket, show_done: false))}
  end

  # edit todo
  def handle_event("start_edit", var, socket) do
    var |> IO.inspect()
    id = String.to_integer(var["id"])
    Logger.info("START EDIT ID:#{id}")
    id |> Todos.start_edit_todo()
    {:noreply, socket |> start_edit(id) |> put_date()}
  end

  def handle_event("save", %{"todo" => %{"id" => id, "title" => title}}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{title: title})
    Logger.info("SAVE ID:#{id}")
    id = String.to_integer(id)
    id |> Todos.end_edit_todo()
    {:noreply, socket |> end_edit() |> put_date()}
  end

  def handle_event("discard", %{"id" => id}, socket) do
    Logger.info("DISCARD ID:#{id}")
    id = String.to_integer(id)
    id |> Todos.end_edit_todo()
    {:noreply, socket |> end_edit() |> put_date()}
  end

  # Private Functions
  defp put_default(socket) do
    socket
    |> assign(show_done: false)
    |> assign(in_edits: [])
    |> assign(in_edit: 0)
  end

  defp start_edit(socket, id) do
    socket.assigns.in_edit |> Todos.end_edit_todo()

    socket
    |> assign(in_edits: socket.assigns.in_edits -- [socket.assigns.in_edit])
    |> assign(in_edit: id)
  end

  defp end_edit(socket) do
    socket
    |> assign(in_edits: socket.assigns.in_edits -- [socket.assigns.in_edit])
    |> assign(in_edit: 0)
  end

  defp put_date(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end
