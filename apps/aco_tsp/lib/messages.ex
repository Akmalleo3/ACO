defmodule Aco_tsp.ColonyManager do
  @moduledoc """
  Colony Manager state struct
  TODO this process would coordinate across
  multiple systems, but first pass is just
  a somewhat redundant top level node for
  reporting
  """
  defstruct(
    best_tour: [],
    best_cost: 999_999_999
  )
end

defmodule Aco_tsp.PheromoneManager do
  @moduledoc """
  Pheremone Manager state struct
  """
  defstruct(
    # The pheremone matrix is
    # of type Map: vertex -> (Map: vertex->pheromoneValue)
    pheromone_matrix: %{},
    # contains running total sum of pheromone update values
    # for next round
    update_matrix: %{},
    # index of the round for which this pheromone applies
    round: 0,
    # number of completed solutions received this round
    n_solutions: 0,
    # number of ants to collect solutions form
    n_ants: 0,
    # a list of (tour, tour cost) pairs
    solutions: [],
    q_val: nil,
    rho: nil
  )
end

defmodule Aco_tsp.GraphManager do
  @moduledoc """
  Graph Manager state struct
  """
  defstruct(
    # A Graph is composed of the "graph"
    # of type Map: vertex -> (Map: vertex->edgeCost)
    graph: %{}
  )
end

defmodule Aco_tsp.AntManager do
  @moduledoc """
  Ant Manager state struct
  """
  defstruct(
    # the list of nodes in order that make the tour
    best_tour: [],
    # cost of most optimal path found thus far
    best_cost: 999_999_999,
    # process id of colony_manager
    colony_manager: nil,
    # number of ants to keep track of
    n_ants: nil,
    # number of solutions collected
    n_solutions: 0,
    round: 0
  )
end

defmodule Aco_tsp.Ant do
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
    # process id of ant_manager
    ant_manager: nil,
    # process id of graph_manager
    graph_manager: nil,
    # process id of pheromone_manager
    pheromone_manager: nil,
    # Pheromone trial importance
    alpha: nil,
    # heuristic visibility importance
    beta: nil,
    n_nodes: nil
  )
end

defmodule Aco_tsp.EdgesRequest do
  @moduledoc """
  Sent by Ant to Graph Manager to get list of incident edges
  """
  defstruct(tour: [])
end

defmodule Aco_tsp.EdgesResponse do
  @moduledoc """
  Sent by Graph Manager to Ant in Response to request
  """
  defstruct(
    # true if every node visited
    tour_complete: false,
    # populate if tour_complete
    cost: nil,
    # map with key: vertex_id, val: edge cost
    neighbors: %{}
  )
end

defmodule Aco_tsp.PheromoneRequest do
  @moduledoc """
  Sent by Ant to Pheromone Manager to get list of pheromone values
  """
  defstruct(
    round: nil,
    current_node: nil,
    neighbors: []
  )
end

defmodule Aco_tsp.PheromoneResponse do
  @moduledoc """
  Sent by Ant to Pheromone Manager to get list of pheromone values
  """
  defstruct(
    # in the order of the neighbors
    pheromones: []
  )
end

defmodule Aco_tsp.SolutionReport do
  @moduledoc """
  From Ant to Ant Manager: solution found
  """
  defstruct(
    # in order list of nodes
    tour: [],
    cost: nil,
    round: nil
  )
end
