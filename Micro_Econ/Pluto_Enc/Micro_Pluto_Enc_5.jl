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

# ╔═╡ dc911456-cb92-11ef-2523-5198111e2809
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
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

# ╔═╡ e4c89af8-d12d-4508-bb0c-d2b75f482d4e
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 70cd2419-fb55-4605-b35f-a28670ef9aa1
md"""
# Micro Pluto Encyclopedia
"""

# ╔═╡ bfa93867-6951-4c98-ab9e-80ba80072b40
md"""
## Kuhn-Tucker Analytically
"""

# ╔═╡ 8874fe16-3165-4323-a043-1af20483d7e1
md"""
Say we are given the following optimization problem

$\begin{equation*}
  \max_x f(x,α)=-(x-α^2) + 4
\end{equation*}$
subject to 

$\begin{align*}
  x &\geq 0 \\
x &≤ 4.
\end{align*}$
A way to solve this optimization problem analytically would be to use the Kuhn_Tucker method where we setup our optimization conditions and see which ones hold. First it is easier to visualize this Kuhn-Tucker as a Lagrangian with constraints that may or may not bind

$\begin{equation*}
  \mathcal{L}= -(x-α^2) + 4 + λ[x] + ν[4-x]
\end{equation*}$
where it is clear that in order to discover the maximum both of these constraints cannot hold. Setting up the optimization conditions results in the following first-order conditions

$\begin{align*}
  \dfrac{d \mathcal{L}}{dx} &= -2\cdot (x-α) + λ - ν=0 \\
\dfrac{d \mathcal{L}}{dλ} &= x ≥ 0 \\
\dfrac{d \mathcal{L}}{dν} &= 4-x ≥ 0
\end{align*}$
and the following non-negativity and complementary-slackness condtiions

$\begin{align*}
  λ &≥ 0 \\
 λ \cdot \dfrac{d \mathcal{L}}{dλ} &= λ[x] = 0 \\
ν& ≥ 0 \\
ν \cdot \dfrac{d \mathcal{L}}{dν} &= ν[4-x] = 0.
\end{align*}$
The way to solve this problem analytically would be to first list out the possible number of cases and try to find contradictions. There are two constraints meaning there are $2^2$ possible permutations,

$\begin{align*}
  &λ \; &ν \\
 &+ \; &+ \\
&+ \; &0 \\
&0 \; &+ \\
&0 \; &0.
\end{align*}$
The first case results in a contradiction because when both λ and ν are positive that implies that x is equal to 0 and 4, which is a contradiction. So we can eliminate that case. No other case here forms a contradiction which means that we have three Langrangian we need to evaluate:

$\begin{align*}
  1.& \mathcal{L} = -(x-α^2) + 4 + λ[x] \\
2.&  \mathcal{L} =-(x-α^2) + 4 + ν[4-x] \\
3.&  \mathcal{L} =-(x-α^2) + 4 
\end{align*}$
and have to determine which one results in the maximum value of the optimization problem.
"""

# ╔═╡ 1c43c9df-9925-4026-aa5d-69a1ff49ed1b
md"""
Essentially what a Lagrangian represents is a maximization problem where the constraint represents a condition that much be equivalent to zero. So the first Lagrangian can be rewritten as 

$\begin{equation*}
  \max_x f(x,α) = -(x-α)^2 + 4
\end{equation*}$
subject to 

$\begin{equation*}
  x=0
\end{equation*}$
we can substitute that condition into the optimization problem to get the unconstrained problem 

$\begin{align*}
  \max f(x,α) &= -(-α)^2 + 4 \\
&= -α^2 + 4
\end{align*}$
So this problem just results in a number that is dependent on the parameter α.
The second Lagrangian can be rewritten as 

$\begin{equation*}
  \max_x f(x,α) = -(x-α)^2 + 4
\end{equation*}$
subject to 

$\begin{equation*}
  4-x=0
\end{equation*}$
where once again we can substiture that condition into the optimization problem to get the unconstrained problem

$\begin{align*}
  \max f(α) &= -(4-α)^2 + 4
\end{align*}$
which will also just result in a number. The first two Lagrangians are referred to as knife-edge cases. The last Lagrangian is already unconstrained and can be rewritten as

$\begin{equation*}
  \max_x f(α) = -(x-α)^2 + 4
\end{equation*}$
where in order to find the maximum we need to perform the normal optimization analysis. 

$\begin{equation*}
  \dfrac{df}{dx} = -2(x-α) =0
\end{equation*}$
where he second-order condition is -2 so the first-order condition establishes a local maximum. Using the implicit function theorem we can define x as a function of the parameter α 

$\begin{equation*}
  x^*=x^*(α).
\end{equation*}$
Plugging this result into the objective function will produce the unconstrained problem

$\begin{equation*}
  \max f(α) = -(x^*(α)-α)^2 + 4
\end{equation*}$
where by knowing α we know the maximum of $f$. 
"""

