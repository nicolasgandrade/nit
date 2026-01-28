defmodule Nit.Core.TreeParser do
  def parse(tree_binary) do
    do_parse(tree_binary, [])
  end

  defp do_parse(<<>>, acc), do: Enum.reverse(acc)

  defp do_parse(binary, acc) do
    case :binary.match(binary, <<0>>) do
      {null_pos, 1} ->
        <<header::binary-size(null_pos), 0, rest::binary>> = binary

        [mode, name] = String.split(header, " ", parts: 2)

        <<sha_bin::binary-size(20), remainder::binary>> = rest
        sha_hex = Base.encode16(sha_bin, case: :lower)

        entry = %{mode: mode, name: name, sha: sha_hex}

        do_parse(remainder, [entry | acc])

      :nomatch ->
        acc
    end
  end
end
