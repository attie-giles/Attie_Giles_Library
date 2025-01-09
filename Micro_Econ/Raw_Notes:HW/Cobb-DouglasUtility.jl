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

# ╔═╡ a0c04c1c-7798-11ef-3e07-a3d004f51788
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
end

# ╔═╡ 7a832a43-96db-4699-858d-e0cac5f35497
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ d57ca3ce-da74-49d6-a442-e5965bb6cf5f
md"""
# Cobb-Douglas Utility Function
"""

# ╔═╡ 17b06190-93cb-49a0-8f84-78dbdf84401d
md"""
The Cobb-Douglas Utility function is a two variable function of products $x_1$ and $x_2$ that is written as 

$\begin{equation*}
  U(x_1,x_2)=x_1^\alpha x_2^{1-\alpha}
\end{equation*}$
subject to the constraint of a budget equation which is

$\begin{equation*}
  I(p_1,p_2,x_1,x_2)=p_1x_1+p_2x_2.
\end{equation*}$
Solving the budget constraint equation for $x_2$ gives

$\begin{equation*}
  x_2=\frac{I-p_1x_1}{p_2}
\end{equation*}$
We can insert thie value into the Cobb-Douglas Utility function to give 

$\begin{equation*}
  U(x_1)=x^\alpha (\frac{I-p_1x_1}{p_2})^{1-\alpha}
\end{equation*}$
where we are trying to maximize this equation with regard to the endogenous variable $x_1$.

$\begin{equation*}
  Max_{x_1}U  = x^\alpha (\frac{I-p_1x_1}{p_2})^{1-\alpha}.
\end{equation*}$
Finding the first-order condition of this equation with respect to $x_1$ gives

$\begin{equation*}
  \frac{dU}{dx_1}=\alpha x_1^{\alpha-1} (\frac{I-p_1x_1}{p_2})^{1-\alpha}-x_1^\alpha(1-\alpha)(\frac{I-p_1x_1}{p_2})^{-\alpha}\frac{p_1}{p_2}=0
\end{equation*}$
This function, by the implicit function theorem can be defined as an implicit function of 

$\begin{equation*}
  x^*_1=x_1^*(p_1,p_2,I)
\end{equation*}$
where $x^*_1$ is the value of $x_1$ that satisfies the first-order condition.
We can use this implicit function to 


      . plot x1*(p1,p2,I) against p1, at two values of p2
      . plot x1*(p1,p2,I) against p2, at two values of p1
      . plot x1*(p1,p2,I) against  I, at two values of p1
      . plot the p1, p2, and I expansion paths for x1* in (x1,x2) space
      . plot V(p1,p2,I) againts p1, p2, I

"""

# ╔═╡ 5b1e3791-7d0a-43de-9ac0-4c4d513aaf24
α=.6

# ╔═╡ b7dc4a82-5359-4bb2-8c8c-0df7cb7ab9fa
dU(x1,p1,p2,I)=α*x1^(α-1)*((I-p1*x1)/p2)^(1-α)-x1^α*(1-α)*((I-p1*x1)/p2)^(-α)*(p1/p2)

# ╔═╡ d30911bd-f785-4b9d-9fe5-1283c529193c
p1vec=collect(range(.1, 25, length=101))

# ╔═╡ 5ffb2b16-1a34-4583-8537-e60e0ca49a79
p2vec=collect(range(.1, 25, length=101))

# ╔═╡ 0bc69635-0ecc-4753-9503-7472672fad8f
U(x1,x2)=x1^α*x2^(1-α)

# ╔═╡ c946ee7b-2b12-4768-8e3e-fe9b43333691
U2(x1,p1,p2,I)=x1^α*((I-p1*x1)/p2)^(1-α)

# ╔═╡ d3ae0f51-a4da-46c5-82ba-464dff913f6f
I(x1,x2,p1,p2)=p1*x1+p2*x2

# ╔═╡ b51ab38c-6465-4dac-a05f-cf63d08094e2
x2(x1,p1,p2,I)=(I-p1*x1)/p2

# ╔═╡ 84a66dc3-cb97-4b1e-a4a1-6b5d9688452c
begin
	p1s=20
	p12s=25
	p13s=30
	p2s=22
	p22s=27
	p23s=33
	Is=200
	I2s=220
	I3s=240