# ╔═╡ 19ed9293-b1f2-49b3-a3fe-553ddb3cc2c8
begin #equations
	f(x,α) = -(x - α)^2 + 4
	f_x(x,α) = -2*(x - α)
#_______________________________________________________________________________#
	#conditions
	x_min=0
	x_max=4
end;

# ╔═╡ 28acc8da-abc2-4282-b5ce-e522cdfe9f82
md"""
## Kuhn-Tucker Find_zero
"""

# ╔═╡ 596d4cca-9e53-48e9-a4c5-c12ee21c9113
function x_star(α)

# Define the zero condition at the parameter value supplied
cond(x) = f_x(x,α)

# Specify a starting guess
x0 = .1

# Find and return the solution
x = find_zero(cond, x0)
	if x >= x_max
		x_max
	elseif x <= x_min
		x_min
	else
		x
	end
end;

# ╔═╡ 9667df06-aa8c-47bb-bae4-13495cef6485
md"""
These above functions are the hard way of doing kuhn-tukcers where we have to specify the constraints outright and construct a specific function to handle the optimization problem when it cross those contraints.
"""

# ╔═╡ 3feb2cde-c5b2-444a-8cf7-f74601a69c12
xvec = collect(range(-2,6,length=101));

# ╔═╡ 2b734c54-cb5f-49a0-a9e0-c94b24f4b2e5
md"""
This graphically shows the solution to the optimization problem at various calues of x. Between 0 and 4, the soultion is constant, but at 0 and 4 the solution will change with changes in the parameter, those are the knife-edge case.
"""

# ╔═╡ a12d0266-5b35-4916-9ee9-b1acc04cee0c
md"""
Additionally we can graph the comparative static of change in the optimal $x^*$ as $α$ changes.
"""

# ╔═╡ 29942957-a520-461b-a943-f2b74fbc839b
αvec = collect(range(-2,6,length=101));

