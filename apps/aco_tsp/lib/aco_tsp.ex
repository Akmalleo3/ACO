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
    Q: 1,
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

  def tour_cost(tour) do
    0
  end

  def is_tour_complete(tour) do
    false
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
      n_ants: state.n_ants
    }

    pheromone_manager(pm_state)
  end

  @spec make_ant_manager(%Aco_tsp{}) :: no_return()
  def make_ant_manager(state) do
    am_state = %Aco_tsp.AntManager{colony_manager: state.pid}
    ant_manager(am_state)
  end

  @spec make_ant(%Aco_tsp.Ant{}, non_neg_integer()) :: no_return()
  def make_ant(a_state, n_left) do
    case n_left do
      0 ->
        true

      _ ->
        spawn(String.to_atom("ant#{n_left}"), ant(a_state))
        make_ant(a_state, n_left-1)
    end
  end

  @spec make_ants(%Aco_tsp{}) :: no_return()
  def make_ants(state) do
    ant_state = %Aco_tsp.Ant{
      ant_manager: :am,
      graph_manager: :gm,
      pheromone_manager: :pm
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
    # receive best solution from ant_manager for this iteration
    IO.puts("in colony manager")
    # report it
    receive do
    after 5_000 -> true
    end
  end

  @doc
  """
  This function implements the state machine for
  a process that is a pheromone_manager
  """

  @spec pheromone_manager(%Aco_tsp.PheromoneManager{}) :: no_return()
  def pheromone_manager(state) do
    # for a given round provide requested pheromone valuers
    IO.puts("In Pheromone manager")
    # collect solutions from all ants for a single round

    # update pheromone matrix
    pheromone_manager(state)
    # update iteration index
  end

  @doc
  """
  This function implements the state machine for
  a process that is a graph_manager
  """

  @spec graph_manager(%Aco_tsp.GraphManager{}) :: no_return()
  def graph_manager(state) do
    # Receive request from ant for incident edges to current node
    IO.puts("In graph manager")
    graph_manager(state)
    # Check if tour is complete, if so return the cost
  end

  @doc
  """
  This function implements the state machine for
  a process that is an ant_manager
  """

  @spec ant_manager(%Aco_tsp.AntManager{}) :: no_return()
  def ant_manager(state) do
    # collect all solutions for a single round
    IO.puts("In ant manager")

    # select the best one
    ant_manager(state)
    # send to colony manager
  end

  @doc
  """
  This function implements the state machine for
  a process that is an ant
  """

  @spec ant(%Aco_tsp.Ant{}) :: no_return()
  def ant(state) do
    # Request possible moves
    IO.puts("In ant" )
    ant(state)
    # is tour completed? Send to pheromone manager
    # and to ant manager

    # otherwise get pheromones for possible moves

    # Select an edge and add to solution
  end
end
