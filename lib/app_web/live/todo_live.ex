defmodule AppWeb.TodoLive do
  use Phoenix.LiveView
  alias App.Todos
  alias AppWeb.TodoView

  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end

  def mount(_session, socket) do
    Todos.subscribe()

    {:ok, put_date(socket)}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, put_date(socket)}
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    {:noreply, put_date(socket)}
  end

  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, put_date(socket)}
  end

  def handle_event("show_done", _, socket) do
    {:noreply, put_date(socket, true)}
  end

  def handle_event("hide_done", _, socket) do
    {:noreply, put_date(socket)}
  end

  defp put_date(socket, show_done \\ false) do
    assign(socket, todos: Todos.list_todos(), show_done: show_done)
  end
end
