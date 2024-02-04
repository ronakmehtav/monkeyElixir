defmodule MonkeyLexerTest do
  use ExUnit.Case, async: true

  test "basic tokens" do
    input_string = "=+(){},;`"

    expected_output = [
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

    assert Monkey.Lexer.init(input_string) == expected_output
  end

  test "numbers are available" do
    input_string = "142 + 25"
    expected_output = [{:int, "142"}, :plus, {:int, "25"}, :eof]
    assert Monkey.Lexer.init(input_string) == expected_output
  end

  test "Equal or not Equal" do
    input_string = "2 != 4"
    expected_output = [{:int, "2"}, :notEqual, {:int, "4"}, :eof]
    assert Monkey.Lexer.init(input_string) == expected_output
    input_string = "true == true"
    expected_output = [true, :equal, true, :eof]
    assert Monkey.Lexer.init(input_string) == expected_output
  end

  test "keywords inital" do
    input_string = "let a = fn x -> x + 31;"

    expected_output = [
      :let,
      {:ident, "a"},
      :assign,
      :function,
      {:ident, "x"},
      :minus,
      :greaterThan,
      {:ident, "x"},
      :plus,
      {:int, "31"},
      :semicolon,
      :eof
    ]

    assert Monkey.Lexer.init(input_string) == expected_output
  end

  test "Boolean and return" do
    input_string = """
    !-/*5;
    5 < 10 > 5;
       if (5 < 10) {
           return true;
       } else {
           return false;
    }
    """

    expected_output = [
      :bang,
      :minus,
      :slash,
      :asterik,
      {:int, "5"},
      :semicolon,
      {:int, "5"},
      :lessThan,
      {:int, "10"},
      :greaterThan,
      {:int, "5"},
      :semicolon,
      :if,
      :lparen,
      {:int, "5"},
      :lessThan,
      {:int, "10"},
      :rparen,
      :lsquirly,
      :return,
      true,
      :semicolon,
      :rsquirly,
      :else,
      :lsquirly,
      :return,
      false,
      :semicolon,
      :rsquirly,
      :eof
    ]

    assert Monkey.Lexer.init(input_string) == expected_output
  end
end
