defmodule CliTest do
  use ExUnit.Case

  import FullBoardNirvana.CLI, only: [parse_args: 1, print_welcome_message: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["-help", "anything"]) == :help
  end

  test "count is returned if provided by the user" do
    assert parse_args(["10"]) == 10
  end

  test "count is defaulted if not provided by the user" do
    assert parse_args([]) == 25
  end

  test "print_welcome_message returns number of rounds given" do
    assert print_welcome_message(20) == 20
  end

end
