defmodule Bingo.Buzzwords do
  @spec read() :: [[String.t()]]
  def read do
    "../../data/buzzwords.csv"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split([",", "\n"], trim: true)
    |> Enum.chunk_every(2)
  end
end
