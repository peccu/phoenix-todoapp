defmodule AppWeb.TodoLive do
  use Phoenix.LiveView
  alias App.Todos
  alias AppWeb.TodoView

  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end

  def mount(_session, socket) do
    Todos.subscribe()

    {:ok, put_date(assign(socket, show_done: false, in_edit: false))}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, put_date(assign(socket, show_done: false, in_edit: false))}
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    {:noreply, put_date(assign(socket, show_done: false, in_edit: false))}
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
    {:noreply, put_date(assign(socket, in_edit: true))}
  end

  def handle_event("save", %{"id" => id, "title" => title}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{title: title})
    {:noreply, put_date(assign(socket, in_edit: false))}
  end

  def handle_event("discard", %{"id" => _id}, socket) do
    {:noreply, put_date(assign(socket, in_edit: false))}
  end

  defp put_date(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end
