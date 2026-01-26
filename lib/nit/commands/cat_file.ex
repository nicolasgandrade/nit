defmodule Nit.Commands.CatFile do
  def run(object_hash) do
    {dir_name, file_name} = String.split_at(object_hash, 2)
    path = ".nit/objects/#{dir_name}/#{file_name}"

    compressed_data = File.read!(path)
    raw_content = :zlib.uncompress(compressed_data)

    case String.split(raw_content, <<0>>, parts: 2) do
      [_header, body] -> IO.write(body)
      _ -> IO.puts("Error: Object corrupted or invalid format.")
    end
  end
end
