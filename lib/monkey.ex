defmodule Monkey do
  @moduledoc """
  Documentation for `Monkey`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Monkey.hello()
      :world

  """
  def hello do
    :world
  end

  def x() do
    hello()
  end
end
