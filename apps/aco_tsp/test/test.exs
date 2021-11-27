defmodule Acotsp_Test do
  use ExUnit.Case
  doctest Aco_tsp

  import Emulation, only: [spawn: 2, send: 2, broadcast: 1, timer: 1]
  import Kernel,
    except: [spawn: 3, spawn: 1, spawn_link: 1, spawn_link: 3, send: 2]



test "breathing" do
  Emulation.init()

  config = Aco_tsp.new_configuration(3, %{a: 1, b: 2})
  IO.puts(inspect(config))
  spawn(:colony_manager, fn-> Aco_tsp.start_colony(config) end)
end

end
