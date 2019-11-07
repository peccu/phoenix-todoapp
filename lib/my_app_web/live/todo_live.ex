defmodule MyAppWeb.TodoLive do
  use Phoenix.LiveView
  alias MyApp.Todos
  alias MyAppWeb.TodoView

  def render(assigns) do
    TodoView.render("todos.html", assigns)
  end

  def mount(_session, socket) do
    # if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
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
