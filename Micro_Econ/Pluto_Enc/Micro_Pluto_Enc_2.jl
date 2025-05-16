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

# ╔═╡ d703ad84-c20f-11ef-244e-ab1cddc07ff1
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
      #using Printf #allows you to use sprintf
end

# ╔═╡ 2ed0df42-3cfd-4bda-8f8c-5f1d19ed6f9c
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 5e796460-898b-4d12-a55f-01b12a872e0e
md"""
# Micro Pluto Encyclopedia
"""

# ╔═╡ 1d8741da-fc29-4785-8ce3-1df711e2d86d
md"""
Indifference Curves, budget constraint, basic consumer problem.
"""

# ╔═╡ 54b656f2-7be5-403a-90e0-df02acf11a90
md"""
## Vanilla Consumer Problem
"""

# ╔═╡ de65ffbf-de6e-4493-b601-16b7f62fcd12
md"""
For a very simplified consumer who has an Income $I$ and is looking to spend all that income on two goods, $x_1$ and $x_2$, he will have a budget constraint

$\begin{equation*}
  I = p_1 \cdot x_1 + p_2 \cdot x_2.
\end{equation*}$
For a very simple problem like this it would be easy to solve for $x_2$ explicitly

$\begin{equation*}
  x_2 = \dfrac{I-p_1 \cdot x_1}{p_2},
\end{equation*}$
but we can also solve $x_2$ implicitly by taking the budget constraint and substracting the right-hand side 

$\begin{equation*}
  I - p_1 \cdot x_1 - p_2 \cdot x_2 = 0
\end{equation*}$
which can be used to define any variable in terms of the other four,

$\begin{equation*}
  \hat{x}_2 = \hat{x}_2(I,p_1,p_2,x_1).
\end{equation*}$
We will now show this graphically.
"""

# ╔═╡ 4f4c12fb-e258-42ac-afab-b58cbfb65deb
begin #constraints
	I_1 = 120
	p1 = 15
	p2 = 20
end;

# ╔═╡ 37125c83-6f1a-48cb-a495-e39f5a6c8501
begin #Equations
	I(x1,x2) = p1 * x1 + p2 * x2
	x2(x1) = (I_1 - p1 * x1) / p2
end;

# ╔═╡ f8176995-6fca-4827-9c6a-cedba01172f0
x1vec = collect(range(0.1, 20, length=101));

# ╔═╡ 87ded16f-72d0-41b3-890a-be14d97d8990
function x2hat(x1)

# Define the zero condition at the parameter value supplied
cond(x2) = I_1 - I(x1,x2)

# Specify a starting guess
x20 = 20

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ 084adad9-a8e1-4d86-860d-69d6b6e90de9
md"Check Implicit Function: $(@bind impfunc CheckBox(default=false))"

