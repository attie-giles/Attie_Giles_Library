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

# ╔═╡ 3c3a7fc4-c20f-11ef-0aa8-79f8621f6c7d
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end

# ╔═╡ 87a78e85-87b7-4e37-abf5-22f1d07c2758
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ a9d2e981-e293-4647-b970-c9a4adba2d1e
md"""
# Micro Pluto Encycolopedia
"""

# ╔═╡ e3938a84-584b-477b-8cf0-44e55453c965
md"""
This part of the Encyclopedia will cover basic plotting and coding parts of Pluto, basic demand and supply curves, and simple, perfectly competitive firms.
"""

# ╔═╡ 142936b8-34c9-45a8-bed7-fad26e6987c1
md"""
## Basic Plotting
"""

# ╔═╡ df123947-5e98-44b2-9852-0a49c15b390c
md"""
Plotting in Pluto essentially comes down to two main features, specifying a vector for the x-axis and specififying a function to operate on that domain vector. Using that knowledge and the general tools of Pluto we can specify a production function $q(l)$. 
"""

# ╔═╡ de0db303-aace-452b-8ddb-b6a21862d6e3
lmax = 25 #This is what is referred to as a global variable where specifying this variable can be used throughout the whole sheet

# ╔═╡ fdfe51f5-fc3f-4d53-b6d7-c5bca394aa2c
lvec= collect(range(0,lmax,length=101)) #our domain vector

# ╔═╡ 18fd9bfd-1356-4a7d-93a6-7b99ab8289bc
md"""
As we see in equation $q_1(l)$, it is only a function of the variable $l$, but there are a total of 4 unknowns. This is because those other unknowns are being treated as parameters in the function and do not need to be specified because Pluto is assuming they will not vary. However, in order to actually plot the function, we need to specify them or else we will get an error message. We can do this in one of two ways, either specifying them as a global variable like we did for $lmax$ or giving them a slider so that we can see how the function will change when the parameters change.
"""

# ╔═╡ 13c46070-d67c-4417-81cb-27e87f62d8f2
a_1 = @bind a_1 Slider(0.0:0.1:1.0, default=0.5, show_value=true)

# ╔═╡ a9d02ae8-2758-48df-b17f-bde523bedaba
b_1 = @bind b_1 Slider(0.0:0.5:5.0, default=2, show_value=true)

# ╔═╡ e34f8010-2c8a-4eae-be6d-1dabefab45dd
c_1 = @bind c_1 Slider(0.0:0.5:5.0, default=2, show_value=true)

# ╔═╡ 682e8a03-e1e0-4f8e-8129-40d49fee06e3
q_1(l) = a_1 + b_1*l + .5*c_1*l^2 #This is our production function, where because we wil probably use these variable representations again we need to give them subscripts because pluto notebooks cannot handle multiple variables of the same name. ;

# ╔═╡ 02e6b1d1-9a11-4efe-964f-56932f4bf0d9
md"""
We now have all the information necessary in order for pluto to plot this function. 
"""

# ╔═╡ ac9a8e16-54da-4bfd-b27c-027035d37da7
plot(lvec,q_1.(lvec)) #This is all you need for a basic pluto plot, but it is important to keep in mind that because we are working with vector we need the "." because it specfies that our function act on each individual data point in that vector.

# ╔═╡ 899d20bd-959a-43e4-89b7-337275e01274
md"""
This is the most basic plotting function that pluto can generate, but we can specify other things to make it look better as we will do below. 
"""

