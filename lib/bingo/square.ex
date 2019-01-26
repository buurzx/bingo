defmodule Bingo.Square do
  @enforce_keys [:phrase, :points]

  defstruct [:marked_by, :phrase, :points]

  alias __MODULE__

  @spec new(String.t(), integer()) :: struct()
  def new(phrase, points) when is_integer(points) do
    %Square{phrase: phrase, points: points}
  end

  @spec from_buzzwords([...]) :: struct()
  def from_buzzwords([phrase, points]) when is_binary(phrase) when is_binary(points) do
    Square.new(phrase, String.to_integer(points))
  end
end
