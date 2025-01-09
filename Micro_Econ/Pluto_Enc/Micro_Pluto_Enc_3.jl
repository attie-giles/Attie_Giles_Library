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

# ╔═╡ e4029728-c7a5-11ef-2f04-3731ad5737c2
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
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
      #using Printf #allows you to use sprintf
end

# ╔═╡ af3eeddd-db7e-447b-9f6b-a02b868fbcff
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 235a0ff9-3f3a-4dd7-950e-6fd7e6a08dc3
md"""
# Micro Pluto Encyclopedia
"""

# ╔═╡ 684303da-aded-4910-9d4a-9a82e6c5fd43
md"""
Competitive Firm problem 
"""

# ╔═╡ 28bc23ca-9ed1-452b-b604-7dbf4d21a93b
md"""
## Competitive Firm Manager
"""

# ╔═╡ 7d8f241d-6d1d-43df-8abc-a1274c7dcb20
md"""
A competitive firm is defined as an instituiton that produces commodities for sale in a given market whose end goal is to mazimize profits. The competitive market in this model is defined by the characterisitc that there are so many firms producing the same commodity that each firm cannot dictate the price of the commodity, but must set the same general price else they will lose business to the other firms. The optimization problem in this model is for each firm to determine how much to spend on production for each commodity, with the chief determinant of costs being the wage rate paid to labor. In this model the market for wage labor is also competitive, which means that like setting the price for the commodity to sell, the each firm must also pay the same wage rate as all the other firms, else they will lose labor to another firm. It is under these constaints that we analyze the optimization problem for each firm and determine what the optimal amount of labor is for the goal of maximizing profits. 
"""

# ╔═╡ d09f799f-1a0d-4124-9938-64eae7fe00c5
md"""
After outlining the basic problem, we must determine that functional form that allows for modeling the story listed above. There are two types of variables in this model, the endogeneous variables that each firm can either directly or indirectly control and the exogeneous variables that no firm can control. Which can be symbolized as 

**Endogeneous Variables**:

$π \equiv Profit$
$R \equiv Revenues$
$C \equiv Cost$
$q \equiv Quantity \enspace Produced$
$L \equiv Labor \enspace Employed$
and

**Exogeneous Variables**:

$p \equiv Commodity \enspace Price$
$w \equiv Wage \enspace Price$

The main difference between these two types of variables is that endogeneous variables can be listed as relationships between other endogeneous variables and exogeneous variables, while exogeneous variables are more like parameters that can not be determined by a relationship with other variables in the model.

"""

# ╔═╡ d11bda3b-89c1-4c9d-97dd-e45bc6faa095
md"""
As determined by the setup for the model above, the competitive-firm problem is trying to maximize profts given the contraints of these other variables. We can model what those constraints are by equations between the endogenous and exogeneous variables.

**Relationship Equations**

$π = R - C$
$R = p \cdot q$
$C = w \cdot L$
$q = q(L)$

These relationships determine that this problem is solvable because there are four equations with six unknowns. In the next section we will show how the relationships can be modeled to solve the specific profit maximization problem for the competitive firm in the competitive market.

"""

# ╔═╡ 4e878a78-d4c4-43e1-963f-382fd7660b27
md"""
The optimization problem for each competitive-firm manager is to maximize profits. As stated in the first section the competitive-firm manager must maximize profits given the constraints of the market price for both labor and commodities produced along with the constraints of production of said commodities. His problem can be stated as

**Firm Optimization Problem** 

$\begin{equation*}
  \max_{π,R,C,q,L} π
\end{equation*}$

**Subject to**

$\begin{align*}
π &= R-C \\
  R&=p \cdot q \\
 C &= w \cdot L \\
q &= q(L).
\end{align*}$

The first step in solving would be to reorder the objective function by inserting the the profit equation containing the variables revenue and cost,

**Firm Optimization Problem** 

$\begin{equation*}
   \max_{R,C,q,L} π = R- C
\end{equation*}$

**Subject to**

$\begin{align*}
  R&=p \cdot q \\
 C &= w \cdot L \\
q &= q(L).
\end{align*}$

This allows us to remove an equation from the constraints list and insert it into the optimization problem. Doing the same for the revenue equation gives

**Firm Optimization Problem** 

$\begin{equation*}
   \max_{C,q,L} π = p \cdot q- C
\end{equation*}$

**Subject to**

$\begin{align*}
   C &= w \cdot L \\
q &= q(L).
\end{align*}$


Same thing for the costs equation

**Firm Optimization Problem** 

$\begin{equation*}
   \max_{q,L} π = p \cdot q- w \cdot L
\end{equation*}$

**Subject to**

$\begin{equation*}
  q = q(L)
\end{equation*}$

Finally, we insert the last constraint for production q into the objective function to give the unconstrained problem

**Firm Optimization Problem** 

$\begin{equation*}
   \max_{L} π = p \cdot q(L)- w \cdot L
\end{equation*}$

To maximize this problem we have to find where the first derivative of this equation with relation to labor is equal to zero and where the second derivative of this equation with relation to labor is negative. Which can be written as

**First-Order Condition**

$\begin{equation*}
  \frac{dπ(L)}{dL} = 0
\end{equation*}$

and

**Second-Order Condition**

$\begin{equation*}
    \frac{dπ^2(L)}{dL^2} < 0
\end{equation*}$

Doing this allows the firm manager to find the absolute maximum amount of profits. Finding the first-order and second-order condition for the specified equation gives

**In order to maximize π with relation to L**

$\begin{equation*}
  \frac{dπ(L)}{dL} = p \cdot q'(L) - w = 0
\end{equation*}$

and

$\begin{equation*}
    \frac{dπ^2(L)}{dL^2} = p \cdot q''(L) < 0.
\end{equation*}$

Focusing on the first derivative equation, treating the parameters of wage price and commodity price as variables, we can define the function as one of three variables

$\begin{equation*}
  f(p,L,w) = p \cdot q'(L) - w 
\end{equation*}$

which as stated above is equivalent to zero,

$\begin{equation*}
  p \cdot q'(L) - w = 0
\end{equation*}$ 

this allows us to implictly define the function implicitly for labor, which can be written as

$\begin{equation*}
  L^* = L^*(p,w) 
\end{equation*}$

Where $L^*$ represents the optimal amount of labor employed which is where the first derivative of the profit equation is equivalent to zero. Isolating one of the initial constaint equations for quantity

$\begin{equation*}
  q = q(L)
\end{equation*}$

we can plug in this optimal amount of labor funciton, $L^*$, to find the optimal amount of quantity to produce. Which gives

$\begin{equation*}
  q^* = q(L^*)
\end{equation*}$

and simplifies to 

$\begin{equation*}
  q^* = q(L^*(p,w))
\end{equation*}$

Thus the answer to the profit maximization problem is to produce quantity of output where the optimal amount of labor is being utilized which is determined by the where the first derivative of the profit function is zero. The only cavaet is to determine that the optimal amount of labor employed is at the absolute maximum for profits and not just a local maximum, which can be understood where the second derivatve of the profit equation

$\begin{equation*}
    \frac{dπ^2(L)}{dL^2} = p \cdot q''(L)
\end{equation*}$

must be less than zero

$p \cdot q''(L) < 0$

and if that relation holds, then 

$\begin{equation*}
  q^* = q(L^*(p,w))
\end{equation*}$

will determine the absolute optimal amount of quantity to produce so as to find the absolute maximum profits.

"""

