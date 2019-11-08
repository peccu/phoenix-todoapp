IO.puts("Restart to App.restart()")

defmodule App do
  def restart() do
    Application.stop(:app)
    recompile()
    Application.ensure_all_started(:app)
  end
end