# ╔═╡ a0e5ea9f-b9eb-4314-94d9-e40345fbf4d4
begin
    quadractifunction1 = plot(
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
    plot!(lvec, q_1.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   quadractifunction1	
end

# ╔═╡ 4a6293a9-c132-432c-bcee-329eac418329
md"""
The above plot is given the exact same info regarding the domain and the function, the only difference is that it is given different info regarding the aesthetics. The above graph and function specifies a **quadratic function**, below we will create different types of functions and show how they look.
"""

# ╔═╡ 42a8b0cb-328b-4029-9fae-a8146ce70e45
md"""
A different type of function is an **exponential function** that raises some constant to a variable, the easiest constant to work with analytically is $e$. 
"""

# ╔═╡ 05406643-15d9-4542-855e-997fe3b5abb9
a_2 = @bind a_2 Slider(1.0:0.1:2, default=1.0, show_value=true)

# ╔═╡ 39c79a65-eddc-4f24-88aa-77745509da3c
k_1 = @bind k_1 Slider(0.0:0.1:5, default=1.0, show_value=true)

# ╔═╡ 0707ae83-2f81-4805-9d3f-26cfaea761e1
θ_1(l) = a_2*ℯ^(k_1*l); #exponential function

# ╔═╡ b7dbfc12-61fa-408d-bff2-7047de4c44f9
begin
    exponentialgraph1 = plot(
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
    plot!(lvec, θ_1.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   exponentialgraph1	
end

# ╔═╡ 92a15fc5-ba1a-481e-b81a-184d2c849999
md"""
Both the quadratic function and the exponential function have the characteristic of being constantly increasing and going to ∞ as l goes to ∞. An example of a function that doesn't is a **logistic equation** that we will specify below. 
"""

# ╔═╡ 876e8681-df7f-4791-81cc-260f65dbfb01
P₀ = @bind P₀ Slider(0.0:1:10, default=1.0, show_value=true) #Initial population

# ╔═╡ 7ec10c59-0fba-4081-9c4f-f572921b0d59
K = @bind K Slider(5.0:0.1:10.0, default=0.5, show_value=true) #Max capacity

# ╔═╡ d8f0947a-6096-4fe8-8249-a02942ad6c7b
r = @bind r Slider(0.0:0.1:5.0, default=0.5, show_value=true) #growth rate

# ╔═╡ 846a0b5e-fae7-4358-bce3-42a2de3d3248
P(L) = (P₀*K*ℯ^(r*L))/((K-P₀)+(P₀*ℯ^(r*L))) #logistic function

# ╔═╡ 1ac82d8a-5ca7-43b0-8d42-f7c5b56f56ae
begin
    logisticgraph1 = plot(
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
    plot!(lvec, P.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   logisticgraph1	
end

# ╔═╡ e7a74f4f-157a-46bf-ab4f-98a41003e52e
md"""
Here we can clearly see that this function plateaus at a certain point and never exceeds that for all values of $l$. The logistic equation is a common equation in animal population and ecology that can be used to represent the maximum carrying capacity for a certain group of animals in a certain environment where $P_o$ is the initial population, $K$ represents the maximum capacity and $r$ represents the growth rate of the organism. As we will see later on there are lots of parallels with ecology, biology and economics that we will uncover in later works. 
"""

# ╔═╡ 1cf6f061-1aed-4180-9951-773ef44dfcb8
md"""
Another basic function is the **square root** function that we specify below.
"""

# ╔═╡ 208d60b2-8e28-4b88-8a55-b7433de33dca
w = @bind w Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ 6479d242-e46e-4d4b-833f-a0f63b077d92
Y(l)=sqrt(l*w); #square root function

# ╔═╡ 1d2ccdee-a16a-4100-adb3-d038e129197a
begin
    squarerootgraph = plot(
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
    plot!(lvec, Y.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   squarerootgraph	
end

# ╔═╡ 55645ce3-9554-4680-ae23-826bae312942
md"""
As we will see later on, all these function will be used to specify one or another specific functional forms for a given problem. Like how we specified our production function $q(l)$ with a **quadratic** functional form. 
"""

# ╔═╡ c13cd50a-35e6-4b04-a809-78c18a3be1da
md"""
## Practice Problem 1
"""

# ╔═╡ a33ca462-13f3-4ed9-be25-b4d2749148ae
md"""
Say we are given an equation for a demand function and we want to determine how much the price will be at a certain quantity demanded and how much quantity will be demanded at a certain price. That demand function is specified below.
"""

# ╔═╡ ccaf674b-92fb-4a6d-bcfd-2d21c7837923
α_1 = @bind α_1 Slider(0.0:0.1:100.0, default=100.0, show_value=true) #parameter

# ╔═╡ 265df00a-f296-477d-92cb-bec66e5d9403
z_1 = @bind z_1 Slider(-5:0.01:5.0, default=-0.1, show_value=true) #parameter

# ╔═╡ 467b7d96-e403-4213-9f13-e1ce6b749799
Qd_1(p_1) = α_1*ℯ^(z_1*p_1); #Quantity demanded equation that is nonlinear

# ╔═╡ 01eef373-8f1d-407c-8be4-90c626b720df
P_1min=0 #price min

# ╔═╡ 048b3788-1076-4ee9-959c-44f455108525
P_1max=100 #price max

# ╔═╡ 7da981d8-8653-4257-8ec2-d848ccbc2ac9
p_1vec = collect(range(P_1min, P_1max, length=P_1max))

# ╔═╡ 962e2aba-7f77-46b7-808c-16840460eda9
md"""
All this information results in the following graph where the price that it is sold is located on the x-axis and the quantity demanded is located on the y-axis.
"""

# ╔═╡ 9e930004-74cb-4bbe-8025-daed2466e8d5
begin
    qdgraph1 = plot(
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
    plot!(p_1vec, Qd_1.(p_1vec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis labels
    annotate!(1.02*xlims(qdgraph1)[2], 0, text(L"P", :left, :center, 12))
    annotate!(0, 1.01*ylims(qdgraph1)[2], text(L"Q", :center, :bottom, 12))

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

   qdgraph1	
end

# ╔═╡ 824d67fe-cd19-4df8-a374-38faf8d8ecb0
md"""
To determine what the quantity demanded given a certain price is easy, we would just plug that price into the equation and get the answer.
"""

# ╔═╡ e4a8b11d-cab6-4e1a-948f-2b91ea6e5eb4
md"""Enter Price: $(@bind price_str TextField(default="20"))"""

# ╔═╡ 2d317809-b12b-4bf2-b6b7-8069309ba954
function practiceq1() #function to answer the question

	#parse the text box to turn it into a number
	price=parse(Float64, price_str)

	#insert the price into the function to get the answer
	answer = Qd_1(price) #Qd_1 is our quantity demanded function

	return md" Quantity Demanded for price \$$price is $(round(answer,digits=2)) " #Spits out the answer
end;

# ╔═╡ 1e0bfd42-81b7-4de0-9e40-cc9a48b84355
practiceq1() #returns the value to our function

# ╔═╡ c730f8d5-dfea-48d8-ba80-8b08866a5a35
md"""
However, if we wanted to find a general and easy way to answer the other question of how much price will be at a certain quantity demanded we cannot simply just plug it into the equation. One route would be to use a numerical method via a ""for"" loop.
"""

# ╔═╡ 5b9ca874-d6f3-4712-8c45-c9df3cf65396
md"""Enter Quantity Demanded: $(@bind qd_str TextField(default="13.53"))"""

# ╔═╡ 45203b71-62e0-41d6-ac9d-d3c44ce38afd
function practiceeq2() #function to answer the question

	#parse the text box to turn it into a number
	qd=parse(Float64,qd_str)

	#initialize the price
	price=0

	#begin the for loop
	for p1 = P_1min : .001 : P_1max 
		if .999*qd < Qd_1(p1) < 1.001*qd
			break 
		end
			price=p1
	end
	md"Price for quantity demanded of $qd is \$$(round(price,digits=2))" 
end;

# ╔═╡ 1b4f1470-2551-4978-bf70-3f57e33b7cab
practiceeq2()

# ╔═╡ 1f41f7bb-9140-4bac-991e-f3ce210b61bf
md"""
What I am telling this function to do is to run through all the prices from our min to max until it finds one close enough to the quantity demanded we specified where the for loop "breaks" and reports back that price that was close enough.
"""

# ╔═╡ f7ac776c-bd8b-426e-b416-5232623e5fa5
md"""
## Basic Plotting 2
"""

# ╔═╡ 128441d8-d0f6-42f0-8942-0654046429ba
md"""
For the equations like the logistic equation that aymptote at a particular value, we can denote the value and show it graphically. Take the two functions specified below.
"""

# ╔═╡ 2c899284-01ed-4d41-b8a9-45e46b422784
α_exp1 =  @bind α_exp1 Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ a9a5f604-b147-4924-a414-d6e7a4100aa5
β_exp1 = @bind β_exp1 Slider(0.0:0.1:10.0, default=0.3, show_value=true)

# ╔═╡ 8e4dd5b9-1ded-49de-b66d-26d0ff42e0d0
q_exp1(l) = α_exp1 * (1-exp(-β_exp1*l)); #exp stands for eulers numer

# ╔═╡ e5307530-a4a9-4105-ad5c-d129eccc8839
α_exp2 =  @bind α_exp2 Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 268fd40f-d467-4f24-9cd1-024e042ebf05
β_exp2 = @bind β_exp2 Slider(0.0:0.1:10.0, default=0.3, show_value=true)

# ╔═╡ 4d38db1b-8ad2-4536-be60-7bb977dad3c5
q_exp2(l) = α_exp2 * (1-exp(-β_exp2*l));

# ╔═╡ 8cac7656-f152-4438-ae19-34d707970da2
begin
    qexpgraph1 = plot(
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
    plot!(lvec, q_exp1.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_exp2.(lvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	plot!([0,lvec[end]], [α_exp1,α_exp1], linecolor=:black, linestyle=:dash, linewidth=2)
	plot!([0,lvec[end]], [α_exp2,α_exp2], linecolor=:blue, linestyle=:dash, linewidth=2)


	 # Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.2*maximum(q_exp1.(lvec)))
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

   qexpgraph1	
end

# ╔═╡ 71cd290f-52c0-4d9f-b18a-ed6ae8c8eaaf
md"""
We can see above that the both functions aymptote at particular values and that value is indicated by the line. Because the general form for this equation is

$\begin{equation*}
  q(l) = α \cdot (1 - e^{-β \cdot l})
\end{equation*}$
This equation can be rewritten to

$\begin{equation*}
  q(l) = α \cdot (1 - \dfrac{1}{e^{β\cdot l}})
\end{equation*}$

where it is clear to see that for high values of $l$ this equation will approach $\alpha$
"""

# ╔═╡ 15158c45-4b09-4b3b-a466-bad174de6f19
md"""
Pluto can also be used to graph functions in both total and marginal space as well as the averages for functions, which is useful in economics. Take the following equations.
"""

# ╔═╡ 77844849-42a0-4c85-bb6b-801988f8ee51
a_quad = @bind a_quad Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 9cb78948-f050-4cfe-9d02-c7296cbe3c51
b_quad = @bind b_quad Slider(0.0:0.1:10.0, default=5.0, show_value=true)

# ╔═╡ 93798d2f-01ba-4c09-8990-72e0275a5dae
begin #Wrapping all the equations in one block
	q_quad(l) = a_quad*l - (0.5*b_quad*(l^2)) #total function
	q_quadd(l) = a_quad -b_quad*l #derivative function
	q_quadavg(l) = q_quad(l)/l #average function
end;

# ╔═╡ 06a198fc-c062-473d-9213-b6457edfc905
begin
    totalspacequad = plot(
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
    plot!(lvec, q_quad.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	

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

   totalspacequad	
end

# ╔═╡ 0d75e712-395a-4ce6-beee-e8c2a5f26f9b
md"""
Additionally, if we are ever curious to know if our math is correct for the derivative we can use the forward.diff package in pluto to tell us.
"""

# ╔═╡ 4e4f7452-bb9f-49e4-b1e9-320221915960
md"Check derivative: $(@bind check_derivative CheckBox(default=false))"

# ╔═╡ e3d363bd-b385-40d8-9471-31af8d04be7d
begin
    qquadgraphmargandavg = plot(
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
    plot!(lvec, q_quadd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_quadavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative==true
		# Calculate the derivative numerically
	  quadpchk(l) = ForwardDiff.derivative(q_quad, l)
		
      # Plot the numerical derivative in red
	  plot!(lvec, quadpchk.(lvec), linecolor=:blue)
    end 
		

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

   qquadgraphmargandavg	
end

# ╔═╡ 26c3be98-0f14-4a20-88ab-4d93e5314a99
md"""
We can do the same thing for all the other different types of functional forms that we specified. First example will be the power function.
"""

# ╔═╡ 745703d1-8ce8-493d-bcbd-733ddf79c86c
begin 
	q_power(l) = l^a_quad
	q_powerd(l) = a_quad*l^(a_quad-1)
	q_poweravg(l) = q_power(l)/l
end;

# ╔═╡ 99c66e56-a9e8-4219-a9d9-2640ccd7104e
begin
    qpowertotal = plot(
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
    plot!(lvec, q_power.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   qpowertotal	
end

# ╔═╡ d0442e6f-6be5-43e0-a01c-1990274b2a73
md"Check derivative: $(@bind check_derivative2 CheckBox(default=false))"

# ╔═╡ 7927392a-eeea-489e-8c54-71d15c0c6851
begin
    qquaddmarginal = plot(
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
    plot!(lvec, q_powerd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_poweravg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative2==true
		powerpchk(l) = ForwardDiff.derivative(q_power,l)
		plot!(lvec, powerpchk.(lvec),linecolor=:blue)
	end
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

   qquaddmarginal	
end

# ╔═╡ b612449f-d7ee-4aab-893b-9d305f9f6288
md"""
Same thing for a **Log Function**.
"""

# ╔═╡ e35a05ac-584e-4b86-9907-b0af1309d895
begin
	q_log(l)=log(l+a_quad)
	q_logd(l)=1/(l+a_quad)
	q_logavg(l)=q_log(l)/l
end;

# ╔═╡ 8f119c28-190a-4bd9-8a04-1982c426c701
begin
    qlogtotalspace = plot(
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
    plot!(lvec, q_log.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   qlogtotalspace	
end

# ╔═╡ f324295b-1aef-4a1d-8842-f17f98184012
md"Check derivative: $(@bind check_derivative3 CheckBox(default=false))"

# ╔═╡ 93dbd900-1b3b-4bc9-bd63-a07489be0aa7
begin
    qlogmarginal = plot(
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
    plot!(lvec, q_logd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_logavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative3==true
		q_logdchk(l)=ForwardDiff.derivative(q_log,l)
		plot!(lvec,q_logdchk.(lvec),linecolor=:blue)
	end

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

   qlogmarginal	
end

# ╔═╡ 1c235801-141b-4852-aeae-81d89bd5d823
md"""
Same thing for the **euler function**.
"""

# ╔═╡ fe7220ae-af14-416c-b8b8-fe8a523bb517
begin 
	q_exponential(l) = α_exp1 * (1-exp(-β_exp1*l))
	q_exponentiald(l) = α_exp1*β_exp1*exp(-β_exp1*l)
	q_exponentialavg(l) = q_exponential(l)/l
end;

# ╔═╡ c28a7413-03a8-4352-8dfc-7cb0defa4961
begin
    qexptotal = plot(
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
    plot!(lvec, q_exponential.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   qexptotal	
end

# ╔═╡ 1eb3e454-e15a-4e3b-9f14-18b03e81dbbd
md"Check derivative: $(@bind check_derivative4 CheckBox(default=false))"

# ╔═╡ 1ec3205d-18b1-416c-9c76-28e4db1f17de
begin
    qexpmarginal = plot(
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
    plot!(lvec, q_exponentiald.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_exponentialavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative4==true
		q_expchd(l) = ForwardDiff.derivative(q_exponential,l)
		plot!(lvec, q_expchd.(lvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end
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

   qexpmarginal	
end

# ╔═╡ 600c8bd0-95ca-4402-9647-48261db2090f
md"""
**Iso-Elastic Equation**. In mathematical economics, an isoelastic function, sometimes constant elasticity function, is a function that exhibits a constant elasticity, i.e. has a constant elasticity coefficient. The elasticity is the ratio of the percentage change in the dependent variable to the percentage causative change in the independent variable, in the limit as the changes approach zero in magnitude. 
"""

# ╔═╡ e2999e0d-6f5c-4b53-bf7c-520dc448a766
c_2 = @bind c_2 Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ c6c5a122-44af-4122-8874-ed79e8f7287a
d_2 = @bind d_2 Slider(0.0:0.1:10.0, default=0.5, show_value=true)

# ╔═╡ 4905ddf1-f3a1-49dc-a8e5-2d8767465add
begin 
	q_iso(l)=(c_2 * (l+1)^d_2 + c_2) / d_2 
	q_isod(l) = c_2*(l+1)^(d_2-1)
	q_isoavg(l)=q_iso(l)/l
end;

# ╔═╡ d628f5ef-1d37-4fc2-8b18-d95e2bf1bfcd
begin
    qisograph = plot(
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
    plot!(lvec, q_iso.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   qisograph	
end

# ╔═╡ 4add0af1-c689-402a-909f-4601c4a828b7
md"Check derivative: $(@bind check_derivative5 CheckBox(default=false))"

# ╔═╡ f01f5b27-8da2-4018-9344-4ae03cb3014b
begin
    q_isomarginal = plot(
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
    plot!(lvec, q_isod.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_isoavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative5==true
		q_isodchk(l)=ForwardDiff.derivative(q_iso,l)
		plot!(lvec, q_isodchk.(lvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end
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

   q_isomarginal	
end

# ╔═╡ 8b56b99c-cda4-486b-81ca-92eedd571751
md"""
**Inverse Function**
"""

# ╔═╡ 42a218d2-6c0f-4e13-a6d1-450ee8b5351c
begin
	q_inverse(l) = c_2 - (c_2/(d_2*l+1))
	q_inversed(l) = c_2*d_2/(d_2*l+1)^2
	q_inverseavg(l) = q_inverse(l)/l
end;

# ╔═╡ 67f186a9-25d2-4ff1-8643-79db8067978f
begin
    q_inversegraph = plot(
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
    plot!(lvec, q_inverse.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

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

   q_inversegraph	
end

# ╔═╡ 08d8f250-ef1f-4bf5-8fba-85de33461f76
md"Check derivative: $(@bind check_derivative6 CheckBox(default=false))"

# ╔═╡ 679d54ed-bb3b-4d1e-bfbf-1c8f93c63d28
begin
    q_inversemarginal = plot(
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
    plot!(lvec, q_inversed.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, q_inverseavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative6 == true
		q_inversedchk(l) = ForwardDiff.derivative(q_inverse,l)
		plot!(lvec, q_inversedchk.(lvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end
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

   q_inversemarginal	
end

# ╔═╡ a5604bdd-f9c6-4b1a-99d6-2f2c9a60987e
md"""
Given all that we have learned from these previous sections we can now setup an example for the profits of a perfectly competitive firm where we assume that the only cost to production is the amount of hired labor. So this means that the specified profit formula is

$\begin{equation*}
  π(l) = p \cdot q(l) - w \cdot l 
\end{equation*}$
where p represents the price of the product set by the market, w represents the wage paid to employees and q(l) represents the amount of products produced by the employees. Here we will assume that that the production function is concave meaning that we can use the inverse function above as our production function. 
"""

# ╔═╡ 9c774d0b-0afc-40dc-aef5-aa1b4df08f77
p_exp =  @bind p_exp Slider(0.0:1.0:100.0, default=100, show_value=true) #price set by market

# ╔═╡ fbeba5e9-4097-43a7-a7c6-b048c34cb047
w_exp = @bind w_exp Slider(0.0:1.0:100.0, default=2.0, show_value=true) #wage set by the market

# ╔═╡ c218b534-a843-403a-b81f-9578f5440c4c
begin
π_exp(l)=p_exp * q_inverse(l) - w_exp * l #total profits
π_expd(l)=p_exp * q_inversed(l) - w_exp  #marginal profits
π_expavg(l)= π_exp(l)/l #average profits
end;

# ╔═╡ 258ec483-0c71-4195-b3ee-2e2827914cee
begin
    profitexptotal = plot(
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
    plot!(lvec, π_exp.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.2*maximum(π_exp.(lvec)))

	# Axis labels
    annotate!(1.02*xlims(profitexptotal)[2], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.01*ylims(profitexptotal)[2], text(L"π", :center, :bottom, 12))

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

   profitexptotal	
end

# ╔═╡ dab21043-a6e5-4215-aca3-b63f4717490a
md"Check derivative: $(@bind check_derivative7 CheckBox(default=false))"

# ╔═╡ 8a92a576-26a5-40e3-914b-94173e20ee0f
begin
    profitexpmarginal = plot(
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
    plot!(lvec, π_expd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(lvec, π_expavg.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	if check_derivative7 == true
		π_expdchk(l)=ForwardDiff.derivative(π_exp,l)
		plot!(lvec, π_expdchk.(lvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end

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

   profitexpmarginal	
end

# ╔═╡ 58ef175b-9b4a-4535-b1cb-0d15f0c28e7e
md"""
As will be shown later, A LOT of economics has to do with looking at where marginal benefits cross marginal costs. In this very simple example the benefits are the firms revenues and the costs are how much they pay in labor. We represent those seperately down below. 
"""

# ╔═╡ f2cda3ee-e9ae-49f2-b105-366e71b7985f
begin 
	R_exp(l) = p_exp * q_inverse(l) 
	C_exp(l) = w_exp * l 
	dR_exp(l) = p_exp * q_inversed(l)
	dC_exp(l) = w_exp
end;

# ╔═╡ 2f115d9a-2c08-4eeb-afe0-fa884c12d672
begin
    benefitvcosttotal = plot(
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
    plot!(lvec, R_exp.(lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(lvec, C_exp.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)
	plot!(lvec, π_exp.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis labels
    annotate!(1.02*1.05*lvec[end], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.01* 1.2*maximum(R_exp.(lvec)), text(L"π", :center, :bottom, 12))

	# Curve labels
    annotate!(7, 1.03*R_exp.(7), text(L"R(l)", :left, :bottom, 12))

	# Curve labels
    annotate!(7, 1.15*C_exp.(7), text(L"C(l)", :left, :bottom, 12))

	# Curve labels
    annotate!(7, 1.01*π_exp.(7), text(L"π(l)", :left, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.2*maximum(R_exp.(lvec)))
	
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

   benefitvcosttotal	
end

# ╔═╡ 973e22f9-af24-4557-af88-c7f2a334a197
md"""
In typical producer theory the firm is trying to maximize where the gap between total revenue and total costs is the largest because the distance between the two curves at a particular point represents the total profits. That maximum distance is going to be at the point where the derivative of the profit function is equivalent to zero. This point is referred to as the **first-order condition** for the profit function. It is also the point where the marginal revenue and marginal cost curves intersect as seen below. 
"""

# ╔═╡ c6a38e12-d496-471f-8d83-05f1de523bf9
begin
    benefitvcostmarginal = plot(
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
    plot!(lvec, dR_exp.(lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(lvec, dC_exp.(lvec), linecolor=:red, linestyle=:solid, linewidth=2)
	plot!(lvec, π_expd.(lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis labels
    annotate!(1.02*1.05*lvec[end], 0, text(L"l", :left, :center, 12))
    annotate!(0, 1.01* 1.2*maximum(dR_exp.(lvec)), text(L"π", :center, :bottom, 12))

	# Curve labels
    annotate!(3, 1.03*dR_exp.(3), text(L"dR(l)", :left, :bottom, 12))

	# Curve labels
    annotate!(7, 1.15*dC_exp.(7)-.5, text(L"dC(l)", :left, :bottom, 12))

	# Curve labels
    annotate!(.1, 1.01*π_expd.(2.5), text(L"dπ(l)", :left, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*lvec[end])
    ylims!(0, 1.2*maximum(dR_exp.(lvec)))
	
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

   benefitvcostmarginal
end

# ╔═╡ 9fa76c5a-4cdb-42a9-87b5-84a18ca63328
md"""
## Basic Demand and Supply
"""

# ╔═╡ 2685605b-6cdb-4b65-93b4-94002a6fd115
md"""
Above we had specifed how to find the amount of quantity supplied when given a certain price from the equation 

$\begin{equation*}
  Q_d(p) = α \cdot ℯ^{z \cdot p}
\end{equation*}$
which specified a nonlinear demand curve given a certain price. In that example we placed quantity demanded on the vertical axis while price was on the horizontal axis, but the convention in economics is to do the opposite. Additionally, given that we solved the price for a certain quantity demanded we can graph those values like we did for the asympototic values.
"""

# ╔═╡ cd620c71-e153-4768-a4a3-ed2f7d68cd05
Qt = @bind Qt Slider(0.0:1:100.0, default=50, show_value=true)

# ╔═╡ 97a8f59d-7a3d-42d0-a650-18de48db483d
md"""
Let $Qt$ represent the quantity actually demanded at a given point. Using the find_zero function of pluto we can solve this numerically using Pluto's ability without having to explicitly specify a "for" loop.
"""

# ╔═╡ 647f2e6d-54d5-43d5-931d-5bfcdc927940
function qd_qt(p)

# Define the zero condition at the parameter value supplied
cond(p) = Qd_1(p)-Qt

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 6b3f5451-3a5c-43dd-a012-7d9d71258bef
md"""
This find_zero function will run through all the different values of quantity demanded given different prices and will return the price value that is makes quantity demanded equivalent to the quantity actually demanded $Qt$.
"""

# ╔═╡ 2bdc5d80-f976-4a41-915a-04831ce353f5
begin
    demandqunatitygiven = plot(
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
    plot!(Qd_1.(p_1vec), p_1vec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
    plot!([Qt,Qt], [0,qd_qt(p_1vec)], linecolor=:black, linestyle=:dash) 
    plot!([0,Qt], [qd_qt(p_1vec),qd_qt(p_1vec)], linecolor=:black, linestyle=:dash)
    scatter!([Qt], [qd_qt(p_1vec)], markercolor=:black, markersize=5)

	# Axis limits
    xlims!(0,1.2*maximum(Qd_1.(p_1vec)))
    ylims!(0, 1.05*p_1vec[end])
    
    # Axis labels
    annotate!(1.02*xlims(demandqunatitygiven)[2], 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.01*ylims(demandqunatitygiven)[2], text(L"P", :center, :bottom, 12))

	 # Axis ticks
    xticks!([0.001, Qt], [L"0", L"Q^*"])
    yticks!([0.001, qd_qt(p_1vec) ], [L"0", L"P^*"])
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

   demandqunatitygiven	
end

# ╔═╡ 8636e6b3-15e1-4139-88ef-71b45e3224f1
md"""
We can see from the above graph that $Q^*$ represents $Qt$ and $p^*$ represents the corresponding price that generates from that quantity demanded. Find_zero will be a useful tools when trying to calculate equilibrium of different values.
"""

# ╔═╡ 71ff2a3b-ba9a-4d45-8b80-2101d22e0e64
md"""
Let's talk more about demand and supply and specify both a quantity demanded function and a quantity supplied function,

$\begin{align*}
  Q_d(p)&=24 \cdot ℯ^{-0.02 \cdot p} - 0.1 \cdot p \\
	Q_s(p)&= 3 + 0.6 \cdot p,
\end{align*}$
where we can use find_zero to find the market clearing price and quantity.
"""

# ╔═╡ 0f711c22-f9ff-4927-b1a6-4a335a4c0416
begin
qdexp(p) = 24*exp(-0.02*p) -.1*p #quantity demanded
qsexp(p) = 3 + 0.6*p #quantity supplied 
end;

# ╔═╡ 49551a5f-ad84-4108-b5ec-093b988077e8
function qd_qs(p) #will find market clearing price

# Define the zero condition at the parameter value supplied
cond(p) = qdexp(p)-qsexp(p)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ de3bbb9f-4fe1-4048-aeab-c01015721580
begin
    demandsupplyexp = plot(
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
    plot!(qdexp.(p_1vec), p_1vec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qsexp.(p_1vec), p_1vec, linecolor=:black, linestyle=:solid, linewidth=2)
	
	# Key points, with dashed lines to them
    plot!([qdexp.(qd_qs(p_1vec)),qdexp.(qd_qs(p_1vec))], [0,qd_qs(p_1vec)], linecolor=:black, linestyle=:dash) 
    plot!([0,qdexp.(qd_qs(p_1vec))], [qd_qs(p_1vec),qd_qs(p_1vec)], linecolor=:black, linestyle=:dash)
    scatter!([qdexp.(qd_qs(p_1vec))], [qd_qs(p_1vec)], markercolor=:black, markersize=5)
	
	 # Axis limits
    xlims!(0, 40)
    ylims!(0, 60)

	 # Axis labels
    annotate!(41, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 60.1, text(L"P", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, qdexp.(qd_qs(p_1vec))], [L"0", L"Q^*"])
    yticks!([0.001, qd_qs(p_1vec)], [L"0", L"P^*"])

	
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

   demandsupplyexp	
end

# ╔═╡ 8090c40b-f22d-4356-971f-a7b43e2d6363
md"""
Using the find_zero we can find this equilibrium for any two demand and supply curves so long as they intersect. 
"""

# ╔═╡ 9478c426-b20c-47f9-b370-5b54b5dd7451
md"""
In theoretical economics, usually a demand curve is going to be determined by two exogenous variables, price of the commodity and the income of the individual. Knowing this, we can construct a new demand curve

$\begin{equation*}
  Q_d(p,Y) = 6 \cdot ℯ^{-0.02 \cdot p} - 0.3 \cdot p + Y ,
\end{equation*}$
where $Y$ is income. Using this equation and the supply curve from above, we can generate three things
* a (Q,p)-space supply-demand graph that shows demand shifting in and out when you move a Y slider
* a (Y,p)-space graph that plots equilibrium price against a range of incomes from Ymin = 4 to Ymax = 24
* a (Y,Q)-space graph that plots equilibrium quantity against that same income range.

"""

# ╔═╡ 9bbab3df-e24d-4616-927b-664d860e9ec1
qdexp_Y(p,Y) = 6*exp(-0.02*p) -.3*p+Y;

# ╔═╡ 3245d492-1e42-4b0c-9623-25db741f5ad2
Y_1 = @bind Y_1 Slider(4:.1:24, default=10, show_value=true)

# ╔═╡ 7c5fbf7d-74c4-4341-9eaa-9baf14e668d2
function qdy_qs(p,Y)

# Define the zero condition at the parameter value supplied
cond(p) = qdexp_Y(p,Y) - qsexp(p)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ c1c44aca-737a-4aaf-af0e-671543521a9d
md"""
Example 1
"""

# ╔═╡ a5eb5e66-ec10-4585-baaa-bfbf248e814a
begin
    qdygraph1 = plot(
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
    plot!(qdexp_Y.(p_1vec,Y_1), p_1vec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qsexp.(p_1vec), p_1vec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0,40)
    ylims!(0, 60)

	# Key points, with dashed lines to them
    plot!([qsexp(qdy_qs(p_1vec,Y_1)),qsexp(qdy_qs(p_1vec,Y_1))], [0,qdy_qs(p_1vec,Y_1)], linecolor=:black, linestyle=:dash) 
    plot!([0,qsexp(qdy_qs(p_1vec,Y_1))], [qdy_qs(p_1vec,Y_1),qdy_qs(p_1vec,Y_1)], linecolor=:black, linestyle=:dash)
    scatter!([qsexp(qdy_qs(p_1vec,Y_1))], [qdy_qs(p_1vec,Y_1)], markercolor=:black, markersize=5)

	 # Axis labels
    annotate!(41, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 60.1, text(L"P", :center, :bottom, 12))

	 # Axis ticks
    xticks!([0.001, qsexp(qdy_qs(p_1vec,Y_1))], [L"0", L"Q^*"])
    yticks!([0.001, qdy_qs(p_1vec,Y_1)], [L"0", L"P^*"])
	
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

   qdygraph1	
end

# ╔═╡ 1e72ceb5-c4d0-4623-a7c0-0ea56e5a18d5
md"""
As we see above, this is generated using the find\_zero and slider where Y is treated like a paramter that we can adjust and the find_zero calculates the equilibrium between demand and supply and will adjust with the slider. 
"""

# ╔═╡ 2ecb4c84-9af2-4cd7-974a-8ca4e9981b49
begin
	Y_1min = 4
	Y_1max = 24
end;

# ╔═╡ 525269e4-fc79-4c10-b650-d50131a0cafe
Y_1vec=collect(range(Y_1min,Y_1max,length=101))

# ╔═╡ 19aa760d-98ca-4b09-8e00-2b585d7d2db5
function qdy_qs2(Y)

# Define the zero condition at the parameter value supplied
cond(p) = qdexp_Y(p,Y) - qsexp(p)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 23d569a6-5a38-47a0-b946-e08f96668feb
md"""
Example 2
"""

# ╔═╡ 3a91f8e7-c0b7-459f-8e31-aae2051ab6a9
begin
    Ypequilibrium = plot(
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
    plot!(Y_1vec, qdy_qs2.(Y_1vec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 30)
    ylims!(0, 30)

	 # Axis labels
    annotate!(31, 0, text(L"Y", :left, :center, 12))
    annotate!(0, 30.1, text(L"P^*", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, Y_1min,Y_1max], [L"0", L"\underbar{Y}",L"\bar{Y}"])
    yticks!([0.001], [L"0"])

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

   Ypequilibrium	
end

# ╔═╡ f72ebe41-4c09-457e-bff0-d5ec1ee67759
md"""
Specifying a vector for the possible values of Y, we can create another find_zero command to run that vector through the equilibrium equation

$\begin{equation*}
  Q_{d}(p,Y)-Q_s(p)=0
\end{equation*}$
to implicitly define the values of $p$ that would result in an equilibrium. We then plot those implicitly defined values.
"""

# ╔═╡ 47cbc95c-e6f3-44a3-8999-5f89ea344969
md"""
Example 3
"""

# ╔═╡ d9969865-9550-4b1a-9e5b-3a7e755305d2
begin
    yqexpgraph = plot(
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
    plot!(Y_1vec, qsexp.(qdy_qs2.(Y_1vec)), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 30)
    ylims!(0, 30)

	 # Axis labels
    annotate!(31, 0, text(L"Y", :left, :center, 12))
    annotate!(0, 30.1, text(L"Q^*", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, Y_1min,Y_1max], [L"0", L"\underbar{Y}",L"\bar{Y}"])
    yticks!([0.001], [L"0"])

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

   yqexpgraph	
end

# ╔═╡ 7d673aa1-c2e8-4796-8496-a3c33f01b108
md"""
Similar to what we did above, we can use those implicitly defined values of P and plug them back into either of our quantity demanded or quantity supplied functions to get the equilibrium quantity. We could plug it into either equation but I chose the quantity supplied because that is simpler to do.
"""

# ╔═╡ c865b5dd-4e3f-4def-8395-90e35e3ed76a
md"""
## Competitive Firms
"""

# ╔═╡ 7e7e5b4c-1886-4c23-97b0-535f70c4b366
md"""
In very simple models for firms in competitive markets, there is a single firm manager who has to decide how much output to produce in order to maximize profits for the firm. So in typical fashion the profit equation is 

$\begin{equation*}
  Profit=Revenue - Cost
\end{equation*}$
where revenue is modeled as being the number of goods sold multiplied by the price of the good,

$\begin{equation*}
  R=p \cdot q,
\end{equation*}$
while cost is modeled as just being a function of quantity produced,

$\begin{equation*}
  C=c(q).
\end{equation*}$
So the firm optimization problem can be modeled as

$\begin{equation*}
  \max_{π,R,C,q} π
\end{equation*}$
subject to 

$\begin{align*}
  π&=R-C \\
	R&=p \cdot q \\
	C&=c(q)
\end{align*}$
we have a system 4 endogenous variables and three constraint equations meaning we can substitute the constraint equations into the objective function to get the unconstrained problem, we will do this set-by-step

$\begin{equation*}
  \max_{R,C,q} π=R-C
\end{equation*}$
subject to 

$\begin{align*}
	R&=p \cdot q \\
	C&=c(q)
\end{align*}$
where we are still trying to maximize the objective variable π by the endogenous variables under the $\max$. Substituting in the final two endogenous variables leaves

$\begin{equation*}
  \max_{q} π=p \cdot q-c(q)
\end{equation*}$
which is an unconstrained problem.In order to solve this equation we must find the first-order condition which is

$\begin{equation*}
  \dfrac{dπ}{dq}=p-c'(q)=0
\end{equation*}$
where in order for this first-order conditin to specify a maximum then the second-order condition must hold

$\begin{equation*}
  \dfrac{d^2π}{dq^2}=-c''(q)<0. 
\end{equation*}$
We can define the first-order condition as one equation with two unknowns

$\begin{equation*}
 f(p,q)= p-c'(q)=0
\end{equation*}$
where by the implicit function theorem we can define any one unknown by the other, it makes most sense to define the endogenous variable $q$ in terms of the exogenous variable $p$ so that is what we will do,

$\begin{equation*}
  q^*=q^*(p).
\end{equation*}$
The value $q^*$ specifies a value of quantity produced given price which satisfies the first-order condition, in other words it specifies the optimal amount of quantity to produce given price. By the implicit function theorem we can derive the comparative static of the optimal quantity to produce given price by finding it's derivative. All the comparative static tells us is how change in the optimal quantity to produce will move with changes in price,

$\begin{equation*}
  \dfrac{dq^*}{dp}=-\dfrac{1}{-c''(q)}.
\end{equation*}$
A keen eye will notice that the denominator of this derivative is equivalent to the second-order condition which we specified had to be negative in order for the first-order condition to specify a maximum. Using this information we can sign the comparative static as

$\begin{equation*}
  \dfrac{dq^*}{dp}=-\dfrac{1}{\underbrace{-c''(q)}_{(-)}}>0,
\end{equation*}$
which implies that as price increases the optimal amount of quantity to produce will increase as well. We can substitute the implicitly defined quantity $q^*$ into the maximization problem 

$\begin{equation*}
  \max π^*(p)=p \cdot q^*(p) - c(q^*(p)),
\end{equation*}$
where by the envelope theorem we can derive the comparative static of change in profits with respect to change in the exogenous variable of price,

$\begin{equation*}
  \dfrac{dπ^*}{dp} = q^*(p) > 0,
\end{equation*}$

This comparative static implies that as price increases profits also increase.  
Below we will graph a number of different models of the firm problem and show how these aspects change with changes in the constraint equations.
"""

# ╔═╡ 3ce79c4a-8d7c-4e16-b27b-a7661fa211c0
md"""
In keeping with the simple model specified above, our cost equation will be

$\begin{equation*}
  C(q)=ℯ^{α \cdot q} -1
\end{equation*}$
where $α$ is a cost scaling parameter. The firm optimization problem then becomes 

$\begin{equation*}
  \max_{q} π= p \cdot q - ℯ^{α \cdot q} + 1
\end{equation*}$
"""

# ╔═╡ cfac0666-5cb0-4978-8392-d5ed608b440e
α = @bind α Slider(0.0:.001:.1, default=.05, show_value=true)

# ╔═╡ 4a16c3d0-4a34-4b1c-b633-638612d027d1
p = @bind p Slider(0.00:1:100, default=1.00, show_value=true)

# ╔═╡ 907557ce-089a-4230-b37e-73a1e1c2caf0
qvec=collect(range(0,100,length=101))

# ╔═╡ 39497ad9-fd2c-487d-9419-f1dbeccc81e5
begin
	π(q) =R(q) - C(q) ; #profit equation
	R(q) = p*q; #revenue equation
	C(q) = exp(α*q) - 1; #cost equation
#_______________________________________________________________________________#
	dπ(q) = dR(q) - dC(q) #profit equation derivative
	dR(q) = p #revenue equation derivative
	dC(q) = α*exp(α*q) #cost equation derivative
end;

# ╔═╡ bcbfb693-5bad-43c1-ace6-7355eeb8262f
function πfz(q)

# Define the zero condition at the parameter value supplied
cond(q) = dπ(q)

# Specify a starting guess
q0 = 20

# Find and return the solution
q = find_zero(cond, q0)

end;

# ╔═╡ fdfcc37d-3468-404c-981b-d819f5fd0d2d
begin
    firmprofitgraph = plot(
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
	plot!(qvec, π.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)
    plot!(qvec, R.(qvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, C.(qvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(R.(qvec)))

	 # Axis labels
    annotate!(1.02*xlims(firmprofitgraph)[2], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.01*ylims(firmprofitgraph)[2], text(L"$", :center, :bottom, 12))

	
    # Axis ticks
    xticks!([0.001, πfz(qvec)], [L"0", L"q^*"])
    yticks!([0.001, π(πfz(qvec)), R(πfz(qvec)), C(πfz(qvec))], [L"0", L"\pi(q^*)", L"R(q^*)", L"C(q^*)"])

	  # Key points, with dashed lines to them
    plot!([πfz(qvec),πfz(qvec)], [0,π(πfz(qvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,πfz(qvec)], [π(πfz(qvec)),π(πfz(qvec))], linecolor=:black, linestyle=:dash)
    scatter!([πfz(qvec)], [π(πfz(qvec))], markercolor=:black, markersize=5)

	plot!([πfz(qvec),πfz(qvec)], [0,R(πfz(qvec))], linecolor=:black, linestyle=:dash)
	 plot!([0,πfz(qvec)], [R(πfz(qvec)),R(πfz(qvec))], linecolor=:black, linestyle=:dash)
    scatter!([πfz(qvec)], [R(πfz(qvec))], markercolor=:black, markersize=5)

	 plot!([0,πfz(qvec)], [C(πfz(qvec)),C(πfz(qvec))], linecolor=:black, linestyle=:dash)
    scatter!([πfz(qvec)], [C(πfz(qvec))], markercolor=:black, markersize=5)
	
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

   firmprofitgraph	
end

# ╔═╡ 1b97eefb-fa4f-432d-8948-767bac16d5fc
begin
    firmprofitgraphmarginal = plot(
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
	plot!(qvec, dπ.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)
    plot!(qvec, dR.(qvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, dC.(qvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(dR.(qvec)))

	 # Axis labels
    annotate!(1.02*xlims(firmprofitgraphmarginal)[2], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.01*ylims(firmprofitgraphmarginal)[2], text(L"d$", :center, :bottom, 12))

	
    # Axis ticks
    xticks!([0.001, πfz(qvec)], [L"0", L"q^*"])
    yticks!([0.001,], [L"0"])

	
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

   firmprofitgraphmarginal	
end

# ╔═╡ dac8a6eb-5962-47f6-b592-21fcca32f027
md"""
The first order condition to the optimization problem is

$\begin{equation*}
  \dfrac{dπ}{dq} = p - α \cdot ℯ^{α \cdot q} = 0
\end{equation*}$
where we can implicitly define the $q$ as a function of $α$ and $p$,

$\begin{equation*}
  q^* = q^*(α,p).
\end{equation*}$
By the implict function theorem we can derive the comparative static for change in equilirbrium quantity with respect to change in price,

$\begin{equation*}
  \dfrac{dq^*}{dp} = - \dfrac{1}{-α^2 \cdot ℯ^{α \cdot q^*}},
\end{equation*}$
where the denominator is equivalent to the second-order condition 

$\begin{equation*}
   \dfrac{d^2π}{dq^2} = - α^2 \cdot ℯ^{α \cdot q}<0
\end{equation*}$
implying that it is strictly less than zero. This then implies that the comparative static of change in equilirbrium quantity with respect to change in price is positive,

$\begin{equation*}
   \dfrac{dq^*}{dp} > 0, 
\end{equation*}$
which is exactly what we derived for the general version. The comparative static for change in equilibrium quantity with respect to change in the cost scaling parameter $\alpha$ is

$\begin{equation*}
  \dfrac{dq^*}{dα} = - \dfrac{-[α \cdot q^*\cdot ℯ^{α \cdot q^*} +  ℯ^{α \cdot q}]}{-α^2 \cdot ℯ^{α \cdot q^*}} < 0. 
\end{equation*}$
We will graph those comparative statics below.
"""

# ╔═╡ 85aab2ca-2b4e-43e6-8bcb-8c1a195bfd60
begin #comparative statics
	dq_dp(α,q) =  (1/(α^2 * exp(α*q)))
	dq_dα(α,q) = -(α * q * exp(α * q)+ exp(α * q)) / (α^2 * exp(α*q)) 
end;

# ╔═╡ bd74a96a-a4c0-41c8-93d7-f6f8403f89cb
p_focvec = collect(range(0.1,100,length=200));

# ╔═╡ 34b4fa56-a35b-44ac-9264-dd7db794a427
α_focvec = collect(range(0.01, 1, length=200));

# ╔═╡ b414911f-2f04-4641-8898-75983c84bee7
function qstar(α,p)

# Define the zero condition at the parameter value supplied
cond(q) = p - α*exp(α*q) #foc

# Specify a starting guess
q0 = .1

# Find and return the solution
q = find_zero(cond, q0)

end;

# ╔═╡ 4898da4c-27e3-4877-bd6b-1c3ed7e196df
begin
    optq = plot(
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
    plot!(p_focvec, qstar.(α,p_focvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis labels
    annotate!(1.07*p_focvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.2*maximum(qstar.(α,p_focvec)), text(L"q^*", :center, :bottom, 12))

	 # Axis limits
    xlims!(0, 1.05*p_focvec[end])
    ylims!(0, 1.2*maximum(qstar.(α,p_focvec)))
    
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(50, qstar.(α,50)+10, text(L"q^*(α,p)", :left, :bottom, 12))

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

   optq	
end

# ╔═╡ 0b19f0b8-0e11-4fbf-9497-690815002a00
begin
    compstatqp = plot(
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
    plot!(p_focvec, dq_dp.(α,qstar.(α,p_focvec)), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	 # Curve labels
    annotate!(30, dq_dp(α,30), text(L"\dfrac{dq^*}{dp}", :left, :bottom, 18))

	# Axis labels
    annotate!(1.02*xlims(compstatqp)[2], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.01*ylims(compstatqp)[2], text(L"q^*", :center, :bottom, 12))

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

   compstatqp	
end

# ╔═╡ 6737c862-bd32-4504-b8b8-b17636c0f2e6
begin
    optqα = plot(
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
    plot!(α_focvec, qstar.(α_focvec,p), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis labels
    annotate!(1.07*α_focvec[end], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(qstar.(α_focvec,p)), text(L"q^*", :center, :bottom, 12))

	 # Axis limits
    xlims!(0, 1.05*α_focvec[end])
    ylims!(0, 1.2*maximum(qstar.(α_focvec,p)))
    
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(.5, qstar.(.5,p)+10, text(L"α^*(α,p)", :left, :bottom, 12))

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

   optqα
end

# ╔═╡ b9d99946-6f53-4bb5-b8ac-aa18b2275810
begin
    compstatqα = plot(
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
    plot!(α_focvec, dq_dα.(α,qstar.(α_focvec,p)), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*α_focvec[end])
    ylims!(-1000, 100)

	# Axis ticks
    xticks!([0.001], [L" "])
    yticks!([0.001], [L"0"])

	# Axis labels
    annotate!(1.07, 0, text(L"α", :left, :center, 12))
    annotate!(0, 101, text(L"q^*", :center, :bottom, 12))
	
	# Curve labels
	annotate!(.5, -400, text(L"\dfrac{dq^*}{dα}", :left, :bottom, 18))
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

   compstatqα	
end

# ╔═╡ 68c637bf-3df8-434e-beea-6f6a2b605018
md"""
The graphs show what we proved analystically. We can then reinsert the implictly defined $q^*$ back into the objective function to get

$\begin{equation*}
  π^*(α,p) = p \cdot q^*(α,p) - ℯ^{α \cdot q^*(α,p)} + 1
\end{equation*}$
with the following comparative statics using the envelope theorem,

$\begin{align*}
  \dfrac{dπ^*}{dα} &=  - q^*(α,p) \cdot ℯ^{α \cdot q^*(α,p)} < 0\\
	 \dfrac{dπ^*}{dp} &=  q^*(α,p) > 0
\end{align*}$
which show exactly what we proved analytically. Below we will graph the results.
"""

# ╔═╡ d12c72f6-c5e6-470c-a2a8-8432794f51b6
begin
π_star(α,p,q) = p * q - exp(α * q) + 1
dπ_starα(α,p,q) = -q * exp(α * q) 
dπ_starp(α,p,q) = q
end;

# ╔═╡ 02f68ec3-be16-4c35-b9ae-6c66bf7ac8c6
begin
    optpip = plot(
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
    plot!(p_focvec, π_star.(α, p_focvec, qstar.(α,p_focvec)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*p_focvec[end])
    ylims!(0, 1.2*maximum( π_star.(α, p_focvec, qstar.(α,p_focvec))))

    # Axis labels
    annotate!(1.02*xlims(optpip)[2], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.01*ylims(optpip)[2], text(L"π^*", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

    # Curve labels
    annotate!(50, π_star.(α, 50, qstar.(α,50))+2500, text(L"π^*(α,p)", :left, :bottom, 12))


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

   optpip	
end

# ╔═╡ e7f855c5-ac31-4821-ac02-a8b1daa60783
md"Check Comparative Static: $(@bind check_qstar CheckBox(default=false))"

# ╔═╡ 36d45ab0-0d4e-4d9b-a360-4f7415792122
begin
    doptpip = plot(
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
    plot!(p_focvec, dπ_starp.(α, p_focvec, qstar.(α,p_focvec)), linecolor=:black, linestyle=:solid, linewidth=2)

	if check_qstar == true
	 plot!(p_focvec, qstar.(α, p_focvec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end

	 # Axis limits
    xlims!(0, 1.05*p_focvec[end])
    ylims!(0, 1.2*maximum( dπ_starp.(α, p_focvec, qstar.(α,p_focvec))))

    # Axis labels
    annotate!(1.02*xlims(doptpip)[2], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.01*ylims(doptpip)[2], text(L"π^*", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

    # Curve labels
    annotate!(50, dπ_starp.(α, 50, qstar.(α,50)), text(L"\dfrac{dπ^*}{dp}", :left, :bottom, 18))


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

   doptpip	
end

# ╔═╡ a06042c0-3c17-4d9d-8178-1de1cff8623d
begin
    optpiα = plot(
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
    plot!(α_focvec, π_star.(α_focvec, p, qstar.(α_focvec,p)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*α_focvec[end])
    ylims!(0, 1.2*maximum( π_star.(α_focvec, p, qstar.(α_focvec,p))))

    # Axis labels
    annotate!(1.02*xlims(optpiα)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(optpiα)[2], text(L"π^*", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

    # Curve labels
    annotate!(.5, π_star.(.5, p, qstar.(.5,p)), text(L"π^*(α,p)", :left, :bottom, 12))


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

   optpiα
end

# ╔═╡ e9107f47-4306-4b0f-b434-0c0114be15c0
begin
    doptpiα = plot(
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
    plot!(α_focvec, dπ_starα.(α_focvec, p, qstar.(α_focvec,p)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*α_focvec[end])
    ylims!(-1.2*maximum( dπ_starp.(α_focvec, p, qstar.(α_focvec,p))), 1.2*maximum( dπ_starp.(α_focvec, p, qstar.(α_focvec,p))))

    # Axis labels
    annotate!(1.02*xlims(doptpiα)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(doptpiα)[2], text(L"π^*", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001], [L" "])
    yticks!([0.001], [L"0"])

    # Curve labels
    annotate!(.5, dπ_starα.(.5, p, qstar.(.5,p))-250, text(L"\dfrac{dπ^*}{dα}", :left, :bottom, 18))


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

   doptpiα
end

# ╔═╡ 6bcc5d3a-a4aa-455d-b227-401d74db6543
md"""
This concludes the full analysis for the perfectly competitive firm problem. 
"""

# ╔═╡ Cell order:
# ╠═3c3a7fc4-c20f-11ef-0aa8-79f8621f6c7d
# ╠═87a78e85-87b7-4e37-abf5-22f1d07c2758
# ╟─a9d2e981-e293-4647-b970-c9a4adba2d1e
# ╟─e3938a84-584b-477b-8cf0-44e55453c965
# ╟─142936b8-34c9-45a8-bed7-fad26e6987c1
# ╟─df123947-5e98-44b2-9852-0a49c15b390c
# ╠═682e8a03-e1e0-4f8e-8129-40d49fee06e3
# ╠═de0db303-aace-452b-8ddb-b6a21862d6e3
# ╠═fdfe51f5-fc3f-4d53-b6d7-c5bca394aa2c
# ╟─18fd9bfd-1356-4a7d-93a6-7b99ab8289bc
# ╠═13c46070-d67c-4417-81cb-27e87f62d8f2
# ╠═a9d02ae8-2758-48df-b17f-bde523bedaba
# ╠═e34f8010-2c8a-4eae-be6d-1dabefab45dd
# ╟─02e6b1d1-9a11-4efe-964f-56932f4bf0d9
# ╠═ac9a8e16-54da-4bfd-b27c-027035d37da7
# ╟─899d20bd-959a-43e4-89b7-337275e01274
# ╟─a0e5ea9f-b9eb-4314-94d9-e40345fbf4d4
# ╟─4a6293a9-c132-432c-bcee-329eac418329
# ╟─42a8b0cb-328b-4029-9fae-a8146ce70e45
# ╠═0707ae83-2f81-4805-9d3f-26cfaea761e1
# ╠═05406643-15d9-4542-855e-997fe3b5abb9
# ╠═39c79a65-eddc-4f24-88aa-77745509da3c
# ╟─b7dbfc12-61fa-408d-bff2-7047de4c44f9
# ╟─92a15fc5-ba1a-481e-b81a-184d2c849999
# ╠═846a0b5e-fae7-4358-bce3-42a2de3d3248
# ╠═876e8681-df7f-4791-81cc-260f65dbfb01
# ╠═7ec10c59-0fba-4081-9c4f-f572921b0d59
# ╠═d8f0947a-6096-4fe8-8249-a02942ad6c7b
# ╟─1ac82d8a-5ca7-43b0-8d42-f7c5b56f56ae
# ╟─e7a74f4f-157a-46bf-ab4f-98a41003e52e
# ╟─1cf6f061-1aed-4180-9951-773ef44dfcb8
# ╠═6479d242-e46e-4d4b-833f-a0f63b077d92
# ╠═208d60b2-8e28-4b88-8a55-b7433de33dca
# ╟─1d2ccdee-a16a-4100-adb3-d038e129197a
# ╟─55645ce3-9554-4680-ae23-826bae312942
# ╟─c13cd50a-35e6-4b04-a809-78c18a3be1da
# ╟─a33ca462-13f3-4ed9-be25-b4d2749148ae
# ╠═467b7d96-e403-4213-9f13-e1ce6b749799
# ╠═ccaf674b-92fb-4a6d-bcfd-2d21c7837923
# ╠═265df00a-f296-477d-92cb-bec66e5d9403
# ╠═01eef373-8f1d-407c-8be4-90c626b720df
# ╠═048b3788-1076-4ee9-959c-44f455108525
# ╠═7da981d8-8653-4257-8ec2-d848ccbc2ac9
# ╟─962e2aba-7f77-46b7-808c-16840460eda9
# ╟─9e930004-74cb-4bbe-8025-daed2466e8d5
# ╟─824d67fe-cd19-4df8-a374-38faf8d8ecb0
# ╠═e4a8b11d-cab6-4e1a-948f-2b91ea6e5eb4
# ╠═2d317809-b12b-4bf2-b6b7-8069309ba954
# ╠═1e0bfd42-81b7-4de0-9e40-cc9a48b84355
# ╟─c730f8d5-dfea-48d8-ba80-8b08866a5a35
# ╠═5b9ca874-d6f3-4712-8c45-c9df3cf65396
# ╠═45203b71-62e0-41d6-ac9d-d3c44ce38afd
# ╠═1b4f1470-2551-4978-bf70-3f57e33b7cab
# ╟─1f41f7bb-9140-4bac-991e-f3ce210b61bf
# ╟─f7ac776c-bd8b-426e-b416-5232623e5fa5
# ╟─128441d8-d0f6-42f0-8942-0654046429ba
# ╠═8e4dd5b9-1ded-49de-b66d-26d0ff42e0d0
# ╠═4d38db1b-8ad2-4536-be60-7bb977dad3c5
# ╠═2c899284-01ed-4d41-b8a9-45e46b422784
# ╠═a9a5f604-b147-4924-a414-d6e7a4100aa5
# ╠═e5307530-a4a9-4105-ad5c-d129eccc8839
# ╠═268fd40f-d467-4f24-9cd1-024e042ebf05
# ╟─8cac7656-f152-4438-ae19-34d707970da2
# ╟─71cd290f-52c0-4d9f-b18a-ed6ae8c8eaaf
# ╟─15158c45-4b09-4b3b-a466-bad174de6f19
# ╠═93798d2f-01ba-4c09-8990-72e0275a5dae
# ╠═77844849-42a0-4c85-bb6b-801988f8ee51
# ╠═9cb78948-f050-4cfe-9d02-c7296cbe3c51
# ╟─06a198fc-c062-473d-9213-b6457edfc905
# ╟─e3d363bd-b385-40d8-9471-31af8d04be7d
# ╟─0d75e712-395a-4ce6-beee-e8c2a5f26f9b
# ╟─4e4f7452-bb9f-49e4-b1e9-320221915960
# ╟─26c3be98-0f14-4a20-88ab-4d93e5314a99
# ╠═745703d1-8ce8-493d-bcbd-733ddf79c86c
# ╟─99c66e56-a9e8-4219-a9d9-2640ccd7104e
# ╟─d0442e6f-6be5-43e0-a01c-1990274b2a73
# ╟─7927392a-eeea-489e-8c54-71d15c0c6851
# ╟─b612449f-d7ee-4aab-893b-9d305f9f6288
# ╠═e35a05ac-584e-4b86-9907-b0af1309d895
# ╟─8f119c28-190a-4bd9-8a04-1982c426c701
# ╟─f324295b-1aef-4a1d-8842-f17f98184012
# ╟─93dbd900-1b3b-4bc9-bd63-a07489be0aa7
# ╟─1c235801-141b-4852-aeae-81d89bd5d823
# ╠═fe7220ae-af14-416c-b8b8-fe8a523bb517
# ╟─c28a7413-03a8-4352-8dfc-7cb0defa4961
# ╠═1eb3e454-e15a-4e3b-9f14-18b03e81dbbd
# ╟─1ec3205d-18b1-416c-9c76-28e4db1f17de
# ╟─600c8bd0-95ca-4402-9647-48261db2090f
# ╠═4905ddf1-f3a1-49dc-a8e5-2d8767465add
# ╠═e2999e0d-6f5c-4b53-bf7c-520dc448a766
# ╠═c6c5a122-44af-4122-8874-ed79e8f7287a
# ╟─d628f5ef-1d37-4fc2-8b18-d95e2bf1bfcd
# ╟─4add0af1-c689-402a-909f-4601c4a828b7
# ╟─f01f5b27-8da2-4018-9344-4ae03cb3014b
# ╟─8b56b99c-cda4-486b-81ca-92eedd571751
# ╠═42a218d2-6c0f-4e13-a6d1-450ee8b5351c
# ╟─67f186a9-25d2-4ff1-8643-79db8067978f
# ╟─08d8f250-ef1f-4bf5-8fba-85de33461f76
# ╟─679d54ed-bb3b-4d1e-bfbf-1c8f93c63d28
# ╟─a5604bdd-f9c6-4b1a-99d6-2f2c9a60987e
# ╠═9c774d0b-0afc-40dc-aef5-aa1b4df08f77
# ╠═fbeba5e9-4097-43a7-a7c6-b048c34cb047
# ╠═c218b534-a843-403a-b81f-9578f5440c4c
# ╟─258ec483-0c71-4195-b3ee-2e2827914cee
# ╟─dab21043-a6e5-4215-aca3-b63f4717490a
# ╟─8a92a576-26a5-40e3-914b-94173e20ee0f
# ╟─58ef175b-9b4a-4535-b1cb-0d15f0c28e7e
# ╠═f2cda3ee-e9ae-49f2-b105-366e71b7985f
# ╟─2f115d9a-2c08-4eeb-afe0-fa884c12d672
# ╟─973e22f9-af24-4557-af88-c7f2a334a197
# ╟─c6a38e12-d496-471f-8d83-05f1de523bf9
# ╟─9fa76c5a-4cdb-42a9-87b5-84a18ca63328
# ╟─2685605b-6cdb-4b65-93b4-94002a6fd115
# ╠═cd620c71-e153-4768-a4a3-ed2f7d68cd05
# ╟─97a8f59d-7a3d-42d0-a650-18de48db483d
# ╠═647f2e6d-54d5-43d5-931d-5bfcdc927940
# ╟─6b3f5451-3a5c-43dd-a012-7d9d71258bef
# ╟─2bdc5d80-f976-4a41-915a-04831ce353f5
# ╟─8636e6b3-15e1-4139-88ef-71b45e3224f1
# ╟─71ff2a3b-ba9a-4d45-8b80-2101d22e0e64
# ╠═0f711c22-f9ff-4927-b1a6-4a335a4c0416
# ╠═49551a5f-ad84-4108-b5ec-093b988077e8
# ╟─de3bbb9f-4fe1-4048-aeab-c01015721580
# ╟─8090c40b-f22d-4356-971f-a7b43e2d6363
# ╟─9478c426-b20c-47f9-b370-5b54b5dd7451
# ╠═9bbab3df-e24d-4616-927b-664d860e9ec1
# ╠═3245d492-1e42-4b0c-9623-25db741f5ad2
# ╠═7c5fbf7d-74c4-4341-9eaa-9baf14e668d2
# ╟─c1c44aca-737a-4aaf-af0e-671543521a9d
# ╟─a5eb5e66-ec10-4585-baaa-bfbf248e814a
# ╟─1e72ceb5-c4d0-4623-a7c0-0ea56e5a18d5
# ╠═2ecb4c84-9af2-4cd7-974a-8ca4e9981b49
# ╠═525269e4-fc79-4c10-b650-d50131a0cafe
# ╠═19aa760d-98ca-4b09-8e00-2b585d7d2db5
# ╟─23d569a6-5a38-47a0-b946-e08f96668feb
# ╟─3a91f8e7-c0b7-459f-8e31-aae2051ab6a9
# ╟─f72ebe41-4c09-457e-bff0-d5ec1ee67759
# ╟─47cbc95c-e6f3-44a3-8999-5f89ea344969
# ╟─d9969865-9550-4b1a-9e5b-3a7e755305d2
# ╟─7d673aa1-c2e8-4796-8496-a3c33f01b108
# ╟─c865b5dd-4e3f-4def-8395-90e35e3ed76a
# ╟─7e7e5b4c-1886-4c23-97b0-535f70c4b366
# ╟─3ce79c4a-8d7c-4e16-b27b-a7661fa211c0
# ╠═cfac0666-5cb0-4978-8392-d5ed608b440e
# ╠═4a16c3d0-4a34-4b1c-b633-638612d027d1
# ╠═907557ce-089a-4230-b37e-73a1e1c2caf0
# ╠═39497ad9-fd2c-487d-9419-f1dbeccc81e5
# ╠═bcbfb693-5bad-43c1-ace6-7355eeb8262f
# ╟─fdfcc37d-3468-404c-981b-d819f5fd0d2d
# ╟─1b97eefb-fa4f-432d-8948-767bac16d5fc
# ╟─dac8a6eb-5962-47f6-b592-21fcca32f027
# ╠═85aab2ca-2b4e-43e6-8bcb-8c1a195bfd60
# ╠═bd74a96a-a4c0-41c8-93d7-f6f8403f89cb
# ╠═34b4fa56-a35b-44ac-9264-dd7db794a427
# ╠═b414911f-2f04-4641-8898-75983c84bee7
# ╟─4898da4c-27e3-4877-bd6b-1c3ed7e196df
# ╟─0b19f0b8-0e11-4fbf-9497-690815002a00
# ╟─6737c862-bd32-4504-b8b8-b17636c0f2e6
# ╟─b9d99946-6f53-4bb5-b8ac-aa18b2275810
# ╟─68c637bf-3df8-434e-beea-6f6a2b605018
# ╠═d12c72f6-c5e6-470c-a2a8-8432794f51b6
# ╟─02f68ec3-be16-4c35-b9ae-6c66bf7ac8c6
# ╟─e7f855c5-ac31-4821-ac02-a8b1daa60783
# ╟─36d45ab0-0d4e-4d9b-a360-4f7415792122
# ╟─a06042c0-3c17-4d9d-8178-1de1cff8623d
# ╟─e9107f47-4306-4b0f-b434-0c0114be15c0
# ╟─6bcc5d3a-a4aa-455d-b227-401d74db6543