# ╔═╡ 14ae1b31-b612-4972-a72a-e36aedc2fe21
md"""
Similarly we could have solved this equation by making labor a function of quantity produced,

$\begin{equation*}
  L=L(q)
\end{equation*}$
which would change the firm optimization problem to 

$\begin{equation*}
  \max_{q} π = p \cdot q - w \cdot L(q)
\end{equation*}$
where instead of $L$ being the only endogenous variable left, $q$ is now the inly endogenous variable. We would solve this equation the same way,

$\begin{align*}
  \dfrac{dπ}{dq} &= p - w \cdot L'(q) =0  \\
	\dfrac{d^2π}{dq^2} &=  - w \cdot L''(q) < 0
\end{align*}$
where the first-ordr condition implicitly defines $q$ as a function of both p and w,

$\begin{equation*}
  q^*=q^*(p,w).
\end{equation*}$
We are now in the position to insert both results into the objective function and show how profits change with respect to change in the exogenous variables

$\begin{align*}
\max π &= p \cdot q(L^*(p,w)) - w \cdot L^*(p,w) \\
\max π &= p \cdot q^*(p,w) - w \cdot L(q^*(p,w)).
\end{align*}$
By the envelope theorem we can discover the comparative statics

**Approach 1**

$\begin{align*}
  \dfrac{dπ}{dp} &= q(L^*(p,w)) \\
\dfrac{dπ}{dw} &= L^*(p,w)
\end{align*}$
**Approach 2**

$\begin{align*}
  \dfrac{dπ}{dp} &= q^*(p,w) \\
\dfrac{dπ}{dw} &= L(q^*(p,w)).
\end{align*}$
This implies that 

$\begin{align*}
  q(L^*(p,w)) &= q^*(p,w) \\
L^*(p,w) &= L(q^*(p,w)),
\end{align*}$
which just means that the optimal amount of quantity to produce and labor to hire is the same regardless of which variable is defined by the other. Similarly we can also discover the other comparative statics using the two approaches,

**Approach 1**

$\begin{align*}
  \dfrac{dL^*}{dp} &= - \dfrac{\overbrace{q'(L)}^{(+)}}{\underbrace{p\cdot q''(L)} _{S.O.C}} > 0 \\
 \dfrac{dL^*}{dw} &= - \dfrac{-1}{\underbrace{p\cdot q''(L)} _{S.O.C}} < 0
\end{align*}$

**Approach 2**

$\begin{align*}
  \dfrac{dq^*}{dp} &= - \dfrac{1}{\underbrace{-w \cdot L''(q)} _{S.O.C}} > 0 \\
 \dfrac{dq^*}{dw} &= - \dfrac{\overbrace{-L'(q)}^{(-)}}{\underbrace{-w \cdot L''(q)} _{S.O.C}} < 0
\end{align*}$
"""

# ╔═╡ 91687827-b6c8-4583-a16f-cce4424451b5
md"""
Further analysis in paper and Latex notes.
"""

# ╔═╡ d50cc984-1fdc-4112-a4b6-961af9ee326c
md"""
## Example 1
"""

# ╔═╡ 611a5bba-5199-4668-a678-e4fbd8651627
md"""
Approach 1
"""

