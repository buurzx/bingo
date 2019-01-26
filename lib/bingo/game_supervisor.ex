defmodule Bingo.GameSupervisor do
  @moduledoc """
  Starts Game server processes dynamically
  """

  use DynamicSupervisor

  alias Bingo.GameServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a Game Server process and dynamically supervises it
  """
  @spec start_game(String.t(), integer()) :: {:error, any()} | {:ok, pid()}
  def start_game(game_name, size) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [game_name, size]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates GameServer normally, it won't be restarted
  """
  def stop_game(game_name) do
    :ets.delete(:games_table, game_name)

    child_pid = GameServer.game_pid(game_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
