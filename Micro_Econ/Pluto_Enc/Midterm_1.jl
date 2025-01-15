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

# ╔═╡ 6ea3aef8-d04d-11ef-2482-53d8635a9a7a
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

# ╔═╡ a2b16f8e-ece1-4e10-a557-37d649ab111e
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 433fb1bb-cc13-4a52-ac41-ceeb61707137
md"""
# Midterm 1: Robinson Crusoe
"""

# ╔═╡ 36ce9203-05da-43eb-a223-0b0693fd2677
md"""
## Question 1
"""

# ╔═╡ 7f6fc2b2-ad0b-4eb5-aaa6-615212484e23
md"""
Robinson Crusoe is stranded alone on a desert island. He gets utility from fish consumption F and from time l spent lying on the beach each day. He has to catch the fish himself, though, and that takes time too: his (strictly concave) production function for fish is F = F(L), where L is the time he spends fishing each day. Let U = U(F,l) represent Robinson’s (strictly quasiconcave, meaning that his indifference curves have the usual convex-to-the-origin shape) utility function. Let T = L + l represent his time constraint, whereby he treats T, the time available in the day for fishing and leisure after subtracting the time that he sleeps, as given. Assume throughout that L and l are strictly positive (implying that F is strictly positive as well).

Do as complete an analysis as you can of Robinson’s problem of optimally allocating his time. Include full comparative statics w.r.t. T . (Imagine that he suddenly finds himself needing less sleep.) Also submit a Pluto notebook (both .jl and .pdf) to generate graphs. (Hint: Plot Robinson’s optimization problem in (l, F ) space, after substituting away L.) In that notebook, define functions F(L) and U(F,l) near the beginning, and try to have everything else look as closely as possible to the math in your LaTeX file. That includes using implicit functions for the solution values, calculated using find zero or ift. Make the code in those functions as generic as possible, in the sense that the notebook should run even if you were to pick different functional forms for F(L) and U(F,l) at the top and change nothing else.
"""

# ╔═╡ 1be67dd7-9341-4f95-b61d-c8df95b5528e
md"""Select specific utility function: 
	$(@bind ddm Select(["Cobb-Douglas", "symmetric", "CES"], default="CES"))"""

# ╔═╡ e9abae7c-c3bd-48d7-b364-19c747bbd1aa
#Robinson Crusoe Equations
	if ddm == "Cobb-Douglas" 
		α=0.6 
		U(F,l)=F^α*l^(1-α)
		U_F(F,l)=α*F^(α-1)*l^(1-α)
		U_l(F,l)=F^α*(1-α)*l^(-α)
	elseif ddm == "symmetric"
		U(F,l)=F*l
		U_F(F,l)=l
		U_l(F,l)=F
	elseif ddm == "CES"
		ρ=0.5
		α=0.7
		U(F,l)=(α*F^ρ + (1-α)*l^ρ)^(1/ρ)
		U_F(F,l) = (α*F^ρ + (1-α)*l^ρ)^(1/ρ-1)*α*F^(ρ-1)
		U_l(F,l) = (α*F^ρ + (1-α)*l^ρ)^(1/ρ-1)*(1-α)*l^(ρ-1)
end;

# ╔═╡ afcb953f-00b7-494a-aa25-377e330b07e5
begin #Production Function
	β = 1
	F(L)=β*L^0.5
	F_L(L)=β*0.5*L^(-0.5)
end;

# ╔═╡ aae3dc97-b53c-4e7e-8988-d3f113e93922
md"""
Robinson's Optimization problem can be written as

$\begin{equation*}
  \max_{L,l}=U(F(L),l)
\end{equation*}$

subject to 

$\begin{equation*}
  L=T-l
\end{equation*}$
which can be simplified to 

$\begin{equation*}
   \max_{l}=U(F(T-l),l)
\end{equation*}$

with the following first-order condition

$\begin{equation*}
  \dfrac{dU}{dl}= -U_F(F(T-l),l) \cdot F'(T-l)+U_l(F(T-l),l)=0
\end{equation*}$
"""

# ╔═╡ 2cf563d5-fe0a-4c06-8d44-df83bc14f3da
begin #parameter
	Tmax=18
	Fmax=12
end;

# ╔═╡ 87c33aad-1338-4036-b392-6c321664aabd
Fvec = collect(range(0,Fmax,length=1001))

# ╔═╡ fa27449d-a7e1-439b-9d43-fae3dc9fde4f
T = @bind T Slider(1.0:0.5:Tmax, default=16.0, show_value=true)