end
	

# ╔═╡ 05a39487-3548-4bc1-90c4-6441e928730b
p2d = @bind p2d Slider(1.0:0.1:40, default=20, show_value=true)

# ╔═╡ 5e750675-d35d-41bc-beb2-5a645b6af9dc
function findzero(p1,p2,I)

# Define the zero condition at the parameter value supplied
cond(x1) = dU(x1,p1,p2,I)

# Specify a starting guess
x0 = 5

# Find and return the solution
x = find_zero(cond, x0)

end;

# ╔═╡ d53ad172-efbe-4070-a053-737d64049f0a
md"Plot at different value of p2: $(@bind diffp2 CheckBox(default=false))"

# ╔═╡ aa5075a0-8e6f-41e8-adc2-7d96e66065ea
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
    plot!(findzero.(p1vec,p2s,Is), p1vec, linecolor=:black, linestyle=:solid, linewidth=2)
	if diffp2 == true
	plot!(findzero.(p1vec,p2d,Is), p1vec, linecolor=:red, linestyle=:solid, linewidth=2)
	end
	 # Axis labels
    annotate!(25, 1, text(L"x1^*", :left, :center, 12))
    annotate!(0, 25, text(L"p1", :center, :bottom, 12))
	# Axis limits
    xlims!(0, 25)
    ylims!(0, 25)
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

   plot1	
end

# ╔═╡ ce35baf3-694b-4677-bb01-79155c10f8bd
p1d = @bind p1d Slider(1.0:0.1:40, default=20, show_value=true)

# ╔═╡ cd6f85bd-bb53-46eb-9bab-bb8535e11f41
md"Plot at different value of p1: $(@bind diffp1 CheckBox(default=false))"

