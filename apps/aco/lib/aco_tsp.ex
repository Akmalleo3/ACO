defmodule aco_tsp do
  @moduledoc """
  A distributed ant colony optimizer for the Traveling Salesman Problem
  """
  import Kernel
  require Logger

  @doc """
  Create state for an initial colony system
  """
  @spec new_configuration() :: %aco_tsp{}
  def new_configuration() do
    %aco_tsp{}
  end

  ##########################
  # Begin Helper functions
  ##########################

  def tour_cost(tour) :: integer do
    0
  end

  def is_tour_complete(tour) :: boolean do
    false
  end

  ##########################
  # Begin Process functions
  ##########################
  @doc
  """
  This function implements the state machine for
  a process that is a colony_manager
  """

  @spec colony_manager(%aco_tsp.ColonyManager{}) :: no_return()
  def colony_manager(state) do
    # receive best solution from ant_manager for this iteration

    # report it
  end

  @doc
  """
  This function implements the state machine for
  a process that is a pheremone_manager
  """

  @spec pheremone_manager(%aco_ts.Pheremone{}) :: no_return()
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

  @spec graph_manager(%aco_tsp.GraphManager{}) :: no_return()
  def graph_manager(state) do
    # Receive request from ant for incident edges to current node

    # Check if tour is complete, if so return the cost
  end

  @doc
  """
  This function implements the state machine for
  a process that is an ant_manager
  """

  @spec ant_manager(%aco_tsp.AntManager{}) :: no_return()
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

  @spec ant(%aco_tsp.Ant{}) :: no_return()
  def ant(state) do
    # Request possible moves

    # is tour completed? Send to pheremone manager
    # and to ant manager

    # otherwise get pheremones for possible moves

    # Select an edge and add to solution
  end
end