# ╔═╡ 48e54957-9bf6-4a21-b2b1-ad695d60a625
md"""
As an example of this problem, take the following production function

$\begin{equation*}
  q(L) = L^{1/ α},
\end{equation*}$
the firm's optimization problem would then be

$\begin{equation*}
  \max_{L} π = p \cdot L^{1/ α} - w \cdot L
\end{equation*}$
with the following first and second-order conditions

$\begin{align*}
  \dfrac{dπ}{dL} &= p \cdot \left(\dfrac{1}{α} \right) L^{(1/ α)-1}  - w =0 \\
\dfrac{d^2π}{dL^2} &= p \cdot \left(\dfrac{1}{α^2}  - \dfrac{1}{α} \right) \cdot L^{(1/ α)-2} < 0.
\end{align*}$
So long as $α$ is greater than 1 the second-order condition will hold implying that the first-order condition specifies a local maximum.
"""

# ╔═╡ 1ff0fbad-51ec-4f1b-8aef-e6a23ae6d8bf
Lvec = collect(range(0.3,12,length=101));

# ╔═╡ 5de4f47b-8b8b-4926-8040-7483e5d9a14f
begin #parameters
	p = 20
	w = 10
end;

# ╔═╡ 1d4b0fd2-f90a-4041-8ce4-8c2cac9231a7
α = @bind α Slider(1.01:0.01:2, default=1.4, show_value=true)

# ╔═╡ 1a7dc6c4-f988-4c89-adcb-04853ceef531
begin #equations
	#total
	π(L,p,w) = R(L,p) - C(L,w)
	R(L,p) = p * q(L)
	C(L,w) = w * L
	q(L) = L^(1/α)
#_______________________________________________________________________________#
	#marginal
	dπ(L,p,w) = dR(L,p) - dC(L,w)
	dR(L,p) = p * dq(L)
	dC(L,w) = w
	dq(L) = (1/α)*L^((1/α)-1)
end;