# ╔═╡ 92a18f20-2e0d-4c72-95a5-218cf6cb71e4
begin
    plot2 = plot(
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
    plot!(findzero.(p1s,p2vec,Is), p2vec, linecolor=:black, linestyle=:solid, linewidth=2)
	if diffp1 == true
	plot!(findzero.(p1d,p2vec,Is), p2vec, linecolor=:red, linestyle=:solid, linewidth=2)
	end
	 # Axis labels
    annotate!(25, 1, text(L"x1^*", :left, :center, 12))
    annotate!(0, 25, text(L"p2", :center, :bottom, 12))
	 # Axis limits
    xlims!(0, 25)
    ylims!(0, 25)

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

   plot2
end

# ╔═╡ 40c0a50d-a4d6-49b0-bed7-d874d31eb0fa
Ivec=collect(range(101,300,length=300))

# ╔═╡ 9a5b87eb-5690-4774-9316-c21ee46bc78d
md"Plot at different value of p1: $(@bind diffp1forI CheckBox(default=false))"

# ╔═╡ 5def8cfd-a0f6-427d-bb49-8e61ea027912
begin
    plot3 = plot(
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
    plot!(findzero.(p1s,p2s,Ivec), Ivec, linecolor=:black, linestyle=:solid, linewidth=2)
	if diffp1forI == true
	plot!(findzero.(p1d,p2s,Ivec), Ivec, linecolor=:red, linestyle=:solid, linewidth=2)
	end
	 # Axis labels
    annotate!(25, 110, text(L"x1^*", :left, :center, 12))
    annotate!(0, 300, text(L"I", :center, :bottom, 12))
	 # Axis limits
    xlims!(0, 25)
    ylims!(101, 300)

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

   plot3
end

# ╔═╡ 37e3e821-1e33-4afc-8262-e999d71dc7b6
x1vec=collect(range(.1,20,length=101))

# ╔═╡ ada43ca8-241d-48c8-b439-3862c29ddb8b
x2vec=copy(x1vec)

# ╔═╡ f573952d-315c-4073-9c62-e8e3704bc072
function tangent(p1,p2,I) #uses a find zero to find x^* that can then be used to find the corresponding x2 that can then be used to find the k value
	x1opt=0
	x2opt=0
	k=0
	cond1(x1) = dU(x1,p1,p2,I)
	x10 = 1
	x1 = find_zero(cond1,x10)
	x1opt = x1
	x2opt= x2(x1opt,p1,p2,I)
	k=U(x1opt,x2opt)
end

# ╔═╡ 4b0afc0c-d0d7-45de-b1f6-c30bd93da56c
function tangent2(p1,p2,I) #uses a find zero to find x^* that can then be used to find the corresponding x2 that can then be used to find the k value
	x1opt=0
	x2opt=0
	k=0
	cond1(x1) = dU(x1,p1,p2,I)
	x10 = 1
	x1 = find_zero(cond1,x10)
	x1opt = x1
	x2opt= x2(x1opt,p1,p2,I)
	return [x1opt,x2opt]
end

# ╔═╡ e80e5f42-9a08-4374-a071-f4c96cfe8d54
function Util(x1, k)

# Define the zero condition at the parameter value supplied, in this case the zero condition is dependent on the p1,p2, and I values, beause that's the utility level to reach.
cond1(x2) = k - U(x1,x2)

# Specify a starting guess
U1 = 1

# Find and return the solution
x2 = find_zero(cond1, U1)

end;

# ╔═╡ c38b3a6b-ec4c-46cc-b41f-75bb53029dcd
md"Plot p1 expansion path: $(@bind p1exp CheckBox(default=false))"

# ╔═╡ e8679452-4359-4029-b493-649829fc3c51
md"Plot p2 expansion path: $(@bind p2exp CheckBox(default=false))"

# ╔═╡ 82b28f40-b12d-4801-9b67-54b8d6612fd4
md"Plot I expansion path: $(@bind Iexp CheckBox(default=false))"

# ╔═╡ 6f668420-04d5-4751-b435-0dea283f2487
begin
    plot4 = plot(
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
	#p1 Exapnasion
	if p1exp == true
	#Curve 1 
	plot!(x1vec, Util.(x1vec,tangent(p1s,p2s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
    plot!(x1vec, x2.(x1vec,p1s,p2s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
    plot!([tangent2(p1s,p2s,Is)[1],tangent2(p1s,p2s,Is)[1]], [0,tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2],tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2]], markercolor=:black, markersize=5)
	#_________________________________________________________________________#
	#curve 2
	plot!(x1vec, Util.(x1vec,tangent(p12s,p2s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p12s,p2s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
 	plot!([tangent2(p12s,p2s,Is)[1],tangent2(p12s,p2s,Is)[1]], [0,tangent2(p12s,p2s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p12s,p2s,Is)[1]], [tangent2(p12s,p2s,Is)[2],tangent2(p12s,p2s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p12s,p2s,Is)[1]], [tangent2(p12s,p2s,Is)[2]], markercolor=:black, markersize=5)
#_________________________________________________________________________#
	#curve 3
	plot!(x1vec, Util.(x1vec,tangent(p13s,p2s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p13s,p2s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([tangent2(p13s,p2s,Is)[1],tangent2(p13s,p2s,Is)[1]], [0,tangent2(p13s,p2s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p13s,p2s,Is)[1]], [tangent2(p13s,p2s,Is)[2],tangent2(p13s,p2s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p13s,p2s,Is)[1]], [tangent2(p13s,p2s,Is)[2]], markercolor=:black, markersize=5)
	end
		#p2 expansion
		if p2exp == true
	#Curve 1
	plot!(x1vec, Util.(x1vec,tangent(p1s,p2s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
    plot!(x1vec, x2.(x1vec,p1s,p2s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
    plot!([tangent2(p1s,p2s,Is)[1],tangent2(p1s,p2s,Is)[1]], [0,tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2],tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2]], markercolor=:black, markersize=5)
	#_________________________________________________________________________#
	#curve 2
	plot!(x1vec, Util.(x1vec,tangent(p1s,p22s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p1s,p22s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
 	plot!([tangent2(p1s,p22s,Is)[1],tangent2(p1s,p22s,Is)[1]], [0,tangent2(p1s,p22s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p22s,Is)[1]], [tangent2(p1s,p22s,Is)[2],tangent2(p1s,p22s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p22s,Is)[1]], [tangent2(p1s,p22s,Is)[2]], markercolor=:black, markersize=5)
#_________________________________________________________________________#
	#curve 3
	plot!(x1vec, Util.(x1vec,tangent(p1s,p23s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p1s,p23s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([tangent2(p1s,p23s,Is)[1],tangent2(p1s,p23s,Is)[1]], [0,tangent2(p1s,p23s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p23s,Is)[1]], [tangent2(p1s,p23s,Is)[2],tangent2(p1s,p23s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p23s,Is)[1]], [tangent2(p1s,p23s,Is)[2]], markercolor=:black, markersize=5)
		end
	#Expansion path for income
	if Iexp == true
	#Curve 1
	plot!(x1vec, Util.(x1vec,tangent(p1s,p2s,Is)), linecolor=:black, linestyle=:solid, linewidth=2)
    plot!(x1vec, x2.(x1vec,p1s,p2s,Is), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
    plot!([tangent2(p1s,p2s,Is)[1],tangent2(p1s,p2s,Is)[1]], [0,tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2],tangent2(p1s,p2s,Is)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p2s,Is)[1]], [tangent2(p1s,p2s,Is)[2]], markercolor=:black, markersize=5)

	#_________________________________________________________________________#
	#curve 2
	plot!(x1vec, Util.(x1vec,tangent(p1s,p2s,I2s)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p1s,p2s,I2s), linecolor=:black, linestyle=:solid, linewidth=2)
 	plot!([tangent2(p1s,p2s,I2s)[1],tangent2(p1s,p2s,I2s)[1]], [0,tangent2(p1s,p2s,I2s)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p2s,I2s)[1]], [tangent2(p1s,p2s,I2s)[2],tangent2(p1s,p2s,I2s)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p2s,I2s)[1]], [tangent2(p1s,p2s,I2s)[2]], markercolor=:black, markersize=5)
#_________________________________________________________________________#
	#curve 3
	plot!(x1vec, Util.(x1vec,tangent(p1s,p2s,I3s)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2.(x1vec,p1s,p2s,I3s), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([tangent2(p1s,p2s,I3s)[1],tangent2(p1s,p2s,I3s)[1]], [0,tangent2(p1s,p2s,I3s)[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent2(p1s,p2s,I3s)[1]], [tangent2(p1s,p2s,I3s)[2],tangent2(p1s,p2s,I3s)[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent2(p1s,p2s,I3s)[1]], [tangent2(p1s,p2s,I3s)[2]], markercolor=:black, markersize=5)
	end
	# Axis limits
    xlims!(0, 20)
    ylims!(0, 20)
	 # Axis labels
    annotate!(20, 1, text(L"x1", :left, :middle, 12))
    annotate!(0, 20, text(L"x2", :center, :bottom, 12))
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

   plot4	
end

# ╔═╡ 2172297f-244d-4eb5-a429-970dab9fde9c
md"""
In mathematical economics we can define the utility curves above identified from the first order condition $\frac{dU}{dx_1}$ as 

$\begin{equation*}
  U^*(p_1,p_2,I)=U(x^*_1(p_1,p_2,I),\frac{I-p_1x_1^*(p_1,p_2,I)}{p_2}).
\end{equation*}$
This equation we then define as 

$\begin{equation*}
  V(p_1,p_2,I)=U^*(p_1,p_2,I),
\end{equation*}$
where $ V(p_1,p_2,I)$ can be understood as meaning the indirect defined by the exogenous variables $p_1,p_2,I$. We can plot those that graph below for different values of $p_1,p_2,I$.
"""

# ╔═╡ 039101eb-b361-4d75-b9b0-cdbde0a37d59
V(p1,p2,I)=U(tangent2(p1,p2,I)[1],tangent2(p1,p2,I)[2])

# ╔═╡ 185a308b-4aca-4358-93e1-1e5d764e47a3
md"Plot V against p1: $(@bind Vp1 CheckBox(default=false))"

# ╔═╡ 9d893cd5-849c-4cb2-b90a-35bf063eec25
md"Plot V against p2: $(@bind Vp2 CheckBox(default=false))"

# ╔═╡ 3a9507d4-012e-44d2-8b87-4d0814c06798
md"Plot V against I: $(@bind VI CheckBox(default=false))"

# ╔═╡ f2385a3b-644d-49b1-ba39-3259abb85d99
begin
    plot5 = plot(
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
	if Vp1 == true
    plot!(V.(p1vec,p2s,Is), p1vec, linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis labels
    annotate!(.95*xlims(plot5)[2], 1, text(L"V(p_1,p_2,I)", :left, :center, 12))
    annotate!(5, 1.01*ylims(plot5)[2], text(L"p_1", :center, :bottom, 12))
	end
	if Vp2 == true
		 plot!(V.(p1s,p2vec,Is), p2vec, linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis labels
    annotate!(.95*xlims(plot5)[2], 1, text(L"V(p_1,p_2,I)", :left, :center, 12))
    annotate!(5, 1.01*ylims(plot5)[2], text(L"p_2", :center, :bottom, 12))
	end
	if VI == true
	 plot!(V.(p1s,p2s,Ivec), Ivec, linecolor=:black, linestyle=:solid, linewidth=2)
	# Axis labels
    annotate!(7, 110, text(L"V(p_1,p_2,I)", :left, :center, 12))
    annotate!(2.5, 300, text(L"I", :center, :bottom, 12))
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

   plot5
end

# ╔═╡ Cell order:
# ╠═a0c04c1c-7798-11ef-3e07-a3d004f51788
# ╠═7a832a43-96db-4699-858d-e0cac5f35497
# ╟─d57ca3ce-da74-49d6-a442-e5965bb6cf5f
# ╟─17b06190-93cb-49a0-8f84-78dbdf84401d
# ╠═b7dc4a82-5359-4bb2-8c8c-0df7cb7ab9fa
# ╠═5b1e3791-7d0a-43de-9ac0-4c4d513aaf24
# ╠═d30911bd-f785-4b9d-9fe5-1283c529193c
# ╠═5ffb2b16-1a34-4583-8537-e60e0ca49a79
# ╠═0bc69635-0ecc-4753-9503-7472672fad8f
# ╠═c946ee7b-2b12-4768-8e3e-fe9b43333691
# ╠═d3ae0f51-a4da-46c5-82ba-464dff913f6f
# ╠═b51ab38c-6465-4dac-a05f-cf63d08094e2
# ╠═84a66dc3-cb97-4b1e-a4a1-6b5d9688452c
# ╠═05a39487-3548-4bc1-90c4-6441e928730b
# ╠═5e750675-d35d-41bc-beb2-5a645b6af9dc
# ╠═d53ad172-efbe-4070-a053-737d64049f0a
# ╟─aa5075a0-8e6f-41e8-adc2-7d96e66065ea
# ╠═ce35baf3-694b-4677-bb01-79155c10f8bd
# ╠═cd6f85bd-bb53-46eb-9bab-bb8535e11f41
# ╠═92a18f20-2e0d-4c72-95a5-218cf6cb71e4
# ╠═40c0a50d-a4d6-49b0-bed7-d874d31eb0fa
# ╠═9a5b87eb-5690-4774-9316-c21ee46bc78d
# ╟─5def8cfd-a0f6-427d-bb49-8e61ea027912
# ╠═37e3e821-1e33-4afc-8262-e999d71dc7b6
# ╠═ada43ca8-241d-48c8-b439-3862c29ddb8b
# ╠═f573952d-315c-4073-9c62-e8e3704bc072
# ╠═4b0afc0c-d0d7-45de-b1f6-c30bd93da56c
# ╠═e80e5f42-9a08-4374-a071-f4c96cfe8d54
# ╠═c38b3a6b-ec4c-46cc-b41f-75bb53029dcd
# ╠═e8679452-4359-4029-b493-649829fc3c51
# ╠═82b28f40-b12d-4801-9b67-54b8d6612fd4
# ╟─6f668420-04d5-4751-b435-0dea283f2487
# ╟─2172297f-244d-4eb5-a429-970dab9fde9c
# ╠═039101eb-b361-4d75-b9b0-cdbde0a37d59
# ╠═185a308b-4aca-4358-93e1-1e5d764e47a3
# ╠═9d893cd5-849c-4cb2-b90a-35bf063eec25
# ╟─3a9507d4-012e-44d2-8b87-4d0814c06798
# ╟─f2385a3b-644d-49b1-ba39-3259abb85d99
