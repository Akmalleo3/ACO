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
  graph = %{1=> %{1=> 0,2=> 107,3=> 241,4=> 190,5=> 124,6=> 80,7=> 316,8=> 76,9=> 152,10=> 157,11=> 283,12=> 133,13=> 113,14=> 297,15=> 228,16=> 129,17=> 348,18=> 276,19=> 188,20=> 150,21=> 65,22=> 341,23=> 184,24=> 67,25=> 221,26=> 169,27=> 108,28=> 45,29=> 167,},
  2=> %{1=> 107,2=> 0,3=> 148,4=> 137,5=> 88,6=> 127,7=> 336,8=> 183,9=> 134,10=> 95,11=> 254,12=> 180,13=> 101,14=> 234,15=> 175,16=> 176,17=> 265,18=> 199,19=> 182,20=> 67,21=> 42,22=> 278,23=> 271,24=> 146,25=> 251,26=> 105,27=> 191,28=> 139,29=> 79,},
  3=> %{1=> 241,2=> 148,3=> 0,4=> 374,5=> 171,6=> 259,7=> 509,8=> 317,9=> 217,10=> 232,11=> 491,12=> 312,13=> 280,14=> 391,15=> 412,16=> 349,17=> 422,18=> 356,19=> 355,20=> 204,21=> 182,22=> 435,23=> 417,24=> 292,25=> 424,26=> 116,27=> 337,28=> 273,29=> 77,},
  4=> %{1=> 190,2=> 137,3=> 374,4=> 0,5=> 202,6=> 234,7=> 222,8=> 192,9=> 248,10=> 42,11=> 117,12=> 287,13=> 79,14=> 107,15=> 38,16=> 121,17=> 152,18=> 86,19=> 68,20=> 70,21=> 137,22=> 151,23=> 239,24=> 135,25=> 137,26=> 242,27=> 165,28=> 228,29=> 205,},
  5=> %{1=> 124,2=> 88,3=> 171,4=> 202,5=> 0,6=> 61,7=> 392,8=> 202,9=> 46,10=> 160,11=> 319,12=> 112,13=> 163,14=> 322,15=> 240,16=> 232,17=> 314,18=> 287,19=> 238,20=> 155,21=> 65,22=> 366,23=> 300,24=> 175,25=> 307,26=> 57,27=> 220,28=> 121,29=> 97,},
  6=> %{1=> 80,2=> 127,3=> 259,4=> 234,5=> 61,6=> 0,7=> 386,8=> 141,9=> 72,10=> 167,11=> 351,12=> 55,13=> 157,14=> 331,15=> 272,16=> 226,17=> 362,18=> 296,19=> 232,20=> 164,21=> 85,22=> 375,23=> 249,24=> 147,25=> 301,26=> 118,27=> 188,28=> 60,29=> 185,},
  7=> %{1=> 316,2=> 336,3=> 509,4=> 222,5=> 392,6=> 386,7=> 0,8=> 233,9=> 438,10=> 254,11=> 202,12=> 439,13=> 235,14=> 254,15=> 210,16=> 187,17=> 313,18=> 266,19=> 154,20=> 282,21=> 321,22=> 298,23=> 168,24=> 249,25=> 95,26=> 437,27=> 190,28=> 314,29=> 435,},
  8=> %{1=> 76,2=> 183,3=> 317,4=> 192,5=> 202,6=> 141,7=> 233,8=> 0,9=> 213,10=> 188,11=> 272,12=> 193,13=> 131,14=> 302,15=> 233,16=> 98,17=> 344,18=> 289,19=> 177,20=> 216,21=> 141,22=> 346,23=> 108,24=> 57,25=> 190,26=> 245,27=> 43,28=> 81,29=> 243,},
  9=> %{1=> 152,2=> 134,3=> 217,4=> 248,5=> 46,6=> 72,7=> 438,8=> 213,9=> 0,10=> 206,11=> 365,12=> 89,13=> 209,14=> 368,15=> 286,16=> 278,17=> 360,18=> 333,19=> 284,20=> 201,21=> 111,22=> 412,23=> 321,24=> 221,25=> 353,26=> 72,27=> 266,28=> 132,29=> 111,},
  10=> %{1=> 157,2=> 95,3=> 232,4=> 42,5=> 160,6=> 167,7=> 254,8=> 188,9=> 206,10=> 0,11=> 159,12=> 220,13=> 57,14=> 149,15=> 80,16=> 132,17=> 193,18=> 127,19=> 100,20=> 28,21=> 95,22=> 193,23=> 241,24=> 131,25=> 169,26=> 200,27=> 161,28=> 189,29=> 163,},
  11=> %{1=> 283,2=> 254,3=> 491,4=> 117,5=> 319,6=> 351,7=> 202,8=> 272,9=> 365,10=> 159,11=> 0,12=> 404,13=> 176,14=> 106,15=> 79,16=> 161,17=> 165,18=> 141,19=> 95,20=> 187,21=> 254,22=> 103,23=> 279,24=> 215,25=> 117,26=> 359,27=> 216,28=> 308,29=> 322,},
  12=> %{1=> 133,2=> 180,3=> 312,4=> 287,5=> 112,6=> 55,7=> 439,8=> 193,9=> 89,10=> 220,11=> 404,12=> 0,13=> 210,14=> 384,15=> 325,16=> 279,17=> 415,18=> 349,19=> 285,20=> 217,21=> 138,22=> 428,23=> 310,24=> 200,25=> 354,26=> 169,27=> 241,28=> 112,29=> 238,},
  13=> %{1=> 113,2=> 101,3=> 280,4=> 79,5=> 163,6=> 157,7=> 235,8=> 131,9=> 209,10=> 57,11=> 176,12=> 210,13=> 0,14=> 186,15=> 117,16=> 75,17=> 231,18=> 165,19=> 81,20=> 85,21=> 92,22=> 230,23=> 184,24=> 74,25=> 150,26=> 208,27=> 104,28=> 158,29=> 206,},
  14=> %{1=> 297,2=> 234,3=> 391,4=> 107,5=> 322,6=> 331,7=> 254,8=> 302,9=> 368,10=> 149,11=> 106,12=> 384,13=> 186,14=> 0,15=> 69,16=> 191,17=> 59,18=> 35,19=> 125,20=> 167,21=> 255,22=> 44,23=> 309,24=> 245,25=> 169,26=> 327,27=> 246,28=> 335,29=> 288,},
  15=> %{1=> 228,2=> 175,3=> 412,4=> 38,5=> 240,6=> 272,7=> 210,8=> 233,9=> 286,10=> 80,11=> 79,12=> 325,13=> 117,14=> 69,15=> 0,16=> 122,17=> 122,18=> 56,19=> 56,20=> 108,21=> 175,22=> 113,23=> 240,24=> 176,25=> 125,26=> 280,27=> 177,28=> 266,29=> 243,},
  16=> %{1=> 129,2=> 176,3=> 349,4=> 121,5=> 232,6=> 226,7=> 187,8=> 98,9=> 278,10=> 132,11=> 161,12=> 279,13=> 75,14=> 191,15=> 122,16=> 0,17=> 244,18=> 178,19=> 66,20=> 160,21=> 161,22=> 235,23=> 118,24=> 62,25=> 92,26=> 277,27=> 55,28=> 155,29=> 275,},
  17=> %{1=> 348,2=> 265,3=> 422,4=> 152,5=> 314,6=> 362,7=> 313,8=> 344,9=> 360,10=> 193,11=> 165,12=> 415,13=> 231,14=> 59,15=> 122,16=> 244,17=> 0,18=> 66,19=> 178,20=> 198,21=> 286,22=> 77,23=> 362,24=> 287,25=> 228,26=> 358,27=> 299,28=> 380,29=> 319,},
  18=> %{1=> 276,2=> 199,3=> 356,4=> 86,5=> 287,6=> 296,7=> 266,8=> 289,9=> 333,10=> 127,11=> 141,12=> 349,13=> 165,14=> 35,15=> 56,16=> 178,17=> 66,18=> 0,19=> 112,20=> 132,21=> 220,22=> 79,23=> 296,24=> 232,25=> 181,26=> 292,27=> 233,28=> 314,29=> 253,},
  19=> %{1=> 188,2=> 182,3=> 355,4=> 68,5=> 238,6=> 232,7=> 154,8=> 177,9=> 284,10=> 100,11=> 95,12=> 285,13=> 81,14=> 125,15=> 56,16=> 66,17=> 178,18=> 112,19=> 0,20=> 128,21=> 167,22=> 169,23=> 179,24=> 120,25=> 69,26=> 283,27=> 121,28=> 213,29=> 281,},
  20=> %{1=> 150,2=> 67,3=> 204,4=> 70,5=> 155,6=> 164,7=> 282,8=> 216,9=> 201,10=> 28,11=> 187,12=> 217,13=> 85,14=> 167,15=> 108,16=> 160,17=> 198,18=> 132,19=> 128,20=> 0,21=> 88,22=> 211,23=> 269,24=> 159,25=> 197,26=> 172,27=> 189,28=> 182,29=> 135,},
  21=> %{1=> 65,2=> 42,3=> 182,4=> 137,5=> 65,6=> 85,7=> 321,8=> 141,9=> 111,10=> 95,11=> 254,12=> 138,13=> 92,14=> 255,15=> 175,16=> 161,17=> 286,18=> 220,19=> 167,20=> 88,21=> 0,22=> 299,23=> 229,24=> 104,25=> 236,26=> 110,27=> 149,28=> 97,29=> 108,},
  22=> %{1=> 341,2=> 278,3=> 435,4=> 151,5=> 366,6=> 375,7=> 298,8=> 346,9=> 412,10=> 193,11=> 103,12=> 428,13=> 230,14=> 44,15=> 113,16=> 235,17=> 77,18=> 79,19=> 169,20=> 211,21=> 299,22=> 0,23=> 353,24=> 289,25=> 213,26=> 371,27=> 290,28=> 379,29=> 332,},
  23=> %{1=> 184,2=> 271,3=> 417,4=> 239,5=> 300,6=> 249,7=> 168,8=> 108,9=> 321,10=> 241,11=> 279,12=> 310,13=> 184,14=> 309,15=> 240,16=> 118,17=> 362,18=> 296,19=> 179,20=> 269,21=> 229,22=> 353,23=> 0,24=> 121,25=> 162,26=> 345,27=> 80,28=> 189,29=> 342,},
  24=> %{1=> 67,2=> 146,3=> 292,4=> 135,5=> 175,6=> 147,7=> 249,8=> 57,9=> 221,10=> 131,11=> 215,12=> 200,13=> 74,14=> 245,15=> 176,16=> 62,17=> 287,18=> 232,19=> 120,20=> 159,21=> 104,22=> 289,23=> 121,24=> 0,25=> 154,26=> 220,27=> 41,28=> 93,29=> 218,},
  25=> %{1=> 221,2=> 251,3=> 424,4=> 137,5=> 307,6=> 301,7=> 95,8=> 190,9=> 353,10=> 169,11=> 117,12=> 354,13=> 150,14=> 169,15=> 125,16=> 92,17=> 228,18=> 181,19=> 69,20=> 197,21=> 236,22=> 213,23=> 162,24=> 154,25=> 0,26=> 352,27=> 147,28=> 247,29=> 350,},
  26=> %{1=> 169,2=> 105,3=> 116,4=> 242,5=> 57,6=> 118,7=> 437,8=> 245,9=> 72,10=> 200,11=> 359,12=> 169,13=> 208,14=> 327,15=> 280,16=> 277,17=> 358,18=> 292,19=> 283,20=> 172,21=> 110,22=> 371,23=> 345,24=> 220,25=> 352,26=> 0,27=> 265,28=> 178,29=> 39,},
  27=> %{1=> 108,2=> 191,3=> 337,4=> 165,5=> 220,6=> 188,7=> 190,8=> 43,9=> 266,10=> 161,11=> 216,12=> 241,13=> 104,14=> 246,15=> 177,16=> 55,17=> 299,18=> 233,19=> 121,20=> 189,21=> 149,22=> 290,23=> 80,24=> 41,25=> 147,26=> 265,27=> 0,28=> 124,29=> 263,},
  28=> %{1=> 45,2=> 139,3=> 273,4=> 228,5=> 121,6=> 60,7=> 314,8=> 81,9=> 132,10=> 189,11=> 308,12=> 112,13=> 158,14=> 335,15=> 266,16=> 155,17=> 380,18=> 314,19=> 213,20=> 182,21=> 97,22=> 379,23=> 189,24=> 93,25=> 247,26=> 178,27=> 124,28=> 0,29=> 199,},
  29=> %{1=> 167,2=> 79,3=> 77,4=> 205,5=> 97,6=> 185,7=> 435,8=> 243,9=> 111,10=> 163,11=> 322,12=> 238,13=> 206,14=> 288,15=> 243,16=> 275,17=> 319,18=> 253,19=> 281,20=> 135,21=> 108,22=> 332,23=> 342,24=> 218,25=> 350,26=> 39,27=> 263,28=> 199,29=> 0,},
  }
  config = Aco_tsp.new_configuration(3, graph)
    IO.puts(inspect(config))
    process = spawn(:cm, fn -> Aco_tsp.start_colony(config) end)

    handle = Process.monitor(process)

    # Timeout
    receive do
      {:DOWN, ^handle, _, _, reason} -> IO.puts("Received down #{reason}")
    after
      120_000 -> assert false
    end
  after
    Emulation.terminate()


  end
end
