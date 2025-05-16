### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 70d8faa6-3106-11f0-21cd-e3e09af7671f
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

# ╔═╡ 03c24925-3b6c-436f-8517-01b20ae78fc4
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 395b8d33-c5c2-45e5-8a28-ce787c69e70f
md"""
# Dynamics Final
"""

# ╔═╡ b092383a-016f-42ff-a8a4-a3f727a9bf7e
begin #parameters
	p = 10.0
	δ = 0.5
	e = 5.0
	c = 1.0
	r = 0.1
end;

# ╔═╡ b43a7f41-6129-4a60-9903-d64528a96b73
begin #nullclines
	u_1(X) = S(X)
	u_2(X) = (S_X(X) * (p - e * δ * S(X))) / (c * (r + S_X(X)))
	#______________________________________________________________#
	S(X) = X^0.5
	S_X(X) = 0.5 * X^(-0.5) 
end;

# ╔═╡ 4e2dc336-97c0-4574-b5f1-ae5fa087599e
Xvec = collect(range(0, 100, length=101))

# ╔═╡ 299786bb-e696-4889-a380-84a4585c3e64
begin
    nullclines = plot(
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
    plot!(Xvec, u_1.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Xvec, u_2.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 
   

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


   nullclines	
end


# ╔═╡ 48be07f0-df30-488c-9731-fc357585b6d4
function Xss()


# Define the zero condition at the parameter value supplied
cond(x) = u_1(x) - u_2(x)


# Specify a starting guess
x0 = 5


# Find and return the solution
x = find_zero(cond, x0)


end;


# ╔═╡ db123313-0b64-4427-b299-de48c663adfe
Xss()

# ╔═╡ 9b154793-949b-47e8-b6a4-2e431780b243
u_1(Xss())

# ╔═╡ f1658b2d-4824-450a-9a48-007a39c7bd3d


# ╔═╡ Cell order:
# ╠═70d8faa6-3106-11f0-21cd-e3e09af7671f
# ╠═03c24925-3b6c-436f-8517-01b20ae78fc4
# ╟─395b8d33-c5c2-45e5-8a28-ce787c69e70f
# ╠═b43a7f41-6129-4a60-9903-d64528a96b73
# ╠═b092383a-016f-42ff-a8a4-a3f727a9bf7e
# ╠═4e2dc336-97c0-4574-b5f1-ae5fa087599e
# ╟─299786bb-e696-4889-a380-84a4585c3e64
# ╠═48be07f0-df30-488c-9731-fc357585b6d4
# ╠═db123313-0b64-4427-b299-de48c663adfe
# ╠═9b154793-949b-47e8-b6a4-2e431780b243
# ╠═f1658b2d-4824-450a-9a48-007a39c7bd3d
