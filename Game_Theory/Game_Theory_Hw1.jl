### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ a6ce4e98-e5a4-11ef-140c-c70897198774
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
    #using DifferentialEquations  
	#using GameTheory
	using Graphs
	#using GraphPlot
	#using NetworkLayout
	#using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
   # using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	using Plots     # plot graphs
	using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ 4ae4391e-228e-4e7c-8544-1be33595f5a3
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ bed66f64-fbe1-4757-89d4-27d1d21689ff
md"""
# Game Theory Problem Set 1
"""

# ╔═╡ 3fab9d75-b6fa-4f0e-a372-bcea6cf0c1ff
md"""
## Question 1
"""

# ╔═╡ 5d5057df-b2f8-4ec1-b5f8-4ca5687d2137
md"""
Consider a person that has a Von Neumann-Morgensern utility function, defined on money, such that an increase in wealth from $w$ to $w+Δ$ leads to an increase in utility that is directly proportional to $\Delta$ but inversely proportional to $w$ $(i.e. \; u(w+\Delta)-u(w))=\alpha(\Delta/w)$ for some positive parameter $\alpha$.
"""

# ╔═╡ 93b9952b-2b8d-48c1-ba87-b4020ab945b3
md"""
a. Find a utility function that his this proprty. [Hint: what happens to $u(w+\Delta)$ as $\Delta$ tends to zero?]

We are given the equation 

$\begin{equation*}
u(w+\Delta)-u(w) = \alpha(\dfrac{\Delta}{w})
\end{equation*}$
which we can rearrange to create

$\begin{equation*}
\dfrac{u(w+\Delta)-u(w)}{\Delta} = \dfrac{\alpha}{w}. 
\end{equation*}$
The limit of the left hand side as $\Delta$ approaches zero is

$\begin{equation*}
\lim_{\Delta \rightarrow 0}\dfrac{u(w+\Delta)-u(w)}{\Delta} = u'(w)
\end{equation*}$
by the fundamental theorem of calculus. Using this value gives

$\begin{equation*}
u'(w) = \dfrac{a}{w}
\end{equation*}$
which is a differential equation. Integrating both sides over the range $(1,w)$ 

$\begin{align*}
&\int^w_1 u'(w) dw = \int^w_1 \dfrac{\alpha}{w} dw \\
& \Rightarrow \quad u(w) = \alpha \cdot ln(w) 
\end{align*}$
for the domain $w \in [1,\infty]$ where we assume that $u(1)=0$.
"""

# ╔═╡ 754d556f-e1bc-487a-9845-dae48145b9cb
wvec=collect(range(1,100,length=1001))

# ╔═╡ 9e914985-8c20-4a26-b109-55e6ea3560f3
begin #parameters
	α=2
end;

# ╔═╡ 41376947-b169-416c-a200-8aeaed8d1659
begin #equations
	u(w) = α * log(w) 
end;

