defmodule Shell do
  def exec() do
    separator =
      case :os.type() do
        {:win32, _} -> ";"
        {:unix, _} -> ":"
      end

    port =
      Port.open(
        {:spawn_executable, System.find_executable("java")},
        [
          :binary,
          :eof,
          :stream,
          :stderr_to_stdout,
          :exit_status,
          :use_stdio,
          :hide,
          args: [
             "-jar",
             "Interceptor.jar",
             "java",

            "-Djline.terminal=off",
            "-Dde.renew.splashscreen.enabled=false",
            "-Dde.renew.gui.autostart=false",
            "-Dde.renew.simulatorMode=-1",
            "-Dlog4j.configuration=./log4j.properties",
            "-Dde.renew.plugin.autoLoad=false",
            "-Dde.renew.plugin.load=Renew Util, Renew Simulator, Renew Formalism, Renew Misc, Renew PTChannel, Renew Remote, Renew Window Management, Renew JHotDraw, Renew Gui, Renew Formalism Gui, Renew Logging, Renew NetComponents, Renew Console, Renew FreeHep Export",
            "-p",
            "./renew41" <> separator <> "./renew41/libs",
            "-m",
            "de.renew.loader",
            "script",
            "sim-script"
          ]
        ]
      )

    Process.flag(:trap_exit, true)
    Process.link(port)

    Port.monitor(port)

    c = self()

    spawn(fn ->
      handle_input(c, port)
    end)

    handle_output(port)
  end

  def handle_input(c, port) do
    case IO.gets("> ") do
      :eof ->
        send(port, {c, :close})

      cmd ->
        send(port, {c, {:command, cmd}})

        handle_input(c, port)
    end
  end

  def handle_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        handle_output(port)

      {^port, {:exit_status, status}} ->
        status

      {:EXIT, ^port, exit_code} ->
        IO.puts(exit_code)

      e ->
        IO.puts("xxxx")
        dbg(e)
    end
  end
end

Shell.exec()