# ╔═╡ d5010981-9bed-4284-9b06-09daae82ca85
begin
    budgetconstraint = plot(
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
    plot!(x1vec, x2.(x1vec), linecolor=:black, linestyle=:solid, linewidth=2)

	if impfunc == true
	plot!(x1vec, x2hat.(x1vec), linecolor=:blue, linestyle=:solid, linewidth=2)
	end

	# Axis labels
    annotate!(1.1*x1vec[end], 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 1.2*maximum(x2.(x1vec)), text(L"x_2", :center, :bottom, 12))
	# Axis limits
    xlims!(0, 1.05*x1vec[end])
    ylims!(0, 1.2*maximum(x2.(x1vec)))
	
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

   budgetconstraint	
end

# ╔═╡ 683a40d3-aae7-4f90-89c9-86fc9750f000
md"""
This acts as a visualization for the consumer's budget constraint, where they can pick any combination along that line and it will cost all of their income. Additionally we can say that a consumer will generate a certain amount of utility from their consumption of products $x_1$ and $x_2$, a very simple utility function is a cobb-douglas utility function

$\begin{equation*}
  U(x_1,x_2) = x_1^α * x_2^{1-α}
\end{equation*}$
where $α$ acts as an elsasticity of substitution parameter where the higher $α$ is the more utility is had from $x_1$ and vice versa. Utility is essentially a madeup concept, one that I personally hate along with a bunch of other stuff in theoretical econ but I'll save that for later, so we need to specify a certain level of utility, $k$, to which is produced by consuming different amounts of $x_1$ and $x_2$.
"""

# ╔═╡ 75580318-4f23-4c15-8614-d39c9892fd27
k = @bind k Slider(1.0:1:20, default=5, show_value=true)

# ╔═╡ f9056cd6-1a30-418e-9524-8ec2b52df675
md"""
If you look at the graph above we see that higher levels of utility $k$ corresponds to higher amounts of consumptions for both goods, additionally if you look we see that the curves are evenly distributed. If you adjust the level of utility $k$ the curve will shift right into higher and higher amounts of products and if you change $α$ the shape of the curves will change. The higher you make $α$ there would need to be considerable increases in $x_2$ consumption in order to make up for losses in $x_1$. Vice versa if you make $α$ smaller. It is because of this that these curves are called indifference curves because they represent a combination of goods that the consumer is indifferent towards at a certin utility. As we will show later, utility curves are important in consumer theory to show where the optimal combination of goods will be to maximize utility.
"""

# ╔═╡ cbbbcec6-bcfb-4625-8200-59a8b30c8f9f
md"""
Take a conusmer that is trying to maximize utility subject to a utility function and a budget constraint,

$\begin{equation*}
  \max_{U,x_1,x_2} U
\end{equation*}$
subject to 

$\begin{align*}
  U &= x_1^α \cdot x_2^{1-α} \\
I &= p_1 \cdot x_1 + p_2 \cdot x_2
\end{align*}$
this optimization problem can be recuded to 

$\begin{equation*}
  \max_{x_1,x_2} U = x_1^α \cdot x_2^{1-α}
\end{equation*}$
subject to 

$\begin{equation*}
I = p_1 \cdot x_1 + p_2 \cdot x_2
\end{equation*}$
Value $I$ is just a parameter that is chosen exogenously meaning we can subtract the right-hand side from it to get

$\begin{equation*}
I - p_1 \cdot x_1 - p_2 \cdot x_2 = 0
\end{equation*}$
which by the implicit function theorem can be used to implicitly define $x_2$

$\begin{equation*}
  \hat{x}_2 = \hat{x}_2(x_1)
\end{equation*}$
where we drop the arguments of $I$, $p_1$, and $p_2$ as being understood since they are exogenous parameters. We can then substitute this implictly define variable into the optimization problem to get the unconstrained problem 

$\begin{equation*}
  \max_{x_1} U = x_1^α \cdot \hat{x}_2(x_1)^{1-α}
\end{equation*}$
where the only endogenous variable left is $x_1$. The first-order condition for this problem is 

$\begin{equation*}
  \dfrac{dU}{dx_1} = α \cdot x_1^{α-1} \cdot \hat{x}_2(x_1)^{1-α} +  x_1^α \cdot (1-α)\cdot \hat{x}_2(x_1)^{-α} \cdot \dfrac{d\hat{x}_2}{dx_1}=0
\end{equation*}$
In order to find the derivative of $\hat{x}_2$ with respect to $x_1$ we need to use the implicit function theorem

$\begin{equation*}
  \dfrac{d\hat{x}_2}{dx_1} = - \dfrac{p_1}{p_2},
\end{equation*}$
substituting this into the first-order condition results in

$\begin{align*}
  \dfrac{dU}{dx_1} &= α \cdot x_1^{α-1} \cdot \hat{x}_2(x_1)^{1-α} +  x_1^α \cdot (1-α)\cdot \hat{x}_2(x_1)^{-α} \cdot -\dfrac{p_1}{p_2}=0 \\
&= α \cdot x_1^{α-1} \cdot \hat{x}_2(x_1)^{1-α} -  x_1^α \cdot (1-α)\cdot \hat{x}_2(x_1)^{-α} \cdot \dfrac{p_1}{p_2}=0
\end{align*}$
So long as the second-order condition holds, then this combination of good $x_1$ and $x_2$ specifies a local maximum.
"""

# ╔═╡ 34770556-4647-4e34-94e1-a1728b93026d
md"""
Additionally we can reinterpret this first-order condition as 

$\begin{equation*}
  U(x_1,\hat{x}_2) = x_1^α \cdot \hat{x}_2^{1-α}
\end{equation*}$
where the partial derivative with respect to to the first argument $x_1$ is 

$\begin{equation*}
  U_1(x_1,\hat{x}_2) = α \cdot x_1^{α-1} \cdot \hat{x}_2^{1-α}
\end{equation*}$
and the partial derivative with respect to the second argument $x_2$ is 

$\begin{equation*}
   U_2(x_1,\hat{x}_2) = x_1^α \cdot (1-α) \cdot \hat{x}_2^{-α}
\end{equation*}$
so the first-order condition can be interpreted as

$\begin{align*}
  \dfrac{dU}{dx_1} &= U_1 + U_2 \cdot \dfrac{d\hat{x}_2}{dx_1} = 0 \\
&= U_1 - U_2 \cdot \dfrac{p_1}{p_2} = 0 \\
& \Rightarrow \dfrac{U_1}{U_2} = \dfrac{p_1}{p_2}
\end{align*}$
which yields this usual result from intermediate micro.
"""

# ╔═╡ f8d4ecc5-f9d4-4c37-b3e9-2a1fbf53ed48
md"""
A way to visualize the consumer's optimization problem is to see the constraints and the indifference curves on the same plane,
"""

# ╔═╡ 7aaf8c7d-71d2-4a23-907e-b022c1dd028f
begin
	x2_c(x1,I_c) = (I_c - p1 * x1) / p2
end;

# ╔═╡ 7be6f0cf-21a6-497c-ad96-1323798021b0
md"""
where the black lines represent different budget constraints where the more to the right the line the higher the budget. The solution to the vanillia consumer optimization problem is to find where the budget constraint is tangent with the higher indifference curve and that will maximize the consumer's utility subject to his constraint.
"""

# ╔═╡ 3af315b7-8392-474d-8922-4ce8b3c512e5
α = @bind α confirm(Slider(0.1:0.1:.7, default=0.5, show_value=true))

# ╔═╡ d9b600e8-e13c-4285-b57e-83d0ce9228c4
begin
U(x1,x2) = x1^α * x2^(1-α) #utility function
end;

# ╔═╡ bf05fcb5-6f09-45b4-b705-603334cef8f3
function Util(x1,k)

# Define the zero condition at the parameter value supplied
cond(x2) = U(x1,x2) - k

# Specify a starting guess
x20 = .1

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ f66d7212-f736-405b-9506-efebd7e2519c
begin
    utilitygraph = plot(
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
    plot!(x1vec, Util.(x1vec,3), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,6), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,9), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,12), linecolor=:gray, linestyle=:solid, linewidth=2)

	plot!(x1vec, Util.(x1vec,k), linecolor=:black, linestyle=:solid, linewidth=2)

	#arrow
	 plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)


	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(20.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))
	
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

   utilitygraph	
end

