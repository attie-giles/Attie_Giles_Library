### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ cca98ba6-d344-11ef-3ebd-a54d20671921
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

# ╔═╡ d77ae4c9-b6c3-4654-9455-f2ea68b6ff54
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 157cac88-7575-480d-9cee-24951889cfd0
md"""
# Professor Problem
"""

# ╔═╡ 51939bd2-3b89-49e6-a4b7-7e01eb4ac601
md"""
## Analytical Setup
"""

# ╔═╡ 2e804666-c3d0-44fe-b449-80904c9a2ac1
md"""
A professor gets positive utility from hours $r$ in a day spent doing research, but negative utility from hours $g$ spent grading. Specifically, her utility each day is

$\begin{equation*}
  u(r_t,g_t)=(r_t+1)(T-g_t+1), \; t ∈{1,2}
\end{equation*}$
where $T>0$ is the number of hours available after eating, sleeping ,etc. Now consider a two-day period in which the professor chooses $r_1$ and $g_1$ for day 1 as well as $r_2$ and $g_2$ for day $2$. She does so subject to non-negativity contraints on all of her choice variables, to the upper bound on available hours in each day, and also to a constraint that she'll need to spend at least $T$ hours over the two days combined to finish her grading. Importantly, she discounts the second day's utility by a factor $δ<1$.

The professor's optimization problem is 

$\begin{equation*}
  \max_{r_1,r_2,g_1,g_2}U=(r_1+1)(T-g_1+1)+δ(r_2+1)(T-g_2+1)
\end{equation*}$
subject to 

$\begin{align*}
  g_1+g_2 &\geq T \\
  r_1+g_1 & \leq T \\
r_2 + g_2 & \leq T
\end{align*}$
The associated Lagrangian is

$\begin{multline*}
  \mathcal{L}= (r_1+1)(T-g_1+1)+δ(r_2+1)(T-g_2+1) + λ[g_1+g_2-T] + μ_1[T-r_1-g_1] \\
+ μ_2[T-r_2-g_2] + ν_1r_1 + ν_2r_2 + ω_1g_1 + ω_2g_2
\end{multline*}$
"""

# ╔═╡ 851d5796-554c-4969-88f0-c1aa21530da5
md"""
The optmization conditions for this lagrangian are as follows:

**First-order Conditions**

$\begin{align*}
  \dfrac{d\mathcal{L}}{d r_1} &= (T-g_1+1) - μ_1 + ν_1 = 0 \\
\dfrac{d\mathcal{L}}{d r_2} &= δ(T-g_2+1) - μ_2 + ν_2 = 0 \\
\dfrac{d\mathcal{L}}{d g_1} &= -(r_1+1) + \lambda - \mu_1 + \omega_1 = 0 \\
\dfrac{d\mathcal{L}}{d g_2} &= -\delta(r_2+1) + \lambda - \mu_2 + \omega_2 = 0 \\
\dfrac{d\mathcal{L}}{d \lambda} &= g_1 +g_2 -T  \geq 0 \\
\dfrac{d\mathcal{L}}{d μ_1} &= T-r_1-g_1 \geq 0 \\
\dfrac{d\mathcal{L}}{d \mu_2} &= T-r_2-g_2 \geq 0 \\
\dfrac{d\mathcal{L}}{d \nu_1} &= r_1 \geq 0 \\
\dfrac{d\mathcal{L}}{d \nu_2} &= r_2 \geq 0 \\
\dfrac{d\mathcal{L}}{d \omega_1} &= g_1 \geq 0 \\
\dfrac{d\mathcal{L}}{d \omega_2} &= g_2 \geq 0
\end{align*}$
"""

# ╔═╡ 801d4cf1-f0ea-4b38-b5f4-ad121aa13ecc
md"""
**Complementary Slackness Conditions**

$\begin{align*}
  \lambda  \dfrac{d\mathcal{L}}{d \lambda} &= \lambda[g_1+g_2-T]=0 \\
\mu_1 \dfrac{d\mathcal{L}}{d \mu_1} &= \mu_1 [T-r_1-g_1]=0 \\
\mu_2 \dfrac{d\mathcal{L}}{d \mu_2} &= \mu_2 [T-r_2-g_2]=0 \\
\nu_1 \dfrac{d\mathcal{L}}{d \nu_1} &= \nu_1r_1=0 \\
\nu_2 \dfrac{d\mathcal{L}}{d \nu_2} &= \nu_2r_2=0 \\
\omega_1 \dfrac{d\mathcal{L}}{d \omega_1} &= \omega_1 g_1 =0 \\
\omega_2 \dfrac{d\mathcal{L}}{d \omega_2} &= \omega_1 g_2 =0 \\
\end{align*}$

**Non-Negativity Constraint** 

$\begin{align*}
  \lambda &\geq 0 \\
\mu_1 & \geq 0 \\
\mu_2 & \geq 0 \\
\nu_1 & \geq 0 \\
\nu_2 & \geq 0 \\
\omega_1 & \geq 0 \\
\omega_2 & \geq 0



\end{align*}$
"""

