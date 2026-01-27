defmodule Nit.Commands.HashObject do
  alias Nit.Core.ObjectStore

  def run(file_path) do
    content = File.read!(file_path)

    {sha_hex, _} = write_blob(content)

    IO.puts(sha_hex)
  end

  def write_blob(content) do
    header = "blob #{byte_size(content)}\0"
    blob_data = header <> content

    sha_binary = :crypto.hash(:sha, blob_data)
    sha_hex = Base.encode16(sha_binary, case: :lower)

    compressed_data = :zlib.compress(blob_data)

    ObjectStore.save_object_on_disk(sha_hex, compressed_data)

    {sha_hex, sha_binary}
  end
end
