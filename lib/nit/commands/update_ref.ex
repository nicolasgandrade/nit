defmodule Nit.Commands.UpdateRef do
  alias Nit.Core.Head

  def run(latest_commit_sha) do
    current_branch_path = Head.get_head_branch_path()

    branch_dir =
      current_branch_path
      |> Path.dirname()

    File.mkdir_p!(branch_dir)
    File.write!(current_branch_path, "#{latest_commit_sha}\n")
  end
end
