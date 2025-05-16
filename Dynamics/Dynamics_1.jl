### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 85d40860-e1bf-11ef-15f7-6931f047551f
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	using QuadGK   # integrate a function
    using DynamicalSystems #dynamical systems
    using DifferentialEquations  
    #using Compiler
    #using Flux
    #using Turing  
    using CairoMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	#using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end

# ╔═╡ b1f11839-4d0d-42f3-afb0-e80a3509afec
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ deefff85-ae64-4b89-98d2-f834b6a7edcf
md"""
# Dynamics 
"""

# ╔═╡ a7acfc28-dd36-444d-96c2-9507ad4fc3d3
md"""
## Differential Equations and Dynamical Systems in Julia
"""

# ╔═╡ 0555a924-cd40-4dbc-bcca-e6add2f6f253
md"""
### Henon Map
"""

# ╔═╡ bc2e1d41-ca65-4e7f-b251-60fc14ddf011
md"""
$Henon \;  Map$

The Henon Map is a discrete-time dynamical system which is one of the most stuied dynamical systems that exhibit chaotic behavior. The henon maps takesa point $(x_n,y_n)$ in the plane and maps it to a new point 

$\begin{align*}
x_{n+1} &= 1 - ax^2_n+t_n \\
y_{n+1} &= bx_n.
\end{align*}$
This map depends on two parameters, $a$ and $b$, which for the classical Henon Map have alues of $a=1.4$ and $b=0.3$. For other values of a and b the map may be chaotic, intermittent, or converge to a periodic orbit. The map was introduced by Michel Hénon as a simplified model of the Poincaré section of the Lorenz model. For the classical map, an initial point of the plane will either approach a set of points known as the Hénon strange attractor, or diverge to infinity. The Hénon attractor is a fractal, smooth in one direction and a Cantor set in another.

$\underline{History}$

In 1976 France, the Lorenz attractor is analyzed by the physicist Yves Pomeau who performs a series of numerical calculations with J.L. Ibanez. The analysis produces a kind of complement to the work of Ruelle (and Lanford) presented in 1975. It is the Lorenz attractor, that is to say, the one corresponding to the original differential equations, and its geometric structure that interest them. Pomeau and Ibanez combine their numerical calculations with the results of mathematical analysis, based on the use of Poincaré sections. Stretching, folding, sensitivity to initial conditions are naturally brought in this context in connection with the Lorenz attractor. If the analysis is ultimately very mathematical, Pomeau and Ibanez follow, in a sense, a physicist approach, experimenting with the Lorenz system numerically.

Two openings are brought specifically by these experiences. They make it possible to highlight a singular behavior of the Lorenz system: there is a transition, characterized by a critical value of the parameters of the system, for which the system switches from a strange attractor position to a configuration in a limit cycle. The importance will be revealed by Pomeau himself (and a collaborator, Paul Manneville) through the "scenario" of Intermittency, proposed in 1979.

The second path suggested by Pomeau and Ibanez is the idea of realizing dynamical systems even simpler than that of Lorenz, but having similar characteristics, and which would make it possible to prove more clearly "evidences" brought to light by numerical calculations. Since the reasoning is based on Poincaré's section, he proposes to produce an application of the plane in itself, rather than a differential equation, imitating the behavior of Lorenz and its strange attractor. He builds one in an ad hoc manner which allows him to better base his reasoning.

In January 1976, Pomeau presented his work during a seminar given at the Côte d'Azur Observatory, attended by Michel Hénon. Michel Hénon uses Pomeau’s suggestion to obtain a simple system with a strange attractor.
"""

# ╔═╡ 65e47ee6-01e8-45b7-a8d6-ec9c4d7b18bc
function henon_rule(u, p, n) # here `n` is "time", but we don't use it.
    x, y = u # system state; here u is defined as a vector of [x,y] where we are feeding it an intitial vector u0 an it is being decomposed into a and y
    a, b = p # system parameters same with this parameter
    xn = 1.0 - a*x^2 + y
    yn = b*x
    return SVector(xn, yn)
end;

# ╔═╡ 2aee0a97-03dc-4716-a535-2483a29d4efb
begin  #define the initial state and parameters
u0 = [0.2, 0.3]
p0 = [1.4, 0.3]
end;

# ╔═╡ c3d98d7d-1a5f-4a28-a974-9da87c1b6040
henon = DeterministicIteratedMap(henon_rule, u0, p0)

# ╔═╡ 3e84e679-d66e-420a-931a-faa369eeb5e0
md"""
henon is a DynamicalSystem, one of the two core structures of the library. They can evolved interactively, and queried, using the interface defined by DynamicalSystem. The simplest thing you can do with a DynamicalSystem is to get its trajectory:
"""

# ╔═╡ 498621ba-aa3a-480f-953e-06afe799f351
begin
total_time = 10_000
X, t = trajectory(henon, total_time)
X
end

# ╔═╡ 0acf270f-6e28-4f0e-a51b-1e593e68390b
scatter(X) #note CairoMakie does not work with plots

# ╔═╡ Cell order:
# ╠═85d40860-e1bf-11ef-15f7-6931f047551f
# ╠═b1f11839-4d0d-42f3-afb0-e80a3509afec
# ╟─deefff85-ae64-4b89-98d2-f834b6a7edcf
# ╟─a7acfc28-dd36-444d-96c2-9507ad4fc3d3
# ╟─0555a924-cd40-4dbc-bcca-e6add2f6f253
# ╟─bc2e1d41-ca65-4e7f-b251-60fc14ddf011
# ╠═65e47ee6-01e8-45b7-a8d6-ec9c4d7b18bc
# ╠═2aee0a97-03dc-4716-a535-2483a29d4efb
# ╠═c3d98d7d-1a5f-4a28-a974-9da87c1b6040
# ╟─3e84e679-d66e-420a-931a-faa369eeb5e0
# ╠═498621ba-aa3a-480f-953e-06afe799f351
# ╠═0acf270f-6e28-4f0e-a51b-1e593e68390b
