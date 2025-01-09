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

# ╔═╡ 1771b858-24ec-11ef-06fc-bf4076641d47
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	#using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 7ad87062-e4bf-4015-89f1-08fe6d27bbfc
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ fea4ff5c-25c4-4072-b652-983b61f7273c
LMax = 12

# ╔═╡ 4fe45bd8-7ca7-4b14-9041-9ff08550871c
LVec = collect(range(0, LMax, length=101))

# ╔═╡ 97673082-723b-4550-a69b-4393f6360626
md"""
# Production Function q(L)
"""

# ╔═╡ 22347fef-4735-4695-ac8f-4709a64609f9
a = @bind a Slider(0.0:0.1:1.0, default=0.5, show_value=true)

# ╔═╡ 9067ccb8-15d8-472c-8c84-76c3a34f8e75
# ╠═╡ disabled = true
#=╠═╡
a = 0
  ╠═╡ =#

# ╔═╡ bc1881c8-5f6b-4cb5-8cb7-f4fe69c404a5
b = @bind b Slider(0.0:0.5:5.0, default=2, show_value=true)

# ╔═╡ 7343fee4-f2fc-418e-84aa-07dfa4228137
# ╠═╡ disabled = true
#=╠═╡
b = 2
  ╠═╡ =#

# ╔═╡ 22fb8836-beff-4032-ab17-be35337f2269
c = @bind c Slider(-5.0:0.1:5.0, default=0.0, show_value=true)

# ╔═╡ 1f1fe950-aed2-4190-8518-8e0adb2c7db8
# ╠═╡ disabled = true
#=╠═╡
c = -0.075
  ╠═╡ =#

# ╔═╡ 62b3fdc3-ec15-43f1-bc87-5b84166c2908
q(L) = a + b*L + 1/2*c*L^2

# ╔═╡ 59f12d36-962c-4ab5-baac-7267fa5e9266
plot(LVec, q.(LVec))

# ╔═╡ 9b2c3de9-11b7-43c4-9a77-17b2f9e0c3f9
md"""
# 8-19 Sets of Production Functions
"""

# ╔═╡ 44f15bc9-f161-435a-ae89-23050c84d58c
md"""
## Quadratic Equation
"""

