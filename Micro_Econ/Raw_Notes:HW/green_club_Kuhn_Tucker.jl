### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 6dd23694-9237-11ef-047f-653eebfa4d94
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
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
      #using Printf #allows you to use sprintf
end

# ╔═╡ ac4f7327-1e5b-4a24-866d-ed01c3938306
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ cd644499-b093-4a73-964b-77408fe6aaf4
md"""
# Green Club Kuhn-Tucker Analysis
"""

# ╔═╡ 17fa158f-f5c4-434d-b232-680e2379df29
nvec=collect(range(0,100,length=101))

# ╔═╡ c3c47ef1-4f6e-417e-b008-0ac692718c90
θvec=copy(nvec)

# ╔═╡ 04a64bf5-f2be-4d95-83bd-932c972e2ccf
begin #Equations for Green club
	E(n,θ)=n*θ
	f(θ)=sqrt(θ)
	c(θ)=θ^2
	α=.5
end;

# ╔═╡ 73e36063-dac6-49a0-aa75-0bb884933f4a
function true_KT(p)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :E, 2, E; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, n)
	@variable(model, θ)
        
    # Specify the objective function
    @NLobjective(model, Max, E(n,θ))

    # Specify the constraints, in == or >= form
    @NLconstraint(model, c1, p-α*θ-c(n) >= 0)
	@NLconstraint(model, c2, f(θ)-p >= 0)
	 @NLconstraint(model, c3, θ >= 0)
	 @NLconstraint(model, c4, n >= 0)
        
    # Pick starting values
    set_start_value(n, 2)
	set_start_value(θ, 2)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	nopt = round(value(n), digits=2)
	θopt = round(value(θ), digits=2)
	λopt = round(dual(c1), digits=2)
	μopt = round(dual(c2), digits=2)
	vopt = round(dual(c3), digits=2)
	wopt = round(dual(c4), digits=2)

	return nopt, θopt, λopt, μopt, vopt, wopt
end

# ╔═╡ 8ceaa60b-2054-47b3-a862-1f1fb11d7b10
begin
nopt(p)=true_KT(p)[1]
θopt(p)=true_KT(p)[2]
λopt(p)=true_KT(p)[3]
μopt(p)=true_KT(p)[4]
vopt(p)=true_KT(p)[5]
wopt(p)=true_KT(p)[6]
end

# ╔═╡ a931d1c3-86ad-4af0-9a61-12fba703917a
p = @bind p Slider(0.0:0.1:100, default=10, show_value=true)

# ╔═╡ 0ad8d9ff-f3da-4d78-bbf0-808e48646d65
pvec=copy(nvec)

# ╔═╡ b424446f-9758-4739-a766-9ba7af271910
begin
    Eplot = plot(
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
	    plot!(θvec, E.(nvec,θvec), linecolor=:black, linestyle=:solid, linewidth=2)
	# Curve labels
    flx = 30
    fly = 2000
    annotate!(flx, fly, text(L"E(n,θ)", :left, :bottom, 12))
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.01*ylims(pX)[2], text(L"y", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, xstar], [L"0", L"x^*"])
    yticks!([0.001, f(0), f(xstar)], [L"0", L"f(0)", L"f(x^*)"])

    # Curve labels
    flx = 1.5*xstar
    fly = 1.01*f(flx)
    annotate!(flx, fly, text(L"f(x)", :left, :bottom, 12))

    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   Eplot	
end

# ╔═╡ 8a016eb5-b134-4020-9b87-e09640836b97
begin
    pX = plot(
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
    plot!(pvec, E.(nopt.(pvec),θopt.(pvec)), linecolor=:black, linestyle=:solid, linewidth=2)
 	# Axis limits
    xlims!(0, 10)
    ylims!(0, 1)
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.01*ylims(pX)[2], text(L"y", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, xstar], [L"0", L"x^*"])
    yticks!([0.001, f(0), f(xstar)], [L"0", L"f(0)", L"f(x^*)"])

    # Curve labels
    flx = 1.5*xstar
    fly = 1.01*f(flx)
    annotate!(flx, fly, text(L"f(x)", :left, :bottom, 12))

    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   pX	
end

# ╔═╡ Cell order:
# ╠═6dd23694-9237-11ef-047f-653eebfa4d94
# ╠═ac4f7327-1e5b-4a24-866d-ed01c3938306
# ╟─cd644499-b093-4a73-964b-77408fe6aaf4
# ╠═17fa158f-f5c4-434d-b232-680e2379df29
# ╠═c3c47ef1-4f6e-417e-b008-0ac692718c90
# ╠═04a64bf5-f2be-4d95-83bd-932c972e2ccf
# ╠═73e36063-dac6-49a0-aa75-0bb884933f4a
# ╠═8ceaa60b-2054-47b3-a862-1f1fb11d7b10
# ╠═a931d1c3-86ad-4af0-9a61-12fba703917a
# ╠═0ad8d9ff-f3da-4d78-bbf0-808e48646d65
# ╟─b424446f-9758-4739-a766-9ba7af271910
# ╠═8a016eb5-b134-4020-9b87-e09640836b97
