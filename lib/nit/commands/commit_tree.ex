defmodule Nit.Commands.CommitTree do
  alias Nit.Core.ObjectStore

  def run(tree_sha, message, parent_sha \\ nil) do
    # TODO: Make this receive actual data from the user.
    author_name = "Nit User"
    author_email = "user@nit.com"
    timestamp = System.os_time()
    timezone = "+0000"

    author_line = "#{author_name} <#{author_email}> #{timestamp} #{timezone}"

    lines = [
      "tree #{tree_sha}",
      if(parent_sha, do: "parent #{parent_sha}", else: nil),
      "author #{author_line}",
      "commiter #{author_line}",
      "",
      message
    ]

    content =
      lines
      |> Enum.reject(&is_nil/1)
      |> Enum.join("\n")
      |> Kernel.<>("\n")

    {commit_sha, _} = ObjectStore.put_object("commit", content)

    IO.puts(commit_sha)
  end
end
