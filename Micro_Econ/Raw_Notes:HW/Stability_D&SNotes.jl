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

# ╔═╡ 3273be14-6a31-11ef-350f-fb50a09e4afd
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 54e98f08-514f-49b2-847c-c342e7945e12
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 4763180e-32cb-48bb-b902-866ff6c15b9c
md"""
# Supply and Demand Curves
"""

# ╔═╡ 4d0955ff-1b27-479f-acd7-a7afa6fb9889
md"""
## Base Conditions
"""

# ╔═╡ 43901f31-f4f6-44fe-9168-cc133d08854a
md"""
Microeconomics can be understood as a complex system composed of both buyers and sellers in a market, where the buyers and the sellers are agents with assumed behaviors that evolve the state the of system over time. The set of assumed behaviors for both the buyers and sellers are as follows: buyers are agents preprogrammed with a set of indifference curves for items that are produced and then sold on a market that can be bought in combination according to both the preprogrammed sets of indifference curves and a utility curve that seeks to optimize the amount of total utility for the buyer given the indifference curves and income respectively, and sellers are preprogrammed to maximize the amount of profits for the goods that they produce and sell on the market. In a perfectly competitive market the parameters that influence both the revenues and costs for the producer is the price for the  commodity they are selling and the wage rate for the labor they are purchasing. For in a perfectly competitive market for both goods and labor these prices are set by the market and can be understood as given, similarly for the buyer whose income is a parameter that is said to be given. So the generalized the set of behaviors for both the buyer and producer can be summarized mathematically as follows,

$\begin{equation*}
  Q_D=D(P,Y)
\end{equation*}$
and

$\begin{equation*}
  Q_S=S(P)
\end{equation*}$
Where $Q_D$ and $Q_S$ can be undesood as the quantity demanded by consumers and the qauntity supplied by producers, respectfully. So to take an example of what has been said above say that a consumer has the income of $Y$ and is looking to spend his entire income on a bundle of two products, $x_1$ and $x_2$, so that the equation describing his indifference curve is 

$\begin{equation*}
  Y = p_1x_1+p_2x_2.
\end{equation*}$
where $p_1$ and $p_2$ are the prices for the products of $x_1$ and $x_2$ respectully. So as we assumed above the incomes for the buyer and the prices for the goods on the market are exogeneous variables that cannot be changed and are essetially treated as parameters in the system. So below I will give an example graphically of an indifference curve for products $x_1$ and $x_2$, given a certain income $Y$.

"""

# ╔═╡ 0007e8f5-55ab-4249-b048-69569093801e
md"""
## Indifference Curves
"""

# ╔═╡ eb3a4ed7-c750-4cf5-9706-8747f058ea3e
# ╠═╡ disabled = true
#=╠═╡
Y = @bind Y Slider(100:1:150, default=120, show_value=true)
  ╠═╡ =#

# ╔═╡ f4d51bb1-abfb-471d-bf60-fdd374e838f7
p_1 = @bind p_1 Slider(10:1:20, default=15, show_value=true)

# ╔═╡ 0123a3a9-90cf-4df8-a221-6d205e71b815
	p_2 = @bind p_2 Slider(10:1:20, default=20, show_value=true)

# ╔═╡ 325f51a8-4335-47e3-af5a-173bd644b37e
x_1vec = collect(range(0.1,12, length=1001))

# ╔═╡ bd81e992-d312-4103-957b-0a62a1ca6135
x_2vec = copy(x_1vec)

# ╔═╡ 930b2940-e1b4-410d-9b74-d22c10e5fa5c
Yf(x_1,x_2) = p_1*x_1+p_2*x_2;

# ╔═╡ c4a43ad1-2d89-4c5a-92b2-3a1a09c1ef3f
md"""
This function can be plotted both explicitly implicitly, where the explicit function is set to find $x_2$ as a function of $x_1$,

$\begin{equation*}
  x_2(x_1) = \frac{Y-p_1x_1}{p_2}
\end{equation*}$
"""

# ╔═╡ fea6756f-b139-461c-b528-2a6a798c7d1f
md"""
So this is the indifference curve for the buyer that is dependent on the incomes stated and the prices for each commodity. We can also grah a series of indifference curves for different values of income: 100,105,110,115,120. 
"""

# ╔═╡ cdaad4aa-cc50-4654-a625-e5de189acaad
md"Graph Implicitly: $(@bind graph_implicitly CheckBox(default=false))"

# ╔═╡ d70f4b61-2576-44c9-a3f7-ad17b328ffda
md"Graph Multiple Indifference Curves: $(@bind mult_indiff CheckBox(default=false))"

# ╔═╡ ab06732e-e805-4f82-9087-1cf0e1748736
Y1=[100,105,110,115,120];

# ╔═╡ 725450ac-deb0-4e79-b24d-324f1961d197
function Hot_Start(x_1,Y)
	cond1(x_2) = Y - (p_1*x_1+p_2*x_2)
	for i = 1:length(x_1vec) 
	x20 = x_1vec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;
	

# ╔═╡ 1eac2abc-ba35-4145-b8ca-ae3fd35a2a56
md"""
## Utility Curves
"""

# ╔═╡ dcd1d991-eeb4-4972-8707-7b88b1c5e474
md"""
Now given our conditions for the consumer they need to optimize their total utility given these two amounts of goods subject to their utility curve. We will assume a utility curve of 

$\begin{equation*}
 U(x_1,x_2)= x_1^{α} * x_2^{1-α}
\end{equation*}$
where $\alpha$ is the subjective utility condition, which we have assumed to be 0.6.
"""