# ╔═╡ aa466562-dcc1-40e4-b1bd-f277659bcd09
begin
    utilitygraphc = plot(
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
    plot!(x1vec, Util.(x1vec,3), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,6), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,9), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,12), linecolor=:gray, linestyle=:solid, linewidth=2)

	#Constraints
	plot!(x1vec, x2_c.(x1vec,100), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2_c.(x1vec,200), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2_c.(x1vec,300), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, x2_c.(x1vec,400), linecolor=:black, linestyle=:solid, linewidth=2)

	#arrow
	 plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)

	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(20.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))
	
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

   utilitygraphc
end

# ╔═╡ e310112d-94c9-417f-b67e-e007108cb9e0
begin
	x2_star(x1,I_star) = (I_star - p1 * x1) / p2 #budget constraint
	U_1(x1,I_star) = α * x1^(α-1) * x2_star(x1,I_star)^(1-α) 
	U_2(x1,I_star) = x1^α * (1-α) * x2_star(x1,I_star)^(-α)
	dx2 = -p1/p2
	dU(x1,I_star) = U_1(x1,I_star) + U_2(x1,I_star) * dx2 
end;

# ╔═╡ 6ed2b882-7230-4b5a-b114-deb9aff08846
function vanillia_cons(I_star) #discover the x1 that satisfies the first-order conditions

# Define the zero condition at the parameter value supplied
cond(x1) = dU(x1,I_star)

# Specify a starting guess
x10 = .1

# Find and return the solution
x1 = find_zero(cond, x10)

end;

# ╔═╡ 803fec4f-5998-4baf-b06b-08bc37b8f072
function Util2(I_star) #Using that x1 we can find k because x2 is implicitly defined by x1

# Define the zero condition at the parameter value supplied
cond(k) = U(vanillia_cons(I_star),x2_star(vanillia_cons(I_star),I_star)) - k

# Specify a starting guess
k0 = .1

# Find and return the solution
k = find_zero(cond, k0)

end; 
	

# ╔═╡ dc8cb167-5edd-4d05-be6b-8265678514f1
I_star = @bind I_star Slider(100.0:10.0:400, default=120, show_value=true)

# ╔═╡ f0380574-ac39-4612-bfda-d927ae67139b
begin
    utilitygraphstar = plot(
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
    plot!(x1vec, Util.(x1vec,3), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,6), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,9), linecolor=:gray, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,12), linecolor=:gray, linestyle=:solid, linewidth=2)

	#Constraints
	plot!(x1vec, x2_star.(x1vec,I_star), linecolor=:black, linestyle=:solid, linewidth=2)

	#arrow
	 plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)

	#solution
    plot!(x1vec, Util.(x1vec,Util2(I_star)), linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them
    plot!([vanillia_cons(I_star),vanillia_cons(I_star)], [0,x2_star(vanillia_cons(I_star),I_star)], linecolor=:black, linestyle=:dash) 
    plot!([0,vanillia_cons(I_star)], [x2_star(vanillia_cons(I_star),I_star),x2_star(vanillia_cons(I_star),I_star)], linecolor=:black, linestyle=:dash)
    scatter!([vanillia_cons(I_star)], [x2_star(vanillia_cons(I_star),I_star)], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, vanillia_cons(I_star)], [L"0", L"x_1^*"])
    yticks!([0.001, x2_star(vanillia_cons(I_star),I_star)], [L"0",L"x_2^*"])

	
	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(20.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))
	
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

   utilitygraphstar
end

# ╔═╡ 242dcd33-89cd-46d0-92f5-c9273e92bf52
md"""
What we have done graphically is a confirmation of what we proved analytically, if the first-order condition establishes a maximum then there is an $x_1$ value that will satisfy it, and once we know that $x_1$ we can discover what that $k$ is because $x_2$ is implicitly defined by $x_1$. And once we know that k value we can discover the maximum utility curve that satisfies the consumer's conditions, and that curve will be tangent with the budget constraint.
"""

# ╔═╡ c1153e02-c54f-42fe-8ab3-4eaf5083e631
md"""
Additionally another way to plot indifference curves is through the contour command, where instead of plotting the curves by implicitly defining $x_2$ we can do it by running both an $x_1$ and $x_2$ vector through the original equation and defining what the output should be.
"""

# ╔═╡ d5a16c57-2fc7-491d-bb9f-9b264c9e7a18
begin
    indifferencecontour = plot(
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
    #plot!(xVec, f.(xVec), linecolor=:black, linestyle=:solid, linewidth=2)
	contour!(x1vec, x1vec, U, levels=(3:3:12), linewidth=2, linecolor=:gray, clabels=true)

	#Constraints
	plot!(x1vec, x2_star.(x1vec,I_star), linecolor=:black, linestyle=:solid, linewidth=2)

	#solution 
	contour!(x1vec, x1vec, U, levels=[Util2(I_star)], linecolor=:black, linewidth=2, clabels=true)

	#arrow
	 plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)

	# Key points, with dashed lines to them
    plot!([vanillia_cons(I_star),vanillia_cons(I_star)], [0,x2_star(vanillia_cons(I_star),I_star)], linecolor=:black, linestyle=:dash) 
    plot!([0,vanillia_cons(I_star)], [x2_star(vanillia_cons(I_star),I_star),x2_star(vanillia_cons(I_star),I_star)], linecolor=:black, linestyle=:dash)
    scatter!([vanillia_cons(I_star)], [x2_star(vanillia_cons(I_star),I_star)], markercolor=:black, markersize=5)

	# Axis ticks
    xticks!([0.001, vanillia_cons(I_star)], [L"0", L"x_1^*"])
    yticks!([0.001, x2_star(vanillia_cons(I_star),I_star)], [L"0",L"x_2^*"])

	
	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(20.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))
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

   indifferencecontour	
end

# ╔═╡ 2d85c122-fce7-4de8-b85c-0687c2a58d3a
md"""
Here we see the indifference curves with the particular level of utility indicated on the curve.
"""

