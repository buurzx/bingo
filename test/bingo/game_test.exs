defmodule Bingo.GameTest do
  use ExUnit.Case, async: true

  alias Bingo.{Game, Player, Square, Buzzwords}

  setup do
    [
      player_1: Player.new("Nicole", "green"),
      player_2: Player.new("Mike", "blue"),

      # Grid of squares with preset buzzwords (letters)
      # so the tests are consistent.
      squares: [
        [sq("A", 10), sq("B", 20), sq("C", 30)],
        [sq("D", 10), sq("E", 20), sq("F", 30)],
        [sq("G", 10), sq("H", 20), sq("I", 30)]
      ]
    ]
  end

  describe "create game" do
    test "new", context do
      game = new_game(context.squares)

      assert game.scores == %{}
      assert game.winner == nil
      assert game.squares == context.squares
    end

    test "with a list of buzzwords and a size" do
      game = Game.new(Buzzwords.read(), 3)

      assert_game_size(game, 3)
    end

    test "with a size" do
      game = Game.new(3)

      assert_game_size(game, 3)
    end

    defp assert_game_size(game, size) do
      row_count = Enum.count(game.squares)

      assert row_count == size

      first_row = Enum.at(game.squares, 0)

      column_count = Enum.count(first_row)

      assert column_count == row_count

      assert %Square{} = Enum.at(first_row, 0)
    end
  end

  # Convenience for creating a square. Short function
  # name makes the grid visually easier to parse.
  defp sq(phrase, points) do
    Square.new(phrase, points)
  end

  defp new_game(squares) do
    %Game{squares: squares}
  end
end
