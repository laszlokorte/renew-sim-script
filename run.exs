Mix.install([
  {:erlexec, "~> 2.0"}
])

defmodule Run do
  def main do
    :exec.start()
    {:ok, process, pid} = IO.inspect(:exec.run("exec ./run.sh", [:stdin, :stdout, :stderr]))

    spawn(fn ->
      handle_input(process)
    end)

    process_output(pid)
  end

  def process_output(pid) do
    receive do
      {:stdout, ^pid, s} ->
        IO.write(s)
        process_output(pid)
    end
  end

  def handle_input(process) do
    input = IO.gets(">")
    :exec.send(process, input)
    handle_input(process)
  end
end

Run.main()
