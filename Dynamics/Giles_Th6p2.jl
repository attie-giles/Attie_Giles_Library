### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 8973c2f2-2059-11f0-2160-11507fad58e2
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


# ╔═╡ 9aa5d903-27f1-43a5-8ad0-04f41d6907f8
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 30e66ec2-f500-451f-9adb-c54cbcc44b8f
begin #parameters
	r = 1.15
	K= 10.0
	α = 0.1 
	s = 1.5
	L = 75.0
	E_0 = 0
	E_max = 3
	E_maxl = 7
end;

# ╔═╡ b7f5a640-c730-4dba-bb00-e90ccd13c2c2
Xvec = collect(range(0, 100, length = 1000))

# ╔═╡ 946ba925-313c-4673-b9c5-e2f57c451c33
begin
	Y_isocline = L
	X_iso_1(X) = -(r .* X.* (1 .- X ./ K) .+ E_0 .* X) ./ (α .* X)
	X_iso_2(X) = -(r .* X.* (1 .- X ./ K) .+ E_max .* X) ./ (α .* X)
	X_iso_3(X) = -(r .* X.* (1 .- X ./ K) .+ E_maxl .* X) ./ (α .* X)
end;

# ╔═╡ 2ed6b01d-f2d2-4b60-bffe-d91a4eb652d3
begin #Equations
	X_dot(X, Y, E) = r * X * (1 - X/K) + α * X * Y - E * X
end;

# ╔═╡ 8edab476-d63b-4f23-b220-9c7261564613
begin
    fig4 = plot(
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
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!([L,L], [0,Xvec[end]], linecolor=:black, linestyle=:solid, linewidth=:2) 
	plot!(Xvec, X_iso_1.(Xvec), linecolor=:gray, linestyle=:solid, linewidth=:2)
	plot!(Xvec, X_iso_2.(Xvec), linecolor=:black, linestyle=:solid, linewidth=:2)
	plot!(Xvec, X_iso_3.(Xvec), linecolor=:gray, linestyle=:solid, linewidth=:2)
	 # Axis limits
    xlims!(0, 100)
    ylims!(0, 100)
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


   fig4	
end


# ╔═╡ 0d789551-47d1-4a1b-8476-ad8d003778f3


# ╔═╡ Cell order:
# ╠═8973c2f2-2059-11f0-2160-11507fad58e2
# ╠═9aa5d903-27f1-43a5-8ad0-04f41d6907f8
# ╠═30e66ec2-f500-451f-9adb-c54cbcc44b8f
# ╠═b7f5a640-c730-4dba-bb00-e90ccd13c2c2
# ╠═946ba925-313c-4673-b9c5-e2f57c451c33
# ╠═2ed6b01d-f2d2-4b60-bffe-d91a4eb652d3
# ╠═8edab476-d63b-4f23-b220-9c7261564613
# ╠═0d789551-47d1-4a1b-8476-ad8d003778f3
