defmodule MyAppWeb.TodoLive do
  use Phoenix.LiveView
  import Calendar.Strftime

  def render(assigns) do
    ~L"""
    <div>
      <h2><%= @salutation %></h2>
      <h2>It's <%= strftime!(@date, "%r") %></h2>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  defp put_date(socket) do
    salutation = "Welcome to LiveView, from the Programming Phoenix team!"
    assign(socket, salutation: salutation, date: :calendar.local_time())
  end
end