# ╔═╡ ba48efaa-61e6-4cdf-81f1-24c2872261ff
# ╠═╡ disabled = true
#=╠═╡
α=.6;
  ╠═╡ =#

# ╔═╡ b0d6155f-1007-4893-9614-53af2747c1d1
md"""
So we can plot this utility curve in the same graph as the indifference curve stated above for different relative Utility values, where the highest Utility value is preferred. So by pressing the Plot Utility Curves box you will see that different levels of subjective utility given the conditions. To find the optimal utility involves finding where the Utility Curve and Indifference curve meet at one point, which means in order to optimize we have to find the points on both the indifference curve and utility curve that are equal in both total and marginal space. So we have to find the combinations of commodities $x_1$ and $x_2$ to that solve the following conditions,

$\begin{equation*}
  Y(x_1,x_2) = U(x_1,x_2)
\end{equation*}$
and

$\begin{equation*}
  Y_{x_1}(x_1,x_2) = U_{x_1}(x_1,x_2)
\end{equation*}$
"""

# ╔═╡ 6a649a61-f139-4786-9ca3-132c6fdfb661
k = [3,4,5,6];

# ╔═╡ 8a3d6368-9b0e-453b-a2c8-fdd25bbcab52
md"Plot Utility Curves: $(@bind util_curve CheckBox(default=false))"

# ╔═╡ 8a6aa316-7045-4def-9f44-64838bc845d2
md"Find Optimal Utility Curve: $(@bind opt_utility CheckBox(default=false))"

# ╔═╡ f9af4f8c-fad4-42e4-bd17-e881a631ce14
md"""
## Stable and Unstable Equilibrium Points
"""

# ╔═╡ 22e8f782-ba15-4cf7-8f9b-6fcc579f89ec
md"""
For demand and supply curves there are stable and unstable equilibrium points that determine whether or not that particular dynamical market system will remain at equilibrium or diverge to the extreme values. To give some example of stable Demand and Supply would be 

$\begin{equation*}
  Q_D(Y,P) = 6ℯ^{-0.02P}-0.3P+Y
\end{equation*}$
and

$\begin{equation*}
  Q_S(P) = -3 + 0.06P
\end{equation*}$
where as we stated for before $Q_D$ is the quantity demanded and $Q_S$ is the quantity supplied. We can model these two equations given a range of Price values that will determine the market equilibrium points. We will graph the market equilibrium for Income avlues of 16 and 18.
"""

# ╔═╡ 208ad354-f768-472c-968a-47226f78b881
Pvec = collect(range(.01,60, length=400))

# ╔═╡ 8dc4f547-4714-4ef3-93e6-d46fcdbec3d3
Qvec = copy(Pvec)

# ╔═╡ ee3b7f00-f416-48b2-a45d-de18cbd31368
QD(P,Y2) = 6*ℯ^(-.02P)-.3*P+Y2

# ╔═╡ aaf6cfbb-b30b-42a6-b257-ec2cecd8cd28
QS(P) = -.3 +0.6*P

# ╔═╡ 663e85b3-7890-425c-84b3-fcbe2ba0b42b
function equilibrium(Q, Y2)
	Popt = 0
	Qopt = 0
	PE = 0
	PE2 = 0
	cond1(P) = Q - QD(P,Y2)
	cond2(P) = Q - QS(P) 
	A=[0,0]
	for i = 1:length(Qvec) 
	P20 = Qvec[i]
		try 
		PE=find_zero(cond1, P20)
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	P21 = Qvec[i]
		try 
		PE2=find_zero(cond2, P21)
		catch e
			if isa(e, TypeError)
				continue
			end
		end
		if .98*PE <= PE2 <= 1.02*PE
			Popt = PE
			Qopt = QS(Popt)
		end
	end
	A = [Qopt,Popt]
	return A
end
		

# ╔═╡ 1bbbf654-cc58-49c6-95f8-603bfa9edc3d
Y2 = [16,18]

# ╔═╡ d2bf7435-64e4-41f4-9bb1-5dbb711e038a
equilibrium.(Qvec,Y2[2])

