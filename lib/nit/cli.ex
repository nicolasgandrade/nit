defmodule Nit.CLI do
  def main(args) do
    case args do
      ["init"] -> Nit.Commands.Init.run()
      _ -> IO.puts("Nit: Unknown command.")
    end
  end
end
