import acopy
import tsplib95
import time

solver = acopy.Solver(rho=0.01, q=1)
colony = acopy.Colony(alpha=1, beta=3)
problem = tsplib95.load_problem('ch130.tsp')
G = problem.get_graph()

for n_ants in [130,260,500,1000]:
    for lim in [50,100,200,500]:
        t_0 = time.time()
        tour = solver.solve(G, colony, gen_size=n_ants, limit=lim)
        end = time.time()
        print(f"Tour cost {tour.cost} #Ants: {n_ants} time: {round(end-t_0,4)}")
