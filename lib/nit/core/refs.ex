defmodule Nit.Core.Refs do
  def update_head(new_commit_sha) do
    current_branch_path = get_head_branch_path()

    branch_dir =
      current_branch_path
      |> Path.dirname()

    File.mkdir_p!(branch_dir)
    File.write!(current_branch_path, "#{new_commit_sha}\n")
  end

  def get_current_head_sha() do
    get_head_branch_path()
    |> File.read!()
    |> String.trim()
  end

  def get_head_branch_path() do
    ".nit/HEAD"
    |> File.read!()
    |> String.trim()
    |> String.replace_prefix("ref: ", "")
    |> then(&Path.join(".nit", &1))
  end
end