# ╔═╡ 9577c208-e8f9-4205-8c4a-050e4c14eb45
function foc1(l) #Robinson's consumer first-order condition

# Define the zero condition at the parameter value supplied
cond(l) = -U_F(F(T-l),l)*F_L(T-l)+U_l(F(T-l),l)

# Specify a starting guess
l0 = .1

# Find and return the solution
l = find_zero(cond, l0)

end;

# ╔═╡ 56d1bacb-4b6c-4c5b-b4e3-610cd0f1e0aa
begin #equations for graphing
	U_c(l,F)=U(F,l) #utility curve for the contour
	V(l) = U(F1(l),foc1(l)) #optimal utility
	F1(l) = F(T-foc1(l)) #optimal hours spent fishing
end;

# ╔═╡ 858e98de-95d4-4f5c-b5c5-6e698ded34d3
lvec = collect(range(0,T,length=1001))

# ╔═╡ 6b0a7c2c-1126-4d56-843a-649d18f8724c
md"""
### Indifference Curves
"""

# ╔═╡ 38f084e3-4be9-4fdb-a1d6-f5d034d45c04
begin
    graph1 = plot(
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
    aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Indifference Curves
	contour!(lvec, Fvec, U_c, levels=[3,6,8,10], 
		linecolor=:lightgray, clabels=false)

	#Production Function
    plot!(lvec, F.(T .- lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	#optimal indifference curve
	contour!(lvec, Fvec, U_c, levels=[V(lvec)], 
		linecolor=:lightgray, clabels=false)

	# Key points, with dashed lines to them
    plot!([foc1(lvec),foc1(lvec)], [0, F.(T .- foc1(lvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,foc1(lvec)], [F.(T .- foc1(lvec)),F.(T .- foc1(lvec))], linecolor=:black, linestyle=:dash)
    scatter!([foc1(lvec)], [F.(T .- foc1(lvec))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, foc1(lvec),T], [L"0", L"l^*",L"T"])
    yticks!([0.001, F(T) ,F.(T .- foc1(lvec))], [L"0", L"F(T)", L"F^*"])

	# Axis limits
    xlims!(0, Tmax)
    ylims!(0, Fmax)
    
    # Axis labels
    annotate!(1.01*xlims(graph1)[2], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.01*ylims(graph1)[2], text(L"F", :center, :bottom, 12))

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

   graph1	
end

# ╔═╡ 32499a6d-50ef-4ce8-8b40-44dffe22fbfe
md"""
### Comparative Statics
"""

# ╔═╡ 804828ce-0402-4ac1-b8be-1c95a21f5a6c
Tvec = collect(range(1.0, Tmax, length=101))

# ╔═╡ dac62816-12e1-4eda-9d31-1714683f80bd
function l1s(T)

# Define the zero condition at the parameter value supplied
cond(l) = -U_F(F(T-l),l)*F_L(T-l)+U_l(F(T-l),l)

# Specify a starting guess
l0 = .1

# Find and return the solution
l = find_zero(cond, l0)

end;

# ╔═╡ 24a3b87d-ad25-4cef-a7c4-f3ee63070b06
begin
    compstat1 = plot(
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
    plot!(Tvec, l1s.(Tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*Tvec[end])
    ylims!(0, 1.2*maximum(l1s.(Tvec)))
    
    # Axis labels
    annotate!(1.071*Tvec[end], 0, text(L"T", :left, :center, 12))
    annotate!(0, 1.212*maximum(l1s.(Tvec)), text(L"l", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(10, l1s(10)+1, text(L"l^*(T)", :left, :bottom, 12))

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

   compstat1	
end

# ╔═╡ e2a71032-aaf6-465f-825a-ece21cb029d0
F1s(T)=F(T-l1s(T));

# ╔═╡ 8b08f357-cb60-4624-8d93-af2786726e6b
begin
    compstat2 = plot(
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
    plot!(Tvec, F1s.(Tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*Tvec[end])
    ylims!(0, 1.2*maximum(F1s.(Tvec)))
    
    # Axis labels
    annotate!(1.071*Tvec[end], 0, text(L"T", :left, :center, 12))
    annotate!(0, 1.212*maximum(F1s.(Tvec)), text(L"F", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(10, F1s.(10)+.1, text(L"F^*(T)", :left, :bottom, 12))

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

   compstat2	
end

# ╔═╡ 308e2838-08ea-487a-8204-5c240402f921
V1s(T)=U(F1s(T),l1s(T));

# ╔═╡ 7b5f23bd-972a-41b5-a87e-19878c5772a5
begin
    compstat3 = plot(
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
    plot!(Tvec, V1s.(Tvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*Tvec[end])
    ylims!(0, 1.2*maximum(V1s.(Tvec)))
    
    # Axis labels
    annotate!(1.071*Tvec[end], 0, text(L"T", :left, :center, 12))
    annotate!(0, 1.212*maximum( V1s.(Tvec)), text(L"V", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(10, V1s(10)+.5, text(L"V(T)", :left, :bottom, 12))

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

   compstat3	
end

# ╔═╡ 46fa0dbe-5cdc-4182-8cac-b593920900de
md"""
## Question 2
"""

# ╔═╡ 84f431e6-5234-498d-88cf-8c634b0d8471
md"""
After many months on the island, Robinson gets bored, and comes up with an idea to entertain himself. He decides to create a money economy with sea shells as the currency, and to every morning until noon pretend that he is both the manager and the sole employee of a fishing firm. The firm produces and sells fish at price p and hires labor at wage rate w, treating both prices as given (i.e., not under its control). Let Fs denote the firm’s supply of fish, and Ld its demand for labor.

Do as complete an analysis as you can of Robinson’s morning problem of maximizing the firm’s profits, including full comparative statics w.r.t. p and w (but not T ).

"""

# ╔═╡ 4af3a0bc-88e4-442f-9c07-50099c6f2956
md"""
Robinson's Optimization problem would be 

$\begin{equation*}
  \max_{L^d}π=p \cdot F(L^d)-wL^d 
\end{equation*}$
with the first-order condition 

$\begin{equation*}
  \dfrac{dπ}{dL^d}=p \cdot F'(L^d)-w=0
\end{equation*}$
"""

# ╔═╡ 7799bf6a-d302-4513-8372-ee644522354b
Lvec = collect(range(0,Tmax,length=101))

# ╔═╡ bebb569b-99d2-4ac6-8383-3dcb3be97ddf
p = @bind p Slider(0.1:0.1:1.5, default=1.0, show_value=true)

# ╔═╡ 58373bd0-87e9-4119-87cb-4477c608a769
w = @bind w Slider(0.1:0.1:.5, default=0.25, show_value=true)

# ╔═╡ bd3f04e4-c85b-422d-888e-8c1e9a844b8e
begin #Firm Equations
	π(L) = p*F(L)-w*L #Normal Firm Equation
	π_c(L,F) = p*F - w*L #Firm Equation for the Contour map
	π_L(L) = p*F_L(L)-w
end;

# ╔═╡ 098a4518-2221-470b-a8e9-268f5eaf3d0e
function foc2(L)

# Define the zero condition at the parameter value supplied
cond(L) = π_L(L)

# Specify a starting guess
L0 = .1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ ecd37d2b-36aa-4edb-9b79-e582799efb04
p*F_L(foc2(T .- lvec))

# ╔═╡ 0e5850db-07d6-40b4-9bc2-0afd98c81603
md"""
### Iso-Profit Indifference Curves
"""

# ╔═╡ 52fc43b7-8823-4125-af5b-236e541c1017
begin
    indifferencefirm1 = plot(
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
    
    # Iso-Profit Curves
    contour!(Lvec, Fvec, π_c, levels=[0.5,2,3,4,5], 
		linecolor=:lightgray, clabels=false)
	
	#Production funciton
	plot!(Lvec, F.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	#opt Iso-Profit Curve
	contour!(Lvec, Fvec, π_c, levels=[π(foc2(Lvec))], 
		linecolor=:lightgray, clabels=false)

	# Key points, with dashed lines to them
    plot!([foc2(Lvec),foc2(Lvec)], [0,F.(foc2(Lvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,foc2(Lvec)], [F.(foc2(Lvec)),F.(foc2(Lvec))], linecolor=:black, linestyle=:dash)
    scatter!([foc2(Lvec)], [F.(foc2(Lvec))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, foc2(Lvec),T], [L"0", L"L^{d*}",L"T"])
    yticks!([0.001 ,F.(foc2(Lvec))], [L"0", L"F^{s*}"])

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.05*Fvec[end])
    
    # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L^d", :left, :center, 12))
    annotate!(0, 1.071*Fvec[end], text(L"F^s", :center, :bottom, 12))

	annotate!(10, F(10), text(L"F(L^s)", :left, :bottom, 12))
	
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

   indifferencefirm1	
end

# ╔═╡ 6bce2d74-b841-4e84-b5b8-31fdea528923
md"""
### Iso-Profit Curves in (l,F) space
"""

# ╔═╡ 3addb7a3-774f-48da-84d3-7f03c69ff8fe
begin 
	π_l(l,F)=p*F - w*(T-l) #countour lines in (l,F) space
end;

# ╔═╡ f2a88819-0bec-4df8-9f3d-e38d9acb18f7
begin
    indifferencefirm2 = plot(
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
    
    #Iso-Profit Indifference Curves
	contour!(lvec, Fvec, π_l, levels=[0.5,2,3,4,5], 
		linecolor=:lightgray, clabels=false)
	
	#Production funciton
	plot!(lvec, F.(T .- lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	#opt Iso-Profit Indifference Curve
	contour!(lvec, Fvec, π_l, levels=[π(foc2(T .- lvec))], 
		linecolor=:lightgray, clabels=false)

	 # Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.05*Fvec[end])
    
    # Axis labels
    annotate!(1.071*lvec[end], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.071*Fvec[end], text(L"F", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([T .- foc2(T .- Lvec),T .- foc2(T .- Lvec)], [0,F(foc2(T .- Lvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,T .- foc2(T .- Lvec)], [F(foc2(T .- Lvec)),F(foc2(T .- Lvec))], linecolor=:black, linestyle=:dash)
    scatter!([T .- foc2(T .- Lvec)], [F(foc2(T .- Lvec))], markercolor=:black, markersize=5)

	 # Axis ticks
    xticks!([0.001, T .- foc2(T .- Lvec),T], [L"0", L"l^*",L"T"])
    yticks!([0.001,F(foc2(T .- Lvec))], [L"0", L"F^{s*}"])

	annotate!(T-10, F(T-10)+.5, text(L"F(T-l)", :left, :bottom, 12))
	
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

   indifferencefirm2	
end

# ╔═╡ 099d5f8d-559d-4b65-8829-256f20b3c555
md"""
### Comparative Statics
"""

# ╔═╡ c7bb5bab-5b16-46f2-af4c-936b5897541a
pvec = collect(range(.1,1.5,length=101))

# ╔═╡ a62272fe-e9bb-4fbf-b2c5-952d4659b7cf
wvec = collect(range(.1,.5,length=101))

# ╔═╡ cbf3636f-9e84-41bb-a9a3-9f9d66608c05
function L_star(p,w)

# Define the zero condition at the parameter value supplied
cond(L) = p*F_L(L)-w

# Specify a starting guess
L0 = .1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 057b8cb2-a373-4a83-ad46-5e00229fa996
begin
    compstat4 = plot(
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
    plot!(pvec, L_star.(pvec,w), linecolor=:black, linestyle=:solid, linewidth=2)

	
    # Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(L_star.(pvec,w)))
    
    # Axis labels
    annotate!(1.071*pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.212*maximum(L_star.(pvec,w)), text(L"L^d", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.5, L_star(.5,w)+2, text(L"L^{d*}(p,w)", :left, :bottom, 12))

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

   compstat4	
end

# ╔═╡ d71dabd7-84be-4716-a236-52afbf0da1eb
begin
    compstat5 = plot(
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
    plot!(wvec, L_star.(p,wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.2*maximum(L_star.(p,wvec)))
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.212*maximum(L_star.(p,wvec)), text(L"L^d", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.2, L_star(p,.2), text(L"L^{d*}(p,w)", :left, :bottom, 12))

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

   compstat5	
end

# ╔═╡ 4b701ee5-5eb6-4903-89e6-82fddd0003d8
Fs(p,w) = F(L_star(p,w));

# ╔═╡ 52a338b6-c77c-4a1f-a83a-0dee7c3f5eea
begin
    compstat6 = plot(
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
    plot!(pvec, Fs.(pvec,w), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(Fs.(pvec,w)))
    
    # Axis labels
    annotate!(1.071*pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.212*maximum(Fs.(pvec,w)), text(L"F^s", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.5, Fs(.5,w)+.5, text(L"F^{s*}(p,w)", :left, :bottom, 12))
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

   compstat6	
end

# ╔═╡ 4d01d454-2f03-4fd0-ba6e-09620bb73ae2
begin
    compstat7 = plot(
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
    plot!(wvec, Fs.(p,wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.2*maximum(Fs.(p,wvec)))
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.212*maximum(Fs.(p,wvec)), text(L"F^s", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.2, Fs(p,.2), text(L"F^{s*}(p,w)", :left, :bottom, 12))

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

   compstat7	
end

# ╔═╡ c6bbe136-3211-4f75-9d7a-1d573e108b89
πs(p,w)=p*Fs(p,w) - w*L_star(p,w);

# ╔═╡ f21e7a48-f862-433f-b409-d39d4082db89
begin
    compstat8 = plot(
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
    plot!(pvec, πs.(pvec,w), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(πs.(pvec,w)))
    
    # Axis labels
    annotate!(1.071*pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.212*maximum(πs.(pvec,w)), text(L"π^s", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.5, πs(.5,w)+.5, text(L"π^{s*}(p,w)", :left, :bottom, 12))

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

   compstat8	
end

# ╔═╡ dae635ed-c2ba-4dfe-9f67-095a72c3ac20
begin
    compstat9 = plot(
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
    plot!(wvec, πs.(p,wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.2*maximum( πs.(p,wvec)))
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.212*maximum( πs.(p,wvec)), text(L"π^s", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.2, πs(p,.2), text(L"π^{s*}(p,w)", :left, :bottom, 12))

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

   compstat9	
end

# ╔═╡ 5ee8b5ef-2ef3-4b25-abac-38485452b8db
md"""
## Question 3
"""

# ╔═╡ 955a2803-95c7-42f6-b763-400e9ccfe242
md"""
Robinson’s idea has a second component. Every afternoon, he pretends that he is a consumer as well as the sole shareholder and sole employee of the fishing firm. As a consumer, he buys fish at price p. As a shareholder, he receives the entire profits π of the firm as income. And as an employee, he additionally receives income from working for the firm, at wage rate w. He treats all three values—p, π, and w—as given, but has to decide how much fish Fd to demand and how much labor Ls to supply.

Do as complete an analysis as you can of Robinson’s afternoon problem of maximizing his utility subject to his budget constraint, including full comparative statics w.r.t. p and w (but not T)
"""

# ╔═╡ 86575151-0232-4527-95d8-f2f33511e4d0
md"""
Rearranged budget Constraint:

$\begin{align*}
 & π+w \cdot L^s = p \cdot F^d \\
\leftrightarrow & π + w (T-l) = p \cdot F^d \\
\leftrightarrow & F^d = \dfrac{π}{p} + \dfrac{w}{p}(T-l)
\end{align*}$
Results in the simplified optmization problem:

$\begin{equation*}
  \max_l U=U(\dfrac{π}{p} + \dfrac{w}{p}(T-l),l)
\end{equation*}$
with the following first-order condition

$\begin{equation*}
  \dfrac{dU}{dl}= -U_F(\dfrac{π}{p} + \dfrac{w}{p}(T-l),l) \cdot \dfrac{w}{p} + U_l(\dfrac{π}{p} + \dfrac{w}{p}(T-l),l)=0
\end{equation*}$
"""

# ╔═╡ e410a8ec-abe0-4bcc-8127-cd78cf9355fd
π2 = @bind π2 Slider(0.1:0.1:2.5, default=1.0, show_value=true)

# ╔═╡ 75c84fa9-c719-448c-b197-64472d05b3c8
begin #Consumer Equations
	Fd(l) = π2/p + (w/p)*(T-l)
	Fd_l(l) = -w/p
	dU_dl(l) = U_F(Fd(l),l) *  Fd_l(l) + U_l(Fd(l),l)
end;

# ╔═╡ 8cad9c4b-ed95-4381-8ca6-b064c3f59349
function focU(l)

# Define the zero condition at the parameter value supplied
cond(l) = dU_dl(l)

# Specify a starting guess
l0 = 20

# Find and return the solution
l = find_zero(cond, l0)

end;

# ╔═╡ 330bd158-571a-4de1-8100-dcb19b72a1a4
md"""
### Indifference Curves
"""

# ╔═╡ 2260adb8-2666-488b-979b-fdc9112a5ee6
begin
    indifferenceconsumer = plot(
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
    
    #Indifference Curves
	contour!(lvec, Fvec, U_c, levels=[3,6,8,10], 
		linecolor=:lightgray, clabels=false)

	#Opt Indifference Curve
	contour!(lvec, Fvec, U_c, levels=[U(Fd(focU(lvec)),focU(lvec))], 
		linecolor=:lightgray, clabels=false)
	#Budget Constraint
	plot!(lvec, Fd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.05*Fvec[end])
    
    # Axis labels
    annotate!(1.071*lvec[end], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.071*Fvec[end], text(L"F^d", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([focU(lvec),focU(lvec)], [0,Fd(focU(lvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,focU(lvec)], [Fd(focU(lvec)),Fd(focU(lvec))], linecolor=:black, linestyle=:dash)
    scatter!([focU(lvec)], [Fd(focU(lvec))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([T,T], [0,π2/p], linecolor=:black, linestyle=:dash) 
    plot!([0,T], [π2/p,π2/p], linecolor=:black, linestyle=:dash)
    scatter!([T], [π2/p], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, focU(lvec),T], [L"0", L"l^*",L"T"])
    yticks!([0.001, π2/p ,Fd(focU(lvec)),Fd(0)], [L"0", L"\pi/p", L"F^{d*}",L"\pi/p+(w/p)T"])
	
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

   indifferenceconsumer	
end

# ╔═╡ 74032019-4c17-48ad-a5fa-e79d73787f27
md"""
### Comparative Statics
"""

# ╔═╡ 7f6fad97-46b5-4c72-9387-3e5d6284e8a7
function l_star(p,w,π)

# Define the zero condition at the parameter value supplied
cond(l) = U_F(π/p + (w/p)*(T-l),l) *  -w/p + U_l(π/p + (w/p)*(T-l),l)

# Specify a starting guess
l0 = .1

# Find and return the solution
l = find_zero(cond, l0)

end;

# ╔═╡ dd86f1b8-5e2c-4277-a275-a31f3ca25dec
begin
    compstat10 = plot(
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
    plot!(pvec, l_star.(pvec,w,π2), linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(l_star.(pvec,w,π2)))
    
    # Axis labels
    annotate!(1.071*pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.212*maximum(l_star.(pvec,w,π2)), text(L"l", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0",])

	annotate!(1, l_star(1,w,π2)+1, text(L"l^*(p \; ;w,π)", :left, :bottom, 12))

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

   compstat10	
end

# ╔═╡ 2bb35563-3ed7-4996-9002-cd49d9f43cb5
begin
    compstat11 = plot(
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
    plot!(wvec, l_star.(p,wvec,π2), linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.2*maximum(l_star.(p,wvec,π2)))
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.212*maximum(l_star.(p,wvec,π2)), text(L"l", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.2, l_star(p,.2,π2), text(L"l^*(w \; ;p,π)", :left, :bottom, 12))

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

   compstat11	
end

# ╔═╡ 3182eff0-3bb0-4387-9c51-fe3df9f367ea
πvec = collect(range(.1,2.5,length=101))

# ╔═╡ 11f3efc4-0517-46a0-8eec-ea67fa42a615
begin
    compstat12 = plot(
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
    plot!(πvec, l_star.(p,w,πvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*πvec[end])
    ylims!(0, 1.2*maximum(l_star.(p,w,πvec)))
    
    # Axis labels
    annotate!(1.071*πvec[end], 0, text(L"π", :left, :center, 12))
    annotate!(0, 1.212*maximum(l_star.(p,w,πvec)), text(L"l", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(1, l_star(p,w,1)+1, text(L"l^*(π \; ;p,w)", :left, :bottom, 12))

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

   compstat12	
end

# ╔═╡ 0f1cf37d-ca93-40c6-ab67-e93626ef36e1
md"""
## Question 4
"""

# ╔═╡ a43d1da3-7ea3-44cd-99f8-966f07aefb16
md"""
Robinson initially picks p and w arbitrarily, but discovers that he ends up with excess demand or supply in the fish and labor markets. By playing around with different prices and wage rates, though, he eventually finds ones at which both markets do clear.

Write down the full set of equations that determines the market-equilibrium values of all endogenous variables. (Hint: Some of those equations will be first-order conditions and constraints of Robinson’s morning and afternoon problems!) You don’t have to do anything else: don’t bother to simplify the system of equations or do comparative statics.
"""

# ╔═╡ caeacfcd-0eae-428e-89c8-aa680c815104
md"""
Fixed Price of be fish will be the numeraire good
"""

# ╔═╡ fb8a9e3c-e155-4bb9-89b0-3d84327e5347
p

# ╔═╡ 97d9a976-deee-4142-a436-254aa7ce41e3
begin #Market Outcomes
	w_m = p*F_L(T .- foc1(lvec)) #Market-Equilibrium Wage
	π_m = p*F(T .- foc1(lvec))-w_m*(T .- foc1(lvec)) #Market-Equilibrium Profits
	Ld_m=L_star(p,w_m) #Optimal Demand for Labor by Firm
	Ls_m=T - l_star(p,w_m,π_m) #Optimal Supply of labor by consumer
	l_m=l_star(p,w_m,π_m) #Optimal implied demand for leisure by consumer
	Fs_m = F(Ld_m) #optimal supply of fish by firm
	Fd_m = F(Ls_m) #Optimal demand for fish by consumer
end;

# ╔═╡ fafb8e4f-54fc-4361-b5ae-1683b6240ab6
L_star(p,w_m)

# ╔═╡ e9b09fdf-ef8a-4720-8c3b-65cf8d090f45
begin 
	Fdm(l,p,w,π2)=π2/p + (w/p)*(T-l)
end;

# ╔═╡ 29cabe5d-3ebd-4ad3-b0b5-67e8da38e7c6
begin
    welfare = plot(
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
    
     #Indifference Curves
	contour!(lvec, Fvec, U_c, levels=[3,6,8,10], 
		linecolor=:lightgray, clabels=false)
	
	#Production Possibilities frontier
	plot!(lvec, F.(T .- lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Budget constraint at market-clearing wage
	plot!(lvec, Fdm.(lvec,p,w_m,π_m), linecolor=:red, linestyle=:solid, linewidth=2)
	plot!([T,T], [0,Fdm.(lvec[end],p,w_m,π_m)], linecolor=:red, linestyle=:solid, linewidth=2)
	
	# Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.05*Fvec[end])
	
	 # Axis labels
    annotate!(1.071*lvec[end], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.071*Fvec[end], text(L"F", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([l_m,l_m], [0,Fs_m], linecolor=:black, linestyle=:dash) 
    plot!([0,l_m], [Fs_m,Fs_m], linecolor=:black, linestyle=:dash)
    scatter!([l_m], [Fs_m], markercolor=:black, markersize=5)

	plot!([0,T], [Fdm.(lvec[end],p,w_m,π_m),Fdm.(lvec[end],p,w_m,π_m)], linecolor=:black, linestyle=:dash)

	# Axis ticks
    xticks!([0.001, l_m,T], [L"0", L"l^{s*}=l^{d*}",L"T"])
    yticks!([0.001, Fdm.(lvec[end],p,w_m,π_m) ,Fs_m,Fdm.(0,p,w_m,π_m)], [L"0", L"\pi^*/p", L"F^{s*}=F^{d*}",L"\pi^*/p+(w^*/p)T"])
	
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

   welfare	
end

# ╔═╡ 27b2fe76-828a-4f00-a298-6d496f8947d7
md"""
The graph illustrates the First Fundamental Welfare Theorem, which states that complete, com- petitive markets yield the socially optimal outcome.
"""

# ╔═╡ Cell order:
# ╠═6ea3aef8-d04d-11ef-2482-53d8635a9a7a
# ╠═a2b16f8e-ece1-4e10-a557-37d649ab111e
# ╟─433fb1bb-cc13-4a52-ac41-ceeb61707137
# ╟─36ce9203-05da-43eb-a223-0b0693fd2677
# ╟─7f6fc2b2-ad0b-4eb5-aaa6-615212484e23
# ╟─1be67dd7-9341-4f95-b61d-c8df95b5528e
# ╠═e9abae7c-c3bd-48d7-b364-19c747bbd1aa
# ╠═afcb953f-00b7-494a-aa25-377e330b07e5
# ╟─aae3dc97-b53c-4e7e-8988-d3f113e93922
# ╠═9577c208-e8f9-4205-8c4a-050e4c14eb45
# ╠═2cf563d5-fe0a-4c06-8d44-df83bc14f3da
# ╠═56d1bacb-4b6c-4c5b-b4e3-610cd0f1e0aa
# ╠═858e98de-95d4-4f5c-b5c5-6e698ded34d3
# ╠═87c33aad-1338-4036-b392-6c321664aabd
# ╠═fa27449d-a7e1-439b-9d43-fae3dc9fde4f
# ╟─6b0a7c2c-1126-4d56-843a-649d18f8724c
# ╟─38f084e3-4be9-4fdb-a1d6-f5d034d45c04
# ╟─32499a6d-50ef-4ce8-8b40-44dffe22fbfe
# ╠═804828ce-0402-4ac1-b8be-1c95a21f5a6c
# ╠═dac62816-12e1-4eda-9d31-1714683f80bd
# ╟─24a3b87d-ad25-4cef-a7c4-f3ee63070b06
# ╠═e2a71032-aaf6-465f-825a-ece21cb029d0
# ╟─8b08f357-cb60-4624-8d93-af2786726e6b
# ╠═308e2838-08ea-487a-8204-5c240402f921
# ╟─7b5f23bd-972a-41b5-a87e-19878c5772a5
# ╟─46fa0dbe-5cdc-4182-8cac-b593920900de
# ╟─84f431e6-5234-498d-88cf-8c634b0d8471
# ╟─4af3a0bc-88e4-442f-9c07-50099c6f2956
# ╠═bd3f04e4-c85b-422d-888e-8c1e9a844b8e
# ╠═098a4518-2221-470b-a8e9-268f5eaf3d0e
# ╠═ecd37d2b-36aa-4edb-9b79-e582799efb04
# ╠═7799bf6a-d302-4513-8372-ee644522354b
# ╠═bebb569b-99d2-4ac6-8383-3dcb3be97ddf
# ╠═58373bd0-87e9-4119-87cb-4477c608a769
# ╟─0e5850db-07d6-40b4-9bc2-0afd98c81603
# ╟─52fc43b7-8823-4125-af5b-236e541c1017
# ╟─6bce2d74-b841-4e84-b5b8-31fdea528923
# ╠═3addb7a3-774f-48da-84d3-7f03c69ff8fe
# ╟─f2a88819-0bec-4df8-9f3d-e38d9acb18f7
# ╟─099d5f8d-559d-4b65-8829-256f20b3c555
# ╠═c7bb5bab-5b16-46f2-af4c-936b5897541a
# ╠═a62272fe-e9bb-4fbf-b2c5-952d4659b7cf
# ╠═cbf3636f-9e84-41bb-a9a3-9f9d66608c05
# ╠═fafb8e4f-54fc-4361-b5ae-1683b6240ab6
# ╟─057b8cb2-a373-4a83-ad46-5e00229fa996
# ╟─d71dabd7-84be-4716-a236-52afbf0da1eb
# ╠═4b701ee5-5eb6-4903-89e6-82fddd0003d8
# ╟─52a338b6-c77c-4a1f-a83a-0dee7c3f5eea
# ╟─4d01d454-2f03-4fd0-ba6e-09620bb73ae2
# ╠═c6bbe136-3211-4f75-9d7a-1d573e108b89
# ╟─f21e7a48-f862-433f-b409-d39d4082db89
# ╟─dae635ed-c2ba-4dfe-9f67-095a72c3ac20
# ╟─5ee8b5ef-2ef3-4b25-abac-38485452b8db
# ╟─955a2803-95c7-42f6-b763-400e9ccfe242
# ╟─86575151-0232-4527-95d8-f2f33511e4d0
# ╠═75c84fa9-c719-448c-b197-64472d05b3c8
# ╠═8cad9c4b-ed95-4381-8ca6-b064c3f59349
# ╠═e410a8ec-abe0-4bcc-8127-cd78cf9355fd
# ╟─330bd158-571a-4de1-8100-dcb19b72a1a4
# ╠═2260adb8-2666-488b-979b-fdc9112a5ee6
# ╟─74032019-4c17-48ad-a5fa-e79d73787f27
# ╠═7f6fad97-46b5-4c72-9387-3e5d6284e8a7
# ╟─dd86f1b8-5e2c-4277-a275-a31f3ca25dec
# ╟─2bb35563-3ed7-4996-9002-cd49d9f43cb5
# ╠═3182eff0-3bb0-4387-9c51-fe3df9f367ea
# ╟─11f3efc4-0517-46a0-8eec-ea67fa42a615
# ╟─0f1cf37d-ca93-40c6-ab67-e93626ef36e1
# ╟─a43d1da3-7ea3-44cd-99f8-966f07aefb16
# ╟─caeacfcd-0eae-428e-89c8-aa680c815104
# ╟─fb8a9e3c-e155-4bb9-89b0-3d84327e5347
# ╠═97d9a976-deee-4142-a436-254aa7ce41e3
# ╠═e9b09fdf-ef8a-4720-8c3b-65cf8d090f45
# ╟─29cabe5d-3ebd-4ad3-b0b5-67e8da38e7c6
# ╟─27b2fe76-828a-4f00-a298-6d496f8947d7
