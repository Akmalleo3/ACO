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

    ant_state = %Aco_tsp.Ant{alpha: 2, beta: 3}
    current_node = 3
    neighbors = %{1 => 5, 2 => 1, 4 => 3}
    pheromones = [0.3, 0.2, 0.1]
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
    # IO.puts("Updated matrix #{inspect(state.update_matrix)}")

    # IO.puts("Pmone Matrix before #{inspect(state.pheromone_matrix)}")
    state = Aco_tsp.update_pheromone_matrix(state)
    # IO.puts("Pmone Matrix after #{inspect(state.pheromone_matrix)}")

    g_state = %Aco_tsp.GraphManager{graph: update_mat}
    cost = Aco_tsp.tour_cost(tour, g_state, 0)
    IO.puts("Tour cost: #{cost}")
  end

  test "baby problem" do
    Emulation.init()

    graph = %{
      1 => %{2 => 10, 3 => 5, 4 => 2},
      2 => %{1 => 10, 3 => 1, 4 => 6},
      3 => %{1 => 5, 2 => 1, 4 => 3},
      4 => %{1 => 2, 2 => 6, 3 => 3}
    }

    config = Aco_tsp.new_configuration(3, graph)
    IO.puts(inspect(config))
    process = spawn(:cm, fn -> Aco_tsp.start_colony(config) end)

    handle = Process.monitor(process)

    # Timeout
    receive do
      {:DOWN, ^handle, _, _, reason} -> IO.puts("Received down #{reason}")
    after
      30_000 -> assert false
    end
  after
    Emulation.terminate()
  end

  test "bays29" do
    Emulation.init()

    graph = Acotsp_graphs.bays29()

    config = Aco_tsp.new_configuration(5000, graph)
    IO.puts(inspect(config))
    process = spawn(:cm, fn -> Aco_tsp.start_colony(config) end)

    handle = Process.monitor(process)

    # Timeout
    receive do
      {:DOWN, ^handle, _, _, reason} -> IO.puts("Received down #{reason}")
    after
      1_200_000 -> assert true
    end
  after
    Emulation.terminate()
  end

  test "a280" do
    Emulation.init()
    graph = Acotsp_graphs.a280()

    config = Aco_tsp.new_configuration(5000, graph)
    IO.puts(inspect(config))
    process = spawn(:cm, fn -> Aco_tsp.start_colony(config) end)

    handle = Process.monitor(process)

    # Timeout
    receive do
      {:DOWN, ^handle, _, _, reason} -> IO.puts("Received down #{reason}")
    after
      2_400_000 -> assert true
    end
  after
    Emulation.terminate()
  end

  test "a280 optimal cost" do
    solution = [
      1,
      2,
      242,
      243,
      244,
      241,
      240,
      239,
      238,
      237,
      236,
      235,
      234,
      233,
      232,
      231,
      246,
      245,
      247,
      250,
      251,
      230,
      229,
      228,
      227,
      226,
      225,
      224,
      223,
      222,
      221,
      220,
      219,
      218,
      217,
      216,
      215,
      214,
      213,
      212,
      211,
      210,
      207,
      206,
      205,
      204,
      203,
      202,
      201,
      198,
      197,
      196,
      195,
      194,
      193,
      192,
      191,
      190,
      189,
      188,
      187,
      186,
      185,
      184,
      183,
      182,
      181,
      176,
      180,
      179,
      150,
      178,
      177,
      151,
      152,
      156,
      153,
      155,
      154,
      129,
      130,
      131,
      20,
      21,
      128,
      127,
      126,
      125,
      124,
      123,
      122,
      121,
      120,
      119,
      157,
      158,
      159,
      160,
      175,
      161,
      162,
      163,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      172,
      171,
      173,
      174,
      107,
      106,
      105,
      104,
      103,
      102,
      101,
      100,
      99,
      98,
      97,
      96,
      95,
      94,
      93,
      92,
      91,
      90,
      89,
      109,
      108,
      110,
      111,
      112,
      88,
      87,
      113,
      114,
      115,
      117,
      116,
      86,
      85,
      84,
      83,
      82,
      81,
      80,
      79,
      78,
      77,
      76,
      75,
      74,
      73,
      72,
      71,
      70,
      69,
      68,
      67,
      66,
      65,
      64,
      58,
      57,
      56,
      55,
      54,
      53,
      52,
      51,
      50,
      49,
      48,
      47,
      46,
      45,
      44,
      59,
      63,
      62,
      118,
      61,
      60,
      43,
      42,
      41,
      40,
      39,
      38,
      37,
      36,
      35,
      34,
      33,
      32,
      31,
      30,
      29,
      28,
      27,
      26,
      22,
      25,
      23,
      24,
      14,
      15,
      13,
      12,
      11,
      10,
      9,
      8,
      7,
      6,
      5,
      4,
      277,
      276,
      275,
      274,
      273,
      272,
      271,
      16,
      17,
      18,
      19,
      132,
      133,
      134,
      270,
      269,
      135,
      136,
      268,
      267,
      137,
      138,
      139,
      149,
      148,
      147,
      146,
      145,
      199,
      200,
      144,
      143,
      142,
      141,
      140,
      266,
      265,
      264,
      263,
      262,
      261,
      260,
      259,
      258,
      257,
      254,
      253,
      208,
      209,
      252,
      255,
      256,
      249,
      248,
      278,
      279,
      3,
      280
    ]
    state= %Aco_tsp.GraphManager{graph: Acotsp_graphs.a280()}
    cost = Aco_tsp.tour_cost(solution,state ,0)
    IO.puts("Optimal tour cost: #{cost}")
  end
end