# ╔═╡ 17bb1666-de2b-4d73-932a-75fc8cca259b
md"""
Case: $\mu_1=0$

Constraints $r_1 \geq 0$ and $r_1+g_1 \leq T$ jointly imply that $g_1 \leq T$. 

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial r_1} = \underbrace{(T-g_1+1)}_{(+)}-\underbrace{\mu_1}_{(0)}+\underbrace{\nu_1}_{(0 \; \text{or} \; +)}=0
\end{equation*}$
is therefore strictly positive, resulting in a contradiction when $\mu_1=0$. It follows that $\mu_1>0$, and therefore by the complementary slackness condition 

$\begin{equation*}
\mu_1 \dfrac{\partial \mathcal{L}}{\partial r_1} = \underbrace{\mu_1}_{(+)}\underbrace{[T-r_1-g_1]}_{(0)}=0,
\end{equation*}$
that 

$\begin{equation*}
g_1=T-r_1.
\end{equation*}$
Case: $\mu_2=0$

By symmetry, $\mu_2>0$ and $g_2=T-r_2$.

Case: $\lambda=0$

Using the above findings for $\mu_1$ and $\mu_2$, we have the following Kuhn-Tucker conditions

$\begin{align*}
\dfrac{\partial \mathcal{L}}{\partial g_1} &= \underbrace{-(r_1+1)}_{(-)} + \underbrace{\lambda}_{(0)}-\underbrace{\mu_1}_{(+)}+\underbrace{\omega_1}_{(0 \; \text{or}\; +)}=0 \\
\dfrac{\partial \mathcal{L}}{\partial g_2} &= \underbrace{-\delta(r_2+1)}_{(-)} + \underbrace{\lambda}_{(0)}-\underbrace{\mu_2}_{(+)}+\underbrace{\omega_2}_{(0 \; \text{or}\; +)}=0
\end{align*}$
that id $\lambda=0$, we must have both $\omega_1>0 \; \text{and} \; \omega_2>0$. But we cannot have both since by the complenetary slackness conditions

$\begin{align*}
\omega_1 \dfrac{\partial \mathcal{L}}{\partial \omega_1} &= \underbrace{\omega_1}_{(+)}\underbrace{g_1}_{(0)}=0 \\
\omega_1 \dfrac{\partial \mathcal{L}}{\partial \omega_2} &= \underbrace{\omega_2}_{(+)}\underbrace{g_2}_{(0)}=0
\end{align*}$
would then imply that $g_1=0$ and $g_2=0$. Given our assumption that $T>0$, this contradicts condition

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial \lambda} = \underbrace{g_1}_{(0)}+\underbrace{g_2}_{(0)} - \underbrace{T}_{(+)}=0
\end{equation*}$
It follows that $\lambda >0$, and therefore, by complementary slackness condition 

$\begin{equation*}
\lambda \dfrac{\partial \mathcal{L}}{\partial \lambda} = \underbrace{\lambda}_{(+)}\underbrace{[g_1+g_2-T]}_{(0)}=0
\end{equation*}$
that 

$\begin{equation*}
g_1+g_2=T.
\end{equation*}$

Combining the latter finding with our earlier findings that 

$\begin{align*}
g_1 &= T-r_1 \\
g_2 &= T-r_2
\end{align*}$
with a little bit of linear algebra 

$\begin{align*}
\rho_1 &+ \rho_2 \\
\rightarrow \quad(g_1+g_2) &= 2T -r_1 -r_2 \\
T &= 2T -r_1 -r_2
r_2 &= T-r_1.
\end{align*}$
Using these equality constraints to eliminate $g_1, \; g_2, \; \text{and} \; r_2$ from the origina; problem yields

$\begin{equation*}
 \max_{r_1}U=(r_1+1)(T-[T-r_1]+1)+δ([T-r-1]+1)(T-[T-[T-r_1]]+1)
  \end{equation*}$
subject to inequality contraints

$\begin{align*}
r_1 &\geq 0 \\
T-r_1 \geq 0 \\
T-r_1 \geq 0 \\
T-[T-r_1] \geq 0,
\end{align*}$
or, simplifying and eliminating redundant constraints,

$\begin{equation*}
\max_{r_1}U=(r_1+1)^2+\delta(T-r-1+1)^2
\end{equation*}$
subject to 

$\begin{align*}
r_1 \geq 0 \\
r_1 \leq T.
\end{align*}$
The associated Lagrangian is

$\begin{equation*}
\mathcal{L}=(r_1+1)^2+\delta(T-r-1+1)^2 + \mu r_1 + \nu(-r-1)
\end{equation*}$
with the key Kuhn-Tucker condition

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial r_1} = 2(r_1+1)-2\delta(T-r_1+1)+\mu-\nu=0
\end{equation*}$
There are now four cases to consider. 

Case 1: $\mu>0, \; \nu>0$. 

This case results in contradiction becase it would imply that 

$\begin{align*}
\mu \dfrac{\partial \mathcal{L}}{\partial \mu} &= \underbrace{\mu}_{(+)}\underbrace{r_1}_{(0)}= 0 \\
\nu \dfrac{\partial \mathcal{L}}{\partial \nu} &= \underbrace{\nu}_{(+)}\underbrace{(T-r_1)}_{(0)}=0 
\end{align*}$
$r_1=0$ and $r_1=T$.

Case 2: $\mu>0, \; \nu=0$

This case yields

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial r_1} = \underbrace{2}_{(+)} - \underbrace{2 \delta (T+1)}_{(+)} + \underbrace{\mu}_{(+)}=0.
\end{equation*}$
This is a feasible case provided the parameters are a certain way. 

Case 3: $\mu=0, \; \nu>0$.

This case yields $r_1=T$, and the first-order condition becomes

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial r_1} = \underbrace{2(T+1)}_{(+)}-\underbrace{2\delta}_{(+)}-\underbrace{\nu}_{(+)}=0.
\end{equation*}$
This case is feasible provided certain parameter conditions. 

Case 4: $\mu=0, \; \nu=0$

In this case, the first-order condition becomes

$\begin{equation*}
\dfrac{\partial \mathcal{L}}{\partial r_1} = \underbrace{2(r_1+1)}_{(+)}-\underbrace{2\delta(T-r_1+1)}_{(+)}=0.
\end{equation*}$
We can solve this first-order condition for $r_1$ to get

$\begin{equation*}
\hat{r}_1=\dfrac{\delta (T+1)-1}{1+\delta}.
\end{equation*}$
For this first-order condition to define a maximum it must be true that the second-order condition holds

$\begin{equation*}
\dfrac{\partial^2 \mathcal{L}}{\partial r_1^2} =2+2\delta <0
\end{equation*}$
where it is clear that it does not since $\delta$ is assumed to be strictly positive. So this first-order condition specifies a minimum. 

To reiterate this problem simplifies to 

$\begin{equation*}
  \max_{r_1}U=(r_1+1)^2+\delta (T-r_1+1)^2
\end{equation*}$
subject to 

$\begin{align*}
  r_1 &\geq 0 \\
	r_1 &\leq T
\end{align*}$
where the two results come from knife-edge cases where

$\begin{equation*}
  U(0)=1 + \delta(T+1)^2 \; \text{and} \; U(T)=(T+1)^2+\delta.
\end{equation*}$
"""

