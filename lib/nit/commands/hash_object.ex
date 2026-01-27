defmodule Nit.Commands.HashObject do
  alias Nit.Core.ObjectStore

  def run(file_path) do
    content = File.read!(file_path)

    {sha_hex, _} = ObjectStore.put_object("blob", content)

    IO.puts(sha_hex)
  end
end