# ╔═╡ 3274b4c2-57e3-48d1-9992-f204f21de240
md"""
## Practice Problems
"""

# ╔═╡ 6ac204ff-5d8e-425a-ab6b-38aab0560ceb
md"""
Practice Problems
 * plot x1*(p1,p2,I) against p1, at two values of p2
  * plot x1*(p1,p2,I) against p2, at two values of p1
  * plot x1*(p1,p2,I) against  I, at two values of p1
  * plot the p1, p2, and I expansion paths for x1* in (x1,x2) space
  * plot V(p1,p2,I) againts p1, p2, I

"""

# ╔═╡ baeb723a-124d-43e8-950f-956a2964844a
md"""
Practice Problem 1:
Above we had used the vanillia_cons(I_star) function to implicitly define $x_1^*$ in terms of the income which we put on a slider. We did this by defining the first-order condition to be a function of just $x_1$ and income; however, we could also have included both $p_1$ and $p_2$ as variables. Below we rewrite the block of equations to incorporate this and then show what happens when we plot $x_1^*$($p_1$,$p_2$,I) against $p_1$, at two values of $p_2$. 
"""

# ╔═╡ 36e996c6-157d-40bc-a297-f5441e51f18f
begin
	x2_e(x1,I_e, p1, p2) = (I_e - p1 * x1) / p2 
	U_1e(x1,I_e,p1,p2) = α * x1^(α-1) * x2_e(x1,I_e,p1,p2)^(1-α) 
	U_2e(x1,I_e,p1,p2) = x1^α * (1-α) * x2_e(x1,I_e,p1,p2)^(-α)
	dx2_e(p1,p2) = -p1/p2
	dU_e(x1,I_e,p1,p2) = U_1e(x1,I_e,p1,p2) + U_2e(x1,I_e,p1,p2) * dx2_e(p1,p2) 
end;

# ╔═╡ e3dd6c32-64df-4fe2-bbaa-194b4f1051ce
function x1_stare(I_e,p1,p2)

# Define the zero condition at the parameter value supplied
cond(x1) = dU_e(x1,I_e,p1,p2)

# Specify a starting guess
x10 = 1

# Find and return the solution
x1 = find_zero(cond, x10)

end;

# ╔═╡ 06234055-fd64-40e9-9e49-a2e9828b2922
p1vec = collect(range(1, 25, length=101));

# ╔═╡ 5aeb4645-b9af-4f51-85fc-fac8dc9aead3
p2e = 10 #different value of p2 from our original;

# ╔═╡ 0740ead8-a648-4e04-99f6-c2592c9d53c9
md"Plot Different $p_2$: $(@bind p2plot CheckBox(default=false))"

