IO.puts("Restart to App.restart()")

defmodule App do
  def restart() do
    Application.stop(:my_app)
    recompile()
    Application.ensure_all_started(:my_app)
  end
end
