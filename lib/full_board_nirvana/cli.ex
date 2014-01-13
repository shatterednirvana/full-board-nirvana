defmodule FullBoardNirvana.CLI do

  @default_rounds 25

  @moduledoc """
  Handle the command-line parsing and dispatch to the various functions
  representing chess learning exercises.
  """

  def run(argv) do
    parse_args(argv)
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

end