# ╔═╡ b4524aa0-388c-4bec-864d-d7b28a216145
begin
    Totalspace = plot(
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
    plot!(Lvec, π.(Lvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, R.(Lvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, C.(Lvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Axis labels
   annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.85*maximum(R.(Lvec,w)), text(L"$", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.8*maximum(R.(Lvec,w)))
	
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

   Totalspace	
end

# ╔═╡ 6be045b3-aece-45a1-ab2a-70cc066273de
md"""
The x-axis represents the hours of labor worked in a day while the y-axis represents the dollar value for the costs, profits, and revenues.
"""

# ╔═╡ 9ee681f4-3d5c-4a24-9724-7b8fede15734
md"""
As we have done before we can implicitly define the optimal amount of labor $L^*$ as a function of both price and wage,

$\begin{equation*}
  L^* = L^*(p,w).
\end{equation*}$
"""

# ╔═╡ 2a970579-76ca-4bfa-b6b9-629792b135b9
function L_star(p,w)

# Define the zero condition at the parameter value supplied
cond(L) = dπ(L,p,w)

# Specify a starting guess
L0 = .1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 8c581595-3773-4f16-830b-18c0dfe53ef9
md"""
When we plug in the parameters for both price and wage we will get the optimal amount of labor $L^*$. We can then use that optimal amount of labor to determine where the competitive, firm-manager should employ.
"""

# ╔═╡ e1ecd956-b57e-4fe9-8f65-8b95a23512b1
begin
    Totalspaceopt = plot(
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
    plot!(Lvec, π.(Lvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, R.(Lvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, C.(Lvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
	#Profits
    plot!([L_star(p,w),L_star(p,w)], [0,π(L_star(p,w),p,w)], linecolor=:black, linestyle=:dash) 
    plot!([0,L_star(p,w)], [π(L_star(p,w),p,w),π(L_star(p,w),p,w)], linecolor=:black, linestyle=:dash)
    scatter!([L_star(p,w)], [π(L_star(p,w),p,w)], markercolor=:black, markersize=5)
	#Costs
	plot!([L_star(p,w),L_star(p,w)], [0,C(L_star(p,w),w)], linecolor=:black, linestyle=:dash) 
    plot!([0,L_star(p,w)], [C(L_star(p,w),w),C(L_star(p,w),w)], 		linecolor=:black, linestyle=:dash)
    scatter!([L_star(p,w)], [C(L_star(p,w),w)], markercolor=:black, markersize=5)
	#Revenues
	plot!([L_star(p,w),L_star(p,w)], [0,R(L_star(p,w),p)], linecolor=:black, linestyle=:dash) 
    plot!([0,L_star(p,w)], [R(L_star(p,w),p),R(L_star(p,w),p)], 		linecolor=:black, linestyle=:dash)
    scatter!([L_star(p,w)], [R(L_star(p,w),p)], markercolor=:black, markersize=5)
	 # Axis labels
   annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.85*maximum(R.(Lvec,w)), text(L"$", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.8*maximum(R.(Lvec,w)))

	# Axis ticks
    xticks!([0.001, L_star(p,w)], [L"0", L"L^*"])
    yticks!([0.001, π(L_star(p,w),p,w), C(L_star(p,w),w),R(L_star(p,w),p)], [L"0", L"\pi(L^*)", L"C(L^*)", L"R(L^*)"])
	
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

   Totalspaceopt	
end

# ╔═╡ c793c155-f286-4015-86a4-daa6091cdd37
md"""
This can also be seen graphically by where the derivative of the profits equation equals zero and where the marginal revenue is equal to marginal costs.
"""

# ╔═╡ 9ac77336-7dd3-405f-b7ef-8b10fab5faf3
begin
    marginalspace = plot(
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
    plot!(Lvec, dπ.(Lvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Lvec, dR.(Lvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(Lvec, dC.(Lvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
    plot!([ L_star(p,w), L_star(p,w)], [0,dR.(L_star(p,w),p)], linecolor=:black, linestyle=:dash) 
    scatter!([L_star(p,w)], [dR.(L_star(p,w),p)], markercolor=:black, markersize=5)

	 # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.212*maximum(dR.(Lvec,p)), text(L"$", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.2*maximum(dR.(Lvec,p)))

	 # Axis ticks
    xticks!([0.001, L_star(p,w)], [L"0", L"L^*"])
    yticks!([0.001, dR.(L_star(p,w),p)], [L"0", L"MR=MC"])

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

   marginalspace	
end

# ╔═╡ ceb20fbe-ee6d-4c8c-9268-1fa1d4389ca8
md"""
Additionally, we also know where the optimal number of products the firm should produce. 
"""

# ╔═╡ a938b940-865b-4fb4-b7d4-6e000851b1e4
begin
    product = plot(
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

	# Key points, with dashed lines to them
    plot!([L_star(p,w),L_star(p,w)], [0,q(L_star(p,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L_star(p,w)], [q(L_star(p,w)),q(L_star(p,w))], linecolor=:black, linestyle=:dash)
    scatter!([L_star(p,w)], [q(L_star(p,w))], markercolor=:black, markersize=5)

	 # Axis ticks
    xticks!([0.001, L_star(p,w)], [L"0", L"L^*"])
    yticks!([0.001, q(L_star(p,w))], [L"0", L"q(L^*)"])

	 # Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.2*maximum(q.(Lvec)))
    
    # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.212*maximum(q.(Lvec)), text(L"q", :center, :bottom, 12))

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

   product	
end

# ╔═╡ 13e90b74-8004-46b5-83f1-47365deb1023
md"""
Approach 2
"""

# ╔═╡ 2d1e51fb-c08b-41ef-bbc3-d072bdc2f770
md"""
As an example of this problem, take the following production function

$\begin{equation*}
  L(q) = q^α,
\end{equation*}$
the firm's optimization problem would then be

$\begin{equation*}
  \max_{q} π = p \cdot q - w \cdot q^α
\end{equation*}$
with the following first and second-order conditions

$\begin{align*}
  \dfrac{dπ}{dq} &= p   - w \cdot α \cdot q^{α-1} =0 \\
\dfrac{d^2π}{dL^2} &=  - w \cdot \left(α^2 - α \right) \cdot q^{α-2} < 0.
\end{align*}$
So long as $α$ is greater than 1 the second-order condition will hold implying that the first-order condition specifies a local maximum.
"""

# ╔═╡ c62b33bf-4209-4168-94fb-7cf684c95cc6
qvec = collect(range(0.3, 10, length=101));

# ╔═╡ 41f91c7f-0827-42d4-8f12-e7a8b3668b51
begin #equations
	#total
	π_1(q,p,w) = R_1(q,p) - C_1(q,w)
	R_1(q,p) = p * q
	C_1(q,w) = w * L(q)
	L(q) = q^α
#_______________________________________________________________________________#
	#marginal
	dπ_1(q,p,w) = dR_1(q,p) - dC_1(q,w)
	dR_1(q,p) = p 
	dC_1(q,w) = w * dL(q)
	dL(q) = α * q^(α-1)
end;

# ╔═╡ 8dcaa181-136d-4860-b20a-8418eaa34b1e
begin
    totalspace2 = plot(
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
    plot!(qvec, π_1.(qvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qvec, R_1.(qvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, C_1.(qvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(R_1.(qvec,p)))
    
    # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(R_1.(qvec,p)), text(L"$", :center, :bottom, 12))

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

   totalspace2	
end

# ╔═╡ c7f55896-1b30-4aec-88e2-00ae2573aa41
md"""
As we have done before we can implicitly define the optimal amount of quantity produced q^* as a function of both price and wage,

$\begin{equation*}
  q^* = q^*(p,w).
\end{equation*}$
"""

# ╔═╡ a3504496-8dbd-47ba-86f5-1cfee30f4d67
function q_star(p,w)

# Define the zero condition at the parameter value supplied
cond(q) = dπ_1(q,p,w)

# Specify a starting guess
q0 = .1

# Find and return the solution
q = find_zero(cond, q0)

end;

# ╔═╡ 6efef79c-c9fa-4a6a-a89f-06c1e85d391d
begin
    Totalspaceopt2 = plot(
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
    plot!(qvec, π_1.(qvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qvec, R_1.(qvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, C_1.(qvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
	#Profits
    plot!([q_star(p,w),q_star(p,w)], [0,π_1(q_star(p,w),p,w)], linecolor=:black, linestyle=:dash) 
    plot!([0,q_star(p,w)], [π_1(q_star(p,w),p,w),π_1(q_star(p,w),p,w)], linecolor=:black, linestyle=:dash)
    scatter!([q_star(p,w)], [π_1(q_star(p,w),p,w)], markercolor=:black, markersize=5)
	#Costs
	plot!([q_star(p,w),q_star(p,w)], [0,C_1(q_star(p,w),w)], linecolor=:black, linestyle=:dash) 
    plot!([0,q_star(p,w)], [C_1(q_star(p,w),w),C_1(q_star(p,w),w)], 		linecolor=:black, linestyle=:dash)
    scatter!([q_star(p,w)], [C_1(q_star(p,w),w)], markercolor=:black, markersize=5)
	#Revenues
	plot!([q_star(p,w),q_star(p,w)], [0,R_1(q_star(p,w),p)], linecolor=:black, linestyle=:dash) 
    plot!([0,q_star(p,w)], [R_1(q_star(p,w),p),R_1(q_star(p,w),p)], 		linecolor=:black, linestyle=:dash)
    scatter!([q_star(p,w)], [R_1(q_star(p,w),p)], markercolor=:black, markersize=5)
	 # Axis labels
   annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.85*maximum(R_1.(qvec,w)), text(L"$", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.8*maximum(R_1.(qvec,w)))

	# Axis ticks
    xticks!([0.001, q_star(p,w)], [L"0", L"q^*"])
    yticks!([0.001, π_1(q_star(p,w),p,w), C_1(q_star(p,w),w),R_1(q_star(p,w),p)], [L"0", L"\pi(q^*)", L"C(q^*)", L"R(q^*)"])
	
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

   Totalspaceopt2	
end

# ╔═╡ 800d7818-369b-4c5e-b54d-db5b28056705
begin
    marginalspace2 = plot(
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
    plot!(qvec, dπ_1.(qvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qvec, dR_1.(qvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, dC_1.(qvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	 # Key points, with dashed lines to them
    plot!([ q_star(p,w), q_star(p,w)], [0,dR_1.(q_star(p,w),p)], linecolor=:black, linestyle=:dash) 
    scatter!([q_star(p,w)], [dR_1.(q_star(p,w),p)], markercolor=:black, markersize=5)

	 # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(dR_1.(qvec,p)), text(L"$", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(dR_1.(qvec,p)))

	 # Axis ticks
    xticks!([0.001, q_star(p,w)], [L"0", L"q^*"])
    yticks!([0.001, dR_1.(q_star(p,w),p)], [L"0", L"MR=MC"])

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

   marginalspace2	
end

# ╔═╡ 1ac85ee4-a002-4152-b845-dfcc74808471
begin
    labor = plot(
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
    plot!(qvec, L.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them
    plot!([q_star(p,w),q_star(p,w)], [0,L(q_star(p,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,q_star(p,w)], [L(q_star(p,w)),L(q_star(p,w))], linecolor=:black, linestyle=:dash)
    scatter!([q_star(p,w)], [L(q_star(p,w))], markercolor=:black, markersize=5)

	 # Axis ticks
    xticks!([0.001, q_star(p,w)], [L"0", L"q^*"])
    yticks!([0.001, L(q_star(p,w))], [L"0", L"L(q^*)"])

	 # Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(L.(qvec)))
    
    # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(L.(qvec)), text(L"L", :center, :bottom, 12))

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

   labor	
end

# ╔═╡ 2472e362-ebcc-451f-8048-fe8c5127ecb0
md"""
Here we have produced essentially the same results using two different methods; however, one shortcut that was taken was to explicitly define L(q), when we could have implicitly defined it. Take the following equation from the first approach

$\begin{equation*}
  q=q(L)
\end{equation*}$
we can subtract the right-hand side from q to get

$\begin{equation*}
  q-q(L)=0
\end{equation*}$
which can be used to implicitly define L(q).
"""

# ╔═╡ 62fa4c64-a701-499f-8095-b7316debbb45
function L_q_imp(q_1)

# Define the zero condition at the parameter value supplied
cond(L) = q_1 - q(L)

# Specify a starting guess
L0 = 1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 87338bde-e7b3-4ae9-9d55-c5eeec430ec7
md"Check Implicit Function: $(@bind check_imp CheckBox(default=false))"

# ╔═╡ b43aeebd-4b19-4d0f-b19c-eec2fe133031
begin
    lofqimp = plot(
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
    plot!(qvec, L_q_imp.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)

	if check_imp == true
		plot!(qvec, L.(qvec), linecolor=:red, linestyle=:solid, linewidth=2)
	end

	# Key points, with dashed lines to them
    plot!([q_star(p,w),q_star(p,w)], [0,L(q_star(p,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,q_star(p,w)], [L(q_star(p,w)),L(q_star(p,w))], linecolor=:black, linestyle=:dash)
    scatter!([q_star(p,w)], [L(q_star(p,w))], markercolor=:black, markersize=5)

	 # Axis ticks
    xticks!([0.001, q_star(p,w)], [L"0", L"q^*"])
    yticks!([0.001, L(q_star(p,w))], [L"0", L"L(q^*)"])

	 # Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(L.(qvec)))
    
    # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(L.(qvec)), text(L"L", :center, :bottom, 12))
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

   lofqimp	
end

# ╔═╡ 67ca75ac-968e-4b64-9043-f5c12b771cb6
md"""
This produces the exact same result as the explicitly defined function.
"""

# ╔═╡ 7816270d-2e2d-4de3-8ab0-c3fc56968d7b
md"""
## Example 2
"""

# ╔═╡ 0694b824-84fa-4663-8fdc-8383c1415625
md"""
Production Function: $q(L) = γ Log(L+1)$
"""

# ╔═╡ 1cf2b16a-3f59-4289-bfff-bb1a251646fa
md"""
Above is another production function that is a little more complicated than the one from example 1, so here we will need to implicitly define the L(q).
"""

# ╔═╡ 226cae7b-7eca-48b4-94ee-3a96ecbbe7e5
begin #parameters
	γ = 4
end;

# ╔═╡ 881bbc7b-8016-4b8a-9cf1-a56bd4b172bc
begin #Approach 1
	π1(L,p,w) = R1(L,p) - C1(L,w)
	R1(L,p) = p * q1(L)
	C1(L,w) = w * L
	q1(L) = γ * log(L+1)
#_______________________________________________________________________________#
	dπ1(L,p,w) = dR1(L,p) - dC1(L,w)
	dR1(L,p) = p * dq1(L)
	dC1(L,w) = w 
	dq1(L) = γ * (1/(L+1))
end;

# ╔═╡ 0c339fa4-0355-414b-aaa2-63bdf3681894
md"""
Approach 1
"""

# ╔═╡ fbb1c4b3-467e-4e78-b74a-97682dcefc1f
function L1opt(p,w)

# Define the zero condition at the parameter value supplied
cond(L) = dπ1(L,p,w)

# Specify a starting guess
L0 = .1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ d718841a-47b7-49ea-88fa-64721541d982
begin
    approach1 = plot(
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
    plot!(Lvec, q1.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.2*maximum(q1.(Lvec)))
    
    # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.212*maximum(q1.(Lvec)), text(L"q", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([L1opt(p,w),L1opt(p,w)], [0,q1.(L1opt(p,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,L1opt(p,w)], [q1.(L1opt(p,w)),q1.(L1opt(p,w))], linecolor=:black, linestyle=:dash)
    scatter!([L1opt(p,w)], [q1.(L1opt(p,w))], markercolor=:black, markersize=5)

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

   approach1	
end

# ╔═╡ 5d4de431-2542-4ab2-8961-ebeaf59faf77
md"""
Opt L: \$$(round(L1opt(p,w),digits=2)) 

Opt q: \$$(round(q1.(L1opt(p,w)),digits=2))
"""

# ╔═╡ 1eea4d4a-8a7d-41ed-ae04-63c9df46c885
begin
    profitspace = plot(
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
    plot!(Lvec, π1.(Lvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
 	plot!(Lvec, R1.(Lvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	 plot!(Lvec, C1.(Lvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*Lvec[end])
    ylims!(0, 1.2*maximum(R1.(Lvec,p)))
    
    # Axis labels
    annotate!(1.071*Lvec[end], 0, text(L"L", :left, :center, 12))
    annotate!(0, 1.212*maximum(R1.(Lvec,p)), text(L"$", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, L1opt(p,w)], [L"0", L"L^*"])
    yticks!([0.001, π1.(L1opt(p,w),p,w), R1.(L1opt(p,w),p),C1.(L1opt(p,w),w)], [L"0", L"\pi(L^*)", L"R(L^*)", L"C(L^*)"])

	# Key points, with dashed lines to them
    plot!([L1opt(p,w),L1opt(p,w)], [0,π1.(L1opt(p,w),p,w)], linecolor=:black, linestyle=:dash) 
    plot!([0,L1opt(p,w)], [π1.(L1opt(p,w),p,w),π1.(L1opt(p,w),p,w)], linecolor=:black, linestyle=:dash)
    scatter!([L1opt(p,w)], [π1.(L1opt(p,w),p,w)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L1opt(p,w),L1opt(p,w)], [0,R1.(L1opt(p,w),p)], linecolor=:black, linestyle=:dash) 
    plot!([0,L1opt(p,w)], [R1.(L1opt(p,w),p),R1.(L1opt(p,w),p)], linecolor=:black, linestyle=:dash)
    scatter!([L1opt(p,w)], [R1.(L1opt(p,w),p)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([L1opt(p,w),L1opt(p,w)], [0,C1.(L1opt(p,w),w)], linecolor=:black, linestyle=:dash) 
    plot!([0,L1opt(p,w)], [C1.(L1opt(p,w),w),C1.(L1opt(p,w),w)], linecolor=:black, linestyle=:dash)
    scatter!([L1opt(p,w)], [C1.(L1opt(p,w),w)], markercolor=:black, markersize=5)
	
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

   profitspace	
end

# ╔═╡ 37c89da8-345d-4ac4-9d34-94002d7cfce7
md"""
Max Profit is \$$(round(π1.(L1opt(p,w),p,w),digits=2))
"""

# ╔═╡ 5f255563-1ecb-4bc5-81a0-a2d064e35404
md"""
Approach 2
"""

# ╔═╡ 271d4721-ae6e-473e-8ef5-6723847eb92d
function L1(q)

# Define the zero condition at the parameter value supplied
cond(L) = q - q1(L)

# Specify a starting guess
L0 = .1

# Find and return the solution
L = find_zero(cond, L0)

end;

# ╔═╡ 795130d8-ffec-4f96-9e60-dd2e9e208a3d
begin #Approach 2
	π2(q,p,w) = R2(q,p) - C2(q,w)
	R2(q,p) = p * q1(L1(q))
	C2(q,w) = w * L1(q)
#_______________________________________________________________________________#
	dπ2(q,p,w) = dR2(q,p) - dC2(q,w)
	dR2(q,p) = p 
	dC2(q,w) = w * dL1(q)
	dL1(q) =  1 / (γ * (1/(L1(q)+1)))
end;

# ╔═╡ 540df8fa-e384-4b71-9f7e-f43c64dad6bf
function q2opt(p,w)

# Define the zero condition at the parameter value supplied
cond(q) = dπ2(q,p,w)

# Specify a starting guess
q0 = .01

# Find and return the solution
q = find_zero(cond, q0)

end;

# ╔═╡ 6f1feac1-42a0-4784-9e35-b8f8b3102cbd
begin
    approach2 = plot(
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
    plot!(qvec, L1.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(L1.(qvec)))
    
    # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(L1.(qvec)), text(L"L", :center, :bottom, 12))

	 # Key points, with dashed lines to them
    plot!([q2opt(p,w),q2opt(p,w)], [0,L1(q2opt(p,w))], linecolor=:black, linestyle=:dash) 
    plot!([0,q2opt(p,w)], [L1(q2opt(p,w)),L1(q2opt(p,w))], linecolor=:black, linestyle=:dash)
    scatter!([q2opt(p,w)], [L1(q2opt(p,w))], markercolor=:black, markersize=5)

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

   approach2	
end

# ╔═╡ f7892c28-d68f-4dc6-993f-04a2812273b1
md"""
Opt L: \$$(round(L1(q2opt(p,w)),digits=2)) 

Opt q: \$$(round(q2opt(p,w),digits=2))
"""

# ╔═╡ cb0e386a-f268-4f5e-801d-a31db60d75bf
begin
    profitspace2 = plot(
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
    plot!(qvec, π2.(qvec,p,w), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(qvec, R2.(qvec,p), linecolor=:green, linestyle=:solid, linewidth=2)
	plot!(qvec, C2.(qvec,w), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(R2.(qvec,p)))
    
    # Axis labels
    annotate!(1.071*qvec[end], 0, text(L"q", :left, :center, 12))
    annotate!(0, 1.212*maximum(R2.(qvec,p)), text(L"$", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, q2opt(p,w)], [L"0", L"q^*"])
    yticks!([0.001, π2.(q2opt(p,w),p,w), R2.(q2opt(p,w),p),C2.(q2opt(p,w),w)], [L"0", L"\pi(q^*)", L"R(q^*)", L"C(q^*)"])

	# Key points, with dashed lines to them
    plot!([q2opt(p,w),q2opt(p,w)], [0,π2.(q2opt(p,w),p,w)], linecolor=:black, linestyle=:dash) 
    plot!([0,q2opt(p,w)], [π2.(q2opt(p,w),p,w),π2.(q2opt(p,w),p,w)], linecolor=:black, linestyle=:dash)
    scatter!([q2opt(p,w)], [π2.(q2opt(p,w),p,w)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q2opt(p,w),q2opt(p,w)], [0,R2.(q2opt(p,w),p)], linecolor=:black, linestyle=:dash) 
    plot!([0,q2opt(p,w)], [R2.(q2opt(p,w),p),R2.(q2opt(p,w),p)], linecolor=:black, linestyle=:dash)
    scatter!([q2opt(p,w)], [R2.(q2opt(p,w),p)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([q2opt(p,w),q2opt(p,w)], [0,C2.(q2opt(p,w),w)], linecolor=:black, linestyle=:dash) 
    plot!([0,q2opt(p,w)], [C2.(q2opt(p,w),w),C2.(q2opt(p,w),w)], linecolor=:black, linestyle=:dash)
    scatter!([q2opt(p,w)], [C2.(q2opt(p,w),w)], markercolor=:black, markersize=5)

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

   profitspace2	
end

# ╔═╡ ad6e8ab3-d784-4464-b0b2-20c78d1d4030
md"""
Max Profit is \$$(round(π2(q2opt(p,w),p,w),digits=2))
"""

# ╔═╡ a8919823-fd20-4733-a297-97fa84af4675
md"""
As we see these two approaches yield identical results. We can now plot the comparative statics for both approaches.
"""

# ╔═╡ d6022d03-1101-48f4-ad22-ee4c92f3648e
md"""
Approach 1
"""

# ╔═╡ 2470be3f-0239-4754-adb0-43cbdfca0752
wvec = collect(range(.01, 25, length=101));

# ╔═╡ b11b07dd-d6bd-45c2-98b2-8cf4fe2391b1
pvec = collect(range(2, 25, length=101));

# ╔═╡ 33c6c28f-7094-46b9-b876-065e3c439387
begin
    compstatwagelabor = plot(
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
    plot!(wvec, L1opt.(p,wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.05*wvec[end])
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.071*wvec[end], text(L"L^*", :center, :bottom, 12))

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

   compstatwagelabor	
end

# ╔═╡ b3732252-dacf-43dd-b36b-b0954f9ebece
begin
    compstatpricelabor = plot(
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
    plot!(pvec, L1opt.(pvec,w), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*pvec[end])
   ylims!(0, 1.05*pvec[end])
    
    # Axis labels
    annotate!(1.071pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.071*pvec[end], text(L"L^*", :center, :bottom, 12))

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

   compstatpricelabor	
end

# ╔═╡ c8198214-c250-470b-8cea-59f3a40d3526
md"""
Approach 2
"""

# ╔═╡ 3185bba9-f3e1-4fb4-8a6a-63f8950eb6e3
begin
    compstatwageproduct = plot(
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
    plot!(wvec, q2opt.(p,wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.05*wvec[end])
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.071*wvec[end], text(L"q^*", :center, :bottom, 12))

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

   compstatwageproduct	
end

# ╔═╡ b35ddb7b-8c31-4598-b64a-201d50a406c5
begin
    compstatpriceproduct = plot(
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
    plot!(pvec, q2opt.(pvec,w), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*pvec[end])
   ylims!(0, 1.05*pvec[end])
    
    # Axis labels
    annotate!(1.071pvec[end], 0, text(L"p", :left, :center, 12))
    annotate!(0, 1.071*pvec[end], text(L"q^*", :center, :bottom, 12))
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

   compstatpriceproduct	
end

# ╔═╡ Cell order:
# ╠═e4029728-c7a5-11ef-2f04-3731ad5737c2
# ╠═af3eeddd-db7e-447b-9f6b-a02b868fbcff
# ╟─235a0ff9-3f3a-4dd7-950e-6fd7e6a08dc3
# ╟─684303da-aded-4910-9d4a-9a82e6c5fd43
# ╟─28bc23ca-9ed1-452b-b604-7dbf4d21a93b
# ╟─7d8f241d-6d1d-43df-8abc-a1274c7dcb20
# ╟─d09f799f-1a0d-4124-9938-64eae7fe00c5
# ╟─d11bda3b-89c1-4c9d-97dd-e45bc6faa095
# ╟─4e878a78-d4c4-43e1-963f-382fd7660b27
# ╟─14ae1b31-b612-4972-a72a-e36aedc2fe21
# ╟─91687827-b6c8-4583-a16f-cce4424451b5
# ╟─d50cc984-1fdc-4112-a4b6-961af9ee326c
# ╟─611a5bba-5199-4668-a678-e4fbd8651627
# ╟─48e54957-9bf6-4a21-b2b1-ad695d60a625
# ╠═1ff0fbad-51ec-4f1b-8aef-e6a23ae6d8bf
# ╠═1a7dc6c4-f988-4c89-adcb-04853ceef531
# ╠═5de4f47b-8b8b-4926-8040-7483e5d9a14f
# ╠═1d4b0fd2-f90a-4041-8ce4-8c2cac9231a7
# ╟─b4524aa0-388c-4bec-864d-d7b28a216145
# ╟─6be045b3-aece-45a1-ab2a-70cc066273de
# ╟─9ee681f4-3d5c-4a24-9724-7b8fede15734
# ╠═2a970579-76ca-4bfa-b6b9-629792b135b9
# ╟─8c581595-3773-4f16-830b-18c0dfe53ef9
# ╟─e1ecd956-b57e-4fe9-8f65-8b95a23512b1
# ╟─c793c155-f286-4015-86a4-daa6091cdd37
# ╟─9ac77336-7dd3-405f-b7ef-8b10fab5faf3
# ╟─ceb20fbe-ee6d-4c8c-9268-1fa1d4389ca8
# ╟─a938b940-865b-4fb4-b7d4-6e000851b1e4
# ╟─13e90b74-8004-46b5-83f1-47365deb1023
# ╟─2d1e51fb-c08b-41ef-bbc3-d072bdc2f770
# ╠═c62b33bf-4209-4168-94fb-7cf684c95cc6
# ╠═41f91c7f-0827-42d4-8f12-e7a8b3668b51
# ╟─8dcaa181-136d-4860-b20a-8418eaa34b1e
# ╟─c7f55896-1b30-4aec-88e2-00ae2573aa41
# ╠═a3504496-8dbd-47ba-86f5-1cfee30f4d67
# ╟─6efef79c-c9fa-4a6a-a89f-06c1e85d391d
# ╟─800d7818-369b-4c5e-b54d-db5b28056705
# ╟─1ac85ee4-a002-4152-b845-dfcc74808471
# ╟─2472e362-ebcc-451f-8048-fe8c5127ecb0
# ╠═62fa4c64-a701-499f-8095-b7316debbb45
# ╟─87338bde-e7b3-4ae9-9d55-c5eeec430ec7
# ╟─b43aeebd-4b19-4d0f-b19c-eec2fe133031
# ╟─67ca75ac-968e-4b64-9043-f5c12b771cb6
# ╟─7816270d-2e2d-4de3-8ab0-c3fc56968d7b
# ╟─0694b824-84fa-4663-8fdc-8383c1415625
# ╟─1cf2b16a-3f59-4289-bfff-bb1a251646fa
# ╠═881bbc7b-8016-4b8a-9cf1-a56bd4b172bc
# ╠═226cae7b-7eca-48b4-94ee-3a96ecbbe7e5
# ╟─0c339fa4-0355-414b-aaa2-63bdf3681894
# ╟─d718841a-47b7-49ea-88fa-64721541d982
# ╟─5d4de431-2542-4ab2-8961-ebeaf59faf77
# ╠═fbb1c4b3-467e-4e78-b74a-97682dcefc1f
# ╟─1eea4d4a-8a7d-41ed-ae04-63c9df46c885
# ╟─37c89da8-345d-4ac4-9d34-94002d7cfce7
# ╟─5f255563-1ecb-4bc5-81a0-a2d064e35404
# ╠═271d4721-ae6e-473e-8ef5-6723847eb92d
# ╠═795130d8-ffec-4f96-9e60-dd2e9e208a3d
# ╠═540df8fa-e384-4b71-9f7e-f43c64dad6bf
# ╟─6f1feac1-42a0-4784-9e35-b8f8b3102cbd
# ╟─f7892c28-d68f-4dc6-993f-04a2812273b1
# ╟─cb0e386a-f268-4f5e-801d-a31db60d75bf
# ╟─ad6e8ab3-d784-4464-b0b2-20c78d1d4030
# ╟─a8919823-fd20-4733-a297-97fa84af4675
# ╟─d6022d03-1101-48f4-ad22-ee4c92f3648e
# ╠═2470be3f-0239-4754-adb0-43cbdfca0752
# ╠═b11b07dd-d6bd-45c2-98b2-8cf4fe2391b1
# ╟─33c6c28f-7094-46b9-b876-065e3c439387
# ╟─b3732252-dacf-43dd-b36b-b0954f9ebece
# ╟─c8198214-c250-470b-8cea-59f3a40d3526
# ╟─3185bba9-f3e1-4fb4-8a6a-63f8950eb6e3
# ╟─b35ddb7b-8c31-4598-b64a-201d50a406c5
