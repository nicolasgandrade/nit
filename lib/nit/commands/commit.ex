defmodule Nit.Commands.Commit do
  alias Nit.Core.Refs
  alias Nit.Commands.{WriteTree, CommitTree}

  def run(message) do
    {tree_sha, _} = WriteTree.build_tree(".")

    parerent_sha = Refs.get_current_head_sha()

    {new_commit_sha, _} = CommitTree.create_commit(tree_sha, message, parerent_sha)

    Refs.update_head(new_commit_sha)

    IO.puts("Commit #{new_commit_sha} created.")
  end
end
