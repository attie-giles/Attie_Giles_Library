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

# ╔═╡ ad3e3348-c890-11ef-1507-9388ec0fab89
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

# ╔═╡ c5f6b39c-e57c-4043-bff6-ace3745a5c23
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 290f7550-7d21-4849-baeb-57612785c7b9
md"""
# Micro Pluto Encyclopedia
"""

# ╔═╡ caf82c06-7ca4-429e-8486-7b083115fd9d
md"""
Deriving Market Conditions and Equilibrium
"""

# ╔═╡ b416796b-9c09-4a40-9a6b-7a12b12d731a
md"""
## Supply and Demand Curves
"""

# ╔═╡ f414370e-d3dc-4515-8c7f-298aff5ab761
md"""
Microeconomics can be understood as a system composed of both buyers and sellers in a market, where the buyers and the sellers are agents with assumed behaviors that effect and define the system. The set of assumed behaviors for both the buyers and sellers are as follows: buyers are agents preprogrammed with a set of indifference curves for items that are produced and then sold on a market that can be bought in combination according to both the preprogrammed sets of indifference curves and a budget constraint where the buyer seeks to optimize the amount of total utility given the indifference curves and budget constraint respectively. Sellers are preprogrammed to maximize the amount of profits for the goods that they produce and sell on the market. In a perfectly competitive market the parameters that influence both the revenues and costs for the producer is the price for the  commodity they are selling and the wage rate for the labor they are purchasing. For in a perfectly competitive market, both goods and labor these prices are set by the market and can be understood as given, similarly for the buyer whose income is a parameter that is said to be given. So the generalized set of behaviors for both the buyer and producer can be summarized mathematically as follows,

$\begin{equation*}
  Q_D=D(p,Y)
\end{equation*}$
and

$\begin{equation*}
  Q_S=S(p,w)
\end{equation*}$
Where $Q_D$ and $Q_S$ can be understood as the quantity demanded by consumers and the quantity supplied by producers, respectively. So, to take an example of what has been said above say that a consumer has the income of $Y$ and is looking to spend his entire income on a bundle of two products, $x_1$ and $x_2$, so that the equation describing his budget constraint is 

$\begin{equation*}
  Y = p_1x_1+p_2x_2.
\end{equation*}$
where $p_1$ and $p_2$ are the prices for the products of $x_1$ and $x_2$, respectively. So as we assumed above the incomes for the buyer and the prices for the goods on the market are exogeneous variables that cannot be changed and are essetially treated as parameters in the system. Additionally, the buyer will have some utility curve 

$\begin{equation*}
  U(x_1,x_2) = k
\end{equation*}$
which will form his indifference curves by taking a certain combination of both goods 1 and 2 and producing a certain level of utility $k$. The optimization problem the consumer is trying to solve is which combination of goods $x_1$ and $x_2$ will produce the highest level of utility given his budget constraint. 

A firm trying to maximize profits will operate under the following equation

$\begin{equation*}
  π=p \cdot q - w \cdot L
\end{equation*}$
where we assume that labor is the only cost to production. We say in the last section that if labor is the only cost to production we can model the firms optimization problem as

$\begin{equation*}
  π=p \cdot q(L) - w \cdot L
\end{equation*}$
or

$\begin{equation*}
  π=p \cdot q - w \cdot L(q)
\end{equation*}$
and they will give equivalent results. 

For the following model we will make many simplifying assumptions because we are not trying to discover anything or reinvent the wheel but only to show the basics of how this works. We will assume that the consumer is a rational agent looking to maximize his level of utility, $k$, and does so by consuming goods on the market. The consumer has two goods to choose from and has to choose how much of each good to consume in order to maximize his utility. The consumer has a budget of $Y$ dollars and is looking to spend all his money on those two goods. His budget $Y$ is exogenous and not affected by anything in the system. Additionally, the two goods will have prices attached to each which are exogenously chosen.  

In this model we will assume that there is a firm that produces both the goods and this firm is looking to maximize the level of profits for these goods. The firm sells these goods at their respective prices, but is constrained by the production of these goods which has a cost associated with it. To keep things simple we will assume that the only impact to production is the amount of hired labor and that the only cost to labor is the amount of wages the firm has to pay. The wage rate is exogenously chosen as well. 
"""

# ╔═╡ 3340f9c6-ed13-4c17-a66d-d5e724935923
md"""
### Indifference Curves
"""

# ╔═╡ 7fae38b0-1605-4c1c-8152-64b469677960
md"""
The consumer's utility curve will consist of a simple Cobb-Douglas utility curve

$\begin{equation*}
  U(x_1,x_2) = x_1^α \cdot x_2^{1-α}
\end{equation*}$
with some parameter of substitution $α$ which is less than or equal to 1. 

The first-order condition is

$\begin{align*}
  \dfrac{dU}{dx_1} &= α \cdot x_1^{α-1} \cdot \hat{x}_2(x_1)^{1-α} +  x_1^α \cdot (1-α)\cdot \hat{x}_2(x_1)^{-α} \cdot -\dfrac{p_1}{p_2}=0 \\
&= α \cdot x_1^{α-1} \cdot \hat{x}_2(x_1)^{1-α} -  x_1^α \cdot (1-α)\cdot \hat{x}_2(x_1)^{-α} \cdot \dfrac{p_1}{p_2}=0
\end{align*}$

"""

# ╔═╡ 999eadcf-f7b0-410a-a4b3-60d5058c5712
begin #parameters
	p1=15.0 #Initial good 1 price
	p2=20.0 #Initial good 2 price
end;

# ╔═╡ 0895e885-5255-46c9-a94f-63843c5be30b
x1vec = collect(range(.1,25,length=200));

# ╔═╡ 5231bce1-0a46-4fe5-94d5-8337e745b274
Y_1 = @bind Y_1 Slider(100.0:10.0:300.0, default=120.0, show_value=true)

# ╔═╡ 3ae04d3e-71c4-40c5-9c46-fc258acf499e
α = @bind α confirm(Slider(0.1:0.1:.7, default=0.2, show_value=true))

# ╔═╡ e54f8241-4f1a-4a46-a6a2-5ec3e929e89e
begin #Consumer Equations
	U(x1,x2) = x1^α * x2^(1-α) #Utility Equation
	Y(x1,x2,p1,p2) = p1*x1 + p2*x2 #Budget Constraint
#_______________________________________________________________________________#
	#First Derivative
	dU(x1,Y_c,p1,p2) = U_1(x1,Y_c,p1,p2) + U_2(x1,Y_c,p1,p2) * dx2(p1,p2) #derivative of Utility
	U_1(x1,Y_c,p1,p2) = α * x1^(α-1) * x2_hat(x1,Y_c,p1,p2)^(1-α) #argument 1 derivative
	U_2(x1,Y_c,p1,p2) = x1^α * (1-α) * x2_hat(x1,Y_c,p1,p2)^(-α) #argument 2 derivative
	dx2(p1,p2) = -(p1/p2) #implicit derivative of x2 wrt x1
#_______________________________________________________________________________#
	#Second Derivative
	dU2(Y_c,p1,p2) = U_11(Y_c,p1,p2) + 2 * U_12(Y_c,p1,p2) * dx2(p1,p2) + U_22(Y_c,p1,p2) * (dx2(p1,p2))^2 #Second derivative of Utility
	
	U_11(Y_c,p1,p2) = α * (α-1) * x1_star(Y_c,p1,p2)^(α-2) * x2_hat(x1_star(Y_c,p1,p2),Y_c,p1,p2)^(1-α) #argument 1 derivative of U_1
	
	U_12(Y_c,p1,p2) = α * x1_star(Y_c,p1,p2)^(α-1) * (1-α) * x2_hat(x1_star(Y_c,p1,p2),Y_c,p1,p2)^(-α) #argument 2 derivative of U_1
	
	U_22(Y_c,p1,p2) = x1_star(Y_c,p1,p2)^α * (1-α) * (-α) * x2_hat(x1_star(Y_c,p1,p2),Y_c,p1,p2)^(-α-1)#argument 2 derivative of U_2

end;

# ╔═╡ 945cdf30-d1ce-4091-94bd-45cd2e03c5f6
function x2_I(x1,k) #Plot x2 as a function of x1 and whatever arbitrary utility level chosen

# Define the zero condition at the parameter value supplied
cond(x2) = k - U(x1,x2)

# Specify a starting guess
x20 = .01

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ 9c64ddb8-505b-48fb-acaf-b0803fc8101a
function x2_hat(x1,Y_c,p1,p2) #Plot x2 as a function of x1 for the budget constraint

# Define the zero condition at the parameter value supplied
cond(x2) = Y_c-Y(x1,x2,p1,p2)

# Specify a starting guess
x20 = .1

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ 57088f85-a4ed-46dd-8d97-8b89adb92b96
function x1_star(Y_c,p1,p2) #Takes the foc and finds the x1 that satisfies it

# Define the zero condition at the parameter value supplied
cond(x1) = dU(x1,Y_c,p1,p2)

# Specify a starting guess
x10 = .1

# Find and return the solution
x1 = find_zero(cond, x10)

end;

# ╔═╡ eabae7ae-0f30-4ac9-ba02-ddaacd289459
function k_star(Y_c,p1,p2) #finds the k value that satisfies the foc and budget constraint, i.e finds the level of utility tangent with the budget constraint at its highest level

# Define the zero condition at the parameter value supplied
cond(k) = k - U(x1_star(Y_c,p1,p2),x2_hat(x1_star(Y_c,p1,p2),Y_c,p1,p2)) 

# Specify a starting guess
k0 = .1

# Find and return the solution
k = find_zero(cond, k0)

end;

