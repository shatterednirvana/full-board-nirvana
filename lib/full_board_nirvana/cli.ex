defmodule FullBoardNirvana.CLI do

  @default_rounds 25

  @moduledoc """
  Handle the command-line parsing and dispatch to the various functions
  representing chess learning exercises.
  """

  def run(argv) do
    argv
      |> parse_args
      |> print_welcome_message
      |> quiz_user
      |> generate_report
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is either nothing, or (optionally) the number of squares we
  should quiz the user about for this exercise.
  
  Returns :help (if help was given), or count, the number of squares to quiz
  the user about.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
      aliases: [h: :help])

    case parse do
      {[help: true], _, _}
        -> :help

      {_, [rounds], _}
        -> binary_to_integer(rounds)

      _ -> @default_rounds
    end
  end

  @doc """
  Prints the usage for this program and exits.
  """
  def print_welcome_message(:help) do
    IO.puts """
    usage: full_board_nirvana [rounds | #{@default_rounds}]
    """
    System.halt(0)
  end

  @doc """
  Prints information about how users indicate that a square is either black or
  white.

  Returns the number of questions (rounds) that will be asked.
  """
  def print_welcome_message(rounds) do
    IO.puts """
    Hello! This program will pick a random square on the chessboard #{rounds}
    times. It will ask you if the square is black or white. You can indicate
    that the square is black by entering in "black", "b", or "1". You can
    indicate that the square is white by entering in "white", "w", or "2".

    Let's begin!
    """
    rounds
  end

  @doc """
  Asks the user a series of questions about whether random squares on a
  chessboard are white or black.

  Returns {correct_answers, total_questions}. In the future we
  should consider expanding this to return more detailed information. In
  particular, we could gain more insight by returning a list, where each item
  indicates if the question was answered correctly or not, what square was
  chosen, and how long it took the user to respond.
  """
  def quiz_user(total_questions) do
    {0, total_questions}
  end

  @doc """
  Prints information about how many questions the user got right.

  In the future, this may be expanded to include more intelligent information,
  such as insights into specific parts of the board that the user has strong
  or weak visualization on (also possibly taking into account how long it takes
  to get a correct answer).
  """
  def generate_report({correct_answers, total_questions}) do
    percentage = correct_answers / total_questions
    IO.puts """
    You successfully answered #{correct_answers} out of #{total_questions}
    questions (#{percentage}%).
    """
  end

end
