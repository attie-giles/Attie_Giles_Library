### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 812c899a-258a-11f0-3889-2ddfe475722a
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
	using GameTheory
	using Graphs
	using GraphPlot
	using NetworkLayout
	#using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
    #using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
    using  BenchmarkTools
	using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ e6e0d647-820e-43bf-ab3b-f2b3989542db
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ b915b283-0717-48cb-928b-3c9ad8fcf35c
md"""
# Dynamics Final Model
"""

# ╔═╡ 26c2d13d-4d8b-4c2a-9a7d-ba234adb37a0
begin #parameters
	α = 2.0 #productivity
	f_j = 0.5 #other gene fitness
	g_j = 100.0 #population of other genes
	g_i0 = 10.0 #initial population of gene i
end;

# ╔═╡ 75379491-c6ba-4102-82fd-5d350efdc040
begin #Equations
	f_i(w_i, d_i) = ((α * w_i^.5) - w_i) / d_i #fitness equation 
	ϕ(w_i, d_i, g_i) = ((g_i * f_i(w_i, d_i)) + g_j * f_j) / (g_i + g_j) #population fitness
#_________________________________________________________________#
	df_idd(w_i, d_i) = ((w_i - α * w_^.5)) / (d_i)^2 #fitness derivate drones
	df_idw(w_i, d_i) = ((α - 2 * w_i^.5)) / (2 * d_i * w_i^.5) #fitness derivate workers
	dϕdd(w_i, d_i, g_i) = g_i * df_idd(w_i, d_i) / (g_i + g_j) #population derivative drones
	dϕdw(w_i, d_i, g_i) = g_i * df_idw(w_i, d_i) / (g_i + g_j) #population derivative workers
	dϕdg(w_i, d_i, g_i) = d_i * g_i * (α * w_i^.5 - w_i - f_j * d_i) / (d_i * g_i + d_i * g_j)^2
end;

# ╔═╡ bcac808d-154c-4efa-b51d-af5e00678112
function g_dot(g, p ,t)
	g_j, f_j = p
	g * (1 + g_j - g - g_j *f_j) / (1 + g_j)
end;

# ╔═╡ 8952fbd9-1c5b-4900-bf83-5391c393e4d6
begin 
	p = (100.0, 0.5)
	g_0 = 10
	tspan = (0.0, 10.0)
	prob = ODEProblem(g_dot, g_0, tspan, p)
	sol = solve(prob)
end;

# ╔═╡ 4ea7756f-0929-4010-9ab3-484ec2b7c12a
begin
    plot1 = plot(
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
    plot!(sol, xlabel = "", ylabel="", color=:black, linewidth=2)
	plot!([0,10], [g_j,g_j], linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 10)
    ylims!(0, 120)

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001,10,g_j], [L"0", L"g_0",L"g_j"])

	# Axis labels
    annotate!(10.1, 0, text(L"t", :left, :center, 12))
    annotate!(0, 120, text(L"g", :center, :bottom, 12))


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

savefig("plot1_dynamics.pdf")
   plot1	
end


# ╔═╡ 944a7f68-e5b5-4522-8a4f-976975e6e509
tvec = collect(range(0,10,length=100))

# ╔═╡ ee59b303-74a6-4bce-b58f-d3934c855917
begin
	g_i(t) = g_i0 * exp(-f_j *t)
end;

# ╔═╡ 3cdf5f20-cebd-4130-a7cd-4773014c83d1
begin
    plot2_dynamics= plot(
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
    plot!(tvec, g_i.(tvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([0,10], [g_j,g_j], linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 10)
    ylims!(0, 120)

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001,10,g_j], [L"0", L"g_0",L"g_j"])

	# Axis labels
    annotate!(10.1, 0, text(L"t", :left, :center, 12))
    annotate!(0, 120, text(L"g", :center, :bottom, 12))

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

savefig("fig2_dyn.pdf")
   plot2_dynamics	
end


# ╔═╡ Cell order:
# ╠═812c899a-258a-11f0-3889-2ddfe475722a
# ╠═e6e0d647-820e-43bf-ab3b-f2b3989542db
# ╟─b915b283-0717-48cb-928b-3c9ad8fcf35c
# ╠═75379491-c6ba-4102-82fd-5d350efdc040
# ╠═26c2d13d-4d8b-4c2a-9a7d-ba234adb37a0
# ╠═bcac808d-154c-4efa-b51d-af5e00678112
# ╠═8952fbd9-1c5b-4900-bf83-5391c393e4d6
# ╟─4ea7756f-0929-4010-9ab3-484ec2b7c12a
# ╠═944a7f68-e5b5-4522-8a4f-976975e6e509
# ╠═ee59b303-74a6-4bce-b58f-d3934c855917
# ╟─3cdf5f20-cebd-4130-a7cd-4773014c83d1
