defmodule Acotsp_Test do
  use ExUnit.Case
  doctest Aco_tsp
  import Kernel


test "breathing" do
  config = Aco_tsp.new_configuration(3, %{a: 1, b: 2})
  IO.puts(inspect(config))
  colony_manager_id = spawn(fn-> Aco_tsp.start_colony(config) end)
end

end