# ╔═╡ b5fd56fd-9f52-41d2-9f3c-90dc48e70fb4
begin
    Indifferencecurve = plot(
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
    
    # Indifference Curves
	for k=2:1:10
    plot!(x1vec, x2_I.(x1vec,k), linecolor=:gray, linestyle=:solid, linewidth=1)
	end

	#Budget Constraint
	plot!(x1vec, x2_hat.(x1vec,Y_1,p1,p2), linecolor=:black, linestyle=:solid, linewidth=2)

	#Opt Indifference Curve
	plot!(x1vec, x2_I.(x1vec,k_star(Y_1,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 25)
    ylims!(0, 25)
    
    # Axis labels
    annotate!(25.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 25, text(L"x_2", :center, :bottom, 12))

	#arrow
	 plot!([20,20],[20,24], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([20,23],[20,20], arrow=(:closed, 2.0),linecolor=:black)

	# Axis ticks
    xticks!([0.001, x1_star(Y_1,p1,p2)], [L"0", L"x_1^*"])
    yticks!([0.001, x2_hat(x1_star(Y_1,p1,p2),Y_1,p1,p2)], [L"0", L"x_2^*"])

	# Key points, with dashed lines to them
    plot!([x1_star(Y_1,p1,p2),x1_star(Y_1,p1,p2)], [0,x2_hat(x1_star(Y_1,p1,p2),Y_1,p1,p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_star(Y_1,p1,p2)], [x2_hat(x1_star(Y_1,p1,p2),Y_1,p1,p2),x2_hat(x1_star(Y_1,p1,p2),Y_1,p1,p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_star(Y_1,p1,p2)], [x2_hat(x1_star(Y_1,p1,p2),Y_1,p1,p2)], markercolor=:black, markersize=5)

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   Indifferencecurve	
end

# ╔═╡ 23cd6788-da80-43cc-b741-fd1b5302e3a4
md"""
It is important to keep in mind that because we are assuming the agent is perfectly rational, he will constantly be adjusting the levels of consumption for both these goods based on the changing parameters like prices, income, and the parameter of substitution. 
"""

# ╔═╡ 0f1cbf74-d3ee-440e-a8bd-c8429be8146d
md"""
### Demand Curves
"""

# ╔═╡ d8f058b4-541c-42da-9edb-7a61c70e4231
begin #Consumer Market Equations
	D_1(Y_c,p1,p2)=x1_star(Y_c,p1,p2) #demand for good 1
	D_2(Y_c,p1,p2)=x2_hat(x1_star(Y_c,p1,p2),Y_c,p1,p2) #demand for good 2
	Q_D(Y_c,p) = D_1(Y_c,p,p2) + D_2(Y_c,p1,p) #total quantity demanded for both goods
#_______________________________________________________________________________#
	dQ_D(Y_c,p) =  dD_1(Y_c,p,p2) + dD_2(Y_c,p1,p) #derivative of total quantity demanded for both goods
	dD_1(Y_c,p1,p2) = -(U_2(x1_star(Y_c,p1,p2),Y_c,p1,p2)* (-1/p2)) / dU2(Y_c,p1,p2) #derivative of quantity demanded for good 1
	dD_2(Y_c,p1,p2) = - (U_2(x1_star(Y_c,p1,p2),Y_c,p1,p2) * (p1/p2^2)) / dU2(Y_c,p1,p2) #derivative of quantity demanded for good 2
end;

# ╔═╡ ffcffc0b-a555-4366-b69a-36210441401b
md"""
#### Demand Curves: Good 1 and Good 2
"""

# ╔═╡ aa53f9bc-e123-4195-bbde-27ef109d19c5
md"""
The demand curves for both goods is based upon what we did in the first graph where by the first-order condition were able to implicitly define the amount of good 1 the consumer will buy which then determines the consumption of good 2. These demand curves tell us how that level of consumption will change when prices change. The current level of consumption is a singular point on this line, but any other consumption could also be determined by looking at another point.
"""

# ╔═╡ 7f916c48-d8a9-4b01-bfea-4d224f813ac8
md"""
#### Total Quantity Demanded
"""

# ╔═╡ b1a5bbbb-5b6c-4532-aebd-47927ebd4a3e
md"""
Here we sum the two demand curves together to get a total quantity demanded curve which adds together both curves at their respective prices and produces this line. 
"""

# ╔═╡ 8b1a943d-3f36-49ae-9317-98ff8a0a995b
md"""
This is the derivative of the total quantity demanded curve with respect to price, we see that for all values of price it is negative because it is downward sloping.
"""

# ╔═╡ 7d87b441-f72a-4a25-854f-07fb715e14af
md"""
### Firm Curves
"""

# ╔═╡ 72196185-e4e6-428c-a263-f9c624e9acd2
md"""
The firms profit objective function is

$\begin{align*}
	π &= p \cdot q(L) - w \cdot L \\
   &= p \cdot L^{β} - w \cdot L
\end{align*}$
where $β$ is the productivity of workers and is strictl less than 1.

The first-order condition is

$\begin{align*} 
  \dfrac{dπ}{dL} &=  p \cdot dq(L) - w =0 \\
			&=  p \cdot β \cdot L^{β-1} - w =0
\end{align*}$
which implicitly defines $L$ as a function of p and w,

$\begin{equation*}
  L^*=L^*(p,w)
\end{equation*}$
"""

# ╔═╡ e20a5a04-dfe2-4d05-85eb-39d2a9ae22dc
Lvec = collect(range(0,40,length=101));

# ╔═╡ ec4b5cf1-383c-42a0-b7b1-38dd0810e3fb
begin #parameters
	p_c = p1 + p2
end;

# ╔═╡ 37cfb927-f156-47f0-9e89-2c3e42c4a6c8
pvec = collect(range(0.1, p_c*2 , length=100));

# ╔═╡ fb77774a-c9a0-4542-8f0d-c5dcc71c81a3
begin
    demandgood1 = plot(
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
    
    # Demand Curves
    plot!(D_1.(Y_1,pvec,p2), pvec, linecolor=:black, linestyle=:solid, linewidth=2) 	#good 1
	plot!(D_2.(Y_1,p1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2) #good 2

	# Axis limits
    xlims!(0, 30)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(31, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, D_1.(Y_1,p1,p2), D_2.(Y_1,p1,p2) ], [L"0", L"x_1^*", L"x_2^*"])
    yticks!([0.001, p1, p2], [L"0", L"p_1",L"p_2"])

	#label demand1
	annotate!(D_1.(Y_1,15,p2), 15, text(L"D_1", :left, :bottom, 12))

	#label demand2
	annotate!(D_2.(Y_1,p1,15), 15, text(L"D_2", :left, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([D_1.(Y_1,p1,p2),D_1.(Y_1,p1,p2)], [0,p1], linecolor=:black, linestyle=:dash) 
    plot!([0,D_1.(Y_1,p1,p2)], [p1,p1], linecolor=:black, linestyle=:dash)
    scatter!([D_1.(Y_1,p1,p2)], [p1], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([D_2.(Y_1,p1,p2),D_2.(Y_1,p1,p2)], [0,p2], linecolor=:black, linestyle=:dash) 
    plot!([0,D_2.(Y_1,p1,p2)], [p2,p2], linecolor=:black, linestyle=:dash)
    scatter!([D_2.(Y_1,p1,p2)], [p2], markercolor=:black, markersize=5)
	
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   demandgood1	
end

# ╔═╡ 61e8fdc6-acdf-49cb-9f30-41a35b5bfcec
begin
    dqdgraph = plot(
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
    plot!(dQ_D.(Y_1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-30, 10)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(11, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L" "])

	#label 
	annotate!(dQ_D.(Y_1,10)-3, 10, text(L"dQ_D", :left, :bottom, 12))

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   dqdgraph	
end

# ╔═╡ 08a835bb-940c-47de-8940-09f7cca5c02e
begin
    totalqd = plot(
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
    plot!(Q_D.(Y_1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)


	# Axis limits
    xlims!(0, 30)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(31, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, Q_D(Y_1,p_c)], [L"0", L"Q^*"])
    yticks!([0.001, p_c], [L"0", L"p"])

	#label 
	annotate!(Q_D.(Y_1,pvec[end]), pvec[end], text(L"Q_D", :left, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([Q_D(Y_1,p_c),Q_D(Y_1,p_c)], [0,p_c], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_D(Y_1,p_c)], [p_c,p_c], linecolor=:black, linestyle=:dash)
    scatter!([Q_D(Y_1,p_c)], [p_c], markercolor=:black, markersize=5)
	

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   totalqd	
end

# ╔═╡ 8a0c3384-8b0e-43b3-aa4d-187f46dfe176
β = @bind β confirm(Slider(0.0:0.05:1.0, default=0.75, show_value=true))

# ╔═╡ 17a38b81-23c1-447c-bab4-62b351a1694c
begin #Firm equations
	π(p,w,L) = R(p,L) - C(w,L) #profit equation
	R(p,L) = p * q(L) #revenue equation
	C(w,L) = w*L #cost equation
	q(L) = L^β #production equation
#_______________________________________________________________________________#
	dπ(p,w,L) = dR(p,L) - dC(w,L) #derivative of the profit equation
	dR(p,L) = p * dq(L) #derivative of the revenue equation
	dC(w,L) = w #derivative of the Cost equation
	dq(L) = β * L^(β-1) #derivative of the production function
#_______________________________________________________________________________#
	dq2(L) = β * (β-1) * L^(β-2) #second derivative of the production function
end;

# ╔═╡ 3b97d347-697f-4585-92a2-9cc87ec4508a
function L_opt(p,w) #returns optimal L that satisfies the firm foc

# Define the zero condition at the parameter value supplied
cond(L) = dπ(p,w,L)

# Specify a starting guess
L0 = .00000000000001

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ a44de180-1ace-4592-a02e-feb8c3702097
w = @bind w Slider(1.0:1.0:20.0, default=10.0, show_value=true)

# ╔═╡ 56117a64-b7bd-4fee-9391-3c99692dc17f
md"""
#### Firm Curves for Good 1
"""

# ╔═╡ b1d721c1-0d10-4989-ad45-f9513bcf87cc
begin
    good1firm = plot(
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
    plot!(Lvec, π.(p1,w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, R.(p1,Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,10)
    ylims!(0, 75)
    
    # Axis labels
    annotate!(10.2, 0, text(L"L_1", :left, :center, 12))
    annotate!(0, 75, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w),L_opt(p1,w)], [0,π.(p1,w,L_opt(p1,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w)], [π.(p1,w,L_opt(p1,w)),π.(p1,w,L_opt(p1,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w)], [π.(p1,w,L_opt(p1,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w),L_opt(p1,w)], [0,R.(p1,L_opt(p1,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w)], [R.(p1,L_opt(p1,w)),R.(p1,L_opt(p1,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w)], [R.(p1,L_opt(p1,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w),L_opt(p1,w)], [0,C.(w,L_opt(p1,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w)], [C.(w,L_opt(p1,w)),C.(w,L_opt(p1,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w)], [C.(w,L_opt(p1,w))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, L_opt(p1,w)], [L"0", L"L_1^*"])
    yticks!([0.001, π.(p1,w,L_opt(p1,w)), R.(p1,L_opt(p1,w)), C.(w,L_opt(p1,w))], [L"0", L"\pi(L_1^*)", L"R(L_1^*)", L"C(L_1^*)"])

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   good1firm	
end

# ╔═╡ 14a72152-033a-4e55-827f-0d1093382dcf
md"""
Like the consumer the firm is a rational agent responding to the exogenous variables like wage, price, and productivity of labor to decide how much labor to hire which then determines the level of profits.
"""

# ╔═╡ fb1f4b2d-31d4-440d-a4dc-3af87e514342
md"""
#### Firm Curves for Good 2
"""

# ╔═╡ 864aac88-cad4-4443-a0b5-3959c55699ad
begin
    good2firm = plot(
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
    plot!(Lvec, π.(p2,w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, R.(p2,Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,40)
    ylims!(0, 125)
    
    # Axis labels
    annotate!(41, 0, text(L"L_2", :left, :center, 12))
    annotate!(0, 125, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([L_opt(p2,w),L_opt(p2,w)], [0,π.(p2,w,L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p2,w)], [π.(p2,w,L_opt(p2,w)),π.(p2,w,L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p2,w)], [π.(p2,w,L_opt(p2,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p2,w),L_opt(p2,w)], [0,R.(p2,L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p2,w)], [R.(p2,L_opt(p2,w)),R.(p2,L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p2,w)], [R.(p2,L_opt(p2,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p2,w),L_opt(p2,w)], [0,C.(w,L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p2,w)], [C.(w,L_opt(p2,w)),C.(w,L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p2,w)], [C.(w,L_opt(p2,w))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, L_opt(p2,w)], [L"0", L"L_2^*"])
    yticks!([0.001, π.(p2,w,L_opt(p2,w)), R.(p2,L_opt(p2,w)), C.(w,L_opt(p2,w))], [L"0", L"\pi(L_2^*)", L"R(L_2^*)", L"C(L_2^*)"])

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   good2firm	
end

# ╔═╡ b12ebb11-b5bb-4e0e-8cce-9ec983ac9767
md"""
Same for the production of good two.
"""

# ╔═╡ 004336ee-57ba-4cb1-a382-fef591b92ecc
begin #firm curves for both goods
	π_c(p1,p2,w,L) = π(p1,w,L) + π(p2,w,L) #total profits
	R_c(p1,p2,L) = R(p1,L) + R(p2,L) #total revenue
	C_c(w,L) = 2*C(w,L) #total costs
#_______________________________________________________________________________#
	dπ_c(p1,p2,w,L) = dπ(p1,w,L) + dπ(p2,w,L) #derivative of total profits
	dR_c(p1,p2,L) = dR(p1,L) + dR(p2,L) #derivative of total revenue
	dC_c(w,L) = 2*dC(w,L) #derivative of total costs
end;

# ╔═╡ f85d29d2-6c0f-4170-9f7b-64678e1b1943
function Lc_opt(p1,p2,w) #returns optimal L that satisfies the firm foc

# Define the zero condition at the parameter value supplied
cond(L) = dπ_c(p1,p2,w,L)

# Specify a starting guess
L0 = .00000000000001

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 7fac2d8e-3844-43d2-aad3-3533e6a0333a
begin
    totalfirmcurve = plot(
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
    plot!(Lvec, π_c.(p1,p2,w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, R_c.(p1,p2,Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, C_c.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,20)
    ylims!(0, 250)
    
    # Axis labels
    annotate!(20.4, 0, text(L"L", :left, :center, 12))
    annotate!(0, 250, text(L"$", :center, :bottom, 12))

	#Optimal Total Profits
	# Key points, with dashed lines to them
    plot!([Lc_opt(p1,p2,w),Lc_opt(p1,p2,w)], [0,π_c.(p1,p2,w,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,Lc_opt(p1,p2,w)], [π_c.(p1,p2,w,Lc_opt(p1,p2,w)),π_c.(p1,p2,w,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([Lc_opt(p1,p2,w)], [π_c.(p1,p2,w,Lc_opt(p1,p2,w))], markercolor=:black, markersize=5)

	 # Key points, with dashed lines to them
    plot!([Lc_opt(p1,p2,w),Lc_opt(p1,p2,w)], [0,R_c.(p1,p2,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,Lc_opt(p1,p2,w)], [R_c.(p1,p2,Lc_opt(p1,p2,w)),R_c.(p1,p2,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([Lc_opt(p1,p2,w)], [R_c.(p1,p2,Lc_opt(p1,p2,w))], markercolor=:black, markersize=5)

	 # Key points, with dashed lines to them
    plot!([Lc_opt(p1,p2,w),Lc_opt(p1,p2,w)], [0,C_c.(w,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,Lc_opt(p1,p2,w)], [C_c.(w,Lc_opt(p1,p2,w)),C_c.(w,Lc_opt(p1,p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([Lc_opt(p1,p2,w)], [C_c.(w,Lc_opt(p1,p2,w))], markercolor=:black, markersize=5)

#_______________________________________________________________________________#
	#Actual total profits
	 # Key points, with dashed lines to them
    plot!([L_opt(p1,w) + L_opt(p2,w),L_opt(p1,w) + L_opt(p2,w)], [0,π_c(p1,p2,w,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w) + L_opt(p2,w)], [π_c(p1,p2,w,L_opt(p1,w) + L_opt(p2,w)),π_c(p1,p2,w,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w) + L_opt(p2,w)], [π_c(p1,p2,w,L_opt(p1,w) + L_opt(p2,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w) + L_opt(p2,w),L_opt(p1,w) + L_opt(p2,w)], [0,R_c.(p1,p2,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w) + L_opt(p2,w)], [R_c.(p1,p2,L_opt(p1,w) + L_opt(p2,w)),R_c.(p1,p2,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w) + L_opt(p2,w)], [R_c.(p1,p2,L_opt(p1,w) + L_opt(p2,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w) + L_opt(p2,w),L_opt(p1,w) + L_opt(p2,w)], [0,C_c.(w,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w) + L_opt(p2,w)], [C_c.(w,L_opt(p1,w) + L_opt(p2,w)),C_c.(w,L_opt(p1,w) + L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w) + L_opt(p2,w)], [C_c.(w,L_opt(p1,w) + L_opt(p2,w))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, L_opt(p1,w) + L_opt(p2,w), Lc_opt(p1,p2,w)], [L"0", L"L_1^*+L_2^*", L"L^*"])
    yticks!([0.001, π_c.(p1,p2,w,Lc_opt(p1,p2,w)),π_c(p1,p2,w,L_opt(p1,w) + L_opt(p2,w)),R_c.(p1,p2,Lc_opt(p1,p2,w)),R_c.(p1,p2,L_opt(p1,w) + L_opt(p2,w)),C_c.(w,Lc_opt(p1,p2,w)),C_c.(w,L_opt(p1,w) + L_opt(p2,w)) ], [L"0", L"\pi(L^*)", L"\pi(L_1^*)+\pi(L_2^*))",L"R(L^*)",L"R(L_1^*)+R(L_2^*)",L"C(L^*)",L"C(L_1^*)+C(L_2^*)" ])
	
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

   totalfirmcurve	
end

# ╔═╡ 2477b484-d7ea-4b5d-9453-b771db1580ac
md"""
Here we see the firm for both goods and see that from the entire firms point of view it is acting irrationally, this is due to the fact that in this model each individual section of the firm is looking to maxmize the amount of profits for its own good. This then leads to the entire firm not maximizing its profit levels. 
"""

# ╔═╡ 4813ba71-0ac3-437d-86c2-396750f05ffa
md"""
### Production and Supply Curves
"""

# ╔═╡ 2e2cfa26-eeeb-4bd6-8f99-46ebffae8a36
begin #firm market equation
	Q_S(p,w) = S_1(p,w) + S_2(p,w) #Total Quantity supplied
	S_1(p1,w)=q(L_opt(p1,w)) #Supply curve for good 1
	S_2(p2,w)=q(L_opt(p2,w)) #Supply curve for good 2
#_______________________________________________________________________________#
	dQ_S(p,w) = dS_1(p,w) + dS_1(p,w) #Derivative of the total quantity supplied 
	dS_1(p1,w) = dq(L_opt(p1,w)) * dL_dp(p1,w) #derivative of supply curve for good 1
	dS_2(p2,w) = dq(L_opt(p2,w)) * dL_dp(p2,w) #derivative of supply curve for good 2
	dL_dp(p,w) = - (dq(L_opt(p,w))/ p*dq2(L_opt(p,w))) #implicit derivative of Labor wrt price
end;

# ╔═╡ e6af1b58-88ae-4e07-99d3-7b2a77b72d30
md"""
#### Production of good 1 and good 2
"""

# ╔═╡ 85392183-d3b4-4d80-807f-7345abeb4318
begin
    productioncurve = plot(
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
    plot!(Lvec, q.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.2*maximum(q.(Lvec)))
    
    # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.212*maximum(q.(Lvec)), text(L"q", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, L_opt(p1,w), L_opt(p2,w)], [L"0", L"L_1^*", L"L_2^*"])
    yticks!([0.001, q(L_opt(p1,w)),q(L_opt(p2,w))], [L"0", L"q(L_1^*)", L"q(L_2^*)"])

	# Key points, with dashed lines to them
    plot!([L_opt(p1,w),L_opt(p1,w)], [0,q(L_opt(p1,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p1,w)], [q(L_opt(p1,w)),q(L_opt(p1,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p1,w)], [q(L_opt(p1,w))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L_opt(p2,w),L_opt(p2,w)], [0,q(L_opt(p2,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_opt(p2,w)], [q(L_opt(p2,w)),q(L_opt(p2,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_opt(p2,w)], [q(L_opt(p2,w))], markercolor=:black, markersize=5)

	annotate!(Lvec[end]-1, q.(Lvec[end]), text(L"q_1 \; & \; q_2", :left, :bottom, 12))
	
    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   productioncurve	
end

# ╔═╡ 4c16fc98-82fa-4cc1-9599-a801bb275ace
md"""
Here we see the production curve for both goods 1 and 2 where it is the same curve because producing the two goods does not require anything different. The only thing that changes is where along this line the two goods fall.
"""

# ╔═╡ e6498a57-098c-4550-88eb-07870452e5f8
md"""
#### Total Quantity Supplied
"""

# ╔═╡ 9001a602-1fa8-4f4f-b379-a9ffe2b44995
begin
    quantitysuppg1 = plot(
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
    plot!(Q_S.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
    plot!([Q_S.(p_c,w),Q_S.(p_c,w)], [0,p_c], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_S.(p_c,w)], [p_c,p_c], linecolor=:black, linestyle=:dash)
    scatter!([Q_S.(p_c,w)], [p_c], markercolor=:black, markersize=5)


	# Axis limits
    xlims!(0, maximum(Q_S.(pvec,w)))
    ylims!(0, pvec[end])
    
    # Axis labels
    annotate!(1.01*maximum(Q_S.(pvec,w)), 0, text(L"Q", :left, :center, 12))
    annotate!(0, pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, Q_S.(p_c,w)], [L"0", L"Q^*"])
    yticks!([0.001, p_c], [L"0", L"p^*"])

	annotate!(Q_S.(pvec[end],w), pvec[end], text(L"Q_S", :left, :bottom, 12))

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

   quantitysuppg1	
end

# ╔═╡ 2edf57ff-0d8f-4498-a3f3-6b6da687dffc
md"""
This curve represents the total quantity supplied curve that encompasses both goods. The $p^*$ represents the combined prices for both goods, $Q^*$ represents the quantity that would be produced at that combined price. This total quantity supplied essentially removes the details of individual products and acts as if the firm is just producing a singular product which is going to market. This approach loses the information for the consumption of the individual goods and it becomes impossible to see how those supplies affect the consumer.
"""

# ╔═╡ 9d98de91-52fc-4500-8985-28acd022762b
begin
    dqsgraph = plot(
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
    plot!(dQ_S.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 40)
    ylims!(0, pvec[end])

	# Axis labels
    annotate!(41, 0, text(L"Q", :left, :center, 12))
    annotate!(0, pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(dQ_S.(10,w)+2, 7, text(L"dQ_S", :left, :bottom, 12))

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

   dqsgraph	
end

# ╔═╡ 02f3f22d-b1ea-49f6-8a5b-8b4d70c98494
md"""
### Market Curves
"""

# ╔═╡ 3d3c49e3-c46e-4bae-a954-ffc57c0acf5d
md"""
#### Total Market
"""

# ╔═╡ da0082b9-380e-4e1d-bd05-61e1d4bb5b64
function P_star(Y_c,w) #Finds Price value that satisfies the total market equilibrium

# Define the zero condition at the parameter value supplied
cond(p) = Q_S(p,w) - Q_D(Y_c,p)

# Specify a starting guess
p0 = 500

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 9111ffd5-1478-4fc3-8455-2607bfd5eeb5
begin
    marketgeneral = plot(
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
    plot!(Q_S.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Q_D.(Y_1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 20)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(20.4, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([Q_S.(P_star(Y_1,w),w),Q_S.(P_star(Y_1,w),w)], [0,P_star(Y_1,w)], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_S.(P_star(Y_1,w),w)], [P_star(Y_1,w),P_star(Y_1,w)], linecolor=:black, linestyle=:dash)
    scatter!([Q_S.(P_star(Y_1,w),w)], [P_star(Y_1,w)], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, Q_S.(P_star(Y_1,w),w)], [L"0", L"Q^*"])
    yticks!([0.001, P_star(Y_1,w)], [L"0", L"P^*"])

	#QD
	annotate!(Q_D.(Y_1,pvec[end]), pvec[end], text(L"Q_D", :left, :bottom, 12))

	#QS
	annotate!(20, 23, text(L"Q_S", :left, :bottom, 12))

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

   marketgeneral	
end

# ╔═╡ 267917a3-0a62-4d97-85fa-bd6e9140d12b
md"""
Here we see the supply and demand curves for when both goods are combined and treated like singular good. This particulr representation does not provide much information about the individuals utility or firms profits following the assumptions made above, but is nonetheless interesting to see.
"""

# ╔═╡ d5ec33fe-b756-4fa2-90ad-5c43f67779d3
md"""
#### Good 1 Market
"""

# ╔═╡ 2e2133c0-2858-4937-9d27-d250971fb010
function p1_star(Y_c,w,p2) #Finds Price value that satisfies the good 1 market equilibrium

# Define the zero condition at the parameter value supplied
cond(p) = S_1(p,w) - D_1(Y_c,p,p2)

# Specify a starting guess
p0 = .1

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ cd3e778e-fc53-4a50-97ae-9fee1aa2e95a
begin
    marketgood1 = plot(
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
    plot!(D_1.(Y_1,pvec,p2), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(S_1.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 20)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(20.4, 0, text(L"Q_1", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p_1", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_1.(p1_star(Y_1,w,p2),w),S_1.(p1_star(Y_1,w,p2),w)], [0,p1_star(Y_1,w,p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1.(p1_star(Y_1,w,p2),w)], [p1_star(Y_1,w,p2),p1_star(Y_1,w,p2)], linecolor=:black, linestyle=:dash)
    scatter!([S_1.(p1_star(Y_1,w,p2),w)], [p1_star(Y_1,w,p2)], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, S_1.(p1_star(Y_1,w,p2),w)], [L"0", L"Q_1^*"])
    yticks!([0.001, p1_star(Y_1,w,p2)], [L"0", L"p_1^*"])

	#D1
	annotate!(D_1.(Y_1,pvec[end],p2), pvec[end], text(L"D_1", :left, :bottom, 12))

	#S1
	annotate!(20, 30, text(L"S_1", :left, :bottom, 12))

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

   marketgood1	
end

# ╔═╡ 670e6ba4-bb27-48d3-aea5-9f47a0bbc4d4
md"""
Here we see supply and demand curves for good 1, where the intersection represents the market clearing equilibrium.
"""

# ╔═╡ 77f6e8e0-e2e7-462f-bd0c-8b2c263b43be
md"""
#### Good 2 Market
"""

# ╔═╡ 6bcf11df-83a8-451b-b9dd-cfc74f3b6fed
function p2_star(Y_c,w,p1) #Finds Price value that satisfies the good 2 market equilibrium
 
# Define the zero condition at the parameter value supplied
cond(p) = S_2(p,w) - D_2(Y_c,p1,p)

# Specify a starting guess
p0 = .1

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 82ff45be-cc7a-4432-a4eb-6ec630c99dd6
begin
    marketgood2 = plot(
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
    plot!(D_2.(Y_1,p1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(S_2.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 20)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(20.4, 0, text(L"Q_2", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p_2", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_2.(p2_star(Y_1,w,p1),w),S_2.(p2_star(Y_1,w,p1),w)], [0,p2_star(Y_1,w,p1)], linecolor=:black, linestyle=:dash) 
    plot!([0,S_2.(p2_star(Y_1,w,p1),w)], [p2_star(Y_1,w,p1),p2_star(Y_1,w,p1)], linecolor=:black, linestyle=:dash)
    scatter!([S_2.(p2_star(Y_1,w,p1),w)], [p2_star(Y_1,w,p1)], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, S_2.(p2_star(Y_1,w,p1),w)], [L"0", L"Q_2^*"])
    yticks!([0.001, p2_star(Y_1,w,p1)], [L"0", L"p_2^*"])

	#D1
	annotate!(D_2.(Y_1,p1,pvec[end]), pvec[end], text(L"D_2", :left, :bottom, 12))

	#S1
	annotate!(20, 30, text(L"S_2", :left, :bottom, 12))

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

   marketgood2
end

# ╔═╡ 2e663c1e-cb5a-4159-8a3c-5873c1e22756
md"""
Similarly, the intersection of the curves represents the market clearing condition for good 2.
"""

# ╔═╡ 90a94476-b02f-4ba0-8b7b-6cde9c4a776d
md"""
#### Consumer Market Indifference Curve
"""

# ╔═╡ e6dcc8d9-da78-4831-92aa-0e2b8c5320fa
begin #Consumer market utility level
	k_m(Y_c,w,p1,p2) = U(D_1(Y_c,p1_star(Y_c,w,p2),p2),D_2(Y_c,p1,p2_star(Y_c,w,p1)))
end;

# ╔═╡ 4d4993b4-5dd4-41b1-9983-b84f04f3f87a
begin
    marketind = plot(
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
    for k=2:1:10
    plot!(x1vec, x2_I.(x1vec,k), linecolor=:gray, linestyle=:solid, linewidth=1)
	end

	#Budget Constraint
	plot!(x1vec, x2_hat.(x1vec,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)), linecolor=:black, linestyle=:solid, linewidth=2)

	#Opt Indifference Curve
	plot!(x1vec, x2_I.(x1vec,k_m(Y_1,w,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 15)
    ylims!(0, 15)
    
    # Axis labels
    annotate!(15.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 15, text(L"x_2", :center, :bottom, 12))

	#arrow
	 plot!([20,20],[20,24], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([20,23],[20,20], arrow=(:closed, 2.0),linecolor=:black)

	# Key points, with dashed lines to them
    plot!([D_1(Y_1,p1_star(Y_1,w,p2),p2),D_1(Y_1,p1_star(Y_1,w,p2),p2)], [0,D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1)),D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, D_1(Y_1,p1_star(Y_1,w,p2),p2)], [L"0", L"x_1^*"])
    yticks!([0.001,D_2(Y_1,p1,p2_star(Y_1,w,p1))], [L"0", L"x_2^*"])


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

   marketind	
end

# ╔═╡ 9cb688ad-ec69-4d07-8a8d-70334b1d387b
md"""
The above indifference curve represents the consumer's optimal consumption of goods 1 and 2 given the market equilibrium price for each.
"""

# ╔═╡ 6e797ac4-e182-402a-a3cf-dec7d13312e9
md"""
#### Firm Curves for Good 1
"""

# ╔═╡ 1006348c-41f2-4271-962a-766c53dd548f
function L_m1(Y_c,w,p2) #returns the optimal amount of labor to produce the market supply for good 1

# Define the zero condition at the parameter value supplied
cond(L) = S_1(p1_star(Y_c,w,p2),w) - q(L)

# Specify a starting guess
L0 = 1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 5a34431d-0085-478c-a700-a1442a4aa4f3
begin
    good1firmmarket = plot(
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
    plot!(q.(Lvec), π.(p1_star(Y_1,w,p2),w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), R.(p1_star(Y_1,w,p2),Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,8)
    ylims!(0, 75)
    
    # Axis labels
    annotate!(8.2, 0, text(L"q_1", :left, :center, 12))
    annotate!(0, 75, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2)),π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2)),R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,C.(w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [C.(w,L_m1(Y_1,w,p2)),C.(w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [C.(w,L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, S_1(p1_star(Y_1,w,p2),w)], [L"0", L"Q_1^*"])
    yticks!([0.001, π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2)) ,R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2)), C.(w,L_m1(Y_1,w,p2))], [L"0", L"\pi(Q_1^*)", L"R(Q_1^*)",L"C(Q_1^*)"])
	
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

   good1firmmarket	
end

# ╔═╡ 6bd1e84f-6abf-4970-a25d-7d189eeae9dc
md"""
Similarly this curve represents the firms optimal profits level at the market equilbrium price for good 1.
"""

# ╔═╡ 091d3f9d-5966-482a-8f76-1dcfe545c626
md"""
#### Firm Curves for Good 2
"""

# ╔═╡ f76a8b14-39b3-4ee9-a04f-9bdb8afdb94c
function L_m2(Y_c,w,p1) #returns the optimal amount of labor to produce the market supply for good 2

# Define the zero condition at the parameter value supplied
cond(L) = S_2(p2_star(Y_c,w,p1),w) - q(L)

# Specify a starting guess
L0 = 1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 84da7762-314a-4e7d-9e98-fea27acf73be
begin
    good2firmmarket = plot(
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
    plot!(q.(Lvec), π.(p2_star(Y_1,w,p1),w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), R.(p2_star(Y_1,w,p1),Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,15)
    ylims!(0, 115)
    
    # Axis labels
    annotate!(15.3, 0, text(L"q_2", :left, :center, 12))
    annotate!(0, 115, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1)),π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1)),R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,C.(w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [C.(w,L_m2(Y_1,w,p1)),C.(w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [C.(w,L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, q.(L_m2(Y_1,w,p1))], [L"0", L"Q_2^*"])
    yticks!([0.001, π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1)) ,R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1)), C.(w,L_m2(Y_1,w,p1))], [L"0", L"\pi(Q_2^*)", L"R(Q_2^*)",L"C(Q_2^*)"])

	
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

   good2firmmarket	
end

# ╔═╡ de2ec3ec-35a4-4429-8327-ab318d8b442b
md"""
Same for good 2.
"""

# ╔═╡ 7f3f9d8e-9cca-4dae-ae88-824e22102a53
begin #Market Firm
	π_m(Y_c,w,p1,p2) = π1_m(Y_c,w,p2) + π2_m(Y_c,w,p1) #total profit
	π1_m(Y_c,w,p2) = π(p1_star(Y_c,w,p2),w,L_m1(Y_c,w,p2)) #good 1 profit
	π2_m(Y_c,w,p1) = π(p2_star(Y_c,w,p1), w, L_m2(Y_c,w,p1)) #good 2 profit
end;

# ╔═╡ 3f7a20a1-e64c-46c3-9254-0c3afaf366c6
md"""
### The point of equilbrium
"""

# ╔═╡ 905ff211-afe7-4c1e-ae95-c6aaa597589d
md"""
#### Good 1
"""

# ╔═╡ a1a3c9f4-ec4d-4b5c-bd5e-5237e2a6515e
md"""
A central tenet of economics is that market equilbrums represent the point where no actor in the market, consumer or seller, can improve his position by by changing where to produce or buy.
"""

# ╔═╡ 906537b6-3141-45a3-9623-959c4ea5918e
function k_c(Q_1c,Y_c,p1,p2)

# Define the zero condition at the parameter value supplied
cond(k) = k - U(Q_1c,x2_hat(Q_1c,Y_c,p1_star(Y_c,w,p2),p2_star(Y_c,w,p1)))

# Specify a starting guess
k0 = .1

# Find and return the solution
k = find_zero(cond, k0)

end;

# ╔═╡ 94bae7ff-f814-427a-b70a-32463e3bdad1
function L_nonopt(Q_1c)

# Define the zero condition at the parameter value supplied
cond(L) = Q_1c - q(L)

# Specify a starting guess
L0 = 20

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ bb79b135-3bfe-48eb-8c51-264792553039
Q_1c = @bind Q_1c confirm(Slider(0.0:.1:8, default=5, show_value=true))

# ╔═╡ e9cdca26-79fe-445c-982b-c050ef3e2499
function p1_Q1c(Y_c,p2)

# Define the zero condition at the parameter value supplied
cond(p) = Q_1c - D_1(Y_c,p,p2)

# Specify a starting guess
p0 = .1

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 8bbd31cc-a52c-4344-8c58-47d53e03347f
function p1_Q1cs(w)

# Define the zero condition at the parameter value supplied
cond(p) = Q_1c - S_1(p,w)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 36dd967c-35f8-4fa3-87bc-80667ecda45e
begin
    marketgood1equil = plot(
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
    plot!(D_1.(Y_1,pvec,p2), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(S_1.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 20)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(20.4, 0, text(L"Q_1", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p_1", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_1.(p1_star(Y_1,w,p2),w),S_1.(p1_star(Y_1,w,p2),w)], [0,p1_star(Y_1,w,p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1.(p1_star(Y_1,w,p2),w)], [p1_star(Y_1,w,p2),p1_star(Y_1,w,p2)], linecolor=:black, linestyle=:dash)
    scatter!([S_1.(p1_star(Y_1,w,p2),w)], [p1_star(Y_1,w,p2)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([Q_1c,Q_1c], [0,p1_Q1c(Y_1,p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_1c], [p1_Q1c(Y_1,p2),p1_Q1c(Y_1,p2)], linecolor=:black, linestyle=:dash)
    scatter!([Q_1c], [p1_Q1c(Y_1,p2)], markercolor=:black, markersize=5)
	
	plot!([Q_1c,Q_1c], [0,p1_Q1cs(w)], linecolor=:black, linestyle=:dash)
	plot!([0,Q_1c], [p1_Q1cs(w),p1_Q1cs(w)], linecolor=:black, linestyle=:dash)
    scatter!([Q_1c], [p1_Q1cs(w)], markercolor=:black, markersize=5)
	

	# Axis ticks
    xticks!([0.001, S_1.(p1_star(Y_1,w,p2),w),Q_1c], [L"0", L"Q_1^*", L"Q_c"])
    yticks!([0.001, p1_star(Y_1,w,p2), p1_Q1c(Y_1,p2),p1_Q1cs(w)], [L"0", L"p_1^*",L"p_d", L"p_s"])

	#D1
	annotate!(D_1.(Y_1,pvec[end],p2), pvec[end], text(L"D_1", :left, :bottom, 12))

	#S1
	annotate!(20, 30, text(L"S_1", :left, :bottom, 12))

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

   marketgood1equil	
end

# ╔═╡ a57aea41-7c25-4b8a-840b-7acaff5f2c1d
begin
    marketindcoice = plot(
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
    for k=2:1:10
    plot!(x1vec, x2_I.(x1vec,k), linecolor=:gray, linestyle=:solid, linewidth=1)
	end

	#Budget Constraint
	plot!(x1vec, x2_hat.(x1vec,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)), linecolor=:black, linestyle=:solid, linewidth=2)

	#Opt Indifference Curve
	plot!(x1vec, x2_I.(x1vec,k_m(Y_1,w,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)

	#nonopt indifference Curve
	plot!(x1vec, x2_I.(x1vec,k_c(Q_1c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 15)
    ylims!(0, 15)
    
    # Axis labels
    annotate!(15.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 15, text(L"x_2", :center, :bottom, 12))

	#arrow
	 plot!([20,20],[20,24], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([20,23],[20,20], arrow=(:closed, 2.0),linecolor=:black)

	# Key points, with dashed lines to them
    plot!([D_1(Y_1,p1_star(Y_1,w,p2),p2),D_1(Y_1,p1_star(Y_1,w,p2),p2)], [0,D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1)),D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([Q_1c,Q_1c], [0,x2_hat.(Q_1c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_1c], [x2_hat.(Q_1c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)),x2_hat.(Q_1c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([Q_1c], [x2_hat.(Q_1c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, D_1(Y_1,p1_star(Y_1,w,p2),p2),Q_1c], [L"0", L"x_1^*", L"x_{1c}"])
    yticks!([0.001,D_2(Y_1,p1,p2_star(Y_1,w,p1)),x2_hat(Q_1c,Y_1,p1,p2)], [L"0", L"x_2^*",L"x_{2c}"])


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

   marketindcoice	
end

# ╔═╡ bfa1a5aa-0ff2-4655-a4a4-1efa398110bb
md"""
Here we see that the consumer is still looking to spend all of her budget meaning if he increases the amount of good 1 he consumes he will have to decrease the amount of good 2. Every change away from equilibrium moves him to lower indifference curves.
"""

# ╔═╡ c7486dad-1a15-4efc-8774-5d34290ddb9a
begin
    good1firmmarketchoice = plot(
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
    plot!(q.(Lvec), π.(p1_star(Y_1,w,p2),w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), R.(p1_star(Y_1,w,p2),Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,8)
    ylims!(0, 75)
    
    # Axis labels
    annotate!(8.2, 0, text(L"q_1", :left, :center, 12))
    annotate!(0, 75, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2)),π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2)),R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([S_1(p1_star(Y_1,w,p2),w),S_1(p1_star(Y_1,w,p2),w)], [0,C.(w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_1(p1_star(Y_1,w,p2),w)], [C.(w,L_m1(Y_1,w,p2)),C.(w,L_m1(Y_1,w,p2))], linecolor=:black, linestyle=:dash)
    scatter!([S_1(p1_star(Y_1,w,p2),w)], [C.(w,L_m1(Y_1,w,p2))], markercolor=:black, markersize=5)

	# Axis ticks
 xticks!([0.001, S_1(p1_star(Y_1,w,p2),w),Q_1c], [L"0", L"Q_1^*",L"Q_{1c}"])
    yticks!([0.001, π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2)) ,R.(p1_star(Y_1,w,p2),L_m1(Y_1,w,p2)), C.(w,L_m1(Y_1,w,p2)),π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c))], [L"0", L"\pi(Q_1^*)", L"R(Q_1^*)",L"C(Q_1^*)",L"\pi(Q_{1c})"])

	# Key points, with dashed lines to them
    plot!([Q_1c,Q_1c], [0,π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c))], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_1c], [π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c)),π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c))], linecolor=:black, linestyle=:dash)
    scatter!([Q_1c], [π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c))], markercolor=:black, markersize=5)
	
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

   good1firmmarketchoice	
end

# ╔═╡ 14ad550c-8030-4d1a-91cd-11cd1c811d49
md"""
Consumer's Optimal utility: $(round(k_m(Y_1,w,p1,p2),digits=2)) 

Firm's Optimal Profits for Good 1: \$$(round(π.(p1_star(Y_1,w,p2),w,L_m1(Y_1,w,p2)),digits=2))
"""

# ╔═╡ ac7e114e-279f-4e95-93a0-816a63bfd6a4
md"""
Consumer's new utility: $(round(k_c(Q_1c,Y_1,p1,p2),digits=2)) 

Firm's new Profits: \$$(round(π(p1_star(Y_1,w,p2),w,L_nonopt(Q_1c)),digits=2))
"""

# ╔═╡ b1d4a8ef-110d-4430-8b11-3070107e5868
md"""
In this example the price is fixed at the optimal price and we see that as consumer's and producers try to change their strategy by shifting the amount they make or purchase their overall utility or profits decreases.
"""

# ╔═╡ d77930c6-41c6-472d-bb09-aaa65d862e69
md"""
#### Good 2
"""

# ╔═╡ 521e732a-f746-4a40-b0d3-d240cd9aab92
function x1_hat(x2,Y_c,p1,p2) #Plot x1 as a function of x2 for the budget constraint

# Define the zero condition at the parameter value supplied
cond(x1) = Y_c-Y(x1,x2,p1,p2)

# Specify a starting guess
x10 = .1

# Find and return the solution
x1 = find_zero(cond, x10)

end;

# ╔═╡ 2bda6f62-38fc-4729-8744-b37bdcb2aa3d
function k_2c(Q_2c,Y_c,p1,p2)

# Define the zero condition at the parameter value supplied
cond(k) = k - U(x1_hat(Q_2c,Y_c,p1,p2),Q_2c)

# Specify a starting guess
k0 = .1

# Find and return the solution
k = find_zero(cond, k0)

end;

# ╔═╡ 93eec4d9-2d4b-42c4-812f-737565715181
Q_2c = @bind Q_2c confirm(Slider(0.0:.1:8, default=5, show_value=true))

# ╔═╡ ea03c5ce-afa6-44af-b341-cedd4e78e040
function p2_Q2c(Y_c,p1)

# Define the zero condition at the parameter value supplied
cond(p) = Q_2c - D_2(Y_c,p1,p)

# Specify a starting guess
p0 = .1

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ f1007291-9c51-4a57-a525-3341511a33c1
function p2_Q2cs(w)

# Define the zero condition at the parameter value supplied
cond(p) = Q_2c - S_2(p,w)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ a4a930fc-3794-4de3-8161-1321693e8553
begin
    marketgood2choice = plot(
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
    plot!(D_2.(Y_1,p1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(S_2.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 20)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(20.4, 0, text(L"Q_2", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p_2", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([S_2.(p2_star(Y_1,w,p1),w),S_2.(p2_star(Y_1,w,p1),w)], [0,p2_star(Y_1,w,p1)], linecolor=:black, linestyle=:dash) 
    plot!([0,S_2.(p2_star(Y_1,w,p1),w)], [p2_star(Y_1,w,p1),p2_star(Y_1,w,p1)], linecolor=:black, linestyle=:dash)
    scatter!([S_2.(p2_star(Y_1,w,p1),w)], [p2_star(Y_1,w,p1)], markercolor=:black, markersize=5)

	 # Key points, with dashed lines to them
    plot!([Q_2c,Q_2c], [0,p2_Q2c(Y_1,p1)], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_2c], [p2_Q2c(Y_1,p1),p2_Q2c(Y_1,p1)], linecolor=:black, linestyle=:dash)
    scatter!([Q_2c], [p2_Q2c(Y_1,p1)], markercolor=:black, markersize=5)

	 # Key points, with dashed lines to them
    plot!([Q_2c,Q_2c], [0,p2_Q2cs(w)], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_2c], [p2_Q2cs(w),p2_Q2cs(w)], linecolor=:black, linestyle=:dash)
    scatter!([Q_2c], [p2_Q2cs(w)], markercolor=:black, markersize=5)
	
	
	# Axis ticks
    xticks!([0.001, S_2.(p2_star(Y_1,w,p1),w),Q_2c], [L"0", L"Q_2^*",L"Q_{2c}"])
    yticks!([0.001, p2_star(Y_1,w,p1),p2_Q2c(Y_1,p1),p2_Q2cs(w)], [L"0", L"p_2^*",L"p_d", L"p_s"])

	#D1
	annotate!(D_2.(Y_1,p1,pvec[end]), pvec[end], text(L"D_2", :left, :bottom, 12))

	#S1
	annotate!(20, 30, text(L"S_2", :left, :bottom, 12))

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

   marketgood2choice
end

# ╔═╡ 7a49ebee-f2ae-4626-9ce6-af038783355f
begin
    marketindchoice2 = plot(
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
    for k=2:1:10
    plot!(x1vec, x2_I.(x1vec,k), linecolor=:gray, linestyle=:solid, linewidth=1)
	end

	#Budget Constraint
	plot!(x1vec, x2_hat.(x1vec,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)), linecolor=:black, linestyle=:solid, linewidth=2)

	#Opt Indifference Curve
	plot!(x1vec, x2_I.(x1vec,k_m(Y_1,w,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))), linecolor=:black, linestyle=:solid, linewidth=2)

	#nonopt indifference curve
	plot!(x1vec, x2_I.(x1vec,k_2c(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))), linecolor=:red, linestyle=:solid, linewidth=2)
	
	 # Axis limits
    xlims!(0, 15)
    ylims!(0, 15)
    
    # Axis labels
    annotate!(15.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 15, text(L"x_2", :center, :bottom, 12))

	#arrow
	 plot!([20,20],[20,24], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([20,23],[20,20], arrow=(:closed, 2.0),linecolor=:black)

	# Key points, with dashed lines to them
    plot!([D_1(Y_1,p1_star(Y_1,w,p2),p2),D_1(Y_1,p1_star(Y_1,w,p2),p2)], [0,D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1)),D_2(Y_1,p1,p2_star(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([D_1(Y_1,p1_star(Y_1,w,p2),p2)], [D_2(Y_1,p1,p2_star(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([x1_hat(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)),x1_hat(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], [0,Q_2c], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_hat(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], [Q_2c,Q_2c], linecolor=:black, linestyle=:dash)
    scatter!([x1_hat(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1))], [Q_2c], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, D_1(Y_1,p1_star(Y_1,w,p2),p2),x1_hat(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)) ], [L"0", L"x_1^*",L"x_{1c}"])
    yticks!([0.001,D_2(Y_1,p1,p2_star(Y_1,w,p1)),Q_2c], [L"0", L"x_2^*",L"x_{2c}"])


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

   marketindchoice2	
end

# ╔═╡ 10f6caca-938d-480e-9a34-c8d077c6c1d6
begin
    good2firmmarketchoice = plot(
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
    plot!(q.(Lvec), π.(p2_star(Y_1,w,p1),w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), R.(p2_star(Y_1,w,p1),Lvec), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(q.(Lvec), C.(w,Lvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0,15)
    ylims!(0, 115)
    
    # Axis labels
    annotate!(15.3, 0, text(L"q_2", :left, :center, 12))
    annotate!(0, 115, text(L"$", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1)),π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1)),R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q.(L_m2(Y_1,w,p1)),q.(L_m2(Y_1,w,p1))], [0,C.(w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash) 
    plot!([0,q.(L_m2(Y_1,w,p1))], [C.(w,L_m2(Y_1,w,p1)),C.(w,L_m2(Y_1,w,p1))], linecolor=:black, linestyle=:dash)
    scatter!([q.(L_m2(Y_1,w,p1))], [C.(w,L_m2(Y_1,w,p1))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, q.(L_m2(Y_1,w,p1)),Q_2c], [L"0", L"Q_2^*",L"Q_{2c}"])
    yticks!([0.001, π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1)) ,R.(p2_star(Y_1,w,p1),L_m2(Y_1,w,p1)), C.(w,L_m2(Y_1,w,p1)),π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c))], [L"0", L"\pi(Q_2^*)", L"R(Q_2^*)",L"C(Q_2^*)",L"\pi(Q_{2c})"])

	 # Key points, with dashed lines to them
    plot!([Q_2c,Q_2c], [0,π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c))], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_2c], [π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c)),π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c))], linecolor=:black, linestyle=:dash)
    scatter!([Q_2c], [π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c))], markercolor=:black, markersize=5)
	
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

   good2firmmarketchoice	
end

# ╔═╡ 4c1c294d-978a-4161-a92c-1754451d0af6
md"""
Consumer's Optimal utility: $(round(k_m(Y_1,w,p1,p2),digits=2)) 

Firm's Optimal Profits for Good 2: \$$(round(π.(p2_star(Y_1,w,p1),w,L_m2(Y_1,w,p1)),digits=2))
"""

# ╔═╡ c1fab261-f155-4c4d-81c0-8b1416aceb77
md"""
Consumer's new utility: $(round(k_2c(Q_2c,Y_1,p1_star(Y_1,w,p2),p2_star(Y_1,w,p1)),digits=2)) 

Firm's new Profits: \$$(round(π.(p2_star(Y_1,w,p1),w,L_nonopt(Q_2c)),digits=2))
"""

# ╔═╡ c24e0e66-52cf-42e9-8b9b-c1501e43bb15
md"""
#### Both Goods
"""

# ╔═╡ da9fa66a-a8ea-4462-8985-b12a8dae991f
begin #combined quantities
	S_c(Y_c,p1,p2,w) = S_2(p2_star(Y_c,w,p1),w) + S_1(p1_star(Y_c,w,p2),w)
end;

# ╔═╡ 09d33a97-7096-447a-880b-0e6cfb674421
begin
    totalmarketgraphfirm = plot(
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
    plot!(q.(Lvec), π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,Lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them
    plot!([Q_1c+Q_2c,Q_1c+Q_2c], [0,π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(Q_1c+Q_2c))], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_1c+Q_2c], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(Q_1c+Q_2c)),π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(Q_1c+Q_2c))], linecolor=:black, linestyle=:dash)
    scatter!([Q_1c+Q_2c], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(Q_1c+Q_2c))], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w)),q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))], [0,π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))))], linecolor=:black, linestyle=:dash) 
    plot!([0,q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w)))),π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))))], linecolor=:black, linestyle=:dash)
    scatter!([q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w))))], markercolor=:black, markersize=5)

	  # Key points, with dashed lines to them
    plot!([S_c(Y_1,p1,p2,w),S_c(Y_1,p1,p2,w)], [0,π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(S_c(Y_1,p1,p2,w)))], linecolor=:black, linestyle=:dash) 
    plot!([0,S_c(Y_1,p1,p2,w)], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(S_c(Y_1,p1,p2,w))),π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(S_c(Y_1,p1,p2,w)))], linecolor=:black, linestyle=:dash)
    scatter!([S_c(Y_1,p1,p2,w)], [π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(S_c(Y_1,p1,p2,w)))], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, S_c(Y_1,p1,p2,w),q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w)),Q_1c+Q_2c], [L"0", L"Q",L"Q^*",L"Q_c"])

	yticks!([0.001, π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(S_c(Y_1,p1,p2,w))) ,π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(q(Lc_opt(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w)))),π_c.(p1_star(Y_1,w,p2),p2_star(Y_1,w,p1),w,L_nonopt(Q_1c+Q_2c))], [L"0", L"\pi(Q)", L"\pi(Q^*)",L"\pi(Q_c)"])

	# Axis limits
    xlims!(0,20)
    ylims!(-100, 100)
    
    # Axis labels
    annotate!(20.4, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 100, text(L"$", :center, :bottom, 12))

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

   totalmarketgraphfirm	
end

# ╔═╡ 78b6c11b-3b67-4afb-a35f-4935ad97d10b
md"""
Here we see what we had described earlier. $Q$ represents the optimal production levels of good 1 and good 2 when each sector is looking to maximize profit for that one good; however, it is not the maximum profit possible for the firm. That level of profit comes from the $Q^*$ level of production which is less than $Q$. So the firm can actually increase it's total profits by changing the definition of rationality from each individual part of the firm trying to maximize it's own profits to the firm as a whole maximizing profits. However, this would also decrease the utility of the consumer as there would be less goods for purchase.
"""

# ╔═╡ 8cf3e8b3-9ef4-4dc3-88e3-6fdb6be5f66f
md"""
## Stability in Demand and Supply Curves
"""

# ╔═╡ 741a5c8a-7c38-4fff-9acc-9368cca80306
md"""
For a particular equilirbrium to be stable, no actor should be able to improve his payoff by changing his strategy. This is represented in the above strategy where any deviation from equilibrium results in the actors to lose either profits or utility. The equilibrium in the previous section is thus stable. For a demand and supply curve to produce a stable equilibrium 

$\begin{equation*}
  D_p < S_p
\end{equation*}$
meaning the partial derivative of demand with respect to price must be strictly less than the partial derivative of the supply curve with respect to price. We can see this from our previous result
"""

# ╔═╡ 15de9707-2dd1-47f1-8869-a8ef52265d52
begin
    stability = plot(
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
    plot!(dQ_D.(Y_1,pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	# Curves
    plot!(dQ_S.(pvec,w), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-30, 30)
    ylims!(0, 1.05*pvec[end])

	# Axis labels
    annotate!(31, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*pvec[end], text(L"p", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L" "])

	#label 
	annotate!(dQ_D.(Y_1,10)-4, 10, text(L"dQ_D", :left, :bottom, 12))
	#label 
	annotate!(dQ_D.(Y_1,10)+2, 10, text(L"dQ_S", :left, :bottom, 12))

    #=
    # Axis limits
    xlims!(0, 1.05*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Axis labels
    annotate!(1.071*xVec[end], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xVec)), text(L"y", :center, :bottom, 12))
  
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

   stability	
end

# ╔═╡ 7d56511f-483f-4971-b78b-39b07517b008
md"""
Above we have created the conditions to which a demand and supply curve would be derived for a normal market good under normal market conditions. We can also see how changing the exogenous variables that affect supply and demand change the equilibrium, like wage and income. Those equations were

$\begin{equation*}
  Q_D=D(p,Y).
\end{equation*}$
and

$\begin{equation*}
  Q_S=S(p,w)
\end{equation*}$
When we set these two equations equal to each we find the market clearing point,

$\begin{align*}
  Q_S&=Q_D\\
S(p,w)&=D(p,Y) .
\end{align*}$
Setting this equation equal to zero gives us,

$\begin{equation*}
  f(p,Y,w)=S(p,w)-D(p,Y)=0.
\end{equation*}$
Taking the implicit derivative of price with respect to income allows us to find how the price of the commodities changes for an infinitesimal amount of change in the income. The derivative in mathematical notation is

$\begin{align*}
  \dfrac{dp}{dY}&=-\dfrac{\dfrac{df}{dY}}{\dfrac{df}{dp}} \\
&= -\dfrac{-D_Y(p,Y)}{S_p(p,w)-D_p(p,Y)} \\
&=\dfrac{D_Y(p,Y)}{S_p(p,w)-D_p(p,Y)}.
\end{align*}$
In order to determine the correct sign for this function involves analyzing both the numerator and the denominator for their indidividual signs and determing from that what the sign for the entire derivative will be. A "normal" good in "normal" market conditions means that the slope of the demand curve with respect to price has to be less than the supply curve with respect to price, else the market equilibrium would be unstable. Mathematically this would mean

$\begin{equation*}
  D_p<S_P,
\end{equation*}$
which implies that 

$\begin{equation*}
  0<S_P-D_P.
\end{equation*}$
So we have determined that the denominator of this function is positive. To determine the sign of the numerator involves having to remember that one of the defintions for a "normal" market good is that as the income for an individual increases then demand for this good increases. So the numerator is positive. Mathematically this is

$\begin{equation*}
  0<D_Y
\end{equation*}$
So the numerator of this derivative is positive and the denominator is positive so the sign of this derivative is positive. Mathematically this would be

$\begin{equation*}
  \frac{dp}{dY}=\frac{D_Y(p,Y)}{S_P(p,w)-D_P(p,Y)}>0.
\end{equation*}$
This makes a fair amount of intuitive sesne based on the definitions for this model, where idividuals are purchasing "normal" goods, as their income increases they will spend more on "normal" goods, resulting in an increase in price for those goods. 

"""

# ╔═╡ 0aa7c6e7-0653-4649-9d4f-58a38c829191
md"""
Additionally we can derive the comparative statics for change in Quantity with respect to change in price because the equilibrium condition 

$\begin{equation*}
  f(p,Y,w) = S(p,w) - D(p,Y) = 0
\end{equation*}$
can be used to implicitly define p as a function of the two other exogenous variables

$\begin{equation*}
  p^*=p^*(w,Y)
\end{equation*}$
knowing this we can substitute that implicit definition to either of the demand or supply equations to get

$\begin{equation*}
Q_S =   S(p^*(w,Y),w)
\end{equation*}$
where the comparative static of change in quantity supplied with respect to change in income is 

$\begin{equation*}
  \dfrac{dQ}{dY} = S_{p^*}(p^*(w,Y),w) \cdot p^*_Y(w,Y).
\end{equation*}$
We can do the same thing for the amount of quantity demanded

$\begin{equation*}
  Q_D = D(p^*(Y),Y)
\end{equation*}$
where the comparative static with repect to income is

$\begin{equation*}
  \dfrac{dQ}{dY} = \underbrace{D_{p^*}(p^*(Y),Y) \cdot p^*_Y}_{\text{Indirect Effect}} + \underbrace{D_Y(p^*(Y),Y)}_{\text{Direct Effect}}
\end{equation*}$
where the direct effect is going to be positive because people buy more goods when there income goes up, but by buying more goods the price of the goods goes up meaning that people will buy less. So the direction of this comparative static is dependent on the magnitudes of each term.
"""

# ╔═╡ ab14322f-0bc4-45fb-b055-c4f2b23fe4a0
md"""
## Intepret Consumer First Order Condition
"""

# ╔═╡ bc3f5684-ac7d-42be-959b-32dee9ae369b
md"""
The Consumer First Order Condition is derived from a budget constraint function of two goods $x_1$ and $x_2$, for their given prices $p_1$ and $p_2$, respectively. This is represented mathematically as

$\begin{equation*}
  I(x_1,x_2)=p_1x_1+p_2x_2
\end{equation*}$
where $I$ is the total budget expenditure for those two goods. It is also represented by a Utility Function that individual is looking to opitmize, which is

$\begin{equation*}
  U(x_1,x_2)=x_1^{\alpha}x_2^{1-\alpha}.
\end{equation*}$
The consumer first order condition of Utility with respect to $x_1$ is

$\begin{equation*}
  \frac{dU}{dx_1}=U_1(x_1,\frac{I-p_1x_1}{p_2})-\frac{p_1}{p_2}U_2(x_1,\frac{I-p_1x_1}{p_2}).
\end{equation*}$
Where $U_1$ and $U_2$ represents the partial derivative of the Utility Function for $x_1$ and $x_2$ respectively. The interpretation of this function is that the individual receives an increasing amount of utility from infinitesimal inceases in purchasing $x_1$ holding purhcases of $x_2$ constant. However, the more the individual spends on good $x_1$ the less of their budget they have to spend on good $x_2$ which also increases their utility. Additionally this rate of decrease is proportional to price of good one over good two, so the more expensie good one is with respect to good two, the more potential utility is lost from consuming good two. 
"""

# ╔═╡ 83077c1a-4e0f-4f74-a1b3-0f557fc808e3
md"""
## Derive consumers' second-order condition
"""

# ╔═╡ 597dad0d-2504-4956-b735-005d8051d75c
md"""
This equation is derived from solving for the partial derivative in each part of the first order condition. So in general form this would look like

$\begin{equation*}
  \frac{d^2U}{dx_1^2}=U_{11}\frac{∂U_1}{∂x_1}+U_{12}\frac{∂U_2}{∂x_1}+U_{21}\frac{∂U_1}{∂x_1}+U_{22}\frac{∂U_2}{∂x_1}.
\end{equation*}$

The second order condition for the consumer optimization problem is
$\begin{equation*}
  \frac{d^2U}{dx_1^2}=U_{11}(x_1,\frac{I-p_1x_1}{p_2})-\frac{p_1}{p_2}U_{12}(x_1,\frac{I-p_1x_1}{p_2})-\frac{p_1}{p_2}U_{21}(x_1,\frac{I-p_1x_1}{p_2})+\frac{p^2_1}{p^2_2}U_{22}(x_1,\frac{I-p_1x_1}{p_2}).
\end{equation*}$
"""

# ╔═╡ 8c52c150-8b63-4da3-9c51-19eb5d5f1555
md"""
## Using NLsolve
"""

# ╔═╡ ec13eac3-5bad-477e-9f8f-e3eec74e2b31
md"""
Say we wanted to solve a three equation system for a market with the following conditions

$\begin{align*}
  Q_D&= D(p,Y) \\
	Q_S&=S(p) \\
 Q_D&=Q_S
\end{align*}$
those conditions can be changed to 

$\begin{align*}
 f &= D(p,Y)-Q_D=0 \\
 g&= S(p)-Q_S = 0\\
h&= Q_D-Q_S = 0
\end{align*}$
totally differentiating each of these equations 

$\begin{align*}
  df &= D_p(p,Y)dp+D_Y(p,Y)dY-dQ_D=0 \\
 dg&= S_p(p)dp-dQ_S = 0\\
dh&= dQ_D-dQ_S = 0
\end{align*}$
we could use Cramer's rule to solve the system of three equations, but we can also use NLsolve to solve it numerically
"""

# ╔═╡ 1516db25-e5bb-4952-be2d-6de8611b5d2f
begin #Example system
	Q_d(p,Y) = 6*exp(-0.02*p) - 0.3*p + Y
	Q_s(p) = -3 + 0.6*p
end;

# ╔═╡ 1627a007-6c60-4220-8278-5bd71440b2cc
function NL_ex(Y)
	
	function find_zeros(F, x, Y)

    	# Unpack the vector of endogenous variables to be solved for
    	Qd0 = x[1]
    	Qs0 = x[2]
		p=  x[3]

    	# Write out the conditions that must be zero at the solution
		# Demand
    	F[1] = Q_d(p,Y) - Qd0 

		# Supply
    	F[2] = Q_s(p) - Qs0

		#other
		F[3]= Qd0-Qs0
 		
	end

	# Specify a vector of starting guesses (note: must be floats!)
	Qd_0 = 12.0
	Qs_0 = 25.0
	p_0 = 25.0
	x0Vec = [Qd_0, Qs_0, p_0]

	# Find and return the solution
	sol = nlsolve((F, x) -> find_zeros(F, x, Y), x0Vec)

	return sol.zero
	
end;

#Followed by

# Functions implicitly defined by the conditions
#begin
#Qd_eq(Y)=NL_ex(Y)[1] #return equilibrium Quantity demanded
#Qs_eq(Y)=NL_ex(Y)[2] #return equilibrium Quantity supplied
#p_eq(Y)=NL_ex(Y)[3] #returns equilibrium price
#end;

# ╔═╡ 9cf4e31d-886b-4a0d-add7-2b4402b0fb82
begin # Functions implicitly defined by the conditions
	Qd_eq(Y)=NL_ex(Y)[1]
	Qs_eq(Y)=NL_ex(Y)[2]
	p_eq(Y)=NL_ex(Y)[3]
end;

# ╔═╡ ba79cb99-fefe-4491-beb7-8a6a904d832e
function p_e(Y)

# Define the zero condition at the parameter value supplied
cond(p) = Q_d(p,Y) - Q_s(p)

# Specify a starting guess
p0 = 20

# Find and return the solution
p = find_zero(cond, p0)

end;

# ╔═╡ 66afdd26-39e1-4ea8-be94-1d448f2e8da8
Y_e = @bind Y_e Slider(10.0:1.0:20.0, default=16.0, show_value=true)

# ╔═╡ 67ba5ae2-db7e-4379-b7d6-e183a803001d
md"""
**Results using Find_zero:**

equilibrium price: \$$(round( p_e(Y_e),digits=2))

equilibrium quantity: \$$(round(Q_s(p_e(Y_e)),digits=2))

**Results using NLsolve:**

equilibrium price: \$$(round(p_eq(Y_e),digits=2))

equilibrium quantity: \$$(round(Qs_eq(Y_e),digits=2))
"""

# ╔═╡ d04e1b6b-3d42-45a3-88bd-3d09a733adcd
begin
    example_graph = plot(
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
    plot!(Q_d.(pvec,Y_e), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Q_s.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them
    plot!([Q_d.(p_e(Y_e),Y_e),Q_d.(p_e(Y_e),Y_e)], [0,p_e(Y_e)], linecolor=:black, linestyle=:dash) 
    plot!([0,Q_d.(p_e(Y_e),Y_e)], [p_e(Y_e),p_e(Y_e)], linecolor=:black, linestyle=:dash)
    scatter!([Q_d.(p_e(Y_e),Y_e)], [p_e(Y_e)], markercolor=:black, markersize=5)

	 # Axis limits
    xlims!(0, 20)
    ylims!(0, pvec[end])
    
    # Axis labels
    annotate!(21, 0, text(L"Q", :left, :center, 12))
    annotate!(0, pvec[end], text(L"p", :center, :bottom, 12))
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

   example_graph	
end

# ╔═╡ 10c500e3-3c1b-4969-aa91-2bcbb02255c9
md"""
NLsolve essentially does what Find_zero can do in two steps. Instead of having to plug that Find_zero result back in it gives you both results.
"""

# ╔═╡ Cell order:
# ╠═ad3e3348-c890-11ef-1507-9388ec0fab89
# ╠═c5f6b39c-e57c-4043-bff6-ace3745a5c23
# ╟─290f7550-7d21-4849-baeb-57612785c7b9
# ╟─caf82c06-7ca4-429e-8486-7b083115fd9d
# ╟─b416796b-9c09-4a40-9a6b-7a12b12d731a
# ╟─f414370e-d3dc-4515-8c7f-298aff5ab761
# ╟─3340f9c6-ed13-4c17-a66d-d5e724935923
# ╟─7fae38b0-1605-4c1c-8152-64b469677960
# ╠═e54f8241-4f1a-4a46-a6a2-5ec3e929e89e
# ╠═999eadcf-f7b0-410a-a4b3-60d5058c5712
# ╠═0895e885-5255-46c9-a94f-63843c5be30b
# ╠═945cdf30-d1ce-4091-94bd-45cd2e03c5f6
# ╠═9c64ddb8-505b-48fb-acaf-b0803fc8101a
# ╠═57088f85-a4ed-46dd-8d97-8b89adb92b96
# ╠═eabae7ae-0f30-4ac9-ba02-ddaacd289459
# ╟─5231bce1-0a46-4fe5-94d5-8337e745b274
# ╠═3ae04d3e-71c4-40c5-9c46-fc258acf499e
# ╟─b5fd56fd-9f52-41d2-9f3c-90dc48e70fb4
# ╟─23cd6788-da80-43cc-b741-fd1b5302e3a4
# ╟─0f1cbf74-d3ee-440e-a8bd-c8429be8146d
# ╠═d8f058b4-541c-42da-9edb-7a61c70e4231
# ╠═37cfb927-f156-47f0-9e89-2c3e42c4a6c8
# ╟─ffcffc0b-a555-4366-b69a-36210441401b
# ╟─fb77774a-c9a0-4542-8f0d-c5dcc71c81a3
# ╟─aa53f9bc-e123-4195-bbde-27ef109d19c5
# ╟─7f916c48-d8a9-4b01-bfea-4d224f813ac8
# ╟─08a835bb-940c-47de-8940-09f7cca5c02e
# ╟─b1a5bbbb-5b6c-4532-aebd-47927ebd4a3e
# ╟─61e8fdc6-acdf-49cb-9f30-41a35b5bfcec
# ╟─8b1a943d-3f36-49ae-9317-98ff8a0a995b
# ╟─7d87b441-f72a-4a25-854f-07fb715e14af
# ╟─72196185-e4e6-428c-a263-f9c624e9acd2
# ╠═17a38b81-23c1-447c-bab4-62b351a1694c
# ╠═e20a5a04-dfe2-4d05-85eb-39d2a9ae22dc
# ╠═ec4b5cf1-383c-42a0-b7b1-38dd0810e3fb
# ╠═3b97d347-697f-4585-92a2-9cc87ec4508a
# ╠═8a0c3384-8b0e-43b3-aa4d-187f46dfe176
# ╟─a44de180-1ace-4592-a02e-feb8c3702097
# ╟─56117a64-b7bd-4fee-9391-3c99692dc17f
# ╟─b1d721c1-0d10-4989-ad45-f9513bcf87cc
# ╟─14a72152-033a-4e55-827f-0d1093382dcf
# ╟─fb1f4b2d-31d4-440d-a4dc-3af87e514342
# ╟─864aac88-cad4-4443-a0b5-3959c55699ad
# ╟─b12ebb11-b5bb-4e0e-8cce-9ec983ac9767
# ╠═004336ee-57ba-4cb1-a382-fef591b92ecc
# ╠═f85d29d2-6c0f-4170-9f7b-64678e1b1943
# ╟─7fac2d8e-3844-43d2-aad3-3533e6a0333a
# ╟─2477b484-d7ea-4b5d-9453-b771db1580ac
# ╟─4813ba71-0ac3-437d-86c2-396750f05ffa
# ╠═2e2cfa26-eeeb-4bd6-8f99-46ebffae8a36
# ╟─e6af1b58-88ae-4e07-99d3-7b2a77b72d30
# ╟─85392183-d3b4-4d80-807f-7345abeb4318
# ╟─4c16fc98-82fa-4cc1-9599-a801bb275ace
# ╟─e6498a57-098c-4550-88eb-07870452e5f8
# ╟─9001a602-1fa8-4f4f-b379-a9ffe2b44995
# ╟─2edf57ff-0d8f-4498-a3f3-6b6da687dffc
# ╟─9d98de91-52fc-4500-8985-28acd022762b
# ╟─02f3f22d-b1ea-49f6-8a5b-8b4d70c98494
# ╟─3d3c49e3-c46e-4bae-a954-ffc57c0acf5d
# ╠═da0082b9-380e-4e1d-bd05-61e1d4bb5b64
# ╟─9111ffd5-1478-4fc3-8455-2607bfd5eeb5
# ╟─267917a3-0a62-4d97-85fa-bd6e9140d12b
# ╟─d5ec33fe-b756-4fa2-90ad-5c43f67779d3
# ╠═2e2133c0-2858-4937-9d27-d250971fb010
# ╟─cd3e778e-fc53-4a50-97ae-9fee1aa2e95a
# ╟─670e6ba4-bb27-48d3-aea5-9f47a0bbc4d4
# ╟─77f6e8e0-e2e7-462f-bd0c-8b2c263b43be
# ╠═6bcf11df-83a8-451b-b9dd-cfc74f3b6fed
# ╟─82ff45be-cc7a-4432-a4eb-6ec630c99dd6
# ╟─2e663c1e-cb5a-4159-8a3c-5873c1e22756
# ╟─90a94476-b02f-4ba0-8b7b-6cde9c4a776d
# ╠═e6dcc8d9-da78-4831-92aa-0e2b8c5320fa
# ╟─4d4993b4-5dd4-41b1-9983-b84f04f3f87a
# ╟─9cb688ad-ec69-4d07-8a8d-70334b1d387b
# ╟─6e797ac4-e182-402a-a3cf-dec7d13312e9
# ╠═1006348c-41f2-4271-962a-766c53dd548f
# ╟─5a34431d-0085-478c-a700-a1442a4aa4f3
# ╟─6bd1e84f-6abf-4970-a25d-7d189eeae9dc
# ╟─091d3f9d-5966-482a-8f76-1dcfe545c626
# ╠═f76a8b14-39b3-4ee9-a04f-9bdb8afdb94c
# ╟─84da7762-314a-4e7d-9e98-fea27acf73be
# ╟─de2ec3ec-35a4-4429-8327-ab318d8b442b
# ╠═7f3f9d8e-9cca-4dae-ae88-824e22102a53
# ╟─3f7a20a1-e64c-46c3-9254-0c3afaf366c6
# ╟─905ff211-afe7-4c1e-ae95-c6aaa597589d
# ╟─a1a3c9f4-ec4d-4b5c-bd5e-5237e2a6515e
# ╠═e9cdca26-79fe-445c-982b-c050ef3e2499
# ╠═8bbd31cc-a52c-4344-8c58-47d53e03347f
# ╠═906537b6-3141-45a3-9623-959c4ea5918e
# ╠═94bae7ff-f814-427a-b70a-32463e3bdad1
# ╠═bb79b135-3bfe-48eb-8c51-264792553039
# ╟─36dd967c-35f8-4fa3-87bc-80667ecda45e
# ╟─a57aea41-7c25-4b8a-840b-7acaff5f2c1d
# ╟─bfa1a5aa-0ff2-4655-a4a4-1efa398110bb
# ╟─c7486dad-1a15-4efc-8774-5d34290ddb9a
# ╟─14ad550c-8030-4d1a-91cd-11cd1c811d49
# ╟─ac7e114e-279f-4e95-93a0-816a63bfd6a4
# ╟─b1d4a8ef-110d-4430-8b11-3070107e5868
# ╟─d77930c6-41c6-472d-bb09-aaa65d862e69
# ╠═ea03c5ce-afa6-44af-b341-cedd4e78e040
# ╠═f1007291-9c51-4a57-a525-3341511a33c1
# ╠═521e732a-f746-4a40-b0d3-d240cd9aab92
# ╠═2bda6f62-38fc-4729-8744-b37bdcb2aa3d
# ╠═93eec4d9-2d4b-42c4-812f-737565715181
# ╟─a4a930fc-3794-4de3-8161-1321693e8553
# ╟─7a49ebee-f2ae-4626-9ce6-af038783355f
# ╟─10f6caca-938d-480e-9a34-c8d077c6c1d6
# ╟─4c1c294d-978a-4161-a92c-1754451d0af6
# ╟─c1fab261-f155-4c4d-81c0-8b1416aceb77
# ╟─c24e0e66-52cf-42e9-8b9b-c1501e43bb15
# ╠═da9fa66a-a8ea-4462-8985-b12a8dae991f
# ╟─09d33a97-7096-447a-880b-0e6cfb674421
# ╟─78b6c11b-3b67-4afb-a35f-4935ad97d10b
# ╟─8cf3e8b3-9ef4-4dc3-88e3-6fdb6be5f66f
# ╟─741a5c8a-7c38-4fff-9acc-9368cca80306
# ╟─15de9707-2dd1-47f1-8869-a8ef52265d52
# ╟─7d56511f-483f-4971-b78b-39b07517b008
# ╟─0aa7c6e7-0653-4649-9d4f-58a38c829191
# ╟─ab14322f-0bc4-45fb-b055-c4f2b23fe4a0
# ╟─bc3f5684-ac7d-42be-959b-32dee9ae369b
# ╟─83077c1a-4e0f-4f74-a1b3-0f557fc808e3
# ╟─597dad0d-2504-4956-b735-005d8051d75c
# ╟─8c52c150-8b63-4da3-9c51-19eb5d5f1555
# ╟─ec13eac3-5bad-477e-9f8f-e3eec74e2b31
# ╠═1516db25-e5bb-4952-be2d-6de8611b5d2f
# ╠═1627a007-6c60-4220-8278-5bd71440b2cc
# ╠═9cf4e31d-886b-4a0d-add7-2b4402b0fb82
# ╠═ba79cb99-fefe-4491-beb7-8a6a904d832e
# ╠═66afdd26-39e1-4ea8-be94-1d448f2e8da8
# ╟─67ba5ae2-db7e-4379-b7d6-e183a803001d
# ╟─d04e1b6b-3d42-45a3-88bd-3d09a733adcd
# ╟─10c500e3-3c1b-4969-aa91-2bcbb02255c9
