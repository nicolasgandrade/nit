defmodule Nit.Commands.CatFile do
  alias Nit.Core.ObjectStore

  def run(object_hash) do
    raw_content = ObjectStore.get_object(object_hash)

    case String.split(raw_content, <<0>>, parts: 2) do
      [_header, body] -> IO.write(body)
      _ -> IO.puts("Error: Object corrupted or invalid format.")
    end
  end
end
