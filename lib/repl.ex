defmodule Monkey.Repl do
  @moduledoc """
   Repl for the Monkey Lang.
  """
  def start() do
    IO.write("Enter Something\n")
    input = IO.gets(">>")
    Monkey.Lexer.init(input) |> IO.inspect()
    start()
  end
end

