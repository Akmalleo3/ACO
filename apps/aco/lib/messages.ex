defmodule aco_tsp.ColonyManager do
  @moduledoc """
  Colony Manager state struct
  TODO this process would coordinate across
  multiple systems, but first pass is just
  a somewhat redundant top level node for
  reporting
  """
  defstruct()
end

defmodule aco_tsp.PheremoneManager do
  @moduledoc """
  Pheremone Manager state struct
  """
  defstruct(
    # The pheremone matrix is
    # of type Map: vertex -> (Map: vertex->pheremoneValue)
    pheremone_matrix: %{},
    # index of the round for which this pheremone applies
    round: 0,
    # number of completed solutions received this round
    n_solutions: 0,
    # a list of (tour, tour cost) pairs
    solutions: []
  )
end

defmodule aco_tsp.GraphManager do
  @moduledoc """
  Graph Manager state struct
  """
  defstruct(
    # A Graph is composed of the "graph"
    # of type Map: vertex -> (Map: vertex->edgeCost)
    graph: %{}
  )
end

defmodule aco_tsp.AntManager do
  @moduledoc """
  Ant Manager state struct
  """
  defstruct(
    # the list of nodes in order that make the tour
    best_tour: [],
    best_cost: 999_999_999, # cost of most optimal path found thus far
    colony_manager: nil #process id of colony_manager
  )
end

defmodule aco_tsp.Ant do
  @moduledoc """
  Ant state struct
  """
  defstruct(
    # a list of nodes travelled on this tour
    # with the head of the list being
    # the most recently visited node
    tour: [],
    # index of the current iteration
    round: 0,
    ant_manger: nil #process id of ant_manager
    graph_manger: nil #process id of graph_manager
    pheremone_manger: nil #process id of pheremone_manager
  )
end
