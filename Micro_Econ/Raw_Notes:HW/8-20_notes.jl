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

# ╔═╡ 56b547f8-5f0e-11ef-299c-315cbe092230
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	#using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 0b6cd11e-3a7b-4f2d-bb98-95ed56a5c863
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 58398697-6d90-42a3-85a2-513dbd59049c
md"""
# 8-20 Notes/ HW
"""

# ╔═╡ 718ef539-4f30-4ace-9baf-a82a75045e0e
md"""
## Asymptote1
"""

# ╔═╡ 37d70912-ba1f-471e-b6b1-667be54f8ce1
LMax=12

# ╔═╡ 36439e07-6b76-483c-86c6-e3e5839ac3fa
LVec = collect(range(0, LMax, length=101))

# ╔═╡ 5d62574e-c143-40bd-b2b5-45ef8fa31380
α = @bind α Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 7f26323c-4808-432d-9ee6-88eefb586838
β = @bind β Slider(0.0:0.1:10.0, default=0.3, show_value=true)

# ╔═╡ cef504ad-8e1b-435e-b125-1406c61baef2
q_exp(L) = α * (1 - exp(-β*L))

# ╔═╡ 66220bdb-8230-40d7-9c87-99242b5a6d60
α₁ = @bind α₁ Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 05bc055c-b6c1-4d1a-ab47-21b90f999401
β₁ = @bind β₁ Slider(0.0:0.1:10.0, default=0.3, show_value=true)

# ╔═╡ fd4553a6-8ecd-49d0-85ae-cce9f3a56b8f
q_exp1(L) = α₁ * (1 - exp(-β₁*L))

