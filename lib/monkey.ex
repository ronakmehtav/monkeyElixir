defmodule Monkey do
  @moduledoc """
  The interpretor which will run the code.
  """

  def init() do
    Monkey.Repl.start()
  end
end
