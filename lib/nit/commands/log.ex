defmodule Nit.Commands.Log do
  alias Nit.Utils.Head

  def run() do
    last_commit_sha =
      Head.get_head_branch_path()
      |> File.read!()
      |> String.trim()

    log_commit(last_commit_sha)
  end

  defp log_commit(commit_sha) do
    {dir_name, file_name} = String.split_at(commit_sha, 2)
    path = ".nit/objects/#{dir_name}/#{file_name}"

    compressed_data = File.read!(path)
    raw_content = :zlib.uncompress(compressed_data)

    case String.split(raw_content, <<0>>, parts: 2) do
      [_header, body] ->
        IO.puts("#{body}\n-------")

        parent_sha = extract_parent_from_text(body)

        if parent_sha do
          log_commit(parent_sha)
        end

      _ ->
        :ok
    end
  end

  defp extract_parent_from_text(content) do
    case Regex.run(~r/^parent (\w+)/m, content) do
      [_, hash] -> hash
      nil -> nil
    end
  end
end