# ╔═╡ 46e84119-ecdf-492e-9be3-20fa2ad5fd68
begin
    demand_supply = plot(
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
	for i = 1:1:length(Y2)
    plot!(QD.(Pvec,Y2[i]), Pvec, linecolor=:black, linestyle=:solid, linewidth=2)
 	# Key points, with dashed lines to them
    plot!([maximum(equilibrium.(Qvec, Y2[i]))[1],maximum(equilibrium.(Qvec, Y2[i]))[1]], [0,maximum(equilibrium.(Qvec, Y2[i]))[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,maximum(equilibrium.(Qvec, Y2[i]))[1]], [maximum(equilibrium.(Qvec, Y2[i]))[2],maximum(equilibrium.(Qvec, Y2[i]))[2]], linecolor=:black, linestyle=:dash)
    scatter!([maximum(equilibrium.(Qvec, Y2[i]))[1]], [maximum(equilibrium.(Qvec, Y2[i]))[2]], markercolor=:black, markersize=5)   
	end
	plot!(QS.(Pvec), Pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	
	# Axis limits
    xlims!(0, 1.05*maximum(QS.(Pvec)))
    ylims!(0, 1.2*Pvec[end])
	  # Axis labels
    annotate!(.99*xlims(demand_supply)[2], 5, text(L"Quantity", :left, :center, 12))
    annotate!(0, 1.01*ylims(demand_supply)[2], text(L"Price", :center, :bottom, 12))

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

   demand_supply	
end

# ╔═╡ a33bdd86-457b-4c0f-8eda-b5a8c0507197
md"""
## Labor Demanded and Quantity Supplied
"""

# ╔═╡ 930e0236-fe6d-4717-bf27-5565d53f9012
wvec = copy(Pvec)

# ╔═╡ 29a29f78-35ba-4258-9401-55595a7ea4d8
Lvec = copy(wvec)

# ╔═╡ b1692c57-6d9c-4e14-907e-5c37fbe5b892
# ╠═╡ disabled = true
#=╠═╡
γ = 4
  ╠═╡ =#

# ╔═╡ c2e19fcb-2d76-4e34-a090-868432b5dc71
md"Plot multiple Price Values: $(@bind wage_check CheckBox(default=false))"

# ╔═╡ a77e9340-1e30-44a1-bdf2-7689597cb42f
P1 = [15,20]

# ╔═╡ da1c8e48-15ba-41b9-aa19-8745fb56320d
w1 = [2,5]

# ╔═╡ b9f16f45-5628-4fcd-9d9e-2ce36ca68a8f
begin
    quantity_supplied = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Quantity Supplied",
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
	for i =1:1:length(w1)
  #  plot!(Qvec, Hot_Start9.(Qvec,w1[i]), linecolor=:black, linestyle=:solid, linewidth=2)
	end
	 # Axis limits
    xlims!(0, 50)
    ylims!(0, 50)
	 # Axis labels
    annotate!(46, 1, text(L"Quantity", :left, :middle, 12))
    annotate!(0, 50, text(L"Price", :center, :bottom, 12))
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

   quantity_supplied	
end

# ╔═╡ 1d533eed-9e29-4bde-9023-ed6f6cd8a7df
md"""
## Statics Problems
"""

# ╔═╡ 2d1f236e-b676-49a0-8363-f8314133cd59
md"""
Homework: Starting witht the vanilla firm problem's first-order condition

        p - wL'(q) = 0,

      and using the second-order condition

        -wL''(q) < 0,

      derive and sign the following comparative statics:

        dq/dp, dq/dw, dL/dp, dL/dw
"""

# ╔═╡ 8d9264b6-c242-4aef-8307-6e8ec147140e
md"""
$\begin{equation*}
  \frac{dq}{dp}=\frac{1}{wL''(q)}
\end{equation*}$
which because it is the inverse and opposite sign of the second order condition is positive.

$\begin{equation*}
   \frac{dq}{dp} = \frac{+}{+}=+
\end{equation*}$

$\begin{equation*}
  \frac{dq}{dw}=-\frac{L'(q)}{wL''(q)}
\end{equation*}$
which is negative because denominator is positive, as described in the last problem, and the numerator is postive because 

$\begin{equation*}
  L'(q)=\frac{p}{w}
\end{equation*}$
as described in the problem setup, so

$\begin{equation*}
   \frac{dq}{dw}=-\frac{+}{+}=-.
\end{equation*}$

$\begin{equation*}
  \frac{dL}{dp}=-\frac{1}{0}
\end{equation*}$
which is undefined because there is no variable L to take the derivative of in this function. The function space is $f(p,w,q)$. Likewise

$\begin{equation*}
  \frac{dL}{dw}=\frac{L'(q)}{0}
\end{equation*}$
which is also undefined.
"""

# ╔═╡ b075bc9a-515a-4cd5-910c-41f47a25f30f
md"""
## Indicate Direct and Indirect effect of Y in standard market supply-demand graph. 
"""

# ╔═╡ ed4ba0e0-a7e7-46e7-b177-3bba2db22e3d
md"""
For "normal" market conditions operating on "normal" market goods, we can construct a model that specifies the quantity demanded for a commodity as a function of both the price of the commodity and the income of the individual buying said commodity. We can also investigate how changing values for income will affect the supply and demand graph.

$\begin{equation*}
  Q=D(P,Y).
\end{equation*}$
We can also write an equation for the quantity supplied based on the price of the commdity as

$\begin{equation*}
  Q=S(P)
\end{equation*}$
setting aside the quantity supplied function
                                             
$\hspace{15cm}Q=S(P)$
Setting these two equations equal to each other to find the equilibrium point gives us,

$\begin{equation*}
  S(P)=D(P,Y).
\end{equation*}$
Setting this equation equal to zero gives us,

$\begin{equation*}
  f(P,Y)=S(P)-D(P,Y)=0,
\end{equation*}$
where $f(P,Y)$ indicates that this is a two variable function. Taking the implicit derivative of Price with respect to Income allows us to find how the price of the commodities changes for an infinitesimal amount of change in the income. The derivative in mathematical notation is

$\begin{equation*}
  \frac{dP}{dY}=-\frac{D_Y(P,Y)}{S_P(P)-D_P(P,Y)}.
\end{equation*}$
In order to determine the correct sign for this function involves analyzing both the numerator and the denominator for their indidividual signs and determing from there what the sign for the entire function will be. In the assumption we said that this model was for a "normal" good in "normal" market conditions which means that the slope of the demand curve with respect to price has to be less than the supply curve with respect to price, else the market equilibrium would be unstable. Mathematically this would mean

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
So the numerator of this derivative is positive, but the denominator is negative so it would seem that the total sign is indeed negative. However, in implicit differentiation negative one is multiplied by the entire equation, so the true sign of this derivative is actually positive. So mathematically this would be

$\begin{equation*}
  \frac{dP}{dY}=-\frac{D_Y(P,Y)}{S_P(P)-D_P(P,Y)}>0.
\end{equation*}$
This makes a fair amount of intuitive sesne based on the definitions for this model, where idividuals are purchasing "normal" goods, as their income increases they will spend more on "normal" goods, resulting in an increase in price for those goods. 

No bringing back the equation that we had set aside,

$\begin{equation*}
  Q=S(P).
\end{equation*}$
We can solve and determine the sign of how the rate of quantity supplied changes with infinitesimal changes in income. We do this by first setting price has a function of income $P=P(Y)$, and pluggin this equation into our set aside function. That function is

$\begin{equation*}
  Q=S(P(Y)).
\end{equation*}$
Solving for the value of $\frac{dQ}{dY}$ gives

$\begin{equation*}
  \frac{dQ}{dY}=S_P(P(Y))P_Y(Y).
\end{equation*}$
To determine the sign of this equation involves us having to recall that part of the definition of a "normal" good is to that as individuals incomes increase, they buy more of the prdouct, leading to firms to produce more to keep up with demand, so $S_P$ is positive. To determine the second part, $P_Y$, that is what we calculated in the above and we detrmined that $\frac{dP}{dY}$ is positive, which is the same function as $P_Y$. So the rate of change of quantity supplued with respect to infinitesimal amounts of income is postive, or mathematically

$\begin{equation*}
  \frac{dQ}{dY}=S_P(P(Y))P_Y(Y)>0.
\end{equation*}$
This result was derived from setting aside a the Quantity Supplied equation, setting the two functions of Quantity Demanded and Quantity Supplied equal to one another, and finally deriving the various conditions that lead to the result above. There was no particular reason to set aside the quantity supplied equation and not the quantity demanded and if we set aside the quatity demanded equation and went from there we would get the exact same result. So solving for the rate of quantity supplied with respect to the infinitesimal amounts of income, we must first insert the price as a funtion of income function into the quantity demanded equation, which is

$\begin{equation*}
  Q=D(P(Y),Y).
\end{equation*}$
taking the derivative of this function with respct to $Y$ yields

$\begin{equation*}
  \frac{dQ}{dY}=D_P(P(Y),Y)P_Y(Y)+D_Y(P(Y),Y). 
\end{equation*}$
The sign for this derivative should be the same as the other derivation, which was positive. The first part of the equation, $D_P$ is negative because as price increases for "normal" goods demand decreases. The second part of the equation $P_Y$ is positve as this was established earlier, that prices for "normal" goods increase when income of the individuals increases. And finally the last part, $D_Y$ is also positve because as established earlier demand for "normal" goods increases when income increases. So it would seem as first sight that this function is ambiguous when it comes to sign, but actually it is positive. The proof and example that it is positive comes in two parts, the indirect effect and the direct effect. The indirect effect is

$\begin{equation*}
  D_P(P(Y),Y)P_Y(Y)
\end{equation*}$
and the direct effect is 

$\begin{equation*}
  D_Y(P(Y),Y)
\end{equation*}$
The first part is the indirect part because essentially what it is saying is that when incomes increase, then the price of "normal" goods increases, that is what $P_Y(Y)$ represents. Additionally as price for the "normal" goods increases with income, then demand will decrease as the price decreases, that is what $D_P(P(Y),Y)$ represents. The second part is the direct effect because it represents that immediate effect in demand for increases in income, which causes the indirect effect to happen later. It is important to state that the indirect effect could not happen unless prices increased, which in this model occurs for increased demand from higher incomes. Graphically we represent this function with arbitrary demand and supply curves. Take the arbitrary demand function 

$\begin{equation*}
  Q_D(P,Y)=\alphaℯ^{βP}+δP+Y,
\end{equation*}$
and an arbitrary supply function

$\begin{equation*}
  Q_S(P)=ϕ+γP,
\end{equation*}$
setting up the problem and solving it the same way as above we get

$\begin{equation*}
  Q_D(P(Y),Y)=\alphaℯ^{βP(Y)}+δP(Y)+Y.
\end{equation*}$
Breaking this equation up into the parts of $D_P$, $P_Y$, and $D_Y$ gives

$\begin{equation*}
  D_P = αβℯ^{βP}+δ,
\end{equation*}$

$\begin{equation*}
  P_Y=\frac{1}{γ-(αβℯ^{βP}+δ)},
\end{equation*}$
and

$\begin{equation*}
  D_Y=αℯ^\frac{β}{γ-(αβℯ^{βP}+δ)}+\frac{δ}{γ-(αβℯ^{βP}+δ)}+1.
\end{equation*}$
So putting all these values together we get

$\begin{equation*}
  \frac{dQ}{dY}=(αβℯ^{βP}+δ)(\frac{1}{γ-(αβℯ^{βP}+δ)}+(αℯ^\frac{β}{γ-(αβℯ^{βP}+δ)}+\frac{δ}{γ-(αβℯ^{βP}+δ)}+1)
\end{equation*}$
"""

# ╔═╡ 640b38dd-f8fb-401d-9818-429364cf3d2d
Pvec2= collect(range(0,200,length=200));

# ╔═╡ bb0cd26d-da79-4405-81d4-094ad320de58
α = @bind α confirm(Slider(-5.0:0.1:5.0, default=2, show_value=true))

# ╔═╡ 4c7b3955-8e48-4735-8475-5f70d550d85d
U(x_1,x_2)=x_1^(α)*x_2^(1-α);

# ╔═╡ 53045a09-03af-4358-9fa2-2cd061a58259
function Hot_Start3(x_1,k)
	cond1(x_2) = k - (x_1^(α)*x_2^(1-α))
	for i = 1:length(x_1vec) 
	x20 = x_1vec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;

# ╔═╡ e913ba0f-8bd8-45ec-9521-150308afb342
function Tangent2(x_1)
	cond1(x_2) = (p_1/p_2) - (α*x_2)/(x_1*(1-α))
	for i = 1:length(x_1vec) 
	x20 = x_1vec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;

# ╔═╡ d5475fbb-c2cb-4281-ba26-57c8243cc04a
β = @bind β confirm(Slider(-1.0:0.1:1.0, default=-0.6, show_value=true))

# ╔═╡ 0226238e-8365-4bee-a5c1-93b2454c72bf
δ = @bind δ confirm(Slider(-1.0:0.1:1.0, default=-0.9, show_value=true))

# ╔═╡ 843ba6cc-ba30-4431-8a2f-06821c84d28a
ϕ = @bind ϕ confirm(Slider(-1.0:0.1:1.0, default=-0.8, show_value=true))

# ╔═╡ c010ec5f-09f4-422e-96f5-1d34224a02bc
γ = @bind γ confirm(Slider(-1.0:0.1:1.0, default=0.4, show_value=true))

# ╔═╡ a7a1e953-1a0f-405c-acff-0d1b653f295d
L(P,w)=(P*γ)/w - 1

# ╔═╡ 2e930490-559d-4a56-9d54-b55438909837
function Hot_Start8(L, P)
	cond1(w) = L - ((P*γ)/w - 1)
	for i = 1:length(Lvec) 
	w20 = Lvec[i]
		try 
		w=find_zero(cond1, w20)
			return w
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;
	

# ╔═╡ fbca03e6-5f7e-4e77-b711-9ead508e6bea
begin
    labor_plot = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Labor Demanded",
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
	if wage_check == true
	for i=1:1:length(P1)
    plot!(Lvec, Hot_Start8.(Lvec,P1[i]), linecolor=:black, linestyle=:solid, linewidth=2)
	end
	end
	 # Axis labels
    annotate!(49, 1, text(L"Labor", :left, :center, 12))
    annotate!(0, 50, text(L"Wage", :center, :bottom, 12))
	# Axis limits
    xlims!(0, 50)
    ylims!(0, 50)

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

   labor_plot	
end

# ╔═╡ f7cff1e2-a07b-4c04-a0a9-3fe3b78a2e72
q(P,w) = γ*log((P*γ)/w)

# ╔═╡ cf8e4e9c-a9bd-46a2-bd99-023922dab4a4
function Hot_Start9(q, w)
	cond1(P) = q - (γ*log((P*γ)/w))
	for i = 1:length(Qvec) 
	P20 = Lvec[i]
		try 
		P=find_zero(cond1, P20)
			return P
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;
	

# ╔═╡ d58fc1fb-56e0-4fbb-84bf-fac7093bb1d8
Q_S(P)= ϕ +γ*P

# ╔═╡ c517b0e6-86eb-450f-8992-b1b7f04e832f
Y3 = @bind Y3 Slider(100:1:150, default=0.5, show_value=true)

# ╔═╡ 2bca539b-42ce-4b44-9a67-1687bdacfea7
Q_D(P,Y)= α*ℯ^(β*P)+δ*P+Y3

# ╔═╡ 0a644fbb-bca7-4fcb-8d25-cffd714b783e
D_P(P)=α*β*exp(β*P)+δ

# ╔═╡ 69ad3bfa-2052-4e82-bba2-a3187e41c110
P_Y(P)=1/(γ-(α*β*exp(β*P)+δ))

# ╔═╡ de78dbc5-2628-4fe1-9d8d-20cdd57c9628
D_Y(P)=α*exp(β*P_Y(P))+δ*P_Y(P)+1

# ╔═╡ f0fdd5f4-bf1d-4789-aa51-a5249340f666
indirect(P)=D_P(P)*P_Y(P)

# ╔═╡ 06f1e054-080b-4c6a-8c39-4dda615e68ad
dQ_dY(P)=D_P(P)*P_Y(P)+D_Y(P)

# ╔═╡ 90abcf5e-3fd1-48f5-8885-c32fbd50c76e
begin
    supply_demand = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Supply and Demand Curves",
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(Q_D.(Pvec2,Y3), Pvec2, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Q_S.(Pvec2), Pvec2, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 100)
    ylims!(0,100)

	# Axis labels
    annotate!(90, 2, text(L"Quantity", :left, :center, 12))
    annotate!(2, 100, text(L"Price", :center, :bottom, 12))
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

   supply_demand	
end

# ╔═╡ 52ceabc2-78a0-467b-b692-4810d5a9c1a9
begin
    direct_indirect = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="dQ/dY",
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
   	plot!(indirect.(Pvec2), Pvec2, linecolor=:red, linestyle=:solid, linewidth=2,label="Indirect")
	plot!(D_Y.(Pvec2), Pvec2, linecolor=:black, linestyle=:solid, linewidth=2,label="Direct")
	plot!(dQ_dY.(Pvec2), Pvec2, linecolor=:black, linestyle=:dash, linewidth=2,label="dQ/dY")
	# Axis limits
    xlims!(-5, 5)
    ylims!(0,200)
	 annotate!(4.8, 5, text(L"Quantity", :left, :center, 12))
    annotate!(-4.9, 200, text(L"Price", :center, :bottom, 12))

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

   direct_indirect	
end

# ╔═╡ 33cccd7b-9833-48db-a2f8-addee27a2e1b
md"""
As can be seen from the graph above the red line is the indrect effect, the black line is the direct effect, and the dashed line is $\frac{dQ}{dY}$. This graphical representation is a confirmation of what we had said above, where the indirect effect for a normal good is always going to be negative while the direct effect will be positive, and while the true sign of $\frac{dQ}{dY}$ may seem ambiguous, it is always positive for "normal" goods. As the values of the parameters that define the function change, as long as the parameters maintain a "normal" good with downward sloping demand curve and upward sloping supply curve, then the direct effect will outway the indirect effect and mainting a positive $\frac{dQ}{dY}$.
"""

# ╔═╡ d99e3b17-159a-4dbf-8b4c-bd2b09fb5138
md"""
## Intepret Consumer First Order Condition
"""

# ╔═╡ f684dda9-05df-4e66-abb3-e64928c36aa6
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

# ╔═╡ 5b825b9d-3be9-452c-81f1-dac852759d30
md"""
## Derive consumers' second-order condition
"""

# ╔═╡ b2f03b69-4e07-4d42-8123-a9b68425bdd9
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

# ╔═╡ 4cbb5623-790c-4a3f-abf3-825bd80631d6
md"""
# 9-18 Notes
"""

# ╔═╡ 56633e27-17ba-41ef-add3-069099054f55
function ift3(Y)
	
	function find_zeros(F, x, Y)

    	# Unpack the vector of endogenous variables to be solved for
    	Qd0 = x[1]
    	Qs0 = x[2]
		P=  x[3]

    	# Write out the conditions that must be zero at the solution
		# Demand
    	F[1] = 6*exp(-0.02*P) - 0.3*P + Y - Qd0 

		# Supply
    	F[2] = -3 + 0.6*P - Qs0

		#other
		F[3]= Qd0-Qs0
 		
	end

	# Specify a vector of starting guesses (note: must be floats!)
	Q0 = 12.0
	P0 = 25.0
	D0 = 25.0
	x0Vec = [Q0, P0, D0]

	# Find and return the solution
	sol = nlsolve((F, x) -> find_zeros(F, x, Y), x0Vec)

	return sol.zero
	
end;

#Followed by

# Functions implicitly defined by the conditions
#Q_ift(Y) = ift(Y)[1]
#P_ift(Y) = ift(Y)[2]



# ╔═╡ 62b4ac4b-30a6-4b03-b420-b8c10597cafa
# ╠═╡ disabled = true
#=╠═╡
function ift3(Y)
	#snippet (,ift)
	function find_zeros(F, x, Y)
	#Unpack the vector of endogenous variables to be solved for
		Q=x[1]
		P=x[2]
		D=x[3]
#write out the conditions that must be zero at the solution
		#demand
		F[1]=6*exp(-.02*P)-.3*P+Y-Q
#supply
		F[2]=-.3+.6*P
		
		
	end
	#specify a vector of starting guesses (note: must be floats!)
	Q0=12
	P0=25.0
	x0vec=[Q0,P0]
	#find nd return the solution
	sol = nlsolve((F,x) -> find_zeros(F, x, Y),x0vec)
	return sol.zero
end;
  ╠═╡ =#

# ╔═╡ 9d856118-c857-4626-9a97-32d60fcd6605
Y=16

# ╔═╡ 1f7ee1f5-3992-458a-8401-bdd9b66a4067
x_2f(x_1)=(Y-p_1*x_1)/p_2

# ╔═╡ 03c8d019-18e4-4a4d-855a-10bca615fc10
function Hot_Start2(x_1,Y1)
	cond1(x_2) = Y - (p_1*x_1+p_2*x_2)
	for i = 1:length(x_1vec) 
	x20 = x_1vec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;

# ╔═╡ a9d54a97-4685-476a-ba2f-36ea62ebb690
begin
    indifference_curve = plot(
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
    plot!(x_1vec, x_2f.(x_1vec), linecolor=:black, linestyle=:solid, linewidth=2)
	if graph_implicitly == true
		plot!(x_1vec, Hot_Start.(x_1vec,Y), linecolor=:red, linestyle=:solid, linewidth=2)
	end
	if mult_indiff == true
	for i = 1:1:5
	plot!(x_1vec, Hot_Start.(x_1vec,Y1[i]), linecolor=:black, linestyle=:solid, linewidth=2)
	end
	end
	# Axis limits
    xlims!(0,12)
    ylims!(0, 12)
	 # Axis labels
    annotate!(12, .5, text(L"x_1", :left, :center, 12))
    annotate!(0, 12, text(L"x_2", :center, :bottom, 12))
	
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

   indifference_curve	
end

# ╔═╡ 29248830-b120-4805-8520-9ed3d4197956
function Tangent1(x_1)
	cond1(x_2) =  Y - (p_1*x_1+p_2*x_2) - U(x_1,x_2)
	for i = 1:length(x_1vec) 
	x20 = x_1vec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end;

# ╔═╡ 6f229d0d-8166-418f-9c23-76a69dedd3ab
function tangent4() #Set the values for this function to search for the tangent values along the x1vec 
	x1opt = 0
	x2opt = 0
	k=0
	for i=1:1:500
		if .999*Tangent1(x_1vec[i]) <= Tangent2(x_1vec[i]) <= 1.001*Tangent1(x_1vec[i])
			x1opt = x_1vec[i]
			x2opt = x_2f(x1opt)
		end
	end
 	k = (x1opt)^α*(x2opt)^(1-α)
	return k
end;

# ╔═╡ b4a1c02d-0524-43c8-976e-2fb041a6974e
function tangent5() #Set the values for this function to search for the tangent values along the x1vec 
	x1opt = 0
	x2opt = 0
	k=0
	for i=1:1:500
		if .999*Tangent1(x_1vec[i]) <= Tangent2(x_1vec[i]) <= 1.001*Tangent1(x_1vec[i])
			x1opt = x_1vec[i]
			x2opt = x_2f(x1opt)
		end
	end
 	k = (x1opt)^α*(x2opt)^(1-α)
	return [x1opt,x2opt]
end;

# ╔═╡ 35ebd13e-a6aa-46dc-bbb0-9358b50a3117
begin
    indifference_curve_Utility = plot(
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
    plot!(x_1vec, x_2f.(x_1vec), linecolor=:black, linestyle=:solid, linewidth=2)
	if util_curve == true
	for i=1:1:4
	plot!(x_1vec, Hot_Start3.(x_1vec,k[i]), linecolor=:black, linestyle=:solid, linewidth=2)
	end
	end
	
	if opt_utility == true
		plot!(x_1vec, Hot_Start3.(x_1vec,tangent4()), linecolor=:black, linestyle=:solid, linewidth=2)
		 # Key points, with dashed lines to them
    plot!([tangent5()[1],tangent5()[1]], [0,tangent5()[2]], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent5()[1]], [tangent5()[2],tangent5()[2]], linecolor=:black, linestyle=:dash)
    scatter!([tangent5()[1]], [tangent5()[2]], markercolor=:black, markersize=5)
	end
	# Axis limits
    xlims!(0,12)
    ylims!(0, 12)
	 # Axis labels
    annotate!(12, .2, text(L"x_1", :left, :center, 12))
    annotate!(0, 12, text(L"x_2", :center, :bottom, 12))
	
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

   indifference_curve_Utility	
end

# ╔═╡ 6c719556-6556-48d4-8ec2-d3af82c26208
Y

# ╔═╡ f4d45ec4-c9a2-41ce-b13c-f87e67373033
Qdeq_ift3(Y)= ift3(Y)[1]

# ╔═╡ eff1d247-d062-4d92-af49-5855d0b79db0
Qseq_ift3(Y) = ift3(Y)[2]

# ╔═╡ 074ea04f-1979-41c0-a83a-da3aaa409ddf
Qd2eq_ift3(Y) = ift3(Y)[3]

# ╔═╡ 8e48c2db-5269-463b-acae-cf60e382e9ed
Qdeq_ift3(Y)

# ╔═╡ 3f1d6740-1588-479f-9065-3a293cdd3da9
Qseq_ift3(Y)

# ╔═╡ 02b9df03-07c9-48c9-80e8-f0cdf0a54a4a
Qd2eq_ift3(Y)

# ╔═╡ Cell order:
# ╠═3273be14-6a31-11ef-350f-fb50a09e4afd
# ╠═54e98f08-514f-49b2-847c-c342e7945e12
# ╠═4763180e-32cb-48bb-b902-866ff6c15b9c
# ╟─4d0955ff-1b27-479f-acd7-a7afa6fb9889
# ╟─43901f31-f4f6-44fe-9168-cc133d08854a
# ╟─0007e8f5-55ab-4249-b048-69569093801e
# ╠═eb3a4ed7-c750-4cf5-9706-8747f058ea3e
# ╠═f4d51bb1-abfb-471d-bf60-fdd374e838f7
# ╠═0123a3a9-90cf-4df8-a221-6d205e71b815
# ╠═325f51a8-4335-47e3-af5a-173bd644b37e
# ╠═bd81e992-d312-4103-957b-0a62a1ca6135
# ╠═930b2940-e1b4-410d-9b74-d22c10e5fa5c
# ╟─c4a43ad1-2d89-4c5a-92b2-3a1a09c1ef3f
# ╠═1f7ee1f5-3992-458a-8401-bdd9b66a4067
# ╟─fea6756f-b139-461c-b528-2a6a798c7d1f
# ╟─cdaad4aa-cc50-4654-a625-e5de189acaad
# ╟─d70f4b61-2576-44c9-a3f7-ad17b328ffda
# ╠═ab06732e-e805-4f82-9087-1cf0e1748736
# ╠═725450ac-deb0-4e79-b24d-324f1961d197
# ╠═03c8d019-18e4-4a4d-855a-10bca615fc10
# ╟─a9d54a97-4685-476a-ba2f-36ea62ebb690
# ╠═1eac2abc-ba35-4145-b8ca-ae3fd35a2a56
# ╟─dcd1d991-eeb4-4972-8707-7b88b1c5e474
# ╠═ba48efaa-61e6-4cdf-81f1-24c2872261ff
# ╠═4c7b3955-8e48-4735-8475-5f70d550d85d
# ╟─b0d6155f-1007-4893-9614-53af2747c1d1
# ╠═6a649a61-f139-4786-9ca3-132c6fdfb661
# ╠═53045a09-03af-4358-9fa2-2cd061a58259
# ╠═29248830-b120-4805-8520-9ed3d4197956
# ╠═e913ba0f-8bd8-45ec-9521-150308afb342
# ╠═6f229d0d-8166-418f-9c23-76a69dedd3ab
# ╠═b4a1c02d-0524-43c8-976e-2fb041a6974e
# ╟─8a3d6368-9b0e-453b-a2c8-fdd25bbcab52
# ╟─8a6aa316-7045-4def-9f44-64838bc845d2
# ╟─35ebd13e-a6aa-46dc-bbb0-9358b50a3117
# ╟─f9af4f8c-fad4-42e4-bd17-e881a631ce14
# ╟─22e8f782-ba15-4cf7-8f9b-6fcc579f89ec
# ╠═208ad354-f768-472c-968a-47226f78b881
# ╠═8dc4f547-4714-4ef3-93e6-d46fcdbec3d3
# ╠═ee3b7f00-f416-48b2-a45d-de18cbd31368
# ╠═aaf6cfbb-b30b-42a6-b257-ec2cecd8cd28
# ╠═663e85b3-7890-425c-84b3-fcbe2ba0b42b
# ╠═d2bf7435-64e4-41f4-9bb1-5dbb711e038a
# ╠═1bbbf654-cc58-49c6-95f8-603bfa9edc3d
# ╟─46e84119-ecdf-492e-9be3-20fa2ad5fd68
# ╠═a33bdd86-457b-4c0f-8eda-b5a8c0507197
# ╠═930e0236-fe6d-4717-bf27-5565d53f9012
# ╠═29a29f78-35ba-4258-9401-55595a7ea4d8
# ╠═a7a1e953-1a0f-405c-acff-0d1b653f295d
# ╠═b1692c57-6d9c-4e14-907e-5c37fbe5b892
# ╠═2e930490-559d-4a56-9d54-b55438909837
# ╠═c2e19fcb-2d76-4e34-a090-868432b5dc71
# ╠═a77e9340-1e30-44a1-bdf2-7689597cb42f
# ╟─fbca03e6-5f7e-4e77-b711-9ead508e6bea
# ╠═f7cff1e2-a07b-4c04-a0a9-3fe3b78a2e72
# ╠═da1c8e48-15ba-41b9-aa19-8745fb56320d
# ╟─cf8e4e9c-a9bd-46a2-bd99-023922dab4a4
# ╟─b9f16f45-5628-4fcd-9d9e-2ce36ca68a8f
# ╟─1d533eed-9e29-4bde-9023-ed6f6cd8a7df
# ╟─2d1f236e-b676-49a0-8363-f8314133cd59
# ╟─8d9264b6-c242-4aef-8307-6e8ec147140e
# ╟─b075bc9a-515a-4cd5-910c-41f47a25f30f
# ╠═ed4ba0e0-a7e7-46e7-b177-3bba2db22e3d
# ╟─640b38dd-f8fb-401d-9818-429364cf3d2d
# ╠═bb0cd26d-da79-4405-81d4-094ad320de58
# ╠═d5475fbb-c2cb-4281-ba26-57c8243cc04a
# ╠═0226238e-8365-4bee-a5c1-93b2454c72bf
# ╠═843ba6cc-ba30-4431-8a2f-06821c84d28a
# ╠═c010ec5f-09f4-422e-96f5-1d34224a02bc
# ╠═2bca539b-42ce-4b44-9a67-1687bdacfea7
# ╠═d58fc1fb-56e0-4fbb-84bf-fac7093bb1d8
# ╠═c517b0e6-86eb-450f-8992-b1b7f04e832f
# ╠═0a644fbb-bca7-4fcb-8d25-cffd714b783e
# ╠═69ad3bfa-2052-4e82-bba2-a3187e41c110
# ╠═de78dbc5-2628-4fe1-9d8d-20cdd57c9628
# ╠═f0fdd5f4-bf1d-4789-aa51-a5249340f666
# ╠═06f1e054-080b-4c6a-8c39-4dda615e68ad
# ╟─90abcf5e-3fd1-48f5-8885-c32fbd50c76e
# ╟─52ceabc2-78a0-467b-b692-4810d5a9c1a9
# ╟─33cccd7b-9833-48db-a2f8-addee27a2e1b
# ╟─d99e3b17-159a-4dbf-8b4c-bd2b09fb5138
# ╟─f684dda9-05df-4e66-abb3-e64928c36aa6
# ╠═5b825b9d-3be9-452c-81f1-dac852759d30
# ╟─b2f03b69-4e07-4d42-8123-a9b68425bdd9
# ╠═4cbb5623-790c-4a3f-abf3-825bd80631d6
# ╠═6c719556-6556-48d4-8ec2-d3af82c26208
# ╠═56633e27-17ba-41ef-add3-069099054f55
# ╠═62b4ac4b-30a6-4b03-b420-b8c10597cafa
# ╠═9d856118-c857-4626-9a97-32d60fcd6605
# ╠═f4d45ec4-c9a2-41ce-b13c-f87e67373033
# ╠═eff1d247-d062-4d92-af49-5855d0b79db0
# ╠═074ea04f-1979-41c0-a83a-da3aaa409ddf
# ╠═8e48c2db-5269-463b-acae-cf60e382e9ed
# ╠═3f1d6740-1588-479f-9065-3a293cdd3da9
# ╠═02b9df03-07c9-48c9-80e8-f0cdf0a54a4a
