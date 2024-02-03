defmodule Monkey.Lexer do
  @moduledoc """
  This Lexer Module Perform the Lexing/Tokening the input for the parser.
  """

  @type token ::
          :assign
          | :plus
          | :minus
          | :lparen
          | :rparen
          | :lsquirly
          | :rsquirly
          | :comma
          | :semicolon
          | :eof
          | {:int, String.t()}
          | {:illegal, String.t()}

  # Checks White space
  defguardp is_whitespace(c) when c in ~c[\s\r\n\t]
  # Checks a number
  defguardp is_digit(c) when c in ?0..?9

  @doc """
    Returns the List of token from the string.
    
    ## Example
    iex> Monkey.Lexer.init("=+(){},;`")
    [
      :assign,
      :plus,
      :lparen,
      :rparen,
      :lsquirly,
      :rsquirly,
      :comma,
      :semicolon,
      {:illegal, "`"},
      :eof
    ]
  """
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

  # Extracts the token and return it and the rest of the string.
  @spec tokenize(input :: String.t()) :: {token(), rest :: String.t()}
  defp tokenize(input) do
    case input do
      <<"=", rest::binary>> -> {:assign, rest}
      <<"-", rest::binary>> -> {:plus, rest}
      <<"+", rest::binary>> -> {:plus, rest}
      <<"(", rest::binary>> -> {:lparen, rest}
      <<")", rest::binary>> -> {:rparen, rest}
      <<"{", rest::binary>> -> {:lsquirly, rest}
      <<"}", rest::binary>> -> {:rsquirly, rest}
      <<",", rest::binary>> -> {:comma, rest}
      <<";", rest::binary>> -> {:semicolon, rest}
      <<c::8, rest::binary>> when is_digit(c) -> read_number(rest, <<c>>)
      # The illegal is the catchall needs to be last. In this coding style.
      <<c::8, rest::binary>> -> {{:illegal, <<c>>}, rest}
    end
  end

  # Reads the number until a non digit character and then return the number token and rest of the data.
  @spec read_number(input :: String.t(), iodata()) :: {token(), rest :: String.t()}
  defp read_number(input, acc) do
    case input do
      <<c::8, rest::binary>> when is_digit(c) ->
        read_number(rest, [acc | <<c>>])

      # this is the catchall and needs to be last, In this coding style.
      <<rest::binary>> ->
        {{:int, IO.iodata_to_binary(acc)}, rest}
    end
  end
end
