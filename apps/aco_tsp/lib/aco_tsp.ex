defmodule Aco_tsp do
  @moduledoc """
  A distributed ant colony optimizer for the Traveling Salesman Problem
  """

  import Emulation, only: [send: 2, timer: 1, now: 0, whoami: 0]
  import Kernel,
    except: [spawn: 3, spawn: 1, spawn_link: 1, spawn_link: 3, send: 2]

  require Logger

  defstruct(
    # parameters in paper
    alpha: 2, # pheremone trial importance
    beta: 3, # heuristic visibility importance
    Q: 1, # pheremone update constant
    rho: 0.99, #pheremone persistence coefficient
    tau0: 0.01, #pheremone initial value
    n_ants: nil,
    graph: nil
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

  ##########################
  # Begin Process functions
  ##########################

  @spec start_colony(%Aco_tsp{}) :: no_return()
  def start_colony(state) do
    # spawn underling managers and all of the ants

    # become colony manager
    colony_manager(state)
  end


  @doc
  """
  This function implements the state machine for
  a process that is a colony_manager
  """
  @spec colony_manager(%Aco_tsp{}) :: no_return()
  def colony_manager(state) do
    # receive best solution from ant_manager for this iteration

    # report it
  end

  @doc
  """
  This function implements the state machine for
  a process that is a pheremone_manager
  """

  @spec pheremone_manager(%Aco_tsp.PheremoneManager{}) :: no_return()
  def pheremone_manager(state) do
    # for a given round provide reqeursted pheremone valuers

    # collect solutions from all ants for a single round

    # update pheremone matrix

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

    # select the best one

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

    # is tour completed? Send to pheremone manager
    # and to ant manager

    # otherwise get pheremones for possible moves

    # Select an edge and add to solution
  end
end