# ╔═╡ 701fdb91-0aa8-4940-abb5-94041c1a1620
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
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(αvec, x_star.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 # Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(x_star.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  

	annotate!(2,  x_star.(3), text(L"x^*(α)", :left, :bottom, 12))
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

   plot2	
end

# ╔═╡ 9bdbb7c3-e5f5-4b77-8375-b7e5364a796e
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
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(αvec, f.(x_star.(αvec),αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(x_star.(αvec),αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  
	 annotate!(1, f.(x_star.(3),3), text(L"f^*(x^*(α),α)", :left, :bottom, 12))
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

   plot3	
end

# ╔═╡ e1e2def3-0866-4b4e-bca8-a86f236da4bc
md"""
## "True" Kuhn-Tucker
"""

# ╔═╡ 2f854be8-a808-43f2-907b-75afb13da434
function true_KT(α)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :f, 2, f; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, x)
        
    # Specify the objective function
    @NLobjective(model, Max, f(x,α))

    # Specify the constraints, in == or >= form
    @NLconstraint(model, c1, x >= 0)
	@NLconstraint(model, c2, 4 - x >= 0)
        
    # Pick starting values
    set_start_value(x, 2)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	xopt = round(value(x), digits=2)
	λopt = round(dual(c1), digits=2)
	νopt = round(dual(c2), digits=2)

	return xopt, λopt, νopt
end;

# ╔═╡ 151eb7f6-a239-4e0e-87ec-4ecefc1cb327
begin
xopt(α)=true_KT(α)[1]
λopt(α)=true_KT(α)[2]
νopt(α)=true_KT(α)[3]
end;

# ╔═╡ 27481c87-ad83-49d9-8641-7726276218e8
md"""
This "true" Kuhn-Tucker produces the exact same results as the find_zero but through a different manner. In this function we can set the constraints exactly like we did with the original Lagrangian and the Jump.optimizer will solve it.
"""

# ╔═╡ 1c1382d4-cdad-4731-8224-d0c3960f3ff1
md"""
We can also use it to plot all the comparative statics as well, even the ones for the shadow values.
"""

# ╔═╡ 0aa8fa11-0112-4c34-887c-bc0d0ea22dcf
begin
    tktplot2 = plot(
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
    plot!(αvec, xopt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(x_star.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  

	annotate!(2,  xopt.(3), text(L"x^*(α)", :left, :bottom, 12))

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

   tktplot2	
end

# ╔═╡ 47a9438d-da4e-4d2c-b3e8-13bb38f299fc
begin
    tktplot3 = plot(
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
    plot!(αvec, λopt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum( λopt.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum( λopt.(αvec)), text(L"λ^*", :center, :bottom, 12))
  

	annotate!(-1,  λopt.(-1)+.5, text(L"λ^*(α)", :left, :bottom, 12))


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

   tktplot3	
end

# ╔═╡ 282febdc-fa2a-4e30-b61b-5041677c4061
begin
    tktplot4 = plot(
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
    plot!(αvec, νopt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)
	
	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum( νopt.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum( νopt.(αvec)), text(L"ν^*", :center, :bottom, 12))
  

	annotate!(4.5,  νopt.(5)+.5, text(L"ν^*(α)", :left, :bottom, 12))

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

   tktplot4	
end

# ╔═╡ 36801d01-e117-496b-9c3f-206ec3e408a8
begin
    tktplot5 = plot(
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
    plot!(αvec, f.(xopt.(αvec),αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(x_star.(αvec),αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  
	 annotate!(1, f.(x_star.(3),3), text(L"f^*(x^*(α),α)", :left, :bottom, 12))

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

   tktplot5	
end

# ╔═╡ 59b4e157-5533-4eba-b64d-d92a5af9db4d
md"""
## "Fake" Kuhn-Tucker
"""

# ╔═╡ 2c392ce5-5d3a-489f-8fc3-2bf861ab6578
md"""
The "fake" Kuhn-Tucker works by setting an "inertia" value of 1 where the constraints will be the Kuhn-Tucker conditions that will change that 1 to whatever the results of the Kuhn-Tucker are.
"""

# ╔═╡ ae013c88-0ed5-4f0a-85c4-a9150e68ecb7
function fake_KT(α)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of argument
    register(model, :f_x, 2, f_x; autodiff = true)

    # Specify the variables to be solved for
    @variable(model, x)
    @variable(model, λ)
    @variable(model, ν)

    # Specify the fake objective function
    @NLobjective(model, Max, 1)

    # Specify the constraints (note: \scrL generates ℒ symbol)
    # ℒ = -(x - α)^2 + 4 + λ*x + μ*(4 - x)
    # foc x
    @NLconstraint(model, c1, f_x(x,α) + λ - ν == 0) #foc condition x
        
    # foc λ
    @NLconstraint(model, c2, x >= 0) #foc λ

    # nn λ
    @NLconstraint(model, c3, λ >= 0) #nn λ

    # cs λ
    @NLconstraint(model, c4, λ*x == 0) #cs λ

    # foc μ
    @NLconstraint(model, c5, 4 - x >= 0) #foc ν

    # nn μ
    @NLconstraint(model, c6, ν >= 0) #nn ν

    # cs μ
    @NLconstraint(model, c7, ν*(4 - x) == 0) #cs ν
        
    # Pick starting values
    set_start_value(x, 2)
    set_start_value(λ, 0)
    set_start_value(ν, 0)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	xopt = round(value(x), digits=2)
	λopt = round(value(λ), digits=2)
	νopt = round(value(ν), digits=2)

	return xopt, λopt, νopt
end;

# ╔═╡ e7c2d9ca-ce24-41b2-8357-af8810c91574
begin
x_opt(α)=fake_KT(α)[1]
λ_opt(α)=fake_KT(α)[2]
ν_opt(α)=fake_KT(α)[3]
end;

# ╔═╡ 34650600-a229-4678-aa95-f89e8998bd8f
α = @bind α Slider(-2:0.1:6, default=2, show_value=true)

# ╔═╡ 309e8c23-9f6c-46a1-95ec-f4fc95d729af
function kuhn_tucker(x)
	if x <=x_min
		f(x_min,α)
	elseif x>=x_max
		f(x_max,α)
	else 
		f(x_star(α),α)
	end
end;

# ╔═╡ e3a61992-3c93-4ab6-9294-751be839a181
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
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(xvec, f.(xvec,α), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(xvec,α)))
    
    # Axis labels
    annotate!(6.2, 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xvec,α)), text(L"f", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([x_star(α),x_star(α)], [0,kuhn_tucker(x_star(α))], linecolor=:black, linestyle=:dash) 
    plot!([0,x_star(α)], [kuhn_tucker(x_star(α)),kuhn_tucker(x_star(α))], linecolor=:black, linestyle=:dash)
    scatter!([x_star(α)], [kuhn_tucker(x_star(α))], markercolor=:black, markersize=5)

	 plot!([x_max,x_max], [0,1.2*maximum(f.(xvec,α))], linecolor=:black, linestyle=:dash)
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

   plot1	
end

# ╔═╡ 73574172-2a4b-412b-a548-ef2ce7f65251
begin
    tktplot1 = plot(
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
    plot!(xvec, f.(xvec,α), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(xvec,α)))
    
    # Axis labels
    annotate!(6.2, 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xvec,α)), text(L"f", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([xopt(α),xopt(α)], [0,f.(xopt(α),α)], linecolor=:black, linestyle=:dash) 
    plot!([0,xopt(α)], [f.(xopt(α),α),f.(xopt(α),α)], linecolor=:black, linestyle=:dash)
    scatter!([xopt(α)], [f.(xopt(α),α)], markercolor=:black, markersize=5)
	
	 plot!([x_max,x_max], [0,1.2*maximum(f.(xvec,α))], linecolor=:black, linestyle=:dash)
	
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

   tktplot1	
end

# ╔═╡ 1ff47faf-a46b-4fbe-ae75-b8b1f5defaad
begin
    fktplot1 = plot(
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
    plot!(xvec, f.(xvec,α), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(xvec,α)))
    
    # Axis labels
    annotate!(6.2, 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.212*maximum(f.(xvec,α)), text(L"f", :center, :bottom, 12))
	
	 # Key points, with dashed lines to them
    plot!([x_opt(α),x_opt(α)], [0,f.(x_opt(α),α)], linecolor=:black, linestyle=:dash) 
    plot!([0,x_opt(α)], [f.(x_opt(α),α),f.(x_opt(α),α)], linecolor=:black, linestyle=:dash)
    scatter!([x_opt(α)], [f.(x_opt(α),α)], markercolor=:black, markersize=5)

	plot!([x_max,x_max], [0,1.2*maximum(f.(xvec,α))], linecolor=:black, linestyle=:dash)

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

   fktplot1	
end

# ╔═╡ e955555e-6340-458a-bd15-7406c23553bb
begin
    fktplot2 = plot(
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
    plot!(αvec, x_opt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(x_star.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  

	annotate!(2,  xopt.(3), text(L"x^*(α)", :left, :bottom, 12))
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

   fktplot2	
end

# ╔═╡ 1badc909-81ef-4cc1-a881-2d3560ad7a66
begin
    fktplot3 = plot(
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
    plot!(αvec, λ_opt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum( λopt.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum( λopt.(αvec)), text(L"λ^*", :center, :bottom, 12))
  

	annotate!(-1,  λopt.(-1)+.5, text(L"λ^*(α)", :left, :bottom, 12))
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

   fktplot3	
end

# ╔═╡ 8081bde3-cf3d-4b38-9b99-c166b23da40b
begin
    fktplot4 = plot(
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
    plot!(αvec, ν_opt.(αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum( νopt.(αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum( νopt.(αvec)), text(L"ν^*", :center, :bottom, 12))
  

	annotate!(4.5,  νopt.(5)+.5, text(L"ν^*(α)", :left, :bottom, 12))
	
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

   fktplot4	
end

# ╔═╡ cce0885f-9157-4b3d-b34c-119c1a1ff327
begin
    fktplot5 = plot(
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
    plot!(αvec, f.(x_opt.(αvec),αvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 1.2*maximum(f.(x_star.(αvec),αvec)))
    
    # Axis labels
    annotate!(6.3, 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.2*maximum(x_star.(αvec)), text(L"x^*", :center, :bottom, 12))
  
	 annotate!(1, f.(x_star.(3),3), text(L"f^*(x^*(α),α)", :left, :bottom, 12))

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

   fktplot5	
end

# ╔═╡ e2688898-8c00-4f78-8628-4db549d96e68
md"""
Here we have produced three of the exact same results using very different graphing methods. All these results stem from the very basic analytical methods for Kuhn-Tucker optimization which is a nonlinear optimization method founded on Lagrangian analysis.
"""

# ╔═╡ f33b1ecb-4113-49c2-880b-73d0540ebb1e
md"""
## Kuhn-Tucker Consumer Problem
"""

# ╔═╡ 3972b9fc-0282-45cf-9919-8d95e023d052
md"""
$\begin{equation*}
  \max_{x_1,x_2} U = 4x_1 + 4x_2 -x_1^2-x_2^2
\end{equation*}$
subject to 

$\begin{equation*}
  Y \geq x_1 + x_2
\end{equation*}$
This can be rewritten in Lagrangian form as

$\begin{equation*}
  \mathcal{L} = 4x_1 + 4x_2 -x_1^2-x_2^2 + λ[Y-x_1 - x_2]
\end{equation*}$
"""

# ╔═╡ 1a8fa906-87f9-4542-a1e2-9f4317890eaa
begin #equations
	U(x1,x2)= 4x1 + 4x2 -x1^2 - x2^2
	Y_k(x1,x2) = x1+x2
end;

# ╔═╡ b4ebab38-d8cc-4e0f-8c3d-c2008d830fdb
function consumer_kt(Y)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :U, 2, U; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, x1)
	@variable(model, x2)
        
    # Specify the objective function
    @NLobjective(model, Max, U(x1,x2))

    # Specify the constraints, in == or >= form
    @NLconstraint(model, c1, Y-x1-x2 >= 0)
        
    # Pick starting values
    set_start_value(x1, 2)
	set_start_value(x2, 2)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	x1opt = round(value(x1), digits=2)
	x2opt = round(value(x2), digits=2)
	λopt = round(dual(c1), digits=2)

	return x1opt, x2opt, λopt
end;

# ╔═╡ 99fd7df3-59fc-42bb-a4ff-9a781dd7003e
begin #kt output
	x1opt(Y)=consumer_kt(Y)[1]
	x2opt(Y)=consumer_kt(Y)[2]
	λ_opt_c(Y)=consumer_kt(Y)[3]
end;

# ╔═╡ 3a42bee6-0a64-4247-aeb6-bad2d7ffaf52
x1vec = collect(range(-2,6,length=101));

# ╔═╡ 0a8267c6-0984-4f9e-be2f-6e3596ce990b
x2vec = copy(x1vec);

# ╔═╡ 1bebb8d3-fe95-4caf-8c6a-eba11c082c77
Y = @bind Y Slider(0.0:0.1:10.0, default=4.0, show_value=true)

# ╔═╡ 762a4609-4782-4e39-ba44-95b4a141aa53
function x2_hat(x1)

# Define the zero condition at the parameter value supplied
cond(x2) = Y - Y_k(x1,x2)

# Specify a starting guess
x20 = 1

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ 4f08043a-088d-4c91-bc97-6c36c4fb6e67
begin
    consumer_ktgraph = plot(
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
    plot!(x1vec, x2_hat.(x1vec), linecolor=:black, linestyle=:solid, linewidth=2)
	contour!(x1vec, x2vec, U, levels=(4:.5:10), 
		linecolor=:gray, clabels=false)
	contour!(x1vec, x2vec, U, levels=[U(x1opt(Y),x2opt(Y))], 
		linecolor=:black, clabels=false)
	
    # Axis limits
    xlims!(0, 6)
    ylims!(0, 6)
    
    # Axis labels
    annotate!(6.5, 0, text(L"x_1", :left, :center, 12))
    annotate!(0, 6, text(L"x_2", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([x1opt(Y),x1opt(Y)], [0,x2opt(Y)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1opt(Y)], [x2opt(Y),x2opt(Y)], linecolor=:black, linestyle=:dash)
    scatter!([x1opt(Y)], [x2opt(Y)], markercolor=:black, markersize=5)
	
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

   consumer_ktgraph	
end

# ╔═╡ Cell order:
# ╠═dc911456-cb92-11ef-2523-5198111e2809
# ╠═e4c89af8-d12d-4508-bb0c-d2b75f482d4e
# ╟─70cd2419-fb55-4605-b35f-a28670ef9aa1
# ╟─bfa93867-6951-4c98-ab9e-80ba80072b40
# ╟─8874fe16-3165-4323-a043-1af20483d7e1
# ╟─1c43c9df-9925-4026-aa5d-69a1ff49ed1b
# ╠═19ed9293-b1f2-49b3-a3fe-553ddb3cc2c8
# ╟─28acc8da-abc2-4282-b5ce-e522cdfe9f82
# ╠═596d4cca-9e53-48e9-a4c5-c12ee21c9113
# ╠═309e8c23-9f6c-46a1-95ec-f4fc95d729af
# ╟─9667df06-aa8c-47bb-bae4-13495cef6485
# ╠═3feb2cde-c5b2-444a-8cf7-f74601a69c12
# ╟─e3a61992-3c93-4ab6-9294-751be839a181
# ╟─2b734c54-cb5f-49a0-a9e0-c94b24f4b2e5
# ╟─a12d0266-5b35-4916-9ee9-b1acc04cee0c
# ╠═29942957-a520-461b-a943-f2b74fbc839b
# ╟─701fdb91-0aa8-4940-abb5-94041c1a1620
# ╟─9bdbb7c3-e5f5-4b77-8375-b7e5364a796e
# ╟─e1e2def3-0866-4b4e-bca8-a86f236da4bc
# ╠═2f854be8-a808-43f2-907b-75afb13da434
# ╠═151eb7f6-a239-4e0e-87ec-4ecefc1cb327
# ╟─73574172-2a4b-412b-a548-ef2ce7f65251
# ╟─27481c87-ad83-49d9-8641-7726276218e8
# ╟─1c1382d4-cdad-4731-8224-d0c3960f3ff1
# ╟─0aa8fa11-0112-4c34-887c-bc0d0ea22dcf
# ╟─47a9438d-da4e-4d2c-b3e8-13bb38f299fc
# ╟─282febdc-fa2a-4e30-b61b-5041677c4061
# ╟─36801d01-e117-496b-9c3f-206ec3e408a8
# ╟─59b4e157-5533-4eba-b64d-d92a5af9db4d
# ╟─2c392ce5-5d3a-489f-8fc3-2bf861ab6578
# ╠═ae013c88-0ed5-4f0a-85c4-a9150e68ecb7
# ╠═e7c2d9ca-ce24-41b2-8357-af8810c91574
# ╟─34650600-a229-4678-aa95-f89e8998bd8f
# ╟─1ff47faf-a46b-4fbe-ae75-b8b1f5defaad
# ╟─e955555e-6340-458a-bd15-7406c23553bb
# ╟─1badc909-81ef-4cc1-a881-2d3560ad7a66
# ╟─8081bde3-cf3d-4b38-9b99-c166b23da40b
# ╟─cce0885f-9157-4b3d-b34c-119c1a1ff327
# ╟─e2688898-8c00-4f78-8628-4db549d96e68
# ╟─f33b1ecb-4113-49c2-880b-73d0540ebb1e
# ╟─3972b9fc-0282-45cf-9919-8d95e023d052
# ╠═1a8fa906-87f9-4542-a1e2-9f4317890eaa
# ╠═b4ebab38-d8cc-4e0f-8c3d-c2008d830fdb
# ╠═99fd7df3-59fc-42bb-a4ff-9a781dd7003e
# ╠═3a42bee6-0a64-4247-aeb6-bad2d7ffaf52
# ╠═0a8267c6-0984-4f9e-be2f-6e3596ce990b
# ╠═762a4609-4782-4e39-ba44-95b4a141aa53
# ╠═1bebb8d3-fe95-4caf-8c6a-eba11c082c77
# ╟─4f08043a-088d-4c91-bc97-6c36c4fb6e67