# ╔═╡ 3ebfd277-1bc5-4a80-89c7-49b532c806f7
md"""
## Graphical and Analytical Results
"""

# ╔═╡ ef801ad6-14bb-4c1c-8e08-bec20a925ccb
begin #parameters
	T=18
	δ=.5
end;

# ╔═╡ 8b47623c-5728-4a84-b0da-d564e314d801
begin #Functions
	U(r1,T,δ)=(r1+1)^2 + δ*(T-r1+1)^2
	dU(r1,T,δ)=2*(r1+1) - 2*δ*(T-r1+1)
end;

# ╔═╡ da0f4ba5-5dc5-4f21-b765-9ce7a235edc4
r1vec = collect(range(0,T,length=101))

# ╔═╡ 3471475a-0f3a-4613-906e-689d33e4f1ee
function r1_hat(r1,T,δ)

# Define the zero condition at the parameter value supplied
cond(r1) = dU(r1,T,δ)

# Specify a starting guess
r10 = 20

# Find and return the solution
r1 = find_zero(cond, r10)

end;

# ╔═╡ 8c8c0c61-8521-4aca-a9f5-103345f189ed
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
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(r1vec, U.(r1vec,T,δ), linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them - T
    plot!([T,T], [0,1.2*maximum(U.(r1vec,T,δ))], linecolor=:black, linestyle=:solid, linewidth=2) 
    plot!([0,T], [U(T,T,δ),U(T,T,δ)], linecolor=:black, linestyle=:dash)
    scatter!([T], [U(T,T,δ)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them - r1hat
    plot!([r1_hat(r1vec,T,δ),r1_hat(r1vec,T,δ)], [0,U(r1_hat(r1vec,T,δ),T,δ)], linecolor=:black, linestyle=:dash) 
    plot!([0,r1_hat(r1vec,T,δ)], [U(r1_hat(r1vec,T,δ),T,δ),U(r1_hat(r1vec,T,δ),T,δ)], linecolor=:black, linestyle=:dash)
    scatter!([r1_hat(r1vec,T,δ)], [U(r1_hat(r1vec,T,δ),T,δ)], markercolor=:white, markersize=5)

	# Axis limits
    xlims!(0, 1.05*r1vec[end])
    ylims!(0, 1.2*maximum(U.(r1vec,T,δ)))
    
    # Axis labels
    annotate!(1.071*r1vec[end], 0, text(L"r_1", :left, :center, 12))
    annotate!(0, 1.212*maximum(U.(r1vec,T,δ)), text(L"U", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, T,r1_hat(r1vec,T,δ)], [L"0", L"T",L"\hat{r}_1"])
    yticks!([0.001, U.(0,T,δ) ,U.(T,T,δ),U(r1_hat(r1vec,T,δ),T,δ)], [L"0", L"1 + \delta(T+1)^2", L"(T+1)^2+\delta",L"U(\hat{r}_1)"])

	annotate!(.75*T, U(.75*T,T,δ)+40, text(L"U(r_1)", :left, :bottom, 12))

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

# ╔═╡ 78fe1acd-1d7c-4c5d-ad19-6bd06b5f0a6c
md"""
Here we see that the solution to this problem involves the professor spending all of his time doing research on day one and then spending the whole next day grading.
"""

# ╔═╡ fc4e7c1e-fbc4-4ad2-9305-ab6aad126cce
md"""
We can achieve the same results by using the "true" Kukn-Tucker method. 
"""

# ╔═╡ 63d570f9-0ab8-4f39-aa54-4ce2f16e7b61
begin #Lagrangian
	L(r1,g1,r2,g2,T,δ) = (r1+1)*(T-g1+1)+δ*(r2+1)*(T-g2+1)
end;

# ╔═╡ 5420f62b-b528-4f0e-b1fa-2f45c3df8bdc
function true_KT(T,δ)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :L, 6, L; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, r1)
	@variable(model, g1)
	@variable(model, r2)
	@variable(model, g2)
        
    # Specify the objective function
    @NLobjective(model, Max, L(r1,g1,r2,g2,T,δ))

    # Specify the constraints, in == or >= form
    @NLconstraint(model, c1, g1+g2-T >= 0)
	@NLconstraint(model, c2, T-r1-g1 >= 0)
	@NLconstraint(model, c3, T-r2-g2 >= 0)
	@NLconstraint(model, c4, r1 >= 0)
	@NLconstraint(model, c5, r2 >= 0)
	@NLconstraint(model, c6, g1 >= 0)
	@NLconstraint(model, c7, g2 >= 0)
        
    # Pick starting values
    set_start_value(r1, 20)
	set_start_value(r2, 20)
	set_start_value(g1, 20)
	set_start_value(g2, 20)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	r1opt = round(value(r1), digits=2)
	r2opt = round(value(r2), digits=2)
	g1opt = round(value(g1), digits=2)
	g2opt = round(value(g2), digits=2)
	λopt = round(dual(c1), digits=2)
	μ_1opt = round(dual(c2), digits=2)
	μ_2opt = round(dual(c3), digits=2)
	ν_1opt = round(dual(c4), digits=2)
	ν_2opt = round(dual(c5), digits=2)
	ω_1opt = round(dual(c6), digits=2)
	ω_2opt = round(dual(c7), digits=2)

	return r1opt, r2opt, g1opt, g2opt, λopt, μ_1opt, μ_2opt, ν_1opt, ν_2opt, ω_1opt, ω_2opt
end;

# ╔═╡ f6eabd3c-3e42-466d-93fe-22085e7a7cd5
begin #results
	r1opt(T,δ)=true_KT(T,δ)[1]
	r2opt(T,δ)=true_KT(T,δ)[2]
	g1opt(T,δ)=true_KT(T,δ)[3]
	g2opt(T,δ)=true_KT(T,δ)[4]
	λopt(T,δ)=true_KT(T,δ)[5]
	μ_1opt(T,δ)=true_KT(T,δ)[6]
	μ_2opt(T,δ)=true_KT(T,δ)[7]
	ν_1opt(T,δ)=true_KT(T,δ)[8]
	ν_2opt(T,δ)=true_KT(T,δ)[9]
	ω_1opt(T,δ)=true_KT(T,δ)[10]
	ω_2opt(T,δ)=true_KT(T,δ)[11]
end;

# ╔═╡ 49c8db27-4ce1-4e52-a08e-f8119bf83858
md"""
Optimal $r_1$: $(round(r1opt(T,δ),digits=2)) 

Optimal $r_2$: $(round(r2opt(T,δ),digits=2))

Optimal $g_1$: $(round(g1opt(T,δ),digits=2))

Optimal $g_2$: $(round(g2opt(T,δ),digits=2))
"""

# ╔═╡ 78075c57-52d2-49d2-84cb-a7d8b1a7eba9
md"""
Differentiating the professor's utility gives 

$\begin{equation*}
  \dfrac{dU}{dr_1} = \underbrace{2(r_1+1)}_{\text{MB}} - \underbrace{2 \delta (T-r_1+1)}_{\text{MC}}.
\end{equation*}$
Using this we can represent the professor's problem in marginal space.
"""

# ╔═╡ d2b407ee-d778-40c5-a822-08d6f5dd4ddf
begin #marginal space
	MB(r1,T,δ)=2*(r1+1)
	MC(r1,T,δ)=2*δ*(T-r1+1)
end;

# ╔═╡ d754312b-1c4b-4b2d-8411-f96f25df98f4
begin
    graph2 = plot(
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
    plot!(r1vec, MB.(r1vec,T,δ), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(r1vec, MC.(r1vec,T,δ), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([T,T], [0,1.2*maximum(MB.(r1vec,T,δ))], linecolor=:black, linestyle=:solid) 
	plot!([0,T], [2*δ,2*δ], linecolor=:black, linestyle=:dash)
	scatter!([T], [2*δ], markercolor=:black, markersize=5)
	plot!([0,T], [2*(T+1),2*(T+1)], linecolor=:black, linestyle=:dash)
	scatter!([T], [2*(T+1)], markercolor=:black, markersize=5)

	# Key points, with dashed lines to them
    plot!([r1_hat(r1vec,T,δ),r1_hat(r1vec,T,δ)], [0,MB.(r1_hat(r1vec,T,δ),T,δ)], linecolor=:black, linestyle=:dash) 
    scatter!([r1_hat(r1vec,T,δ)], [MB.(r1_hat(r1vec,T,δ),T,δ)], markercolor=:white, markersize=5)

	# Axis limits
    xlims!(0, 1.05*r1vec[end])
    ylims!(0, 1.2*maximum(MB.(r1vec,T,δ)))
    
    # Axis labels
    annotate!(1.071*r1vec[end], 0, text(L"r_1", :left, :center, 12))
    annotate!(0, 1.212*maximum(MB.(r1vec,T,δ)), text(L"U", :center, :bottom, 12))
  
    # Axis ticks
    xticks!([0.001, r1_hat(r1vec,T,δ),T], [L" ", L"\hat{r}_1", L"T"])
    yticks!([0.001, 2*δ,MC(0,T,δ), 2*(T+1)], [L" ", L"2 \delta",L"2\delta(T+1)",L"2(T+1)"])

	#Curve Labels
	annotate!(13, MB(15,T,δ), text(L"MB(r_1)", :left, :bottom, 12))
	annotate!(13, MC(13,T,δ), text(L"MC(r_1)", :left, :bottom, 12))
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

   graph2	
end

# ╔═╡ b4d2e17a-d1b0-4a07-80ff-0cb8d444746e
md"""
For $r_1$ between $0$ and $\hat{r}_1$, the marginal cost of research exceeds the marginal benefit, so overall utility falls, by the triangular area between the MC and the MB curves. But for $r_1$ between $\hat{r}_1$ and $T$, the marginal benefit exceeds the marginal cost, so the overall utility increases, by the triangular area between the MB and MC curves. Because the latter triangle is larger than the former, overall utility is maximized at $r_1=T$. 
"""

# ╔═╡ 6060a0a8-4bd8-4b28-a9d4-3354d1de8e25
md"""
Another way of getting intuition for the solution is to go back to the formulation before substituting away the equality constraints:

$\begin{equation*}
\max_{r_1,r_1,g_1,g_2}U=(r_1+1)(T-g_1+1)+\delta(r_2+1)(T-g_2+1)
\end{equation*}$
subject to

$\begin{align*}
g_1 + g_2 &= T \\
r_1 + g_1 &=T \\
r_2 + g_2 &= T \\
\end{align*}$
and non-negativity constraints 

$\begin{align*}
r_1 & \geq 0 \\
r_2 & \geq 0 \\
g_1 & \geq 0 \\
g_2 & \geq 0
\end{align*}$
Instead of substituting away all three equality constraints, leacing only the choice variable $r_1$, we can solve just the equality constraints

$\begin{align*}
r_1 + g_1 &= T \\
r_2 + g_2 &= T \\
\end{align*}$
for $g_1$ and $g_2$ to get

$\begin{align*}
g_1 &= T - r_1 \\
g_2 = T - r_2
\end{align*}$
and thereby simplifying the problem to 

$\begin{equation*}
\max_{r_1,r_2}U=(r_1)^2 + \delta(r_2+1)^2
\end{equation*}$
subject to

$\begin{equation*}
r_1 + r_2 = T
\end{equation*}$
and inequality constraints

$\begin{align*}
r_1 & \geq 0 \\
r_2 & \geq 0 \\
r_1 & \leq T \\
r_2 & \leq T
\end{align*}$
Here's what the solution looks like:
"""

# ╔═╡ a29241fa-7333-411f-a26e-be0dff2d81ea
begin #Indifference curve plot 
	U2(r1,r2)= (r1+1)^2 + δ*(r2+1)^2 #Contour Plot utility curve
	r2_line(r1) = T- r1
end;

# ╔═╡ 26a0ef88-a806-43bf-9037-f39110b13e52
begin
    indiffplot = plot(
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
    contour!(r1vec, r1vec, U2, levels=[100,U2(r1_hat(r1vec,T,δ),r2_line.(r1_hat(r1vec,T,δ))),200,250,300,350], 
		linecolor=:lightgrey, clabels=false)
	contour!(r1vec, r1vec, U2, levels=[U(r1opt(T,δ),T,δ)], 
			linecolor=:red, clabels=false, linewidth=2)
	plot!(r1vec, r2_line.(r1vec), linecolor=:black, linestyle=:solid, inewidth=3)
	
	  # Axis limits
    xlims!(0, 1.2*r1vec[end])
    ylims!(0, 1.2*r1vec[end])
    
    # Axis labels
    annotate!(1.22*r1vec[end], 0, text(L"r_1", :left, :center, 12))
    annotate!(0, 1.2*r1vec[end], text(L"r_2", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([r1_hat(r1vec,T,δ),r1_hat(r1vec,T,δ)], [0,r2_line.(r1_hat(r1vec,T,δ))], linecolor=:black, linestyle=:dash) 
    plot!([0,r1_hat(r1vec,T,δ)], [r2_line.(r1_hat(r1vec,T,δ)),r2_line.(r1_hat(r1vec,T,δ))], linecolor=:black, linestyle=:dash)
    scatter!([r1_hat(r1vec,T,δ)], [r2_line.(r1_hat(r1vec,T,δ))], markercolor=:white, markersize=5)

	# Axis ticks
    xticks!([0.001, r1_hat(r1vec,T,δ),T], [L"0", L"\hat{r}_1",L"r^*_1=T"])
    yticks!([0.001, r2_line.(r1_hat(r1vec,T,δ)),r2_line(0)], [ L"r_2=0", L"\hat{r}_2", L"r_2"])

	#arrow
		plot!([15,15],[15,19], arrow=(:closed, 2.0),linecolor=:black)
		 plot!([15,18],[15,15], arrow=(:closed, 2.0),linecolor=:black)
	

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


   indiffplot	
end


# ╔═╡ c980b427-a6b6-478a-90f8-0f16a2f8c4b8
md"""
Notice that the indifference curves are concave to the origin, but, since $r_1$ and $r_2$ are "goods", utility increases with higher values of both. The concavity to the origin captures that per-period utility is increasing but convex in $r_t$: the marginal utility of research increases, the more research she already does in a day. This implies that, all else equal, she would prefer to concentrate her research pleasure, rather than spreading it across two days. 

Notice also that discounting tilts the indifference curves clockwise along the $45$-degree line, where $r_1=r_2 \equiv r$. The slope of the indifference curves there is 

$\begin{equation*}
\dfrac{dr_2}{dr_1} |_{IC} = -\dfrac{U_{r_1}}{U_{r_2}}=-\dfrac{2(r+1)}{2\delta(r+1)}=-\dfrac{1}{\delta} < -1
\end{equation*}$
This captures that the professor prefers not to delay her research pleasure. 

As a result, the highest indifference curve she can reach is the one indicated in red, with the optimum at $r_1^*=T$ and $r_2^*=0$.

Notice finally that, for this corner solution to be optimal, the indifference curve through the solution must be more negatively sloped than the budget constraint:

$\begin{equation*}
\dfrac{dr_2}{dr_1} |_{IC} = -\dfrac{U_{r_1}}{U_{r_2}}=-\dfrac{2(T+1)}{2\delta(0+1)}=-\dfrac{T+1}{\delta} < -1 = \dfrac{dr_2}{dr_1} |_{BC}
\end{equation*}$
 Rewriting the inequality gives 

$\begin{align*}
\dfrac{T+1}{\delta} &> 1 \\
\Leftrightarrow\quad T+1 &> \delta \\
\Leftrightarrow\quad T+1-\delta &> 0
\end{align*}$ 
This is the parameter condition deirved above for case 3 of the Kuhn-Tucker analysis with just the single choice variable $r_1$ -- the case that gave us the globally optimal solution $r_1=T$. 

For the other corner solution, at $r_1=0$ and $r_2=T$, to be locally optimal, the indifference curve through that solution must be less negatively sloped than the budget constraint:

$\begin{equation*}
\dfrac{dr_2}{dr_1} |_{IC} = -\dfrac{U_{r_1}}{U_{r_2}}=-\dfrac{2(0+1)}{2\delta(T+1)}=-\dfrac{1}{\delta(T+1)} > -1 = \dfrac{dr_2}{dr_1} |_{BC}
\end{equation*}$
Rewriting the inequality gives

$\begin{align*}
& \quad \quad \dfrac{T+1}{\delta(T+1)} < 1 \\
& \Leftrightarrow\quad 1 < \delta(T+1) \\
& \Leftrightarrow\quad \delta(T+1) - 1 > 0
\end{align*}$
This is the parameter condition derived above for Case 2 of the Kuhn-Tucker analysis with just the single choice variable $r_1$ -- the case that gave us the locally (but not gloabally) optimal solution $r_1=0$. 

The interior tangency at $(\hat{r}_1,\hat{r}_2)$ is a constrained local minimum. The Lagrangian associate with this Kuhn-Tucker case is 

$\begin{equation*}
\mathcal{L} = (r_1+1)^2+\delta(r_2+1)^2+\lambda[T-r_1-r_2],
\end{equation*}$
with first-order conditions (writing the one for $\lambda$ on the top)

$\begin{align*}
\dfrac{\partial \mathcal{L}}{\partial \lambda} &= T-r_1-r_2=0 \\
\dfrac{\partial \mathcal{L}}{\partial r_1} &= 2(r_1+1)-\lambda =0 \\
\dfrac{\partial \mathcal{L}}{\partial \lambda} &= 2\delta(r_2+1)-\lambda =0.
\end{align*}$
The bordered Hessian is 

$\begin{equation*}
H = 
\begin{bmatrix}
0 & -1 & -1 \\
-1 & 2 & 0 \\
-1 & 0 & 2
\end{bmatrix}
\end{equation*}$
and the second-order condition, $|H|$ same sign as  $(-1)^2>0$, since

$\begin{equation*}
|H| = -4 < 0
\end{equation*}$

"""

# ╔═╡ 7057fbd1-803e-4e55-b968-105e34b5df13
md"""
Alternatively, going back to the formulation before substituting away the equality constraints yet again,

$\begin{equation*}
\max_{r_1,r_1,g_1,g_2}U=(r_1+1)(T-g_1+1)+\delta(r_2+1)(T-g_2+1)
\end{equation*}$
subject to

$\begin{align*}
g_1 + g_2 &= T \\
r_1 + g_1 &=T \\
r_2 + g_2 &= T \\
\end{align*}$
and non-negativity constraints 

$\begin{align*}
r_1 & \geq 0 \\
r_2 & \geq 0 \\
g_1 & \geq 0 \\
g_2 & \geq 0
\end{align*}$
we can solve just the equaltiy constraints 

$\begin{align*}
r_1+g_1 &= T \\
r_2+g_2 &=T
\end{align*}$
for $r_1$ and $r_2$ to get 

$\begin{align*}
r_1 &= T - g_1 \\
r_2 &= T- g_2
\end{align*}$
and thereby simplify the problem to

$\begin{equation*}
\max_{g_1,g_2} U = (T-g_1+1)^2 + \delta(T-g_2+1)^2
\end{equation*}$
subject to 

$\begin{equation*}
g_1+g_2=T
\end{equation*}$
and inequality constraints

$\begin{align*}
g_1 & \geq 0 \\
g_2 & \geq 0 \\
g_1 & \leq T \\
g_2 & \leq T
\end{align*}$
Here's what then the solution looks like:
"""

# ╔═╡ f06d5da2-7e27-4cba-b3aa-a4d7cb6da022
begin #indifference curve 
	U3(g1,g2)= (T-g1+1)^2 + δ*(T-g2+1)^2
	g2_line(g1) = T- g1
	g1_line(r1) = T -r1
end;

# ╔═╡ 984cfc4d-c8a6-41f3-ba94-958653923e68
begin
    pX = plot(
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
    contour!(r1vec, r1vec, U3, levels=[U3(g1_line(r1opt(T,δ)) , g2_line(g1_line(r1opt(T,δ))))], linecolor=:red, labels=false, linewidth=2)
	
	contour!(r1vec, r1vec, U3, levels=[100,U3(g1_line(r1_hat(r1vec,T,δ)) , g2_line(g1_line(r1_hat(r1vec,T,δ)) )),200,250,300,400], 
			linecolor=:lightgrey, labels=false)
	plot!(g1_line.(r1vec), g2_line.(g1_line.(r1vec)), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.2*r1vec[end])
    ylims!(0, 1.2*r1vec[end])
    
    # Axis labels
    annotate!(1.22*r1vec[end], 0, text(L"g_1", :left, :center, 12))
    annotate!(0, 1.2*r1vec[end], text(L"g_2", :center, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([g1_line(r1_hat(r1vec,T,δ)),g1_line(r1_hat(r1vec,T,δ))], [0, g2_line(g1_line(r1_hat(r1vec,T,δ)) )], linecolor=:black, linestyle=:dash) 
    plot!([0,g1_line(r1_hat(r1vec,T,δ))], [ g2_line(g1_line(r1_hat(r1vec,T,δ)) ), g2_line(g1_line(r1_hat(r1vec,T,δ)) )], linecolor=:black, linestyle=:dash)
    scatter!([g1_line(r1_hat(r1vec,T,δ))], [ g2_line(g1_line(r1_hat(r1vec,T,δ)) )], markercolor=:white, markersize=5)

	#arrow
		plot!([18,18],[18,14], arrow=(:closed, 2.0),linecolor=:black)
		 plot!([18,15],[18,18], arrow=(:closed, 2.0),linecolor=:black)

	 # Axis ticks
    xticks!([0.001, g1_line(r1_hat(r1vec,T,δ)),T], [L"g^*_1=0", L"\hat{g}_1",L"T"])
    yticks!([0.001, g2_line(g1_line(r1_hat(r1vec,T,δ)) ) ,T], [L"0", L"\hat{g}_2", L"g_2^*=T"])
	

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


   pX	
end


# ╔═╡ 049dafbb-1c7f-4414-8e0d-70e8559dc54c
md"""
Notice that the indifference curves are convex to the origin, but, since $g_1$ and $g_2$ are "bads", utility increases with lower values of both. The convexityt to the origin captures that per-period utility is decreasing but convex in $g_t$: the marginal disutility pf grading decreases (becomes less negative), the more grading she already does in a day. This implies that, all else equal, she would prefer to concentrate her grading pain, rather than spreadign it across two days. 

Notice also again that discounting tilts the indifference curve clockwise along the 45-degree line, where $g_1=g_2 \equiv g$. The slope of indifference curves is 

$\begin{equation*}
\dfrac{dg_2}{dg_1} |_{IC} = -\dfrac{U_{g_1}}{U_{g_2}} = - \dfrac{-2(T-g+1)}{-2\delta(T-g+1)} = -\dfrac{1}{\delta}<-1.
\end{equation*}$
This captures that the professor prefers to delat her grading pain. As a result, the lowest indifference curve she can reach is the one in red, with optimum at $g-1^*=0$ and $g_2^*=T$. 

Notice that finally that, for this corner solution to be optimal, the indifference curve through the solution must be more negativelyt sloped than the budget costraint:

$\begin{equation*}
\dfrac{dg_2}{dg_1} |_{IC} = -\dfrac{U_{g_1}}{U_{g_2}} = - \dfrac{-2(T-0+1)}{-2\delta(T-T+1)} = -\dfrac{T+1}{\delta}<-1 = \dfrac{dg_2}{dg_1} |_{BC}.
\end{equation*}$
Rewriting the inequality gives

$\begin{align*}
& \quad \quad \dfrac{T+1}{\delta} > 1 \\
&\Leftrightarrow\quad T+1 > \delta \\
&\Leftrightarrow\quad T+1-\delta > 0.
\end{align*}$
This is the parameter condition derived earlier for Case 3v of the Kuhn-Tucker analysis with just the single choice variable $r_1$ -- the case that gave us the globally optimal solution $r_1=T$, implying (from the set-aside constraint $g_1=T-r-1$) that $g_1=0$.

For the other corner solutin, at $g_1=T$ and $g_2=0$, to be locally optimal, the indifference curve through that solution must be less negatively sloped than the budget constraint:

$\begin{equation*}
\dfrac{dg_2}{dg_1} |_{IC} = -\dfrac{U_{g_1}}{U_{g_2}} = - \dfrac{-2(T-T+1)}{-2\delta(T-0+1)} = -\dfrac{1}{\delta(T+1)}>-1 = \dfrac{dg_2}{dg_1} |_{BC}.
\end{equation*}$
Rewriting the inequality gives

$\begin{align*}
& \quad \quad \dfrac{1}{\delta(T+1)} < 1 \\
&\Leftrightarrow \quad 1 < \delta(T+1) \\
&\Leftrightarrow \quad \delta(T+1)-1 > 0.
\end{align*}$
This is the parameter condition derived earlier for Case 2 of the Kuhn-Tucker analysis with just the single choice variable $r_1$ -- the case that gave us the locally (but not globally) optimal solution $r_1=0$, implying (from the set-aside constraint $g_1=T-r_1$) that $g_1=T$.

The interior tangency at $(\hat{g}_1,\hat{g}_2) is again a constrained local minimum. The Lagrangian associated with this Kuhn-Tucker case is 

$\begin{equation*}
\mathcal{L}= (T-g_1+1)^2+\delta(T-g_2+1)^2+\lambda[g_1+g_2-T]
\end{equation*}$
with the first-order conditiosn (writing the one fro $\lambda$ on top)

$\begin{align*}
\dfrac{\partial \mathcal{L}}{\partial \lambda} &= g_1 + g_2 -T=0 \\
\dfrac{\partial \mathcal{L}}{\partial g_1} &= -2(T-g_1+1)+\lambda=0 \\
\dfrac{\partial \mathcal{L}}{\partial g_1} &= -2\delta (T-g_2+1)+\lambda = 0
\end{align*}$
The bordered Hessian is 

$\begin{equation*}
H =
\begin{bmatrix}
0 & 1 & 1 \\
1 & 2 & 0 \\
1 & 0 & 2
\end{bmatrix}
\end{equation*}$
and the second-order condition, $|H| eqs (-1)^2>0$ fails, since

$\begin{equation*}
|H|=-4<0.
\end{equation*}$

"""

# ╔═╡ Cell order:
# ╠═cca98ba6-d344-11ef-3ebd-a54d20671921
# ╠═d77ae4c9-b6c3-4654-9455-f2ea68b6ff54
# ╟─157cac88-7575-480d-9cee-24951889cfd0
# ╟─51939bd2-3b89-49e6-a4b7-7e01eb4ac601
# ╟─2e804666-c3d0-44fe-b449-80904c9a2ac1
# ╟─851d5796-554c-4969-88f0-c1aa21530da5
# ╟─801d4cf1-f0ea-4b38-b5f4-ad121aa13ecc
# ╟─17bb1666-de2b-4d73-932a-75fc8cca259b
# ╟─3ebfd277-1bc5-4a80-89c7-49b532c806f7
# ╠═ef801ad6-14bb-4c1c-8e08-bec20a925ccb
# ╠═8b47623c-5728-4a84-b0da-d564e314d801
# ╠═da0f4ba5-5dc5-4f21-b765-9ce7a235edc4
# ╠═3471475a-0f3a-4613-906e-689d33e4f1ee
# ╟─8c8c0c61-8521-4aca-a9f5-103345f189ed
# ╟─78fe1acd-1d7c-4c5d-ad19-6bd06b5f0a6c
# ╟─fc4e7c1e-fbc4-4ad2-9305-ab6aad126cce
# ╠═63d570f9-0ab8-4f39-aa54-4ce2f16e7b61
# ╠═5420f62b-b528-4f0e-b1fa-2f45c3df8bdc
# ╠═f6eabd3c-3e42-466d-93fe-22085e7a7cd5
# ╟─49c8db27-4ce1-4e52-a08e-f8119bf83858
# ╟─78075c57-52d2-49d2-84cb-a7d8b1a7eba9
# ╠═d2b407ee-d778-40c5-a822-08d6f5dd4ddf
# ╟─d754312b-1c4b-4b2d-8411-f96f25df98f4
# ╟─b4d2e17a-d1b0-4a07-80ff-0cb8d444746e
# ╟─6060a0a8-4bd8-4b28-a9d4-3354d1de8e25
# ╠═a29241fa-7333-411f-a26e-be0dff2d81ea
# ╟─26a0ef88-a806-43bf-9037-f39110b13e52
# ╟─c980b427-a6b6-478a-90f8-0f16a2f8c4b8
# ╟─7057fbd1-803e-4e55-b968-105e34b5df13
# ╠═f06d5da2-7e27-4cba-b3aa-a4d7cb6da022
# ╟─984cfc4d-c8a6-41f3-ba94-958653923e68
# ╟─049dafbb-1c7f-4414-8e0d-70e8559dc54c
