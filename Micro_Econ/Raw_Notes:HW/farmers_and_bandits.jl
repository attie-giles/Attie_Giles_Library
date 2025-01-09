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

# ╔═╡ 0348ede4-a519-11ef-0447-7597d548b84b
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
      #using Printf #allows you to use sprintf
end

# ╔═╡ c0b027fd-e5c5-409c-89b5-400be5b13233
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 1373c5b6-8113-4f0b-964b-d1062a59e533
md"""
# Farmer's and Bandits
"""

# ╔═╡ 4de2abf8-92c4-4145-9fd6-925bcae811ac
begin #Parameters
	N=10
	w=10
end;

# ╔═╡ bfee10ba-6350-4dac-9212-b73de8a32ba0
md"""
## Graphs
"""

# ╔═╡ b5408858-4eea-435b-8052-9b8f55a5fbae
nvec=collect(range(0,N,length=101))

# ╔═╡ 8b4f6b2e-68ae-4657-b05a-6263a5360b31
D = @bind D Slider(0.0:0.1:1.0, default=0.5, show_value=true)

# ╔═╡ 23925976-f4e8-4631-8a78-3b9461114cc8
begin #Functions 
	C_f(n)=w*(1-s(n))
	C_b(n)=((N-n)/n)*w*s(n)*D
	s(n)=F(n)
	F(n)=n/(1+n)
end;

# ╔═╡ 17579d8e-2e4d-43fe-8c30-45fc991bc9e7
function Copt(n)

# Define the zero condition at the parameter value supplied
cond(n) = C_f(n)-C_b(n)

# Specify a starting guess
n0 = 1

# Find and return the solution
n = find_zero(cond, n0)

end;

# ╔═╡ 3d666404-84d0-4cd9-992f-0914f2a81dcc
begin
    consumption = plot(
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
    plot!(nvec, C_f.(nvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(nvec, C_b.(nvec), linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 1.05*nvec[end])
    ylims!(0, 1.2*maximum(C_b.(nvec)))
	 # Key points, with dashed lines to them
    plot!([Copt(nvec),Copt(nvec)], [0,C_f.(Copt(nvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,Copt(nvec)], [C_f.(Copt(nvec)),C_f.(Copt(nvec))], linecolor=:black, linestyle=:dash)
    scatter!([Copt(nvec)], [C_f.(Copt(nvec))], markercolor=:black, markersize=5)
	 # Curve labels
    flx = 1
    fly = 1.01* C_b.(flx)
    annotate!(flx, fly, text(L"C^b", :left, :bottom, 12))
	# Curve labels
    flx2 = 1
    fly2 = 1.01* C_f.(flx)
    annotate!(flx2, fly2, text(L"C^f", :left, :bottom, 12))
	# Axis labels
    annotate!(1.02*xlims(consumption)[2], 0, text(L"n", :left, :center, 12))
    annotate!(0, 1.01*ylims(consumption)[2], text(L"C", :center, :bottom, 12))
	 # Axis ticks
    xticks!([0.001, Copt(nvec)], [L"0", L"n^*"])
    yticks!([0.001, C_f.(Copt(nvec))], [L"0", L"C^*"])
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

   consumption	
end

# ╔═╡ Cell order:
# ╠═0348ede4-a519-11ef-0447-7597d548b84b
# ╠═c0b027fd-e5c5-409c-89b5-400be5b13233
# ╟─1373c5b6-8113-4f0b-964b-d1062a59e533
# ╠═4de2abf8-92c4-4145-9fd6-925bcae811ac
# ╠═23925976-f4e8-4631-8a78-3b9461114cc8
# ╟─bfee10ba-6350-4dac-9212-b73de8a32ba0
# ╠═b5408858-4eea-435b-8052-9b8f55a5fbae
# ╠═17579d8e-2e4d-43fe-8c30-45fc991bc9e7
# ╠═8b4f6b2e-68ae-4657-b05a-6263a5360b31
# ╟─3d666404-84d0-4cd9-992f-0914f2a81dcc
