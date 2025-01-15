### A Pluto.jl notebook ###
# v0.19.46

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

# ╔═╡ 2e804666-c3d0-44fe-b449-80904c9a2ac1
md"""
A professor gets positive utility from hours $r$ in a day spent doing research, but negaibe utility from horus $g$ spent grading. Specifically, her utility each day is

$\begin{equation*}
  u(r_t,g_t)=(r_t+1)(T-g_t+1), \; t ∈{1,2}
\end{equation*}$
where $T>0$ is hte bumber of hotus avaible after eating, sleeping ,etc. Now consider a two-day period in which the professor chooses $r_1$ and $g_1$ for day 1 as well as $r_2$ and $_2$ for day 2. She does so subject to non-negativity constrainys on all of her choice variables, to the upper bound on available hpurs in each day, and also to a constrain that she'll need to spend at least $T$ hours over the two days combined to finish her grading. Importantly, she discounts the second day's utility by a factor $δ<1$.

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
For an in depth analysis see the notes on this problem. This problem simplifies to 

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
## Find_Zero Method
"""

# ╔═╡ ef801ad6-14bb-4c1c-8e08-bec20a925ccb
begin #parameters
	T=18
	δ=.8
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
    scatter!([r1_hat(r1vec,T,δ)], [U(r1_hat(r1vec,T,δ),T,δ)], markercolor=:black, markersize=5)

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

# ╔═╡ a8639047-97ea-4f21-baee-34afe2d783a5
md"""
## Ipot method
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

# ╔═╡ db8a20e5-aad7-4a5a-9cad-d65b0e8692c1
md"""
## Continuation of Find_Zero Method
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

	# Key points, with dashed lines to them
    plot!([r1_hat(r1vec,T,δ),r1_hat(r1vec,T,δ)], [0,MB.(r1_hat(r1vec,T,δ),T,δ)], linecolor=:black, linestyle=:dash) 
    scatter!([r1_hat(r1vec,T,δ)], [MB.(r1_hat(r1vec,T,δ),T,δ)], markercolor=:black, markersize=5)

	# Axis limits
    xlims!(0, 1.05*r1vec[end])
    ylims!(0, 1.2*maximum(MB.(r1vec,T,δ)))
    
    # Axis labels
    annotate!(1.071*r1vec[end], 0, text(L"r_1", :left, :center, 12))
    annotate!(0, 1.212*maximum(MB.(r1vec,T,δ)), text(L"U", :center, :bottom, 12))
  
    # Axis ticks
    #xticks!([0.001, xstar], [L"0", L"x^*"])
    #yticks!([0.001, f0 ,fxvec], [L"0", L"f(0)", L"f(x^*)"])
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

# ╔═╡ Cell order:
# ╠═cca98ba6-d344-11ef-3ebd-a54d20671921
# ╠═d77ae4c9-b6c3-4654-9455-f2ea68b6ff54
# ╟─157cac88-7575-480d-9cee-24951889cfd0
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
# ╟─a8639047-97ea-4f21-baee-34afe2d783a5
# ╟─fc4e7c1e-fbc4-4ad2-9305-ab6aad126cce
# ╠═63d570f9-0ab8-4f39-aa54-4ce2f16e7b61
# ╠═5420f62b-b528-4f0e-b1fa-2f45c3df8bdc
# ╠═f6eabd3c-3e42-466d-93fe-22085e7a7cd5
# ╟─49c8db27-4ce1-4e52-a08e-f8119bf83858
# ╟─db8a20e5-aad7-4a5a-9cad-d65b0e8692c1
# ╟─78075c57-52d2-49d2-84cb-a7d8b1a7eba9
# ╠═d2b407ee-d778-40c5-a822-08d6f5dd4ddf
# ╠═d754312b-1c4b-4b2d-8411-f96f25df98f4