# ╔═╡ ba44a1f6-0dcd-4558-ae66-656d1c4b3851
begin
    diffpgraph = plot(
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
    plot!(x1_stare.(I_1,p1vec,p2), p1vec, linecolor=:black, linestyle=:solid, linewidth=2)

	if p2plot == true
		 plot!(x1_stare.(I_1,p1vec,p2e), p1vec, linecolor=:red, linestyle=:solid, linewidth=2)
	end
	
	# Axis labels
    annotate!(26, .5, text(L"x_1^*", :left, :center, 12))
    annotate!(0, 25, text(L"p_1", :center, :bottom, 12))
	# Axis limits
    xlims!(0, 25)
    ylims!(0, 25)
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

   diffpgraph	
end

# ╔═╡ bd1e6f02-3ba3-498f-8790-0d710d770250
md"""
Here we see that there is no difference in the optimal amount of good $x_1^*$ to but when the price of $p_2$ changes. That is not the case when we plot $x_1^*$(p1,p2,I) against $p_2$, at two values of $p_1$.
"""

# ╔═╡ e8d22c27-d01d-413d-a54b-284d9f945f2c
p2vec = copy(p1vec);

# ╔═╡ 4da1368e-d6a8-4b7b-b903-cf7d79a35cb0
md"Plot Different $p_1$: $(@bind p1plot CheckBox(default=false))"

# ╔═╡ 53190315-8ac1-40e0-a297-da7ebe65dc1b
p1e = @bind p1e Slider(1.0:0.1:40, default=20, show_value=true)

# ╔═╡ ac1b983e-6285-472e-bb5e-001e7052d7af
begin
    diffp1graph = plot(
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
    plot!(x1_stare.(I_1,p1,p2vec), p2vec, linecolor=:black, linestyle=:solid, linewidth=2)
	if p1plot == true
		plot!(x1_stare.(I_1,p1e,p2vec), p2vec, linecolor=:red, linestyle=:solid, linewidth=2)
	end
	 # Axis labels
    annotate!(26, .5, text(L"x_1^*", :left, :center, 12))
    annotate!(0, 25, text(L"p_2", :center, :bottom, 12))
	 # Axis limits
    xlims!(0, 25)
    ylims!(0, 25)

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

   diffp1graph	
end

# ╔═╡ c7efc79a-da6e-4fd6-8ec8-a95ada2c7d20
md"""
Here we see that like before there is no difference in the optimal amount of good 1 the conusmer will purchase when $p_2$ changes, but there is a change when $p_1$ changes. Below we see how the consumption of $x_1^*$ changes with income as $p_1$ changes.
"""

# ╔═╡ 0afafe05-8bd6-463a-99a1-518c4a33baca
Ivec = collect(range(100, 400, length=101));

# ╔═╡ 52a85b4e-61df-4f0f-bdac-0533a1aea563
md"Plot Different $p_1$: $(@bind p1plotI CheckBox(default=false))"

# ╔═╡ 00cdb5e1-9a51-48e6-9063-a7a7fc7d5e36
begin
    diffIgraph = plot(
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
    plot!(x1_stare.(Ivec,p1,p2), Ivec, linecolor=:black, linestyle=:solid, linewidth=2)

	if p1plotI == true
	plot!(x1_stare.(Ivec,p1e,p2), Ivec, linecolor=:red, linestyle=:solid,linewidth=2)
	end

	# Axis limits
    xlims!(0, 25)
    ylims!(0, 300)
    
    # Axis labels
    annotate!(26, 0, text(L"x_1^*", :left, :center, 12))
    annotate!(0, 300, text(L"I", :center, :bottom, 12))
	
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

   diffIgraph	
end

# ╔═╡ 352e1069-3271-4181-9f5c-e765388838cb
md"""
Below we will plot the $p_1$, $p_2$, and I expansion paths for $x_1^*$ in $(x_1,x_2)$ space
"""

# ╔═╡ c8faf214-fa5f-4bec-80f2-26e15b8116b8
function Util2_e(I_e,p1,p2) #Using that x1 we can find k because x2 is implicitly defined by x1

# Define the zero condition at the parameter value supplied
cond(k) = U(x1_stare(I_e,p1,p2),x2_e(x1_stare(I_e,p1,p2),I_e, p1, p2)) - k

# Specify a starting guess
k0 = .1

# Find and return the solution
k = find_zero(cond, k0)

end;

# ╔═╡ 290bd325-e82c-43da-9664-c17428693585
begin
    expansionp1 = plot(
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
    plot!(x1vec, Util.(x1vec,Util2_e(I_1,10,p2)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(I_1,20,p2)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(I_1,30,p2)), linecolor=:black, linestyle=:solid, linewidth=2)

	#budget constraints
	plot!(x1vec,x2_e.(x1vec,I_1, 10, p2), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,I_1, 20, p2), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,I_1, 30, p2), linecolor=:black, linestyle=:solid, linewidth=2)

	  # Key points, with dashed lines to them
    plot!([x1_stare(I_1,10,p2),x1_stare(I_1,10,p2)], [0,x2_e.(x1_stare(I_1,10,p2),I_1, 10, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,10,p2)], [x2_e.(x1_stare(I_1,10,p2),I_1, 10, p2),x2_e.(x1_stare(I_1,10,p2),I_1, 10, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,10,p2)], [x2_e.(x1_stare(I_1,10,p2),I_1, 10, p2)], markercolor=:black, markersize=5)
	  # Key points, with dashed lines to them
    plot!([x1_stare(I_1,20,p2),x1_stare(I_1,20,p2)], [0,x2_e.(x1_stare(I_1,20,p2),I_1, 20, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,20,p2)], [x2_e.(x1_stare(I_1,20,p2),I_1, 20, p2),x2_e.(x1_stare(I_1,20,p2),I_1, 20, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,20,p2)], [x2_e.(x1_stare(I_1,20,p2),I_1, 20, p2)], markercolor=:black, markersize=5)
	 # Key points, with dashed lines to them
    plot!([x1_stare(I_1,30,p2),x1_stare(I_1,30,p2)], [0,x2_e.(x1_stare(I_1,30,p2),I_1, 30, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,30,p2)], [x2_e.(x1_stare(I_1,30,p2),I_1, 30, p2),x2_e.(x1_stare(I_1,30,p2),I_1, 30, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,30,p2)], [x2_e.(x1_stare(I_1,30,p2),I_1, 30, p2)], markercolor=:black, markersize=5)

	#arrow
	 plot!([18,18],[18,14], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([18,15],[18,18], arrow=(:closed, 2.0),linecolor=:black)

	 # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(21, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))

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

   expansionp1	
end

# ╔═╡ f2e9467e-ec91-493e-b6a4-dc3aae02c0a1
md"""
In the above graph the higher the price of good 1 the less the consumer will purchase.
"""

# ╔═╡ 5f5f679a-989c-4eb9-9532-f20581f05ac1
begin
    expansionp2 = plot(
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
    plot!(x1vec, Util.(x1vec,Util2_e(I_1,p1,10)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(I_1,p1,20)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(I_1,p1,30)), linecolor=:black, linestyle=:solid, linewidth=2)

	#budget constraints
	plot!(x1vec,x2_e.(x1vec,I_1, p1, 10), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,I_1, p1, 20), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,I_1, p1, 30), linecolor=:black, linestyle=:solid, linewidth=2)

	#arrow
	 plot!([18,18],[18,14], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([18,15],[18,18], arrow=(:closed, 2.0),linecolor=:black)

	  # Key points, with dashed lines to them
    plot!([x1_stare(I_1,p1,10),x1_stare(I_1,p1,10)], [0,x2_e.(x1_stare(I_1,p1,10),I_1, p1, 10)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,p1,10)], [x2_e.(x1_stare(I_1,p1,10),I_1, p1, 10),x2_e.(x1_stare(I_1,p1,10),I_1, p1, 10)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,p1,10)], [x2_e.(x1_stare(I_1,p1,10),I_1, p1, 10)], markercolor=:black, markersize=5)
	  # Key points, with dashed lines to them
    plot!([x1_stare(I_1,p1,20),x1_stare(I_1,p1,20)], [0,x2_e.(x1_stare(I_1,p1,20),I_1, p1, 20)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,p1,20)], [x2_e.(x1_stare(I_1,p1,20),I_1, p1, 20),x2_e.(x1_stare(I_1,p1,20),I_1, p1, 20)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,p1,20)], [x2_e.(x1_stare(I_1,p1,20),I_1, p1, 20)], markercolor=:black, markersize=5)
	 # Key points, with dashed lines to them
    plot!([x1_stare(I_1,p1,30),x1_stare(I_1,p1,30)], [0,x2_e.(x1_stare(I_1,p1,30),I_1, p1, 30)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(I_1,p1,30)], [x2_e.(x1_stare(I_1,p1,30),I_1, p1, 30),x2_e.(x1_stare(I_1,p1,30),I_1, p1, 30)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(I_1,p1,30)], [x2_e.(x1_stare(I_1,p1,30),I_1, p1, 30)], markercolor=:black, markersize=5)

	 # Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(21, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))

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

   expansionp2
