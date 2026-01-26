defmodule Nit.Commands.Init do
  def run do
    base_path = ".nit"

    File.mkdir_p!("#{base_path}/objects")

    File.mkdir_p!("#{base_path}/refs/heads")

    File.write!("#{base_path}/HEAD", "ref: refs/heads/main\n")

    IO.puts("Nit Repository inicialized in #{File.cwd!()}/#{base_path}")
  end
end
