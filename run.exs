Mix.install([
  {:erlexec, "~> 2.0"}
])

defmodule Run do
  def main do
    :exec.start()
    {:ok, process, pid} = :exec.run_link("exec ./run.sh", [:stdin, :stdout, :stderr])
    monitor = Process.monitor(process)

    spawn_link(fn ->
      handle_input(process)
    end)

    process_output(monitor, pid)
  end

  def process_output(monitor, pid) do
    receive do
      {:stdout, ^pid, s} ->
        IO.write(s)
        process_output(monitor, pid)
      {:stderr, _, _} ->
        process_output(monitor, pid)
      {:DOWN, ^monitor, :process, pid, :normal} -> nil
      o -> IO.puts(o)
    end
  end

  def handle_input(process) do
    input = IO.gets("> ")
    :exec.send(process, input)
    handle_input(process)
  end
end

Run.main()
