defmodule Nit.Utils.ObjectStore do
  def save_object_on_disk(hash, data) do
    {dir_name, file_name} = String.split_at(hash, 2)

    dir_path = ".nit/objects/#{dir_name}"
    file_path = "#{dir_path}/#{file_name}"

    File.mkdir_p!(dir_path)
    File.write!(file_path, data)
  end
end
