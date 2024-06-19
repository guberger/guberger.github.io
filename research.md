+++
title = "Research"
+++

Some past and current research projects.

# Data-driven analysis and control of cyber-physical systems

We considered several problems related to the analysis and control of cyber-physical systems from data.
This is relevant in many applications where we do not have an accurate model of the system.
We proposed data-driven Lyapunov function synthesis and data-driven optimal control techniques for switched linear systems [1].
We also proposed data-based predictive control techniques for risk-aware motion planning.

[1] Zheming Wang; Guillaume O. Berger; Raphaël M. Jungers, [Data-driven feedback stabilization of switched linear systems with probabilistic stability guarantees](https://ieeexplore.ieee.org/document/9683233), CDC 2020.

[2] Lara Brudermüller, Guillaume Berger, Julius Jankowski, Raunak Bhattacharyya, Raphaël Jungers, Nick Hawes, [CC-VPSTO: Chance-Constrained Via-Point-based Stochastic Trajectory Optimisation for Safe and Efficient Online Robot Motion Planning](https://arxiv.org/abs/2402.01370), submitted to TRO, 2024.

# Barrier function synthesis for nonlinear systems

We proposed a cone-based abstract-interpretation approach to compute barrier functions for nonlinear systems [1].
We showed that a barrier function can be obtained from a fixed-point of a functional mapping functions to convex cones of functions.
This allowed us to reduce the conservativeness of barrier function conditions usually encountered in the literature.
We also extended the approach to vector barrier functions, thereby allowing us to use several simple functions (e.g., polynomials of low degree) instead of a single complex one.

[1] Guillaume Berger, Masoumeh Ghanbarpour, Sriram Sankaranarayanan, [Cone-Based Abstract Interpretation for Nonlinear Positive Invariant Synthesis](https://dl.acm.org/doi/10.1145/3641513.3650127), HSCC 2024.

# Counterexample-guided methods for hybrid linear system verification

We studied CounterExample-Guided Inductive Synthesis (CEGIS) approaches for the synthesis of Lyapunov functions and barrier functions for switched and piecewise linear systems.
The main advantge of our approach is that it reduces to solve a series of Linear Programs, for which efficient and reliable solvers are available [1].
We also applied this approach to robot motion planning [2].

[1] Guillaume O. Berger, Sriram Sankaranarayanan, [Counterexample-guided computation of polyhedral Lyapunov functions for piecewise linear systems](https://www.sciencedirect.com/science/article/abs/pii/S0005109823003266), Automatica 2023.

[2] Alec Reed, Guillaume O Berger, Sriram Sankaranarayanan, Chris Heckman, [Verified Path Following Using Neural Control Lyapunov Functions](https://proceedings.mlr.press/v205/reed23a.html), CoRL 2023.


# Identification of hybrid linear systems

We addressed the long-standing and challenging problem of identifying hybrid linear systems from data.
Known algorithms are limited by the scalability with respect to the number of data points and/or the lack of guarantees.
Thriving on ideas from falsfication methods and nonsmooth optimization, we provided an algorithm that scales linearly with the number of data points and provides guarantees of near optimality [1].
We also considered other settings such as piecewise linear systems.

[1] Guillaume Berger, Monal Narasimhamurthy, Kandai Watanabe, Morteza Lahijanian, Sriram Sankaranarayanan, [An Algorithm for Learning Switched Linear Dynamics from Data](https://papers.nips.cc/paper_files/paper/2022/hash/c415cd32375a3a020598334eb110dd29-Abstract-Conference.html), NeurIPS 2022.

# Quantized control of switched linear systems

We studied the minimal data rate needed to observe or control a switched linear system over a communication network.
We provided a closed-form formula for the minimal data under the assumption that the switching signal is known [1]&nbsp;(this research obtained the HSCC Best Paper Award and was published in the Communication of the ACM).
We also derived upper and lower bounds on the minimal data rate under various other assumptions.

[1] Guillaume O. Berger, Raphaël M. Jungers, [Worst-case topological entropy and minimal data rate for state observation of switched linear systems](https://dl.acm.org/doi/abs/10.1145/3365365.3382195), HSCC 2020.

# Dominance of switched linear systems

We studied the property of switched linear systems to converge toward a low-dimensionnal subspace.
It is related to the notions of positivity and incremental stability.
It also has applications in quantized control.
Among others, we proposed a Lyapunov framework to verify the dominance of switched linear systems [1].

[1] Guillaume O. Berger, Raphaël M. Jungers, [$p$-dominant switched linear systems](https://www.sciencedirect.com/science/article/abs/pii/S0005109821003216), Automatica, 2021.