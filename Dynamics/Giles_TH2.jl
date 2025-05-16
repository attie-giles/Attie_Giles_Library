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

# ╔═╡ d91ddaf2-ef96-11ef-0f5d-7571efade6de
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
    #using Compiler
    #using Flux
    #using Turing  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ 36c8ba0b-0192-4185-be55-7ad11d73b061
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 0e5ce03b-b1ca-498e-87f4-e3d9e643b206
md"""
# Dynamic Homework 2
"""

# ╔═╡ 0953b2c4-e54f-4089-acaf-14f286e0c10b
md"""
## Shadow Price
"""

# ╔═╡ bf38d59c-77fc-45e7-86e4-42eb4aabd3a2
begin #Parameters Shadow Equation
	β=1 #recreational value of water
	r=.01 #discount rate
	T=20#planning horizon
	γ=.5 #evaporation
end;

# ╔═╡ 6a197283-3877-4d28-906e-39c7ba547409
begin #Shadow Equations
	μ(t) = (β / (r + γ))*(1 - exp((t-T)*(r + γ))) #shadow price
end;

# ╔═╡ e3e1f2cf-6bed-404c-9084-8596f81cfc78
tvec = collect(range(0,T,length=1000))

# ╔═╡ c2158f0c-01e4-4c37-a031-629440d1a5db
begin
    shadowplot = plot(
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
    plot!(tvec, μ.(tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(μ.(tvec)))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(μ.(tvec)), text(L"\mu", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, T], [L"0", L"T"])
    yticks!([0.001, μ.(0)], [L"0", L"\approx \frac{\beta}{r+\gamma}"])

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

	
   shadowplot	
end


# ╔═╡ d3abeeb7-4621-4ff5-b75d-2815a8c0a691
md"""
## Switching Function
"""

# ╔═╡ f05d8dbe-3dfb-41e5-84a8-a55185368ee5
α = @bind α Slider(0.01:0.1:μ(0)-.01, default=μ(0)/2, show_value=true)

# ╔═╡ bd896e17-bf30-45c5-9b13-40ea13ee901d
begin #Switching Function
	σ(t) = α - μ(t) #Switching
end;

# ╔═╡ c0714c01-2e33-4420-ae2e-d9c91b4ac930
function τ(t)


	# Define the zero condition at the parameter value supplied
	cond(t) = σ(t)


	# Specify a starting guess
	t0 =T


	# Find and return the soluion
	τ = find_zero(cond, t0)


end;


# ╔═╡ 9389250c-7d1a-474f-9ac7-ded317521708
τ(tvec)

# ╔═╡ 5de73f64-5154-42a1-9e32-fbd519169c8a
begin
    switchingplot = plot(
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
    plot!(tvec, σ.(tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(-1.2*maximum(σ.(tvec)), 1.2*maximum(σ.(tvec)))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(σ.(tvec)), text(L"σ", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, τ(tvec),T], [L" |", L"\tau", L"T"])
    yticks!([0.001 , σ(0)], [L"0",  L"\alpha - \frac{\beta}{r + \gamma}"])
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

   switchingplot	
end


# ╔═╡ 023f41f4-2948-4204-bdd4-0035f11762da
md"""
## Controls Function
"""

# ╔═╡ 8dd4a983-12a0-4eec-ad90-2952c7949fde
begin #Control Parameters
	u_overline = 80
end;

# ╔═╡ 048f625f-4e6f-4de2-a591-af0cd292177e
function u(t) 
	u = 0
	if σ(t) < 0 
		u = 0
	elseif σ(t) >= 0 
		u = u_overline
	end
	return u
end;

# ╔═╡ ee6cf036-590e-45e8-b449-b5b881d5a9ef
begin
    controlplot = plot(
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
   plot!([0,τ(tvec)], [0,0], linecolor=:black, linestyle=:solid, linewidth=:2)
	plot!([τ(tvec),T], [u_overline,u_overline], linecolor=:black, linestyle=:solid, linewidth=:2)
	plot!([τ(tvec),τ(tvec)], [0,1.2*maximum(u_overline)], linecolor=:black, linestyle=:dash) 
	
	 # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(u_overline))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(u_overline), text(L"u^*", :center, :bottom, 12))
	
	# Axis ticks
    xticks!([0.001, τ(tvec), T], [L"0", L"\tau",L"T"])
    yticks!([0.001 ,u_overline], [L"0",  L"\overline{u}"])
	
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

	
   controlplot	
end


# ╔═╡ 18eea27a-245b-460a-b8bd-6d1beba99802
begin #state parameters
	X_0 = 1000
	P = 200
end;

# ╔═╡ f27719a4-f8aa-4d71-b3d4-fcc43c84c837
begin #state equation functions
	X1(t) = X_0 * exp(-t * γ) + (P/γ)*(1 - exp(-t*γ)) #state equation interval 1
	X2(t) = ((P- u_overline)/γ) + (u_overline / γ)*exp(γ*(τ(t)-t)) + exp(-t*γ)*(X_0-(P/γ)) #state equation interval 2
end;

# ╔═╡ 89f8dd0a-eaa0-4817-9ec7-f1e5c698f0d5
function X(t) #state equation
	X=0
	if t < τ(t)
		X = X1(t)
	elseif t > τ(t)
		X = X2(t)
	end
	return X
end;

# ╔═╡ 48c3a03b-1364-4a86-a370-1679d09cec6a
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
    plot!(tvec, X.(tvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([τ(tvec),τ(tvec)], [0,1.2*maximum(X.(tvec))], linecolor=:black, linestyle=:dash) 
	plot!([0,τ(tvec)], [((P - u_overline)/γ),((P - u_overline)/γ)], linecolor=:black, linestyle=:dash)

	 # Axis limits
    xlims!(0, 1.05*tvec[end])
    ylims!(0, 1.2*maximum(X.(tvec)))
    
    # Axis labels
    annotate!(1.071*tvec[end], 0, text(L"t", :left, :center, 12))
    annotate!(0, 1.212*maximum(X.(tvec)), text(L"X", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, τ(tvec),T], [L"0", L"\tau",L"T"])
    yticks!([0.001 ,X_0,((P - u_overline)/γ) ], [L"0", L"X_0",L"\frac{P-\overline{u}}{\gamma}"])
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
# ╠═d91ddaf2-ef96-11ef-0f5d-7571efade6de
# ╠═36c8ba0b-0192-4185-be55-7ad11d73b061
# ╟─0e5ce03b-b1ca-498e-87f4-e3d9e643b206
# ╟─0953b2c4-e54f-4089-acaf-14f286e0c10b
# ╠═6a197283-3877-4d28-906e-39c7ba547409
# ╠═bf38d59c-77fc-45e7-86e4-42eb4aabd3a2
# ╠═e3e1f2cf-6bed-404c-9084-8596f81cfc78
# ╟─c2158f0c-01e4-4c37-a031-629440d1a5db
# ╟─d3abeeb7-4621-4ff5-b75d-2815a8c0a691
# ╠═bd896e17-bf30-45c5-9b13-40ea13ee901d
# ╠═f05d8dbe-3dfb-41e5-84a8-a55185368ee5
# ╠═c0714c01-2e33-4420-ae2e-d9c91b4ac930
# ╠═9389250c-7d1a-474f-9ac7-ded317521708
# ╟─5de73f64-5154-42a1-9e32-fbd519169c8a
# ╟─023f41f4-2948-4204-bdd4-0035f11762da
# ╠═048f625f-4e6f-4de2-a591-af0cd292177e
# ╠═8dd4a983-12a0-4eec-ad90-2952c7949fde
# ╟─ee6cf036-590e-45e8-b449-b5b881d5a9ef
# ╠═f27719a4-f8aa-4d71-b3d4-fcc43c84c837
# ╠═18eea27a-245b-460a-b8bd-6d1beba99802
# ╠═89f8dd0a-eaa0-4817-9ec7-f1e5c698f0d5
# ╟─48c3a03b-1364-4a86-a370-1679d09cec6a
