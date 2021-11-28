defmodule Aco_tsp do
  @moduledoc """
  A distributed ant colony optimizer for the Traveling Salesman Problem
  """

  import Emulation, only: [spawn: 2, send: 2, timer: 1, now: 0, whoami: 0]

  import Kernel,
    except: [spawn: 3, spawn: 1, spawn_link: 1, spawn_link: 3, send: 2]

  require Logger

  defstruct(
    # parameters in paper
    # Pheromone trial importance
    alpha: 2,
    # heuristic visibility importance
    beta: 3,
    # Pheromone update constant
    q_val: 1,
    # Pheromone persistence coefficient
    rho: 0.99,
    # Pheromone initial value
    tau0: 0.01,
    n_ants: nil,
    graph: nil,
    # pid
    pid: nil
  )

  @doc """
  Create state for an initial colony system
  """
  @spec new_configuration(non_neg_integer(), Map) :: %Aco_tsp{}
  def new_configuration(n_ants, graph) do
    %Aco_tsp{n_ants: n_ants, graph: graph}
  end

  ##########################
  # Begin Helper functions
  ##########################

  def tour_cost(tour, state, cost) do
    case length(tour) do
      1 -> cost
      _ -> [e1,e2|tail] = tour
           tour_cost([e2|tail], state, cost + Map.get(Map.get(state.graph, e1, %{}), e2, 0))
    end
  end

  def is_tour_complete(tour, num_nodes) do
    length(tour) == num_nodes
  end

  @doc
  """
  Send Pheromone Request and Return the response
  """
  @spec ant_get_pheromones(%Aco_tsp.Ant{}, Map) :: []
  def ant_get_pheromones(state, neighbors) do
    send(
      state.pheromone_manager,
      %Aco_tsp.PheromoneRequest{
        round: state.round,
        current_node: hd(state.tour),
        neighbors: Map.keys(neighbors)
      }
    )

    receive do
      {sender, %Aco_tsp.PheromoneResponse{pheromones: pheromones}} -> pheromones
    end
  end

  def my_choice(random_num, probs, idx) do
    IO.puts("My choice #{inspect(probs)} index: #{idx}")

    case length(probs) do
      1 ->
        idx

      _ ->
        [hd_p | tail_p] = probs

        cond do
          random_num <= hd_p ->
            idx

          true ->
            my_choice(random_num, [hd_p + hd(tail_p)] ++ tl(tail_p), idx + 1)
        end
    end
  end

  @spec ant_make_move(%Aco_tsp.Ant{}, Map, []) :: %Aco_tsp.Ant{}
  def ant_make_move(state, neighbors, pheromones) do
    # Calculate the probabilities of each move

    # (tau)^alpha
    taus = Enum.map(pheromones, fn x -> :math.pow(x, state.alpha) end)
    #IO.puts("taus: #{inspect(taus)}")
    # (1/cost)^Beta
    visibilities =
      Enum.map(Map.values(neighbors), fn x -> :math.pow(1 / x, state.beta) end)

    #IO.puts("visibilities: #{inspect(visibilities)}")
    zipper = Enum.zip(taus, visibilities)
    #IO.puts("zipped: #{inspect(zipper)}")
    products = Enum.map(zipper, fn {x, y} -> x * y end)
    total_prob = Enum.sum(products)
    probabilities = Enum.map(products, fn x -> x / total_prob end)
    #IO.puts("Sum of prob: #{inspect(Enum.sum(probabilities))}")

    # Draw a number uniformly between 0 and 1
    # and use it to make a choice
    random = :rand.uniform()
    index_next_node = my_choice(random, probabilities, 0)
    #IO.puts("Chooding index: #{index_next_node}")
    choice = neighbors[index_next_node]
    #IO.puts("Ant Chose node: #{choice}")

    # Update the state and return
    %{state | tour: [choice] ++ state.tour}
  end

  def clear_update_matrix(state) do
    %{
      state
      | update_matrix:
          Map.new(
            Enum.map(state.update_matrix, fn {k, v} ->
              {k, Map.new(Enum.map(v, fn {k, v} -> {k, 0} end))}
            end)
          )
    }
  end

  def update_update_matrix(state, tour, cost) do
    case length(tour) do
      1 ->
        state

      _ ->
        [hd_tour | tail_tour] = tour

        e1 = hd_tour
        e2 = hd(tail_tour)

        q = state.q_val

        # For edge in one direction
        state = %{
          state
          | update_matrix:
              Map.update(state.update_matrix, e1, %{}, fn m ->
                Map.update(m, e2, 0, fn x -> x + q / cost end)
              end)
        }

        # For the edge in the opposite direction
        state = %{
          state
          | update_matrix:
              Map.update(state.update_matrix, e2, %{}, fn m ->
                Map.update(m, e1, 0, fn x -> x + q / cost end)
              end)
        }

        update_update_matrix(state, tail_tour, cost)
    end
  end

  # tau(t+1) = rho*tau(t) + update_matrix
  def update_pheromone_matrix(state) do
    %{
      state
      | pheromone_matrix:
          Map.new(
            Enum.zip(
              Map.keys(state.pheromone_matrix),
              Enum.map(Map.keys(state.pheromone_matrix), fn k ->
                Map.merge(
                  Map.get(state.pheromone_matrix, k, %{}),
                  Map.get(state.update_matrix, k, %{}),
                  fn _k, v1, v2 ->
                    state.rho * v1 + v2
                  end
                )
              end)
            )
          )
    }
  end

  @spec make_graph_manager(%Aco_tsp{}) :: no_return()
  def make_graph_manager(state) do
    gm_state = %Aco_tsp.GraphManager{graph: state.graph}
    graph_manager(gm_state)
  end

  @spec make_pheromone_manager(%Aco_tsp{}) :: no_return()
  def make_pheromone_manager(state) do
    # copy the graph, but all values in the inner map
    # are starting Pheromone value tau0
    g =
      Map.new(state.graph, fn {k, v} ->
        {k,
         Enum.reduce(v, %{}, fn {kk, vv}, m -> Map.put(m, kk, state.tau0) end)}
      end)

    IO.puts(inspect(g))

    pm_state = %Aco_tsp.PheromoneManager{
      pheromone_matrix: g,
      n_ants: state.n_ants,
      q_val: state.q_val,
      rho: state.rho
    }

    pheromone_manager(pm_state)
  end

  @spec make_ant_manager(%Aco_tsp{}) :: no_return()
  def make_ant_manager(state) do
    am_state = %Aco_tsp.AntManager{
      colony_manager: state.pid,
      n_ants: state.n_ants
    }

    ant_manager(am_state)
  end

  @spec make_ant(%Aco_tsp.Ant{}, non_neg_integer()) :: no_return()
  def make_ant(a_state, n_left) do
    case n_left do
      0 ->
        true

      _ ->
        spawn(String.to_atom("ant#{n_left}"), ant(a_state))
        make_ant(a_state, n_left - 1)
    end
  end

  @spec make_ants(%Aco_tsp{}) :: no_return()
  def make_ants(state) do
    ant_state = %Aco_tsp.Ant{
      ant_manager: :am,
      graph_manager: :gm,
      pheromone_manager: :pm,
      alpha: state.alpha,
      beta: state.beta
    }

    make_ant(ant_state, state.n_ants)
  end

  @spec start_colony(%Aco_tsp{}) :: no_return()
  def start_colony(state) do
    IO.puts("Starting colony")
    state = %{state | pid: whoami()}
    IO.puts(inspect(state))
    # spawn underling managers and all of the ants
    spawn(:pm, fn -> make_pheromone_manager(state) end)

    spawn(:gm, fn -> make_graph_manager(state) end)

    spawn(:am, fn -> make_ant_manager(state) end)

    # become colony manager
    colony_manager(state)
  end

  ##########################
  # Begin Process functions
  ##########################

  @doc
  """
  This function implements the state machine for
  a process that is a colony_manager
  """

  @spec colony_manager(%Aco_tsp{}) :: no_return()
  def colony_manager(state) do
    # receive best solution from ant_manager for this iteration and report it
    receive do
      {sender, %Aco_tsp.SolutionReport{tour: tour, cost: cost, round: round}} ->
        IO.puts(
          "Colony Manager received optimal tour of cost #{cost}  " <>
            "For round #{round}"
        )

        IO.puts("OPtimal path is: #{tour}")
    after
      45_000 ->
        IO.puts("No SOlution reported")
        true
    end
  end

  @doc
  """
  This function implements the state machine for
  a process that is a pheromone_manager
  """
  @spec pheromone_manager(%Aco_tsp.PheromoneManager{}) :: no_return()
  def pheromone_manager(state) do
    receive do
      # for the current round provide requested pheromone values
      {sender,
       %Aco_tsp.PheromoneRequest{
         round: round,
         current_node: node,
         neighbors: neighbors
       }} ->
        case round == state.round do
          true ->
            pmones =
              Enum.map(neighbors, fn x ->
                Map.get(Map.get(state.pheromone_matrix, node, %{}), x)
              end)

            send(sender, %Aco_tsp.PheromoneResponse{pheromones: pmones})

          false ->
            IO.puts("received pheromone request for round #{round}")
            IO.puts("My current round is #{state.round}")
            # resend it to the back of the queue?
            send(whoami(), %Aco_tsp.PheromoneRequest{
              round: round,
              current_node: node,
              neighbors: neighbors
            })
        end

        pheromone_manager(state)

      {sender, %Aco_tsp.SolutionReport{tour: tour, cost: cost, round: round}} ->
        case round == state.round do
          false ->
            IO.puts("Received Solution Report for for round #{round}")
            IO.puts("My round is #{state.round}")

            send(whoami(), %Aco_tsp.SolutionReport{
              tour: tour,
              cost: cost,
              round: round
            })

          true ->
            # add to the update matrix
            state = update_update_matrix(state, tour, cost)
            # collected them all?
            state =
              case state.n_ants == state.n_solutions + 1 do
                true ->
                  state = update_pheromone_matrix(state)
                  # clear out the update matrix
                  state = clear_update_matrix(state)
                  # update iteration index/collection count
                  %{state | round: state.round + 1, n_solutions: 0}

                false ->
                  %{state | n_solutions: state.n_solutions + 1}
              end

            pheromone_manager(state)
        end
    end
  end

  @doc
  """
  This function implements the state machine for
  a process that is a graph_manager
  """

  @spec graph_manager(%Aco_tsp.GraphManager{}) :: no_return()
  def graph_manager(state) do
    # Receive request from ant for incident edges to current node
    receive do
      {sender, %Aco_tsp.EdgesRequest{tour: tour}} ->
        # Check if tour is complete, if so return the cost
        case is_tour_complete(tour, length(Map.keys(state.graph))) do
          true ->
            send(
              sender,
              %Aco_tsp.EdgesResponse{
                tour_complete: true,
                neighbors: %{},
                cost: tour_cost(tour,state,0)
              }
            )

          false ->
            # Otherwise return the list of neighbors and edge costs
            neighbors = Map.get(state.graph, hd(tour), %{})
            # deleting nodes already visited in the tour
            neighbors = Map.drop(neighbors, tour)

            send(
              sender,
              %Aco_tsp.EdgesResponse{
                tour_complete: false,
                cost: nil,
                neighbors: neighbors
              }
            )
        end
    end

    graph_manager(state)
  end

  @doc
  """
  This function implements the state machine for
  a process that is an ant_manager
  """

  @spec ant_manager(%Aco_tsp.AntManager{}) :: no_return()
  def ant_manager(state) do
    # collect all solutions for a single round
    receive do
      {sender, %Aco_tsp.SolutionReport{tour: tour, cost: cost, round: round}} ->
        case round == state.round do
          true ->
            # Is this the new optimal?
            state =
              case cost < state.best_cost do
                true ->
                  %{state | best_tour: tour, cost: cost}

                false ->
                  state
              end

            # Have all reports been received this round?
            state =
              case state.n_solutions + 1 == state.n_ants do
                true ->
                  # Send the optimal solution up
                  send(state.colony_manager, %Aco_tsp.SolutionReport{
                    cost: state.best_cost,
                    tour: state.best_tour
                  })

                  # reset the state
                  %Aco_tsp.AntManager{
                    n_ants: state.n_ants,
                    colony_manager: state.colony_manager,
                    round: state.round + 1
                  }

                false ->
                  %{state | n_solutions: state.n_solutions + 1}
              end

            ant_manager(state)

          false ->
            IO.puts("Received Solution report for round:#{round}")
            IO.puts("My current round is : #{state.round}")

            send(whoami(), %Aco_tsp.SolutionReport{
              tour: tour,
              cost: cost,
              round: round
            })

            ant_manager(state)
        end
    end

    ant_manager(state)
  end

  @doc
  """
  This function implements the state machine for
  a process that is an ant
  """

  @spec ant(%Aco_tsp.Ant{}) :: no_return()
  def ant(state) do
    # Request possible moves
    send(
      state.graph_manager,
      %Aco_tsp.EdgesRequest{tour: state.tour}
    )

    receive do
      {sender,
       %Aco_tsp.EdgesResponse{
         tour_complete: tour_complete,
         cost: cost,
         neighbors: neighbors
       }} ->
        case tour_complete do
          # is tour completed? Send to pheromone manager
          # and to ant manager
          true ->
            solution = %Aco_tsp.SolutionReport{
              tour: state.tour,
              cost: cost,
              round: state.round
            }

            send(state.pheromone_manager, solution)
            send(state.ant_manager, solution)
            state = %{state | round: state.round + 1}

          # otherwise get pheromones for possible moves
          false ->
            pheromones = ant_get_pheromones(state, neighbors)
            # Select an edge and add to solution
            state = ant_make_move(state, neighbors, pheromones)
        end
    end

    ant(state)
  end
end
