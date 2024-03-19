defmodule Monkey.Parser.LetStatement do
  defstruct ident: nil, expression: nil
end

defmodule Monkey.Parser do
  @moduledoc """
  Takes token Creates the AST.
  """
  alias Monkey.Parser.LetStatement

  # Let StateMent 
  # let <identifier> = <expression>; 
  # We need a parse function which will take the token list
  # Case Match Let
  def parse(list) do
    output = parse(list, [])
    elem(output, 1)
  end

  defp parse([], tree) do
    {[], tree}
  end

  defp parse([:eof], tree) do
    {[], tree}
  end

  defp parse([:let | rest], tree) do
    case rest do
      [{:ident, ident} | [:assign | rest_after_assign]] ->
        case parse(rest_after_assign, []) do
          {[:semicolon | rest_after_semicolon], expression} ->
            node = %LetStatement{ident: {:ident, ident}, expression: expression}
            parse(rest_after_semicolon, [node | tree])

          _ ->
            raise "SyntaxError: Expected Semicolon"
        end

      _ ->
        raise "Syntax Error: Expected Identifier and Assign"
    end
  end

  defp parse([_ | rest], tree) do
    {rest, tree}
  end
end
