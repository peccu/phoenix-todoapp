defmodule AppWeb.ClockLive do
  use Phoenix.LiveView
  alias App.Todos
  alias AppWeb.ClockView

  def render(assigns) do
    ClockView.render("clock.html", assigns)
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
    assign(socket,
      salutation: salutation,
      date: :calendar.local_time())
  end
end
