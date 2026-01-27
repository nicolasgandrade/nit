defmodule Nit.Core.ObjectStore do
  @objects_path ".nit/objects"

  def put_object(type, content) do
    header = "#{type} #{byte_size(content)}\0"
    store = header <> content

    sha_binary = hash_object(store)
    sha_hex = encode_binary(sha_binary)

    compressed = compress_object(store)

    write_on_disk(sha_hex, compressed)

    {sha_hex, sha_binary}
  end

  defp hash_object(object) do
    :crypto.hash(:sha, object)
  end

  defp encode_binary(binary) do
    Base.encode16(binary, case: :lower)
  end

  defp compress_object(object) do
    object |> :zlib.compress()
  end

  defp write_on_disk(sha, data) do
    {dir_name, file_name} = String.split_at(sha, 2)

    dir_path = "#{@objects_path}/#{dir_name}"
    file_path = "#{dir_path}/#{file_name}"

    File.mkdir_p!(dir_path)
    File.write!(file_path, data)
  end

  def save_object_on_disk(hash, data) do
    {dir_name, file_name} = String.split_at(hash, 2)

    dir_path = ".nit/objects/#{dir_name}"
    file_path = "#{dir_path}/#{file_name}"

    File.mkdir_p!(dir_path)
    File.write!(file_path, data)
  end
end
