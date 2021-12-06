defmodule Acotsp_CostTest do
  use ExUnit.Case
  doctest Aco_tsp

  test "bays29 optimal cost" do
    solution = [
      1,
      28,
      6,
      12,
      9,
      5,
      26,
      29,
      3,
      2,
      20,
      10,
      4,
      15,
      18,
      17,
      14,
      22,
      11,
      19,
      25,
      7,
      23,
      27,
      8,
      24,
      16,
      13,
      21
    ]

    state = %Aco_tsp.GraphManager{graph: Acotsp_graphs.bays29()}
    cost = Aco_tsp.tour_cost(solution, state, 0)
    IO.puts("bays29 Optimal tour cost: #{cost}")
  end

  test "eil76 optimal cost" do
    solution = [
      33,
      63,
      16,
      3,
      44,
      32,
      9,
      39,
      72,
      58,
      10,
      31,
      55,
      25,
      50,
      18,
      24,
      49,
      23,
      56,
      41,
      43,
      42,
      64,
      22,
      61,
      21,
      47,
      36,
      69,
      71,
      60,
      70,
      20,
      37,
      5,
      15,
      57,
      13,
      54,
      19,
      14,
      59,
      66,
      65,
      38,
      11,
      53,
      7,
      35,
      8,
      46,
      34,
      52,
      27,
      45,
      29,
      48,
      30,
      4,
      75,
      76,
      67,
      26,
      12,
      40,
      17,
      51,
      6,
      68,
      2,
      74,
      28,
      62,
      73
    ]

    state = %Aco_tsp.GraphManager{graph: Acotsp_graphs.eil76()}
    cost = Aco_tsp.tour_cost(solution, state, 0)
    IO.puts("eil76 Optimal tour cost: #{cost}")
  end

  test "ch130 optimal cost" do
    solution = [
      1,
      41,
      39,
      117,
      112,
      115,
      28,
      62,
      105,
      128,
      16,
      45,
      5,
      11,
      76,
      109,
      61,
      129,
      124,
      64,
      69,
      86,
      88,
      26,
      7,
      97,
      70,
      107,
      127,
      104,
      43,
      34,
      17,
      31,
      27,
      19,
      100,
      15,
      29,
      24,
      116,
      95,
      79,
      87,
      12,
      81,
      103,
      77,
      94,
      89,
      110,
      98,
      68,
      63,
      48,
      25,
      113,
      32,
      36,
      84,
      119,
      111,
      123,
      101,
      82,
      57,
      9,
      56,
      65,
      52,
      75,
      74,
      99,
      73,
      92,
      38,
      106,
      53,
      120,
      58,
      49,
      72,
      91,
      6,
      102,
      10,
      14,
      67,
      13,
      96,
      122,
      55,
      60,
      51,
      42,
      44,
      93,
      37,
      22,
      47,
      40,
      23,
      33,
      21,
      126,
      121,
      78,
      66,
      85,
      125,
      90,
      59,
      30,
      83,
      3,
      114,
      108,
      8,
      18,
      46,
      80,
      118,
      20,
      4,
      35,
      54,
      2,
      50,
      130,
      71
    ]

    state = %Aco_tsp.GraphManager{graph: Acotsp_graphs.ch130()}
    cost = Aco_tsp.tour_cost(solution, state, 0)
    IO.puts("ch130 Optimal tour cost: #{cost}")
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

    state = %Aco_tsp.GraphManager{graph: Acotsp_graphs.a280()}
    cost = Aco_tsp.tour_cost(solution, state, 0)
    IO.puts("Optimal tour cost: #{cost}")
  end
end
