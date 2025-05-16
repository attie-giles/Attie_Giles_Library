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

# ╔═╡ d82aa3ec-ed88-11ef-2e95-8124a486edc8
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    using DifferentialEquations  
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
	using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ ab225c8d-e224-4397-a650-a53fb1ba4f6c
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ e568af92-08d3-42db-a355-8e42217920b2
md"""
# Homework 1
"""

# ╔═╡ e48d581c-30b9-48d1-83c3-4d3ff8eabc6b
md"""
## Question 5 Sketch
"""

# ╔═╡ cbebbc3f-c3cf-4a1b-b6a7-267ff9aaa47c
begin #costate equation
	λ(β, γ, T, t) = (β/ γ) *(1 - exp(γ*(t-T))) 
end;

# ╔═╡ d3104c68-c6c7-4bf5-bb96-634d1e3dca74
begin #parameters
	β = 1 
	γ = .5
	T = 20 
end;

# ╔═╡ 60e75cce-4511-4034-b56d-51babed476c8
tvec = collect(range(0,T, length=1001))

# ╔═╡ 27f9ecae-847f-4cb0-abdf-bd0a73b53a95
begin
    q5plot = plot(
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
    plot!(tvec, λ.(β, γ, T, tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(λ.(β, γ, T, tvec)))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(λ.(β, γ, T, tvec)), text(L"\lambda", :center, :bottom, 12))
	# Axis ticks
    xticks!([0.001, T], [L"0", L"T"])
    yticks!([0.001, λ.(β, γ, T, 0)], [L"0", L"\approx \frac{\beta}{\gamma}"])
	
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
	

   q5plot
end


# ╔═╡ 3a370bd2-acac-4726-8933-7d258334478a
md"""
## Question 6 Skethces
"""

# ╔═╡ ea1eec78-a7d7-4449-b026-bcba5fbdc6a4
begin #swithcing equation
	σ(α, β, γ, T, t) = α - λ(β, γ, T, t) 
end;

# ╔═╡ 326c99db-6938-43e4-a3a1-1d332d68ed19
begin #parameters
	u_max = 80
end;

# ╔═╡ 82f21735-a86a-4b14-a06b-8f10dc554e3f
α = @bind α Slider(0.01:0.1:(β/γ)-.01, default=1.0, show_value=true)

# ╔═╡ e40331d4-63c0-4c11-ad96-46b71b1b09a5
function τ(α, β, γ, T)

	# Define the zerocondition atthe parametrvalue supplid
	cond(t) = σ(α, β, γ, T, t)


	# Specify a starting guess
	t0 = 20


	# Find and return the solution
	t = find_zero(cond, t0)


end;


# ╔═╡ dbc3174a-6ff7-4c3c-8892-f89074b98afd
τ(α, β, γ, T)

# ╔═╡ b68cd3bc-55c3-43ac-b46e-3812d54a7b0e
begin
    swithingplot = plot(
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
    plot!(tvec, σ.(α, β, γ, T, tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(-1.2*maximum(σ.(α, β, γ, T, tvec)), 1.2*maximum(σ.(α, β, γ, T, tvec)))

	 # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(σ.(α, β, γ, T, tvec)), text(L"\sigma", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001,τ(α, β, γ, T), T], [L" ", L"\tau",L"T"])
    yticks!([0.001 ,σ.(α, β, γ, T, 0)], [L"0", L"\alpha - \frac{\beta}{\gamma}"])
	
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


   swithingplot	
end


# ╔═╡ 3421097f-9358-4fd5-b724-91f215572f06
begin
    control = plot(
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
    plot!([0,τ(α, β, γ, T)], [0,0], linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([τ(α, β, γ, T),T], [u_max,u_max], linecolor=:black, linestyle=:solid, linewidth=2)

	plot!([τ(α, β, γ, T),τ(α, β, γ, T)], [0,1.212*maximum(u_max)], linecolor=:black, linestyle=:dash) 
   
	
	  # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(u_max))
    
   # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(u_max), text(L"u^*", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, τ(α, β, γ, T), T], [L"0", L"\tau", L"T"])
    yticks!([0.001 ,u_max], [L"0",  L"\overline{u}"])


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


   control	
end


# ╔═╡ 00fde4ae-b936-42ee-b271-4ec1ab084f2d
md"""
## Question 7 Sketches
"""

# ╔═╡ cbeadf69-7499-429c-8fcf-17337026e16b
begin #state equations
	X1(P, u_max, γ, X0, t, α, β, T) = (P / γ) + X0*exp(-γ*t) - (P / γ)*exp(-γ*t)
	X2(P, u_max, γ, X0, t, α, β, T) = ((P-u_max) / γ) + X0*exp(-γ*t) - ((P/ γ)*exp(-γ*t) + (u_max / γ)*exp(γ*(τ(α, β, γ, T)-t)))
end;

# ╔═╡ fb6cc439-a98b-4ba3-a0d6-3961fdf97aee
begin #parameters
	X0 = 1000
	P =  200
end;

# ╔═╡ e5483151-7c53-4c3d-821e-3ea76c4396a8
function X(P, u_max, γ, X0, t, α, β, T)
	X=0
	if t < τ(α, β, γ, T)
		X = X1(P, u_max, γ, X0, t, α, β, T)
	elseif t >= τ(α, β, γ, T)
		X = X2(P, u_max, γ, X0, t, α, β, T)
	end
	return X
end;

# ╔═╡ 9100e236-3453-4568-94f5-bf5136c47b11
begin
    stateplot = plot(
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
   plot!(tvec, X.(P, u_max, γ, X0, tvec, α, β, T), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([τ(α, β, γ, T),τ(α, β, γ, T)], [0, 1.2*maximum(X.(P, u_max, γ, X0, tvec, α, β, T))], linecolor=:black, linestyle=:dash) 
	
	plot!([0,τ(α, β, γ, T)], [((P-u_max) / γ),((P-u_max) / γ)],  linecolor=:black, linestyle=:dash) 
	
	 # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(X.(P, u_max, γ, X0, tvec, α, β, T)))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(X.(P, u_max, γ, X0, tvec, α, β, T)), text(L"X", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, τ(α, β, γ, T),T], [L" ", L"\tau", L"T"])
    yticks!([0.001 , X.(P, u_max, γ, X0, 0, α, β, T), ((P-u_max) / γ) ], [L" ",  L"X_0",L"\frac{P-\overline{u}}{\gamma}"])

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
	
   stateplot	
end


# ╔═╡ Cell order:
# ╠═d82aa3ec-ed88-11ef-2e95-8124a486edc8
# ╠═ab225c8d-e224-4397-a650-a53fb1ba4f6c
# ╟─e568af92-08d3-42db-a355-8e42217920b2
# ╠═e48d581c-30b9-48d1-83c3-4d3ff8eabc6b
# ╠═cbebbc3f-c3cf-4a1b-b6a7-267ff9aaa47c
# ╠═d3104c68-c6c7-4bf5-bb96-634d1e3dca74
# ╠═60e75cce-4511-4034-b56d-51babed476c8
# ╟─27f9ecae-847f-4cb0-abdf-bd0a73b53a95
# ╟─3a370bd2-acac-4726-8933-7d258334478a
# ╠═ea1eec78-a7d7-4449-b026-bcba5fbdc6a4
# ╠═326c99db-6938-43e4-a3a1-1d332d68ed19
# ╠═82f21735-a86a-4b14-a06b-8f10dc554e3f
# ╠═e40331d4-63c0-4c11-ad96-46b71b1b09a5
# ╠═dbc3174a-6ff7-4c3c-8892-f89074b98afd
# ╟─b68cd3bc-55c3-43ac-b46e-3812d54a7b0e
# ╟─3421097f-9358-4fd5-b724-91f215572f06
# ╟─00fde4ae-b936-42ee-b271-4ec1ab084f2d
# ╠═cbeadf69-7499-429c-8fcf-17337026e16b
# ╠═fb6cc439-a98b-4ba3-a0d6-3961fdf97aee
# ╠═e5483151-7c53-4c3d-821e-3ea76c4396a8
# ╟─9100e236-3453-4568-94f5-bf5136c47b11
