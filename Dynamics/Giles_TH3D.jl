### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ e9f80a98-f914-11ef-05ca-b7382e844499
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    using DynamicalSystems #dynamical systems
    using DifferentialEquations  
	#using GameTheory
	#using Graphs
	#using GraphPlot
	#using NetworkLayout
	#using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
   # using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end;

# ╔═╡ 9c503ead-1906-455f-b48c-54edee4349a7
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ c89cc15f-90c5-4968-8ff5-fe14685e1bff
Xvec = collect(range(0,1.5,length=200))

# ╔═╡ 9fcb8f04-9ef3-47ae-8d11-6472be72f1a9
begin #system of equations
X_dot(X,h) = g*X*(1-X)-h
h_dot(X,h) = (-(p-c*h)*(r-g+2*g*X))/c
end;

# ╔═╡ 1a8f0f76-df16-4e55-9bcc-9935185f0b67
# ╠═╡ disabled = true
#=╠═╡
begin #Parameters
	g = 3.5
	r = 1.7
	c = 10.0
	p = 11.0
end;
  ╠═╡ =#

# ╔═╡ 276a659d-7555-4512-a460-1db17e595789
begin# Define the system of equations
## Define parameters
g = 3.5
r = 1.7
c = 10.0  # Ensure this is a float
p = 11.0  # Ensure this is a float

# Define the system of equations (removing `p` since it's not needed)
function system!(du, u, _, t)  # Use `_` instead of `p` to avoid parameter issues
    X, h = u
    du[1] = g * X * (1 - X) - h
    du[2] = (-(p - c * h) * (r - g + 2 * g * X)) / c  # Ensure division works
end

	function X_null(X)
	
	# Define the zero condition at the parameter value supplied
cond(h) =  g * X * (1 - X) - h


# Specify a starting guess
h0 = .1


# Find and return the solution
h = find_zero(cond, h0)


end;
#Nullclines
plot!(Xvec, X_null.(Xvec), linecolor=:red, linestyle=:solid, linewidth=2)
	
# Define the grid for the phase plane
X_range = range(-0.5, 1.5, length=40)
h_range = range(-1, 2, length=40)

# Compute the vector field
X_vals = repeat(X_range, length(h_range))
h_vals = repeat(h_range, inner=length(X_range))

# Ensure numerical operations are float-safe
u_vals = [g * X * (1 - X) - h for (X, h) in zip(X_vals, h_vals)]
v_vals = [(-(p - c * h) * (r - g + 2 * g * X)) / c for (X, h) in zip(X_vals, h_vals)]

# Normalize the vectors for quiver plot
magnitude = sqrt.(u_vals.^2 .+ v_vals.^2)
u_norm = u_vals ./ magnitude
v_norm = v_vals ./ magnitude

# Plot the phase plane with quiver
quiver(X_vals, h_vals, quiver=(u_norm, v_norm), xlabel="X", ylabel="h",
       title="Phase Plane with Trajectories", color=:gray, alpha=0.7, linewidth=1)

# Solve an example trajectory
u0 = [0.5, 0.5]  # Initial condition
tspan = (0.0, 10.0)
prob = ODEProblem(system!, u0, tspan, nothing)  # Pass `nothing` as the parameter
sol = solve(prob, Tsit5())

# Overlay trajectories
plot!(sol[1, :], sol[2, :], label="Trajectory", lw=2)

	 # Axis limits
    xlims!(0,1)
    ylims!(-1, 1)
end

# ╔═╡ Cell order:
# ╠═e9f80a98-f914-11ef-05ca-b7382e844499
# ╠═9c503ead-1906-455f-b48c-54edee4349a7
# ╠═1a8f0f76-df16-4e55-9bcc-9935185f0b67
# ╠═9fcb8f04-9ef3-47ae-8d11-6472be72f1a9
# ╠═c89cc15f-90c5-4968-8ff5-fe14685e1bff
# ╠═276a659d-7555-4512-a460-1db17e595789
