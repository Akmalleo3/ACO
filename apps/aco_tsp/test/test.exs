defmodule Acotsp_Test do
  use ExUnit.Case
  doctest Aco_tsp

  import Emulation, only: [spawn: 2, send: 2, broadcast: 1, timer: 1]

  import Kernel,
    except: [spawn: 3, spawn: 1, spawn_link: 1, spawn_link: 3, send: 2]

  test "breathing" do
    Emulation.init()

    config = Aco_tsp.new_configuration(3, %{a: %{c: 1, e: 5}, b: %{d: 3, u: 7}})
    IO.puts(inspect(config))
    process = spawn(:cm, fn -> Aco_tsp.start_colony(config) end)

    handle = Process.monitor(process)

    # Timeout
    receive do
      {:DOWN, ^handle, _, _, reason} -> IO.puts("Received down #{reason}")
    after
      10_000 -> assert false
    end
  after
    Emulation.terminate()
  end
end
