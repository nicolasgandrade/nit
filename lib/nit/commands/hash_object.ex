defmodule Nit.Commands.HashObject do
  def run(file_path) do
    content = File.read!(file_path)

    blob_data = "blob #{byte_size(content)}\0#{content}"

    hash = :crypto.hash(:sha, blob_data) |> Base.encode16(case: :lower)

    compressed_data = :zlib.compress(blob_data)

    write_object(hash, compressed_data)

    IO.puts(hash)
  end

  defp write_object(hash, data) do
    {dir_name, file_name} = String.split_at(hash, 2)

    dir_path = ".nit/objects/#{dir_name}"
    file_path = "#{dir_path}/#{file_name}"

    File.mkdir_p!(dir_path)
    File.write!(file_path, data)
  end
end
