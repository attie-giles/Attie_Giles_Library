### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 94dbf824-126e-11f0-1714-0b4c8428a195
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    #using DifferentialEquations  
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
end


# ╔═╡ 2dfa3d4e-a9b6-4c2e-b8e2-965d97b6ab69
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ d2995d03-a555-4bf8-8917-1719b720c686
md"""
# Take Home 4
"""

# ╔═╡ 1c0beaec-ce20-40fd-ad4d-6400ba624520
begin #parameters
	δ= .1
end;

# ╔═╡ f6221e37-1a73-4244-a4c3-6640cffff988
begin #Nullcline equations
	Y(X) = F(X)
	F(X) = X*(1-X) 
	Y_dot(X,Y) = F_X(X) + (V_X(X)-D_X(X))/(N_Y(Y)) - δ
	F_X(X) = 1 - 2*X
	V(X) = X^(.5)
	V_X(X) = .5 * X^(-.5)
	D(X) = X^2
	D_X(X) = 2*X
	N(Y) = Y*(1-Y)
	N_Y(Y) = 1-2*Y
end;

# ╔═╡ 194bfca1-a552-45f8-b7c8-4e574a7318a3
Xvec = collect(range(0.01,1,length=1001))

# ╔═╡ 138ba34f-daec-4e70-ae6c-3b43befe4e6b
function Y_null(X)


# Define the zero condition at the parameter value supplied
cond(Y) = Y_dot(X,Y)


# Specify a starting guess
Y0 = .00001


# Find and return the solution
Y = find_zero(cond, Y0)


end;


# ╔═╡ 1026602b-330c-4cd7-a4d9-a5c78516a60e
begin
    nullclinefig = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
    #widen=1.02,
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(Xvec, Y.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Xvec,Y_null.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*Xvec[end])
    ylims!(-1, 1)


    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(fxvec))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(fxvec), text(L"y", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, xstar], [L"0", L"x^*"])
    yticks!([0.001, f0 ,fxvec], [L"0", L"f(0)", L"f(x^*)"])


    # Curve labels
    flx = 1.5*xstar
    fly = 1.01*f(flx)
    annotate!(flx, fly, text(L"f(x)", :left, :bottom, 12))


    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,fxvec], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [fxvec,fxvec], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [fxvec], markercolor=:black, markersize=5)
    =#


   nullclinefig	
end


# ╔═╡ Cell order:
# ╠═94dbf824-126e-11f0-1714-0b4c8428a195
# ╠═2dfa3d4e-a9b6-4c2e-b8e2-965d97b6ab69
# ╟─d2995d03-a555-4bf8-8917-1719b720c686
# ╠═f6221e37-1a73-4244-a4c3-6640cffff988
# ╠═1c0beaec-ce20-40fd-ad4d-6400ba624520
# ╠═194bfca1-a552-45f8-b7c8-4e574a7318a3
# ╠═138ba34f-daec-4e70-ae6c-3b43befe4e6b
# ╟─1026602b-330c-4cd7-a4d9-a5c78516a60e
