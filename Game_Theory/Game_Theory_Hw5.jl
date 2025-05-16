### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 0554233e-25ec-11f0-14dc-5b56529e7874
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
	using GameTheory
	using Graphs
	using GraphPlot
	using NetworkLayout
	using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
    using CairoMakie
	using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	#using Plots     # plot graphs
	using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ 7c4b7396-a4f1-410f-bba4-136c21eb4433
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 4a32554d-0b65-41d2-9c69-36fbcc2beeb9
md"""
# Homework 5 Game Theory
"""

# ╔═╡ 5e6b41c0-07c5-412c-a8c9-62b0739d9df5
begin

# Define adjacency matrix
adj_matrix = [0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; #1
              0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 ; #2
              0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 ; #3
              0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 ; #4
              0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 ; #5
              0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 ; #6
              0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 ; #7
              0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #8
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #9
			  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #10
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #11
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #12
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #13
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; #14
	          0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ] #15


	
# Create directed graph
g = SimpleDiGraph(adj_matrix)

# Define layout
 # Define Shell layout layers
   layout = Buchheim()

# Plot the graph
fig, ax, graph_obj = graphplot(g, layout=layout, node_size=10, node_color=:white, nlabels=["1.0 ","2.1 ","2.2 ","1.3","1.4","1.5","1.6", L"$[4,2]$", L"$[3,2]$" , L"$[4,1]$",  L"$[3,1]$",  L"$[2,2]$",  L"$[1,2]$",  L"$[2,1]$",  L"$[1,1]$"], nlabels_align=(:center, :center),nlabels_distance=4.0, elabels=[L"$W_D$", L"$W_E$", "O", "S","O","S","E", "D", "E", "D", "E", "D", "E", "D"], nlabels_fontsize=18, elabels_fontsize=18)


hidedecorations!(ax)  # Hides axis labels and ticks
hidespines!(ax)        # Hides the border around the plot

fig
	
end

# ╔═╡ Cell order:
# ╠═0554233e-25ec-11f0-14dc-5b56529e7874
# ╠═7c4b7396-a4f1-410f-bba4-136c21eb4433
# ╟─4a32554d-0b65-41d2-9c69-36fbcc2beeb9
# ╟─5e6b41c0-07c5-412c-a8c9-62b0739d9df5
