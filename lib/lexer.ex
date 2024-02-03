defmodule Monkey.Lexer do
  @moduledoc """
  This Lexer Module Perform the Lexing/Tokening the input for the parser.
  """

  @type token ::
          :assign
          | :plus
          | :lparen
          | :rparen
          | :lsquirly
          | :rsquirly
          | :comma
          | :semicolon
          | :eof
          | {:illegal, String.t()}

  # Removes White space
  defguardp is_whitespace(c) when c in ~c[\s\r\n\t]

  @spec init(String.t()) :: [token()]
  def init(input) when is_binary(input) do
    lex(input, [])
  end

  # If at the end add EOF and return the tokens
  @spec lex(input :: String.t(), [token()]) :: [token()]
  defp lex(<<>>, tokens) do
    [:eof | tokens] |> Enum.reverse()
  end

  # Ignore White Spaces
  defp lex(<<c::8, rest::binary>>, tokens) when is_whitespace(c) do
    lex(rest, tokens)
  end

  # Takes a input string and generates Tokes
  defp lex(input, tokens) do
    {token, rest} = tokenize(input)
    lex(rest, [token | tokens])
  end

  @spec tokenize(input :: String.t()) :: {token(), rest :: String.t()}
  defp tokenize(input) do
    case input do
      <<"=", rest::binary>> -> {:assign, rest}
      <<"+", rest::binary>> -> {:plus, rest}
      <<"(", rest::binary>> -> {:lparen, rest}
      <<")", rest::binary>> -> {:rparen, rest}
      <<"{", rest::binary>> -> {:lsquirly, rest}
      <<"}", rest::binary>> -> {:rsquirly, rest}
      <<",", rest::binary>> -> {:comma, rest}
      <<";", rest::binary>> -> {:semicolon, rest}
      <<c::8, rest::binary>> -> {{:illegal, <<c>>}, rest}
    end
  end
end
