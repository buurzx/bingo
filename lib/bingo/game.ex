defmodule Bingo.Game do
  @moduledoc """
  Game struct.
  """

  alias Bingo.{Buzzwords, Game, Square, BingoChecker}

  @enforce_keys [:squares]
  defstruct squares: nil, scores: %{}, winner: nil

  @doc """
  Creates a new Game struct.
  """
  def new(size) when is_integer(size) do
    buzzwords = Buzzwords.read()
    Game.new(buzzwords, size)
  end

  @doc """
  Creates new Game struct
  """
  def new(buzzwords, size) do
    squares =
      buzzwords
      |> Enum.shuffle()
      |> Enum.take(size * size)
      |> Enum.map(&Square.from_buzzwords/1)
      |> Enum.chunk_every(size)

    %Game{squares: squares}
  end

  def mark(game, phrase, player) do
    game
    |> update_squares_with_mark(phrase, player)
    |> update_scores()
    |> assign_winner_if_bingo(player)
  end

  defp update_squares_with_mark(game, phrase, player) do
    squares =
      game.squares
      |> List.flatten()
      |> Enum.map(&mark_square_by_player(&1, phrase, player))
      |> Enum.chunk_every(Enum.count(game.squares))

    %{game | squares: squares}
  end

  defp mark_square_by_player(square, phrase, player) do
    case square.phrase == phrase do
      true -> %{square | marked_by: player}
      false -> square
    end
  end

  defp update_scores(game) do
    scores =
      game.squares
      |> List.flatten()
      |> Enum.reject(&is_nil(&1.marked_by))
      |> Enum.reduce(%{}, fn square, acc ->
        Map.update(acc, square.marked_by.name, square.points, &(&1 + square.points))
      end)

    %{game | scores: scores}
  end

  defp assign_winner_if_bingo(game, player) do
    case BingoChecker.bingo?(game.squares) do
      true -> %{game | winner: player}
      false -> game
    end
  end
end
