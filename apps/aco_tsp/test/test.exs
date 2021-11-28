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

  test "test helper functions " do
    probabilities = [0.25, 0.5, 0.25]
    random = :rand.uniform()
    idx = Aco_tsp.my_choice(random, probabilities, 0)
    # IO.puts("Random number: #{random}")
    # IO.puts("Index chosen: #{idx}")

    ant_state = %Aco_tsp.Ant{alpha: 2 , beta: 3}
    current_node = 3
    neighbors =  %{1=> 5, 2=> 1, 4=>3}
    pheromones = [0.3,0.2,0.1]
    IO.puts("ant_state before: #{inspect(ant_state)}")

    ant_state = Aco_tsp.ant_make_move(ant_state, neighbors, pheromones)
    IO.puts("ant_state after: #{inspect(ant_state)}")


    update_mat = %{
      1 => %{2 => 10, 3 => 5, 4 => 2},
      2 => %{1 => 10, 3 => 1, 4 => 6},
      3 => %{1 => 5, 2 => 1, 4 => 3},
      4 => %{1 => 2, 2 => 6, 3 => 3}
    }

    state = %Aco_tsp.PheromoneManager{update_matrix: update_mat, q_val: 1}

    g =
      Map.new(update_mat, fn {k, v} ->
        {k, Enum.reduce(v, %{}, fn {kk, vv}, m -> Map.put(m, kk, 0.1) end)}
      end)

    state = %{state | pheromone_matrix: g, rho: 0.99}
    state = Aco_tsp.clear_update_matrix(state)
    # IO.puts("Cleared State: #{inspect(state.update_matrix)}")

    tour = [3, 2, 1, 4]
    cost = 13
    state = Aco_tsp.update_update_matrix(state, tour, cost)
    #IO.puts("Updated matrix #{inspect(state.update_matrix)}")

    #IO.puts("Pmone Matrix before #{inspect(state.pheromone_matrix)}")
    state = Aco_tsp.update_pheromone_matrix(state)
    #IO.puts("Pmone Matrix after #{inspect(state.pheromone_matrix)}")

    g_state = %Aco_tsp.GraphManager{graph: update_mat}
    cost = Aco_tsp.tour_cost(tour, g_state, 0)
    IO.puts("Tour cost: #{cost}")
  end
end
