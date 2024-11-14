defmodule Shell do
  def exec(exe, args) when is_list(args) do
    port =
      Port.open(
        {:spawn_executable, System.find_executable("java")},
        [
          :binary,
          :stream,
          :stderr_to_stdout,
          :hide,
          args: [
            "-Dde.renew.splashscreen.enabled=false",
            "-Dde.renew.gui.autostart=false",
            "-Dde.renew.simulatorMode=-1",
            "-Dlog4j.configuration=./log4j.properties",
            "-p",
            "./renew41;./renew41/libs",
            "-m",
            "de.renew.loader",
            "script",
            "./sim-script"
          ]
        ]
      )

    c = self()

    spawn(fn ->
      handle_input(port)
    end)

    handle_output(port)
  end

  def handle_input(port) do
    cmd = IO.gets("> ")
    Port.command(port, "help\n")

    handle_input(port)
  end

  def handle_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        handle_output(port)

      {^port, {:exit_status, status}} ->
        status

      e ->
        dbg(e)
    end
  end
end

Shell.exec("./run.sh", [])
