defmodule FullBoardNirvana.CLI do

  @default_rounds 25

  @moduledoc """
  Handle the command-line parsing and dispatch to the various functions
  representing chess learning exercises.
  """

  def run(argv) do
    :random.seed(:erlang.now())

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
    results = ask_question(total_questions)
    correct_answers = Enum.count(results, fn(x) -> x == true end)
    {correct_answers, total_questions}
  end

  @doc """
  Does nothing, since there are no more questions to ask the user.
  """
  def ask_question(0) do
    []
  end

  @doc """
  Determines if the user is able to correctly identify the color of a single
  chess square, and then recursively calls itself to ask as many questions as
  the user would like.

  Returns a list of booleans, where each boolean corresponds to true if the
  user answered the question correctly, and false otherwise.
  """
  def ask_question(total_questions) do
    {square, color} = generate_square()

    # ask the user if it's black or white
    answer = get_response(square)

    # see if they're correct
    this_answer = (color == answer)
    check_response(this_answer)

    # ask more questions
    [this_answer | ask_question(total_questions - 1)]
  end

  @doc """
  Generates a random square on the chessboard, and calculates the color it maps
  to.

  Returns {square, color}, where square corresponds to a chess square in the
  range a1 -> h8, and color is either black or white, based on the color of the
  generated square.
  """
  def generate_square() do
    rank = :random.uniform(8)
    file = :random.uniform(8)

    square = map_rank_and_file_to_square(rank, file)
    color = map_rank_and_file_to_color(rank, file)

    {square, color}
  end

  def map_rank_and_file_to_square(rank, file) do
    a = case rank do
      1 ->
        "a"
      2 ->
        "b"
      3 ->
        "c"
      4 ->
        "d"
      5 ->
        "e"
      6 ->
        "f"
      7 ->
        "g"
      8 ->
        "h"
    end

    "#{a}#{file}"
  end

  def map_rank_and_file_to_color(rank, file) do
    case rem(rank + file, 2) do
      0 ->
        "black"
      1 ->
        "white"
    end
  end

  @doc """
  Asks the user if the given chess square is black or white.

  Returns "black" if the user answered "black", "b", or "1", and "white" if the
  user answered "white", "w", or "2".
  """
  def get_response(square) do
    case IO.gets("What color is #{square}? ") do
      "black\n" ->
        "black"
      "b\n" ->
        "black"
      "1\n" ->
        "black"
      "white\n" ->
        "white"
      "w\n" ->
        "white"
      "2\n" ->
        "white"
    end
  end

  def check_response(this_answer) do
    case this_answer do
      true ->
        IO.puts "correct!"
      false ->
        IO.puts "incorrect!"
    end
  end

  @doc """
  Prints information about how many questions the user got right.

  In the future, this may be expanded to include more intelligent information,
  such as insights into specific parts of the board that the user has strong
  or weak visualization on (also possibly taking into account how long it takes
  to get a correct answer).
  """
  def generate_report({correct_answers, total_questions}) do
    percentage = correct_answers / total_questions * 100
    IO.puts """
    You successfully answered #{correct_answers} out of #{total_questions}
    questions (#{percentage}%).
    """
  end

end
