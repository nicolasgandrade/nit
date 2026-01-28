defmodule Nit.Commands.Checkout do
  alias Nit.Core.{ObjectStore, TreeParser, Refs}

  def run(commit_sha) do
    root_tree_sha = get_tree_sha_from_commit(commit_sha)

    IO.puts("Checking out commit #{commit_sha}")

    restore_tree(root_tree_sha, ".")

    # TODO: create Detached head behavior.
    Refs.update_head(commit_sha)

    IO.puts("Checkout concluded.")
  end

  defp get_tree_sha_from_commit(commit_sha) do
    [_, commit_body] =
      ObjectStore.get_object(commit_sha)
      |> String.split(<<0>>, parts: 2)

    "tree " <> <<tree_sha::binary-size(40)>> <> _rest = commit_body

    tree_sha
  end

  defp restore_tree(root_tree_sha, current_path) do
    [_, tree_body] =
      ObjectStore.get_object(root_tree_sha)
      |> String.split(<<0>>, parts: 2)

    entries = TreeParser.parse(tree_body)

    Enum.each(entries, fn entry ->
      full_path = Path.join(current_path, entry.name)

      case entry.mode do
        "40000" ->
          File.mkdir_p!(full_path)
          restore_tree(entry.sha, full_path)

        "100644" ->
          restore_blob(entry.sha, full_path, 0o644)

        _ ->
          IO.puts("Unexpected mode: #{entry.mode} to #{entry.name}")
      end
    end)
  end

  defp restore_blob(blob_sha, path, mode) do
    [_, blob_content] =
      ObjectStore.get_object(blob_sha)
      |> String.split(<<0>>, parts: 2)

    File.write!(path, blob_content)
    File.chmod!(path, mode)
  end
end
