defmodule Nit.Core.Refs do
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
