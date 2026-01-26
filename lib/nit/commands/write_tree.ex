defmodule Nit.Commands.WriteTree do
  alias Nit.Commands.HashObject
  alias Nit.Utils.ObjectStore

  def run() do
    {root_sha_hex, _binary} = build_tree(".")
    IO.puts(root_sha_hex)
  end

  def build_tree(current_dir) do
    entries = list_directory(current_dir)

    tree_entries =
      Enum.map(entries, fn entry_name ->
        full_path = Path.join(current_dir, entry_name)

        if File.dir?(full_path) do
          {_sha_hex, sha_bin} = build_tree(full_path)
          {:dir, entry_name, sha_bin}
        else
          content = File.read!(full_path)
          {_sha_hex, sha_bin} = HashObject.write_blob(content)
          {:file, entry_name, sha_bin}
        end
      end)

    sorted_entries = Enum.sort_by(tree_entries, fn {_dir_or_file, name, _sha_bin} -> name end)

    tree_body =
      Enum.reduce(sorted_entries, <<>>, fn {type, name, sha_bin}, acc ->
        mode = if type == :dir, do: "40000", else: "100644"
        acc <> "#{mode} #{name}\0" <> sha_bin
      end)

    write_tree_object(tree_body)
  end

  defp list_directory(dir) do
    File.ls!(dir) |> ignore_hidden_directories
  end

  defp ignore_hidden_directories(directories) do
    directories
    |> Enum.filter(fn name ->
      name != ".nit" and
        not String.starts_with?(name, ".")
    end)
  end

  defp write_tree_object(tree_body) do
    # TODO: Transform this into a util function
    header = "tree #{byte_size(tree_body)}\0"
    store = header <> tree_body

    sha_binary = :crypto.hash(:sha, store)
    sha_hex = Base.encode16(sha_binary, case: :lower)

    compressed = :zlib.compress(store)

    ObjectStore.save_object_on_disk(sha_hex, compressed)

    {sha_hex, sha_binary}
  end
end