# ╔═╡ 038fcc08-8287-4e92-a51e-df4ef05dd306
begin
    pq_quadratic = plot(
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
    plot!(LVec, q.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    ymax = 24
    # Axis limits
    xlims!(0, 1.05*LVec[end])
    ylims!(0, ymax)
    #=
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

   pq_quadratic  
end


# ╔═╡ 06be8c09-8a11-4a86-8aa0-69d7274761cb
md"""
## Exponential Equation
"""

# ╔═╡ 00d85991-c6f8-490c-9f91-c779cedfd059
A = @bind A Slider(1.0:0.1:2, default=1.0, show_value=true)

# ╔═╡ b0c278b2-d7f1-47a3-afb6-a35194e34f3c
k = @bind k Slider(0.0:0.1:5, default=1.0, show_value=true)

# ╔═╡ 161e2fd8-e78e-40f8-ae38-ff5318643ff4
θ(L) = A*ℯ^(k*L)

# ╔═╡ 21fc3def-1e5c-48c4-9c7b-130555772680
begin
    pq_exponential = plot(
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
    plot!(LVec, θ.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   pq_exponential   
end


# ╔═╡ 5ffa5e3c-5dde-4a2b-af40-3c44729d6769
md"""
## Logistic Equation
"""

# ╔═╡ 4ed0b3eb-0aa9-4f1e-9d91-f53b03b6cd56
P₀ = @bind P₀ Slider(0.0:1:10, default=1.0, show_value=true)

# ╔═╡ d8274df9-4a9f-474d-b708-6fc711cef9a5
K = @bind K Slider(5.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ 86922abc-3e0c-4eeb-a6e9-3d8f39bf7b96
r = @bind r Slider(0.0:0.1:5.0, default=0.5, show_value=true)

# ╔═╡ f2d26340-53bb-422d-8bab-4eedecaca1c4
P(L) = (P₀*K*ℯ^(r*L))/((K-P₀)+(P₀*ℯ^(r*L)))

# ╔═╡ 14706ef6-74a6-4029-ba93-f07a1f071957
begin
    pq_logistic = plot(
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
    plot!(LVec, P.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

    
    # Axis limits
    xlims!(0, 1.05*LVec[end])
    ylims!(0, 1.2*maximum(P.(LVec)))

	#=
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

   pq_logistic  
end


# ╔═╡ 70e8658d-847a-4fab-8932-356076bf48d4
md"""
## Square Root
"""

# ╔═╡ 5443b0bb-6813-433a-a4b2-b906217361ba
w = @bind w Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ ae292563-a578-4dfc-89c1-f4dea1e724c0
Y(L) = sqrt(L*w)

# ╔═╡ 4dfdbd5c-d639-4b51-8447-4bd3b4018f4b
begin
    pq_sqrt = plot(
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
    plot!(LVec, Y.(LVec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   pq_sqrt   
end


# ╔═╡ b30a78f8-8758-48b5-8d6d-568af5c92c5f
md"""
## Homework
"""

# ╔═╡ 8f445692-5ccf-4e88-9bdf-5208d27867f0
α = @bind α Slider(0.0:0.1:100.0, default=100.0, show_value=true)

# ╔═╡ dc508544-0daf-4a60-b369-579a522520a5
z = @bind z Slider(-5:0.01:5.0, default=-0.1, show_value=true)

# ╔═╡ 126370bd-29c3-406f-a3d6-02b4038c8d9a
#The nonlinear demand function
Qd(p) = α*ℯ^(z*p)

# ╔═╡ b7bf52e2-bc1a-40b1-ac2d-b6bcbb0e009d
Pmin=0

# ╔═╡ 743c79c9-f632-43f6-9bad-80e8b991fe4c
Pmax=100

# ╔═╡ f7266665-122e-48cd-86b7-dc97ce76011b
pvec = collect(range(Pmin, Pmax, length=Pmax))

# ╔═╡ 80e94692-735a-4d1d-9a21-5851ea590d8a
begin
    non_linear_demand = plot(
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
    plot!(pvec, Qd.(pvec), linecolor=:black, linestyle=:solid, linewidth=2)

    
   
    # Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(Qd.(pvec)))
    #=
    # Axis labels
    annotate!(1.02*xlims(Qd.(pvec))[2], 0, text(L"Price", :left, :middle, 12))
    annotate!(0, 1.01*ylims(Qd.(pvec))[2], text(L"Quantity Demanded", :center, :bottom, 12))
  
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

   non_linear_demand   
end


# ╔═╡ ce704484-2c26-4a03-9704-0fa65f3c7fe9
md"""Enter quantity demanded: $(@bind d_str TextField(default="20"))"""

# ╔═╡ ec256eb6-a67c-415f-8ea3-7388e33063e1
function hmw()
	#parse the text box to turn it into a nummber
	Qd = parse(Float64, d_str)

	#insert the price function with the string now number in the origianl function
	tut = log(Qd/α)/z
	answer= tut

	md" $Qd Quantity Demanded gives price \$$(round(answer, digits=2))"
end;


# ╔═╡ 4b5c1862-2d86-42a8-87c4-c189987b4bac
hmw()

# ╔═╡ a5b70408-9660-43a3-8f98-7fc399a5978e
md"""
## Homework 2
"""

# ╔═╡ e1942168-3e01-45aa-8727-18de1a575d85
Qd1(p) = α*ℯ^(z*p)

# ╔═╡ 7094ea4d-d553-4e6f-989e-2f821054b50d
md"""Enter Quantity Demanded: $(@bind qd_str TextField(default="0"))"""

# ╔═╡ c1950ccc-8720-4824-8e95-55c15fda763b
begin
    pqd1 = plot(
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
    plot!(pvec, Qd1.(pvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   pqd1
end

# ╔═╡ 8bd64c68-1d38-4041-8248-6d6d77566a09
function hw2()
#Parse the quantity demanded to get a nymber
QD = parse(Float64, qd_str)
#Initialize the price
price=0
	for p1 = Pmin : .001 : Pmax
		Q = Qd1(p1)
			if .999*QD<Q<1.001*QD
				break
			end
				price=p1
	end
	md" $QD Quantity Demanded gives price \$$(round(price, digits=2))"
end;
		
		
	

# ╔═╡ b15890b2-7f40-4e33-a2b2-f7ae1fdb94d6
hw2()

# ╔═╡ Cell order:
# ╠═1771b858-24ec-11ef-06fc-bf4076641d47
# ╠═7ad87062-e4bf-4015-89f1-08fe6d27bbfc
# ╠═fea4ff5c-25c4-4072-b652-983b61f7273c
# ╠═4fe45bd8-7ca7-4b14-9041-9ff08550871c
# ╠═97673082-723b-4550-a69b-4393f6360626
# ╠═22347fef-4735-4695-ac8f-4709a64609f9
# ╠═9067ccb8-15d8-472c-8c84-76c3a34f8e75
# ╠═bc1881c8-5f6b-4cb5-8cb7-f4fe69c404a5
# ╠═7343fee4-f2fc-418e-84aa-07dfa4228137
# ╠═22fb8836-beff-4032-ab17-be35337f2269
# ╠═1f1fe950-aed2-4190-8518-8e0adb2c7db8
# ╠═62b3fdc3-ec15-43f1-bc87-5b84166c2908
# ╠═59f12d36-962c-4ab5-baac-7267fa5e9266
# ╠═9b2c3de9-11b7-43c4-9a77-17b2f9e0c3f9
# ╠═44f15bc9-f161-435a-ae89-23050c84d58c
# ╠═038fcc08-8287-4e92-a51e-df4ef05dd306
# ╠═06be8c09-8a11-4a86-8aa0-69d7274761cb
# ╠═00d85991-c6f8-490c-9f91-c779cedfd059
# ╠═b0c278b2-d7f1-47a3-afb6-a35194e34f3c
# ╠═161e2fd8-e78e-40f8-ae38-ff5318643ff4
# ╠═21fc3def-1e5c-48c4-9c7b-130555772680
# ╠═5ffa5e3c-5dde-4a2b-af40-3c44729d6769
# ╠═4ed0b3eb-0aa9-4f1e-9d91-f53b03b6cd56
# ╠═d8274df9-4a9f-474d-b708-6fc711cef9a5
# ╠═86922abc-3e0c-4eeb-a6e9-3d8f39bf7b96
# ╠═f2d26340-53bb-422d-8bab-4eedecaca1c4
# ╠═14706ef6-74a6-4029-ba93-f07a1f071957
# ╠═70e8658d-847a-4fab-8932-356076bf48d4
# ╠═ae292563-a578-4dfc-89c1-f4dea1e724c0
# ╠═5443b0bb-6813-433a-a4b2-b906217361ba
# ╠═4dfdbd5c-d639-4b51-8447-4bd3b4018f4b
# ╠═b30a78f8-8758-48b5-8d6d-568af5c92c5f
# ╠═8f445692-5ccf-4e88-9bdf-5208d27867f0
# ╠═dc508544-0daf-4a60-b369-579a522520a5
# ╠═126370bd-29c3-406f-a3d6-02b4038c8d9a
# ╠═b7bf52e2-bc1a-40b1-ac2d-b6bcbb0e009d
# ╠═743c79c9-f632-43f6-9bad-80e8b991fe4c
# ╠═f7266665-122e-48cd-86b7-dc97ce76011b
# ╠═80e94692-735a-4d1d-9a21-5851ea590d8a
# ╠═ce704484-2c26-4a03-9704-0fa65f3c7fe9
# ╠═ec256eb6-a67c-415f-8ea3-7388e33063e1
# ╠═4b5c1862-2d86-42a8-87c4-c189987b4bac
# ╠═a5b70408-9660-43a3-8f98-7fc399a5978e
# ╠═e1942168-3e01-45aa-8727-18de1a575d85
# ╠═7094ea4d-d553-4e6f-989e-2f821054b50d
# ╠═c1950ccc-8720-4824-8e95-55c15fda763b
# ╠═8bd64c68-1d38-4041-8248-6d6d77566a09
# ╠═b15890b2-7f40-4e33-a2b2-f7ae1fdb94d6