end

# ╔═╡ feaad82d-da68-44e8-8c87-6f56002a9b6c
md"""
Similarly, the higher the price of good 2 the less the conusumer will pruchase. Below is the expansion path for income.
"""

# ╔═╡ 79fef477-9aa1-4b65-8301-b7bcf19a008a
begin
    expansionI = plot(
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
    plot!(x1vec, Util.(x1vec,Util2_e(100,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(200,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec, Util.(x1vec,Util2_e(300,p1,p2)), linecolor=:black, linestyle=:solid, linewidth=2)

	#budget constraints
	plot!(x1vec,x2_e.(x1vec,100, p1, p2), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,200, p1, p2), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(x1vec,x2_e.(x1vec,300, p1, p2), linecolor=:black, linestyle=:solid, linewidth=2)

	#arrow
	 plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)

	  # Key points, with dashed lines to them
    plot!([x1_stare(100,p1,p2),x1_stare(100,p1,p2)], [0,x2_e.(x1_stare(100,p1,p2),100, p1, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(100,p1,p2)], [x2_e.(x1_stare(100,p1,p2),100, p1, p2),x2_e.(x1_stare(100,p1,p2),100, p1, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(100,p1,p2)], [x2_e.(x1_stare(100,p1,p2),100, p1, p2)], markercolor=:black, markersize=5)
	
	  # Key points, with dashed lines to them
    plot!([x1_stare(200,p1,p2),x1_stare(200,p1,p2)], [0,x2_e.(x1_stare(200,p1,p2),200, p1, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(200,p1,p2)], [x2_e.(x1_stare(200,p1,p2),200, p1, p2),x2_e.(x1_stare(200,p1,p2),200, p1, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(200,p1,p2)], [x2_e.(x1_stare(200,p1,p2),200, p1, p2)], markercolor=:black, markersize=5)
	
	  # Key points, with dashed lines to them
    plot!([x1_stare(300,p1,p2),x1_stare(300,p1,p2)], [0,x2_e.(x1_stare(300,p1,p2),300, p1, p2)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_stare(300,p1,p2)], [x2_e.(x1_stare(300,p1,p2),300, p1, p2),x2_e.(x1_stare(300,p1,p2),300, p1, p2)], linecolor=:black, linestyle=:dash)
    scatter!([x1_stare(300,p1,p2)], [x2_e.(x1_stare(300,p1,p2),300, p1, p2)], markercolor=:black, markersize=5)



	 # Axis ticks
   # xticks!([0.001], [L"0"])
   # yticks!([0.001], [L"0"])

	 # Axis limits
    xlims!(0, 20)
    ylims!(0, 20)

	# Axis labels
    annotate!(21, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 20, text(L"x_2", :center, :bottom, 12))

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

   expansionI
end

# ╔═╡ b993f0df-aa53-4bd9-ac32-8f39997112f2
md"""
Here we see that higher level of income result in higher consumption of both goods.
"""

# ╔═╡ d0b8762f-fc2c-4bf8-a0c2-acbb47c91da6
md"""
In mathematical economics we can define the optimal utility level

$\begin{align*}
 V(p_1,p_2,I) = U^*(p_1,p_2,I) &= U^*(x_1^*(p_1,p_2,I), x_2^*(p_1,p_2,I)) \\
 &= U^*(x_1^*(p_1,p_2,I), \hat{x}_2^*(x_1^*(p_1,p_2,I), p_1,p_2,I))\\
&= U^*(x_1^*(p_1,p_2,I), \dfrac{I- p_1x_1^*(p_1,p_2,I)}{p_2})
\end{align*}$
as $V$ which is defined by the exogenous variables in the system, $p_1$, $p_2$, and I. We can use the envelop theorem to discover the comparative statics of optimal utility with respect to all the exogenous variables. For our cobb-douglas utility function 

$\begin{equation*}
  V(p_1,p_2,I) = x_1^*(p_1,p_2,I)^\alpha \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{1-α}
\end{equation*}$
with the following comparative statics,

$\begin{align*}
  \dfrac{dV}{dp_1} &= x_1^*(p_1,p_2,I)^\alpha \cdot (1-α) \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot - \dfrac{x_1^*(p_1,p_2,I)}{p_2} \\
   &= -  (1-α) \cdot x_1^*(p_1,p_2,I)^{\alpha}  \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot \dfrac{x_1^*(p_1,p_2,I)}{p_2} , \\
 \dfrac{dV}{dp_2} &= x_1^*(p_1,p_2,I)^\alpha \cdot (1-α) \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot - \dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2^2} \\
&=  -  (1-α) \cdot x_1^*(p_1,p_2,I)^{\alpha}  \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot \dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2^2} ,  \\
 \dfrac{dV}{dI} &= x_1^*(p_1,p_2,I)^\alpha \cdot (1-α) \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot \dfrac{I}{p_2} \\
&= (1-α) \cdot x_1^*(p_1,p_2,I)^{\alpha}  \cdot \left(\dfrac{I - p_1 \cdot x_1^*(p_1,p_2,I)}{p_2} \right)^{-α} \cdot \dfrac{I}{p_2}
\end{align*}$


"""

# ╔═╡ 984fdfc4-5cd0-4639-9d58-6932b56c3c57
md"""
## Comparative Statics
"""

# ╔═╡ 7a64b985-b1ca-4bb1-8537-01bb12510a5e
begin #comparative statics
	V(I_e,p1,p2) = U(x1_stare(I_e,p1,p2),x2_e(x1_stare(I_e,p1,p2),I_e, p1, p2))
	
	dV_dp1(I_e,p1,p2) = x1_stare(I_e,p1,p2)^α * (1-α) * x2_e(x1_stare(I_e,p1,p2),I_e, p1, p2)^(-α) * dx2_e_p1(I_e,p1,p2)
	dx2_e_p1(I_e,p1,p2) = - x1_stare(I_e,p1,p2)/p2
	
	dV_dp2(I_e,p1,p2) = x1_stare(I_e,p1,p2)^α * (1-α) * x2_e(x1_stare(I_e,p1,p2),I_e, p1, p2)^(-α) * dx2_e_p2(I_e,p1,p2)
	dx2_e_p2(I_e,p1,p2) = - (I_e - p1 * x1_stare(I_e,p1,p2))/(p2)^2
	
	dV_dI(I_e,p1,p2) = x1_stare(I_e,p1,p2)^α * (1-α) * x2_e(x1_stare(I_e,p1,p2),I_e, p1, p2)^(-α) * dx2_e_I(I_e,p2)
	dx2_e_I(I_e,p2) = I_e / p2
end;

# ╔═╡ 5a058f97-ff44-43e3-8ea4-0fd786e64ada
md"""
V with respect to $p_1$
"""

# ╔═╡ 10b0af0a-c2f8-49e2-95b9-c2acd1ded7d5
begin
    vp1graph = plot(
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
    plot!(p1vec, V.(I_1,p1vec,p2), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 25)
    ylims!(0, 12)

	# Axis labels
    annotate!(26, 0, text(L"p_1", :left, :center, 12))
    annotate!(0, 12, text(L"V", :center, :bottom, 12))

	annotate!(10, V.(I_1,10,p2), text(L"V(p_1,p_2,I)", :left, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
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

   vp1graph	
end

# ╔═╡ f58a54d2-86fa-4c6d-a9bc-1b5fcfb39f71
begin
    dvp1plot = plot(
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
    plot!(p1vec, dV_dp1.(I_1,p1vec,p2) , linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 25)
    ylims!(-6, 6)

	# Axis labels
    annotate!(26, 0, text(L"p_1", :left, :center, 12))
    annotate!(0, 6, text(L"V", :center, :bottom, 12))

	annotate!(10, dV_dp1.(I_1,10,p2)-2, text(L"\dfrac{dV}{dp_1}", :left, :bottom, 18))

	# Axis ticks
    xticks!([0.001], [L" "])
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

   dvp1plot	
end

# ╔═╡ e984a37d-cc59-4149-a75c-34bc98cc2c4a
md"""
V with respect to $p_2$
"""

# ╔═╡ 30450441-b70d-4ecf-a61f-90c9c8551243
begin
    vp2graph = plot(
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
    plot!(p2vec, V.(I_1,p1,p2vec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 25)
    ylims!(0, 12)

	# Axis labels
    annotate!(26, 0, text(L"p_2", :left, :center, 12))
    annotate!(0, 12, text(L"V", :center, :bottom, 12))

	annotate!(10, V.(I_1,p1,10), text(L"V(p_1,p_2,I)", :left, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
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

   vp2graph	
end

# ╔═╡ 60a902bb-bba4-47c3-95f5-4777f573ec14
begin
    dvp2plot = plot(
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
    plot!(p2vec, dV_dp2.(I_1,p1,p2vec) , linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 25)
    ylims!(-6, 6)

	# Axis labels
    annotate!(26, 0, text(L"p_2", :left, :center, 12))
    annotate!(0, 6, text(L"V", :center, :bottom, 12))

	annotate!(10, dV_dp2.(I_1,p1,10)-2, text(L"\dfrac{dV}{dp_2}", :left, :bottom, 18))

	# Axis ticks
    xticks!([0.001], [L" "])
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

   dvp2plot	
end

# ╔═╡ 56166c50-291e-4f20-afc1-395ffaefb269
md"""
V with respect to I
"""

# ╔═╡ cf4565a1-7304-4c6b-a125-af04b5c67387
begin
    vIgraph = plot(
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
    plot!(Ivec, V.(Ivec,p1,p2), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
	xlims!(0, 400)
    ylims!(0, 15)

	# Axis labels
    annotate!(405, 0, text(L"I", :left, :center, 12))
    annotate!(0, 15, text(L"V", :center, :bottom, 12))

	annotate!(200, V.(200,p1,p2)+2, text(L"V(p_1,p_2,I)", :left, :bottom, 12))

	# Axis ticks
    xticks!([0.001], [L"0"])
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

   vIgraph	
end

# ╔═╡ b71a34be-c3b4-4faa-8cf6-f9352165a5e8
begin
    dvIplot = plot(
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
    plot!(Ivec, dV_dI.(Ivec,p1,p2) , linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 400)
    ylims!(0, 12)

	# Axis labels
    annotate!(405, 0, text(L"I", :left, :center, 12))
    annotate!(0, 12, text(L"V", :center, :bottom, 12))

	annotate!(200, dV_dI.(200,p1,10)-1.5, text(L"\dfrac{dV}{dI}", :left, :bottom, 18))

   

	# Axis ticks
    xticks!([0.001], [L" "])
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

   dvIplot	
end

# ╔═╡ Cell order:
# ╠═d703ad84-c20f-11ef-244e-ab1cddc07ff1
# ╠═2ed0df42-3cfd-4bda-8f8c-5f1d19ed6f9c
# ╟─5e796460-898b-4d12-a55f-01b12a872e0e
# ╟─1d8741da-fc29-4785-8ce3-1df711e2d86d
# ╟─54b656f2-7be5-403a-90e0-df02acf11a90
# ╟─de65ffbf-de6e-4493-b601-16b7f62fcd12
# ╠═37125c83-6f1a-48cb-a495-e39f5a6c8501
# ╠═4f4c12fb-e258-42ac-afab-b58cbfb65deb
# ╠═f8176995-6fca-4827-9c6a-cedba01172f0
# ╠═87ded16f-72d0-41b3-890a-be14d97d8990
# ╟─084adad9-a8e1-4d86-860d-69d6b6e90de9
# ╟─d5010981-9bed-4284-9b06-09daae82ca85
# ╟─683a40d3-aae7-4f90-89c9-86fc9750f000
# ╠═d9b600e8-e13c-4285-b57e-83d0ce9228c4
# ╠═bf05fcb5-6f09-45b4-b705-603334cef8f3
# ╠═75580318-4f23-4c15-8614-d39c9892fd27
# ╟─f66d7212-f736-405b-9506-efebd7e2519c
# ╟─f9056cd6-1a30-418e-9524-8ec2b52df675
# ╟─cbbbcec6-bcfb-4625-8200-59a8b30c8f9f
# ╟─34770556-4647-4e34-94e1-a1728b93026d
# ╟─f8d4ecc5-f9d4-4c37-b3e9-2a1fbf53ed48
# ╠═7aaf8c7d-71d2-4a23-907e-b022c1dd028f
# ╟─aa466562-dcc1-40e4-b1bd-f277659bcd09
# ╟─7be6f0cf-21a6-497c-ad96-1323798021b0
# ╠═e310112d-94c9-417f-b67e-e007108cb9e0
# ╠═6ed2b882-7230-4b5a-b114-deb9aff08846
# ╠═803fec4f-5998-4baf-b06b-08bc37b8f072
# ╟─3af315b7-8392-474d-8922-4ce8b3c512e5
# ╟─dc8cb167-5edd-4d05-be6b-8265678514f1
# ╟─f0380574-ac39-4612-bfda-d927ae67139b
# ╟─242dcd33-89cd-46d0-92f5-c9273e92bf52
# ╟─c1153e02-c54f-42fe-8ab3-4eaf5083e631
# ╟─d5a16c57-2fc7-491d-bb9f-9b264c9e7a18
# ╟─2d85c122-fce7-4de8-b85c-0687c2a58d3a
# ╟─3274b4c2-57e3-48d1-9992-f204f21de240
# ╟─6ac204ff-5d8e-425a-ab6b-38aab0560ceb
# ╟─baeb723a-124d-43e8-950f-956a2964844a
# ╠═36e996c6-157d-40bc-a297-f5441e51f18f
# ╠═e3dd6c32-64df-4fe2-bbaa-194b4f1051ce
# ╠═06234055-fd64-40e9-9e49-a2e9828b2922
# ╠═5aeb4645-b9af-4f51-85fc-fac8dc9aead3
# ╟─0740ead8-a648-4e04-99f6-c2592c9d53c9
# ╟─ba44a1f6-0dcd-4558-ae66-656d1c4b3851
# ╟─bd1e6f02-3ba3-498f-8790-0d710d770250
# ╠═e8d22c27-d01d-413d-a54b-284d9f945f2c
# ╟─4da1368e-d6a8-4b7b-b903-cf7d79a35cb0
# ╠═53190315-8ac1-40e0-a297-da7ebe65dc1b
# ╟─ac1b983e-6285-472e-bb5e-001e7052d7af
# ╟─c7efc79a-da6e-4fd6-8ec8-a95ada2c7d20
# ╠═0afafe05-8bd6-463a-99a1-518c4a33baca
# ╟─52a85b4e-61df-4f0f-bdac-0533a1aea563
# ╟─00cdb5e1-9a51-48e6-9063-a7a7fc7d5e36
# ╟─352e1069-3271-4181-9f5c-e765388838cb
# ╠═c8faf214-fa5f-4bec-80f2-26e15b8116b8
# ╟─290bd325-e82c-43da-9664-c17428693585
# ╟─f2e9467e-ec91-493e-b6a4-dc3aae02c0a1
# ╟─5f5f679a-989c-4eb9-9532-f20581f05ac1
# ╟─feaad82d-da68-44e8-8c87-6f56002a9b6c
# ╟─79fef477-9aa1-4b65-8301-b7bcf19a008a
# ╟─b993f0df-aa53-4bd9-ac32-8f39997112f2
# ╟─d0b8762f-fc2c-4bf8-a0c2-acbb47c91da6
# ╟─984fdfc4-5cd0-4639-9d58-6932b56c3c57
# ╠═7a64b985-b1ca-4bb1-8537-01bb12510a5e
# ╟─5a058f97-ff44-43e3-8ea4-0fd786e64ada
# ╟─10b0af0a-c2f8-49e2-95b9-c2acd1ded7d5
# ╟─f58a54d2-86fa-4c6d-a9bc-1b5fcfb39f71
# ╟─e984a37d-cc59-4149-a75c-34bc98cc2c4a
# ╟─30450441-b70d-4ecf-a61f-90c9c8551243
# ╟─60a902bb-bba4-47c3-95f5-4777f573ec14
# ╟─56166c50-291e-4f20-afc1-395ffaefb269
# ╟─cf4565a1-7304-4c6b-a125-af04b5c67387
# ╟─b71a34be-c3b4-4faa-8cf6-f9352165a5e8
