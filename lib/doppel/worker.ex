defmodule Doppel.Worker do
  use GenServer, restart: :transient

  def init(:no_args) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_file, _) do
    Doppel.PathFinder.next_path() |> add_result()
  end

  defp add_result(nil) do
    Doppel.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Doppel.Gatherer.result(path, hash_of_file_at_path(path))
    send(self(), :do_one_file)
    {:noreply, nil}
  end

  defp hash_of_file_at_path(path) do
    File.stream!(path, [], 1024 * 1024)
    |> Enum.reduce(:crypto.hash_init(:md5), fn block, hash -> :crypto.hash_update(hash, block) end)
    |> :crypto.hash_final()
  end
end