# ╔═╡ 8c422dc2-c45e-4fc3-8d47-6468ece10991
begin

	ql_exp = plot(
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
    plot!(LVec, q_exp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, q_exp1.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)
	plot!(([0,LMax], [α,α]), linecolor=:black, linestyle=:dash, linewidth=2)

    
    # Axis limits
    xlims!(0, 1.05*LVec[end])
    ylims!(0, 1.2*maximum(q_exp.(LVec)))
    
    # Axis labels
    annotate!(1.02*xlims(ql_exp)[2], 0, text(L"x", :left, :center, 20))
    annotate!(0, 1.01*ylims(ql_exp)[2], text(L"y", :center, :bottom, 20))
  #=
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

   ql_exp 
end


# ╔═╡ 76d83d38-588a-495d-ab91-6cf0949d9cd3
md"""
## Quadratic Equation 1
"""

# ╔═╡ e98a7ed3-0c92-4a88-958c-4ba09d1671cc
md"Check derivative: $(@bind check_derivative CheckBox(default=false))"

# ╔═╡ 36099dbb-abf2-429a-a54e-e8a7aee8e2d2
a = @bind a Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 4b5320a9-f57e-450c-ada3-7664b6e8d9e8
b = @bind b Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ e03bbe66-36bf-489c-8504-1f4fff22d44d
begin
q_quad(L) = a*L - (0.5*b*(L^2))
q_quadp(L) = a - b*L
q_quadavg(L) = q_quad(L)/L
end

# ╔═╡ 8d38450b-698e-454f-8472-0f0ec4e4f0df
begin
    pquad = plot(
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
    plot!(LVec, q_quad.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pquad   
end


# ╔═╡ 1dcc2a04-cc28-4b44-b4cf-e99e8859dcab
begin
    pq_quadp = plot(
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
    plot!(LVec, q_quadp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, q_quadavg.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)

	    if check_derivative
	  # Calculate the derivative numerically
	  quadpchk(L) = ForwardDiff.derivative(q_quad, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, quadpchk.(LVec), linecolor=:red)
    end

	
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pq_quadp   
end


# ╔═╡ 8b1b65e7-2b10-4afc-8bb8-601da1f4ee27
md"""
## Power Fucntion
"""

# ╔═╡ 575bc27c-d283-42f8-aa99-eacc996a7eea
a₁ = @bind a₁ Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 00003ab9-732d-440e-95df-38709eec4cbe
begin
q_power(L) = L^a₁
q_powerp(L) = a₁*L^(a₁-1)
q_poweravg(L) = (L^a₁)/L
end

# ╔═╡ af716ffb-4754-46a5-944b-bd117faa9fea
begin
    ppower = plot(
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
    plot!(LVec, q_power.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   ppower  
end


# ╔═╡ 2072855d-2956-46e0-b548-63a595f2ef99
begin
    ppowerp = plot(
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
    plot!(LVec, q_powerp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, q_poweravg.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

	    if check_derivative
	  # Calculate the derivative numerically
	  powerpchk(L) = ForwardDiff.derivative(q_power, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, powerpchk.(LVec), linecolor=:red)
    end


    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   ppowerp  
end


# ╔═╡ 82263778-3fde-4d94-ae59-629e2543639a
md"""
## Log Function
"""

# ╔═╡ 569548f7-e4fe-4f43-83ab-7beac48d9513
a₂ = @bind a₂ Slider(0.0:0.1:10.0, default=1.0, show_value=true)

# ╔═╡ 4834d9e0-c475-492f-b87a-7b14c1a1b3c1
begin
q_log(L) = log(L+a₂) 
q_logp(L) = 1/(L+a₂)
q_logavg(L) = q_log(L)/L
end

# ╔═╡ 8b8da30d-ae57-4475-991a-4771aa1b7ec9
begin
    plog = plot(
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
    plot!(LVec, q_log.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   plog  
end


# ╔═╡ 50ddb194-9f94-43e5-9a5a-5604d3b78725
begin
    plogp = plot(
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
    plot!(LVec, q_logp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, q_logavg.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)

	    if check_derivative
	  # Calculate the derivative numerically
	  logpchk(L) = ForwardDiff.derivative(q_log, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, logpchk.(LVec), linecolor=:red)
    end

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   plogp   
end


# ╔═╡ 27964d02-fc34-4cbf-bb0b-db67af970eec
md"""
## Euler Equation
"""

# ╔═╡ ccdfd2f0-c1a9-44d0-ba22-5613a2edcbad
c = @bind c Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 333c5f42-5b1a-416d-b390-890e9b1b9eae
d = @bind d Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ f862d42c-c510-4c05-adbc-afb7bdf01834
begin
q_exponential(L) = c - c*exp(-d-L)
q_exponentialp(L) = c*ℯ^(-d-L)
q_exponentialavg(L) = (c - c*ℯ^(-d-L))/L
end

# ╔═╡ 0fa13fe5-3fa0-4a1d-8220-dc43864a096e
begin
    pexp = plot(
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
    plot!(LVec, q_exponential.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pexp   
end


# ╔═╡ 273cdc98-31d6-435d-930d-36172c228ba4
begin
    pexpp = plot(
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
    plot!(LVec, q_exponentialp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, q_exponentialavg.(LVec), linecolor=:blue, linestyle=:solid, 
	linewidth=2)
	
	    if check_derivative
	  # Calculate the derivative numerically
	  exppchk(L) = ForwardDiff.derivative(q_exponential, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, exppchk.(LVec), linecolor=:red)
    end

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pexpp   
end


# ╔═╡ 1cc3da3f-950d-4888-9ea7-7383aecac6cb
md"""
## Iso-Elastic Equation
"""

# ╔═╡ ff0c64d2-2f8e-4092-855d-c60a44e7de0c
c₁ = @bind c₁ Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ 4e8ce42b-a367-4f0f-a8c2-19a42955dc32
d₁ = @bind d₁ Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ e01a3e6a-a67c-4bc8-a25e-c0999aade461
begin
q_iso(L) = (c₁*(L+1)^d₁ + c₁)/ d₁
q_isop(L) = (c₁*(L+1)^(d₁-1))
q_isoavg(L) = q_iso(L)/ L
end

# ╔═╡ e2f2f6f1-8435-48bc-9198-545a809763b3
 begin
    piso = plot(
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
    plot!(LVec, q_iso.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   piso
end

# ╔═╡ cd3e2adb-c29c-46de-8829-d0bf3acb89a8
begin
    pisop = plot(
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
    plot!(LVec, q_isop.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	 plot!(LVec, q_isoavg.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)
	    if check_derivative
	  # Calculate the derivative numerically
	  isopchk(L) = ForwardDiff.derivative(q_iso, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, isopchk.(LVec), linecolor=:red)
    end


    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pisop
end

# ╔═╡ 5f354a48-af96-4565-b18a-2ccd3ae42ef2
md"""
## Inverse Function
"""

# ╔═╡ c9d80c1b-3452-4a53-97aa-c9d721def11e
a1 = @bind a1 Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ ed25bc53-7be7-49e3-9c5d-ad10374091fe
b1 = @bind b1 Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ fe7cd9e6-6291-43e9-9fa5-2402959d2902
begin
	q_inverse(L) = a1 - (a1/(b1*L+1))
	q_inversep(L) = a1*b1/((b1*L+1)^2)
	q_inverseavg(L) = q_inverse(L)/L
end

# ╔═╡ 11af4502-c436-483e-a6c8-f2c0ae40c238
begin
    pinv = plot(
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
    plot!(LVec, q_inverse.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pinv
end

# ╔═╡ 45f9b877-650a-484c-a712-bf1265b2b90a
begin
    pinvp = plot(
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
    plot!(LVec, q_inversep.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	 plot!(LVec, q_inverseavg.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)
	   
	if check_derivative
	  # Calculate the derivative numerically
	  invpchk(L) = ForwardDiff.derivative(q_inverse, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, invpchk.(LVec), linecolor=:red)
    end


    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pinvp
end

# ╔═╡ e03cc8ab-ddd8-4b2e-a93c-c74beb500660
md"""
## Profit Equation
"""

# ╔═╡ e5de1968-e5b1-4993-8993-29a568c7427d
P = @bind P Slider(0.0:1.0:100.0, default=15, show_value=true)

# ╔═╡ 8c59909e-6768-44c0-b224-4a46794a85f8
W = @bind W Slider(0.0:1.0:100.0, default=15.0, show_value=true)

# ╔═╡ 65dd249d-5a5c-4c81-8e40-642edf671762
q(L) = a1 - (a1/(b1*L+1))

# ╔═╡ 52de97aa-20e0-4be3-8e5c-21e293b0f187
π(L) = P*q(L) - W*L

# ╔═╡ 51e777b9-eedb-4798-8c4b-76f236db16d0
begin
    profitL = plot(
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
    plot!(LVec, π.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   profitL
end

# ╔═╡ fa5d9ae2-026e-4e92-95c4-a2cb96b02171
begin
πp(L) = P*q_inversep(L) - W
πavg(L)=πp(L)/L
end

# ╔═╡ ad6f0ab0-cd64-489b-a937-2a5a8f354b23
begin
    pprofit = plot(
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
    plot!(LVec, πp.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(LVec, πavg.(LVec), linecolor=:blue, linestyle=:solid, linewidth=2)

	    if check_derivative
	  # Calculate the derivative numerically
	  profitpchk(L) = ForwardDiff.derivative(π, L)
		
      # Plot the numerical derivative in red
	  plot!(LVec, profitpchk.(LVec), linecolor=:red)
    end

	 # Axis labels
    annotate!(1.02*xlims(pprofit)[2], 0, text(L"x", :left, :center, 20))
    annotate!(0, 1.02*ylims(pprofit)[2], text(L"y", :center, :bottom, 20))
	
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
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

   pprofit
end

# ╔═╡ Cell order:
# ╠═56b547f8-5f0e-11ef-299c-315cbe092230
# ╠═0b6cd11e-3a7b-4f2d-bb98-95ed56a5c863
# ╠═58398697-6d90-42a3-85a2-513dbd59049c
# ╠═718ef539-4f30-4ace-9baf-a82a75045e0e
# ╠═37d70912-ba1f-471e-b6b1-667be54f8ce1
# ╠═36439e07-6b76-483c-86c6-e3e5839ac3fa
# ╠═5d62574e-c143-40bd-b2b5-45ef8fa31380
# ╠═7f26323c-4808-432d-9ee6-88eefb586838
# ╠═cef504ad-8e1b-435e-b125-1406c61baef2
# ╠═66220bdb-8230-40d7-9c87-99242b5a6d60
# ╠═05bc055c-b6c1-4d1a-ab47-21b90f999401
# ╠═fd4553a6-8ecd-49d0-85ae-cce9f3a56b8f
# ╠═8c422dc2-c45e-4fc3-8d47-6468ece10991
# ╠═76d83d38-588a-495d-ab91-6cf0949d9cd3
# ╠═e98a7ed3-0c92-4a88-958c-4ba09d1671cc
# ╠═36099dbb-abf2-429a-a54e-e8a7aee8e2d2
# ╠═4b5320a9-f57e-450c-ada3-7664b6e8d9e8
# ╠═e03bbe66-36bf-489c-8504-1f4fff22d44d
# ╠═8d38450b-698e-454f-8472-0f0ec4e4f0df
# ╠═1dcc2a04-cc28-4b44-b4cf-e99e8859dcab
# ╠═8b1b65e7-2b10-4afc-8bb8-601da1f4ee27
# ╠═00003ab9-732d-440e-95df-38709eec4cbe
# ╠═575bc27c-d283-42f8-aa99-eacc996a7eea
# ╟─af716ffb-4754-46a5-944b-bd117faa9fea
# ╠═2072855d-2956-46e0-b548-63a595f2ef99
# ╠═82263778-3fde-4d94-ae59-629e2543639a
# ╠═569548f7-e4fe-4f43-83ab-7beac48d9513
# ╠═4834d9e0-c475-492f-b87a-7b14c1a1b3c1
# ╟─8b8da30d-ae57-4475-991a-4771aa1b7ec9
# ╠═50ddb194-9f94-43e5-9a5a-5604d3b78725
# ╠═27964d02-fc34-4cbf-bb0b-db67af970eec
# ╠═ccdfd2f0-c1a9-44d0-ba22-5613a2edcbad
# ╠═333c5f42-5b1a-416d-b390-890e9b1b9eae
# ╠═f862d42c-c510-4c05-adbc-afb7bdf01834
# ╟─0fa13fe5-3fa0-4a1d-8220-dc43864a096e
# ╟─273cdc98-31d6-435d-930d-36172c228ba4
# ╠═1cc3da3f-950d-4888-9ea7-7383aecac6cb
# ╠═ff0c64d2-2f8e-4092-855d-c60a44e7de0c
# ╠═4e8ce42b-a367-4f0f-a8c2-19a42955dc32
# ╠═e01a3e6a-a67c-4bc8-a25e-c0999aade461
# ╟─e2f2f6f1-8435-48bc-9198-545a809763b3
# ╠═cd3e2adb-c29c-46de-8829-d0bf3acb89a8
# ╠═5f354a48-af96-4565-b18a-2ccd3ae42ef2
# ╠═c9d80c1b-3452-4a53-97aa-c9d721def11e
# ╠═ed25bc53-7be7-49e3-9c5d-ad10374091fe
# ╠═fe7cd9e6-6291-43e9-9fa5-2402959d2902
# ╟─11af4502-c436-483e-a6c8-f2c0ae40c238
# ╟─45f9b877-650a-484c-a712-bf1265b2b90a
# ╠═e03cc8ab-ddd8-4b2e-a93c-c74beb500660
# ╠═e5de1968-e5b1-4993-8993-29a568c7427d
# ╠═8c59909e-6768-44c0-b224-4a46794a85f8
# ╠═65dd249d-5a5c-4c81-8e40-642edf671762
# ╠═52de97aa-20e0-4be3-8e5c-21e293b0f187
# ╟─51e777b9-eedb-4798-8c4b-76f236db16d0
# ╠═fa5d9ae2-026e-4e92-95c4-a2cb96b02171
# ╠═ad6f0ab0-cd64-489b-a937-2a5a8f354b23
