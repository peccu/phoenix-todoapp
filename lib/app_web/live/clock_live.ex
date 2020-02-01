defmodule AppWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>
        It's <%= @date %>
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
    date =
      Timex.now()
      |> Timex.to_datetime("Asia/Tokyo")
      |> Timex.format!("{h12}:{m}:{s}{am}")

    assign(socket, date: date)
  end
end
