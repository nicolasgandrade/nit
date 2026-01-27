defmodule Nit.Core.Head do
  def get_head_branch_path() do
    ".nit/HEAD"
    |> File.read!()
    |> String.trim()
    |> String.replace_prefix("ref: ", "")
    |> then(&Path.join(".nit", &1))
  end
end
