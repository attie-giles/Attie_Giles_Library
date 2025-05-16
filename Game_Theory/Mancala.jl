### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 29f2dfb6-0abf-11f0-1323-478b246035e9
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
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
    #using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ a0f27724-a694-4cc8-aab3-87bd7094444c
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 217f2bab-6cba-49c5-9710-d3858e69b9cf
begin #Mancala starting parameters
	a_10 = 4
	b_10 = 4
	c_10 = 4
	d_10 = 4
	e_10 = 4
	f_10 = 4
	a_20 = 4
	b_20 = 4
	c_20 = 4
	d_20 = 4
	e_20= 4
	f_20= 4
	store_10 = 4
	store_20 = 4
end

# ╔═╡ 16d1c859-5995-47b4-9cfc-6e745b135f01
md"""Select Starting Move: 
	$(@bind start Select(["a1", "b1", "c1", "d1", "e1", "f1", "a2", "b2", "c2", "d2", "e2", "f2"], default="a1"))"""


# ╔═╡ 5dcd75d2-8e12-46de-8365-4235cc9e7c84
function mancala_r1(a_10, b_10, c_10, d_10, e_10, f_10, a_20, b_20, c_20, d_20, e_20, f_20, store_10, store_20, start)

	#Initialize Round 1 Values
	a_11 = 0
	b_11 = 0
	c_11 = 0
	d_11 = 0
	e_11 = 0
	f_11 = 0
	a_21 = 0
	b_21 = 0
	c_21 = 0
	d_21 = 0
	e_21 = 0
	f_21 = 0
	store_11 = 0
	store_21 = 0
	hand = 0 
	
	if start == "a1"
		hand = a_10 
		a_11 = a_10 - hand
	end
	
	return hand, a_11
end;

# ╔═╡ 613033ea-178f-4bd3-96b4-9999349084c1
mancala_r1(a_10, b_10, c_10, d_10, e_10, f_10, a_20, b_20, c_20, d_20, e_20, f_20, store_10, store_20, start)

# ╔═╡ Cell order:
# ╠═29f2dfb6-0abf-11f0-1323-478b246035e9
# ╠═a0f27724-a694-4cc8-aab3-87bd7094444c
# ╠═217f2bab-6cba-49c5-9710-d3858e69b9cf
# ╟─16d1c859-5995-47b4-9cfc-6e745b135f01
# ╠═5dcd75d2-8e12-46de-8365-4235cc9e7c84
# ╠═613033ea-178f-4bd3-96b4-9999349084c1
