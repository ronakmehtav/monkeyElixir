defmodule Monkey.Lexer do
  @moduledoc """
  This Lexer Module Perform the Lexing/Tokening the input for the parser.
  """
  @type keyword_token ::
          :function
          | :let
          | :if
          | :else
          | :return
          | true
          | false

  @type token ::
          :assign
          | :equal
          | :notEqual
          | :plus
          | :minus
          | :bang
          | :slash
          | :asterik
          | :lessThan
          | :greaterThan
          | :lparen
          | :rparen
          | :lsquirly
          | :rsquirly
          | :comma
          | :semicolon
          | :eof
          | keyword()
          | {:ident, String.t()}
          | {:int, String.t()}
          | {:illegal, String.t()}

  # Checks White space
  defguardp is_whitespace(c) when c in ~c[\s\r\n\t]
  # Checks a number
  defguardp is_digit(c) when c in ?0..?9
  # Checks a letter
  defguardp is_letter(c) when c in ?a..?z or c in ?A..?Z or c == ?_

  @doc """
    Returns the List of token from the string.
    
    ## Example
    iex> Monkey.Lexer.init("{ 132 + 14 };")
    [
      :lsquirly,
      {:int, "132"},
      :plus,
      {:int, "14"},
      :rsquirly,
      :semicolon,
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
      <<"==", rest::binary>> -> {:equal, rest}
      <<"!=", rest::binary>> -> {:notEqual, rest}
      <<">", rest::binary>> -> {:greaterThan, rest}
      <<"<", rest::binary>> -> {:lessThan, rest}
      <<"=", rest::binary>> -> {:assign, rest}
      <<"-", rest::binary>> -> {:minus, rest}
      <<"+", rest::binary>> -> {:plus, rest}
      <<"*", rest::binary>> -> {:asterik, rest}
      <<"!", rest::binary>> -> {:bang, rest}
      <<"/", rest::binary>> -> {:slash, rest}
      <<"(", rest::binary>> -> {:lparen, rest}
      <<")", rest::binary>> -> {:rparen, rest}
      <<"{", rest::binary>> -> {:lsquirly, rest}
      <<"}", rest::binary>> -> {:rsquirly, rest}
      <<",", rest::binary>> -> {:comma, rest}
      <<";", rest::binary>> -> {:semicolon, rest}
      <<c::8, rest::binary>> when is_letter(c) -> read_identifier(rest, <<c>>)
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

  # Reads the identifier until a non letter character and then return the identifier token and rest of the data.
  @spec read_identifier(input :: String.t(), iodata()) :: {token(), rest :: String.t()}
  defp read_identifier(input, acc) do
    case input do
      <<c::8, rest::binary>> when is_letter(c) ->
        read_identifier(rest, [acc | <<c>>])

      # this is the catchall and needs to be last, In this coding style.
      <<rest::binary>> ->
        {tokenizeWord(IO.iodata_to_binary(acc)), rest}
    end
  end

  # Returns the associated token for the identifier or the keyword.
  @spec tokenizeWord(word :: String.t()) :: token()
  defp tokenizeWord(word) do
    case word do
      "fn" -> :function
      "let" -> :let
      "if" -> :if
      "else" -> :else
      "return" -> :return
      "true" -> true
      "false" -> false
      # this is the catchall and needs to be last, In this coding style.
      x -> {:ident, x}
    end
  end
end
