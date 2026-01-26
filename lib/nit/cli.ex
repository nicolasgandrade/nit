defmodule Nit.CLI do
  def main(args) do
    case args do
      ["init"] -> Nit.Commands.Init.run()
      ["hash-object", file_path] -> Nit.Commands.HashObject.run(file_path)
      _ -> IO.puts("Nit: Unknown command.")
    end
  end
end
