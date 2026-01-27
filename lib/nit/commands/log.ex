defmodule Nit.Commands.Log do
  alias Nit.Core.ObjectStore
  alias Nit.Core.Refs

  def run() do
    last_commit_sha =
      Refs.get_head_branch_path()
      |> File.read!()
      |> String.trim()

    log_commit(last_commit_sha)
  end

  defp log_commit(nil), do: :ok

  defp log_commit(sha) do
    content = ObjectStore.get_object(sha)

    [_, body] = String.split(content, <<0>>, parts: 2)

    body
    |> tap(fn _ ->
      IO.puts("commit #{sha}")
      IO.puts("#{body}\n------")
    end)
    |> extract_parent_from_text()
    |> log_commit()
  end

  defp extract_parent_from_text(content) do
    case Regex.run(~r/^parent (\w+)/m, content) do
      [_, hash] -> hash
      nil -> nil
    end
  end
end
