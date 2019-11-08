defmodule AppWeb.TodoLive do
  use Phoenix.LiveView
  alias App.Todos
  alias AppWeb.TodoView

  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end

  def mount(_session, socket) do
    # if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    Todos.subscribe()

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
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

  defp put_date(socket) do
    salutation = "Welcome to LiveView, from the Programming Phoenix team!"
    assign(socket,
      salutation: salutation,
      date: :calendar.local_time(),
      todos: Todos.list_todos())
  end
end