# ╔═╡ 0f435ab0-b9cb-4eaf-9357-9b387f2e5cc8
begin
    utility = plot(
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
    plot!(wvec, u.(wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*wvec[end])
    ylims!(0, 1.2*maximum(u.(wvec)))
    
    # Axis labels
    annotate!(1.071*wvec[end], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.212*maximum(u.(wvec)), text(L"u", :center, :bottom, 12))
	
	# Axis ticks
    xticks!([0.001], [L"0"])
    yticks!([0.001], [L"0"])

	annotate!(50, u.(50), text(L"u(w)", :left, :bottom, 12))
	
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
	
   utility	
end


# ╔═╡ 02e0f84d-7565-499d-b3cc-462844a98931
md"""
b. Show that $u(w)$ has decreasing absolute risk aversion and constant relative risk aversion. 

The coefficient for absolute and relative risk aversion are

$\begin{align*}
\lambda(x) &= -\dfrac{u''(x)}{u'(x)} \\
\mu(x) &= -x\dfrac{ u''(x)}{u'(x)}
\end{align*}$
respectively. Note here that $\mu(x)=x\lambda(x)$ which can be interpreted as saying that constant relative risk aversion implies decreasing asbolute risk aversion. To demonstrate this we set $\mu(x)$ to $C$ which stands for constant

$\begin{align*}
C &= x \lambda(x) \\
&\Rightarrow \lambda(x) =\dfrac{1}{x}+C
\end{align*}$
where we can see that $\lambda$ is decreasing with increased $x$. Likewise for our utility equation 

$\begin{align*}
\mu(w) &= - w \dfrac{u''(w)}{u'(w)} \\
&= - w (\dfrac{-\dfrac{\alpha}{w^2}}{\dfrac{\alpha}{w}}) \\
&= -w (-\dfrac{\alpha}{w^2} \cdot \dfrac{w}{\alpha}) \\
&= -w(-\dfrac{1}{w}) \\
&= 1.
\end{align*}$
This shows that our utility function has constant relative risk aversion which implies that is has decreasing absolute risk aversion.

"""

# ╔═╡ 6475c5e2-2495-44aa-bd06-9a4e6c29c2fd
md"""
c. Let $p(x)=x^{-2}, \; x >1$. Confirm that $p(x)$ is a bonda fide lottery, and then calculate its expected monetray value.

A lottery is defined as the set of all probability distributions on $X$. A simple probability distribution $p$ over $X$ must be satisfy the following conditions

$\begin{align*}
&p(x) > 0 \; \text{for each prize} \; x \in supp(p) \\
& \Sigma_{x \in supp(p)}p(x)=1.
\end{align*}$
Here the support of $p$ is defined as $x >1$ or $(1,\infty)$. So to calculate the sum of a continuous series we will integrate $p(x)$ over these bounds

$\begin{align*}
\int^\infty_1 \dfrac{1}{x^2}dx &= [-\dfrac{1}{x}|^\infty_1\\
&= (- \dfrac{1}{\infty}) - (-\dfrac{1}{1}) \\
&= 1.
\end{align*}$
So $p(x)$ is a bona fide lottery.

The expected monetary value for this lottery is 

$\begin{align*}
E(x) &= \int^\infty_1 x \cdot \dfrac{1}{x^2}dx\\
&= \int^\infty_1 \dfrac{1}{x}dx \\
&= [ln(x)|^\infty_1 \\
&= \infty
\end{align*}$

"""

# ╔═╡ 7ff28595-cf46-4e3b-be9f-c89bc6ee6a09
md"""
d. Show that a person with sufficiently large initial wealth will not be willing to trade his
entire fortune to play this lottery. [Hint: use integration by parts and L’Hôpital’s rule].
Find the value of initial wealth at which this person is just indifferent between playing this
lottery and not keeping his wealth (i.e., not playing the lottery).

Following the von Neumann-Morgenstain axiomx, an agent will operate to increase his/her expected utility. We can define the Expected Utility $(EU_p)$ over the lottery $p$ as

$\begin{equation*}
EU_p = \Sigma_{w \in supp(p)}u(w)p(w)
\end{equation*}$
which in continuous form is 

$\begin{align*}
EU_p &= \int^\infty_1u(w)p(w) dw \\
&= \int^\infty_1 (\alpha \cdot ln(w)) \cdot \dfrac{1}{w^2}dw .
\end{align*}$
Using integration by parts we can solve this problem as

$\begin{align*}
\int^\infty_1 (\alpha \cdot ln(w)) \cdot \dfrac{1}{w^2}dw &= -\dfrac{\alpha ln(w)}{w}|^\infty_0 - \int^\infty_1 -\dfrac{\alpha}{w^2}dw \\
&= -\dfrac{\alpha ln(w)}{w}|^\infty_0 + \alpha \int^\infty_1 \dfrac{1}{w^2}dw \\
&= -\dfrac{\alpha ln(w)}{w}|^\infty_0 + \alpha [-\dfrac{1}{w}|^\infty_1 \\
\end{align*}$
Using L'Hopital's rule this expression simplifies to

$\begin{align*}
\int^\infty_1 (\alpha \cdot ln(w)) \cdot \dfrac{1}{w^2}dw &= - \dfrac{\dfrac{-\alpha}{\infty}}{1} + \alpha[(-\dfrac{1}{\infty})-(-\dfrac{1}{1})] \\
&= \alpha. 
\end{align*}$
So the expected value of this lottery is equivalent to $\alpha$, to prove that a player wiht sufficiently large amounts of wealth will not choose to play this game I will assume that the expected value of this game is larger than his utility for wealth and prove this forms a contradiction. So assuming that gives

$\begin{align*}
\alpha ln(w) &< \alpha \\
\lim_{w \rightarrow \infty} \alpha ln(w) &< \lim_{w \rightarrow \infty}\alpha \\
\infty < \alpha
\end{align*}$
which is a contradiction. The level of wealth where the player would be indifferent would be 

$\begin{align*}
\alpha ln (w) &= \alpha \\
ln(w) &= 1 \\
w &= e
\end{align*}$
implying that if the player has wealth equivalent to $e$ he is indifferent between keeping his wealth and playing the game.
"""

# ╔═╡ 085abe56-8182-41a2-a43f-89a64f490f51
md"""
## Question 2
"""

# ╔═╡ cd76463c-4c2d-4f1b-a941-98e2a515efb8
md"""
A risk averse expected utility maximizer must choose between (1) a sure payment of \$200; (2) a lottery paying \$0 with probability ,5, \$200 with probability .3, \$450 with probability .1, and \$1,000 with probability .1; (3) a lottery paying \$0, \$100, \$200, or \$520 each with probability $1/4$. Her preferences exhibit constant absolute risk aversion over the range of prizes and her certainty equivalent for a lottery paying \$1,000 or \$0 with probability $1/2$ turns out to be \$470. Determine which of the three gambles she would prefer, and explain your answer.
"""

# ╔═╡ 6bb0bec8-95fe-48de-b081-e765e8a8df8e
md"""
We know two things about this agent, the first is that their preferences exhibit constant absolute risk aversion which means

$\begin{equation*}
λ = -\dfrac{u''(x)}{u'(x)}
\end{equation*}$
where $\lambda$ is a constant. This condition can be rearranged to

$\begin{equation*}
\lambda u'(x) + u''(x) = 0
\end{equation*}$
which is second-order linear differential equation. We can solve this differential equation to give

$\begin{align*}
e^{\lambda x}\lambda u'(x) +e^{\lambda x} u''(x) &= 0 \\
\dfrac{d}{dx}[e^{\lambda x} u'(x)] &= 0 \\
\int \dfrac{d}{dx}[e^{\lambda x} u'(x)] dx &=\int 0 dx \\
e^{\lambda x} u'(x) &= K_1 \\
u'(x) &= K_1 e^{-\lambda x} \\
\int u'(x) dx &= \int K_1 e^{-\lambda x}  dx\\
u(x) &= K_2 + \dfrac{K_1}{-\lambda} e^{-\lambda x} 
\end{align*}$
we can rewrite this expression as $K_1=u_0$ and $\dfrac{K_1}{-\lambda} = u_1$ to get

$\begin{equation*}
u(x) = u_0 + u_1 e^{-\lambda x}. 
\end{equation*}$ 
where $u_0$ can be negative or positive but $u_1$ is a negative constant to maintain concavity. The second is that between lottery paying \$1,000 or \$0 with probability $1/2$ the agent would accept \$470 as a certainty equivalent. This can be expressed as

$\begin{equation*}
u(470) = \dfrac{u(1000)}{2}+ \dfrac{u(0)}{2}.
\end{equation*}$
Knowing these two facts we can solve for the agent's $\lambda$ and use that to prove which gamble the agent would prefer,

$\begin{align*}
u_o + u_1e^{-470 \lambda} &= \dfrac{u_o + u_1e^{-1000 \lambda}}{2} + \dfrac{u_o + u_1e^{-0 \lambda}}{2} \\
u_o + u_1e^{-470 \lambda}&=  \dfrac{u_o + u_1e^{-1000 \lambda}}{2} + \dfrac{u_o + u_1}{2} \\
2u_o + 2u_1e^{-470 \lambda} &= u_o + u_1e^{-1000 \lambda} + u_o + u_1 \\
2u_1e^{-470 \lambda} &= u_1e^{-1000 \lambda} + u_1 \\
2e^{-470 \lambda} &= e^{-1000 \lambda} + 1 \\
2e^{-470 \lambda} - e^{-1000 \lambda} - 1 &= 0. 
\end{align*}$
We can solve this equation numerically to get two roots for $\lambda$, $0$ and $0.00024057794240086225$. 

Representing the gambles in this utility form results in  comparing the values of the following three gambles

$\begin{align*}
1.& \; u_0 + u_1e^{-\lambda 200} \\
2.& \; (u_0 + u_1e^{-\lambda 0})\cdot .5 + (u_0 + u_1e^{-\lambda 200})\cdot .3 + (u_0 + u_1e^{-\lambda 450})\cdot .1 + (u_0 + u_1e^{-\lambda 1,000})\cdot .1 \\
3.& \; (u_0 + u_1e^{-\lambda 0})\cdot .25 + (u_0 + u_1e^{-\lambda 100})\cdot .25 + (u_0 + u_1e^{-\lambda 200})\cdot .25 + (u_0 + u_1e^{-\lambda 520})\cdot .25.
\end{align*}$
When $\lambda=0$ the agent all three gambles are equivalent meaning the agent would be indifferent between all three of them. When $\lambda=0.00024057794240086225$ the agent's preferred choice is lottery 3. The ordering between the three lotteries hold for any linear combination of $u_1$ and $u_0$, where the only condition is that $u_1$ remain negative. The simplest linear combination which epxpress this result is $u_1=-1$ and $u_0=1$ which results in 

$\begin{align*}
u_1 &= -3960.392356455952 \\
u_2 &= -3965.547521014713 \\
u_3 &= -3959.941993897163
\end{align*}$
where we see that the utility the agent receives from lottery 3 is larger than lotteries 1 or 2. 
"""

# ╔═╡ 7b6ba8b6-3e1e-48fe-90e0-a3fc1955f54d
lamvec = collect(range(-1,1,length=1000))

# ╔═╡ 68ee9f3f-3a64-4997-8970-bbd049b7a927
begin 
	t(λ) = 2*exp(-470*λ)-exp(-1000*λ)-1
end

# ╔═╡ 451cbe2a-0bc4-4a4a-9c38-9182f7bec6e7
function fz(λ)


	# Define the zero condition at the parameter value supplied
	cond(λ) = t(λ)


	# Specify a starting guess
	λ0 = .001

	# Find and return the solution
	λ = find_zero(cond, λ0)

end;


# ╔═╡ d0e1bba1-21cf-4058-a25d-145bae8e4034
begin
ub(x,u0,u1)=u0 + (-u1/fz(lamvec))*exp(-fz(lamvec)*x)
end;

# ╔═╡ 9cae561c-a33e-4a2b-b824-336195da90c7
fz(lamvec)

# ╔═╡ df2f2797-bf20-4e64-9da4-ac9e0375356f
ub(200,1,1) #gamble 1

# ╔═╡ 7f957310-50ab-42fd-bb6d-30953ef24f5f
ub(0,1,1)*.5 + ub(200,1,1)*.3 + ub(450,1,1)*.1 + ub(1000,1,1)*.1 #gamble 2

# ╔═╡ 69127b46-abf3-4984-b5dd-3a1da89413c2
ub(0,1,1)*.25 + ub(100,1,1)*.25 + ub(200,1,1)*.25 + ub(520,1,1)*.25 #gamble 3

# ╔═╡ Cell order:
# ╠═a6ce4e98-e5a4-11ef-140c-c70897198774
# ╠═4ae4391e-228e-4e7c-8544-1be33595f5a3
# ╟─bed66f64-fbe1-4757-89d4-27d1d21689ff
# ╟─3fab9d75-b6fa-4f0e-a372-bcea6cf0c1ff
# ╟─5d5057df-b2f8-4ec1-b5f8-4ca5687d2137
# ╟─93b9952b-2b8d-48c1-ba87-b4020ab945b3
# ╠═754d556f-e1bc-487a-9845-dae48145b9cb
# ╠═41376947-b169-416c-a200-8aeaed8d1659
# ╠═9e914985-8c20-4a26-b109-55e6ea3560f3
# ╟─0f435ab0-b9cb-4eaf-9357-9b387f2e5cc8
# ╟─02e0f84d-7565-499d-b3cc-462844a98931
# ╟─6475c5e2-2495-44aa-bd06-9a4e6c29c2fd
# ╟─7ff28595-cf46-4e3b-be9f-c89bc6ee6a09
# ╟─085abe56-8182-41a2-a43f-89a64f490f51
# ╟─cd76463c-4c2d-4f1b-a941-98e2a515efb8
# ╟─6bb0bec8-95fe-48de-b081-e765e8a8df8e
# ╠═7b6ba8b6-3e1e-48fe-90e0-a3fc1955f54d
# ╠═68ee9f3f-3a64-4997-8970-bbd049b7a927
# ╠═451cbe2a-0bc4-4a4a-9c38-9182f7bec6e7
# ╠═d0e1bba1-21cf-4058-a25d-145bae8e4034
# ╠═9cae561c-a33e-4a2b-b824-336195da90c7
# ╠═df2f2797-bf20-4e64-9da4-ac9e0375356f
# ╠═7f957310-50ab-42fd-bb6d-30953ef24f5f
# ╠═69127b46-abf3-4984-b5dd-3a1da89413c2
