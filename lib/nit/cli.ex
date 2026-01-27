defmodule Nit.CLI do
  def main(args) do
    case args do
      ["init"] ->
        Nit.Commands.Init.run()

      ["hash-object", file_path] ->
        Nit.Commands.HashObject.run(file_path)

      ["cat-file", "-p", object_hash] ->
        Nit.Commands.CatFile.run(object_hash)

      ["write-tree"] ->
        Nit.Commands.WriteTree.run()

      ["commit-tree", tree_sha, message] ->
        Nit.Commands.CommitTree.run(tree_sha, message)

      ["commit-tree", tree_sha, "-p", parent_sha, message] ->
        Nit.Commands.CommitTree.run(tree_sha, message, parent_sha)

      ["update-ref", commit_sha] ->
        Nit.Commands.UpdateRef.run(commit_sha)

      ["log"] ->
        Nit.Commands.Log.run()

      ["commit", "-m", message] ->
        Nit.Commands.Commit.run(message)

      _ ->
        IO.puts("Nit: Unknown command.")
    end
  end
end
