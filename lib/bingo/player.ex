defmodule Bingo.Player do
  @enforce_keys [:name, :color]
  defstruct name: nil, color: nil

  alias __MODULE__

  @spec new(String.t(), String.t()) :: struct()
  def new(name, color) when is_binary(name) when is_binary(color) do
    %Player{name: name, color: color}
  end
end
