defmodule Nit.CLI do
  def main(args) do
    case args do
      ["init"] -> Nit.Commands.Init.run()
      ["hash-object", file_path] -> Nit.Commands.HashObject.run(file_path)
      ["cat-file", "-p", object_hash] -> Nit.Commands.CatFile.run(object_hash)
      ["write-tree"] -> Nit.Commands.WriteTree.run()
      _ -> IO.puts("Nit: Unknown command.")
    end
  end
end
