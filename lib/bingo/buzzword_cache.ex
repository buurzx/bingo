defmodule Bingo.BuzzwordCache do
  @moduledoc """
  Loads collection of buzzwords from an external source and caches them for expedient access.
  Automatically refreshed every hour.
  """

  use GenServer

  @refresh_interval :timer.minutes(60)

  #  Client

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_buzzwords do
    GenServer.call(__MODULE__, :get_buzzwords)
  end

  # Server

  @spec init(:ok) :: {:ok, [[String.t()]]}
  def init(:ok) do
    state = load_buzzwords()
    schedule_refresh()
    {:ok, state}
  end

  def handle_call(:get_buzzwords, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:refersh, _state) do
    state = load_buzzwords()
    schedule_refresh()
    {:noreply, state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp load_buzzwords do
    Bingo.Buzzwords.read()
  end
end
