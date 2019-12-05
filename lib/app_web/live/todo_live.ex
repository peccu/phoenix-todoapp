defmodule AppWeb.TodoLive do
  use Phoenix.LiveView
  alias App.Todos
  alias AppWeb.TodoView
  require Logger

  def render(assigns) do
    TodoView.render("todos.html", assigns)
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
