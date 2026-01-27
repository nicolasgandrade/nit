defmodule Nit.Commands.UpdateRef do
  alias Nit.Core.Refs

  def run(latest_commit_sha) do
    Refs.update_head(latest_commit_sha)
  end
end
