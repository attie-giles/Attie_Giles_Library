### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ e3e3c082-9bbd-11ef-2e34-b1d916a0220f
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	using Ipopt     # find a max or min
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

# ╔═╡ 93694dbc-a3b4-46ea-8d94-0eac0a88912e
md"""
# Quasi-Concavity
"""

# ╔═╡ 9005f4cc-21d1-4353-9974-70e2fb1b9d8f
md"""
Quasi-concave curves are curves that look like indifference curves 

$\begin{equation*}
  U(F,l)-k=0
\end{equation*}$

where we can implicitly define Fish as a function of leisure.

$\begin{equation*}
  F^{IC}(l)
\end{equation*}$

$\begin{equation*}
   F^{IC'}(l)=\frac{dF^{IC'}}{dl}=-\frac{U_l(F,l)}{U_F(F,l)}.
\end{equation*}$
Where when we derive the second derivative F^{IC''} we see that it is positive, indicating an upward sloping indifference curve. What separates a quasiconcave function from a concave function is that quasiconcave is defined as all upper contour sets are strictly convex, meaning any two points in the upper angle of the graph and the line between them will remain in that upper contour. All convex grapsh are striclty quasiconcave, but not all quasiconcave graphs are concave. Quasiconcave functions usually deal with ordinal properties of the utility function, where preferences are not in cardinal numbers and the graph can be altered while still preserving ordinality. 
"""

# ╔═╡ 697728e1-a353-4769-afc6-0665d219516e
begin
	α=.5
	U(F,l)=(F^α)*(l^(1-α))
	U_F(F,l)=α*(F^(α-1))*(l^(1-α))
	U_l(F,l)=(1-α)*(F^α)*(l^(-α))
	dF(F,l)=-U_l(F,l)/U_F(F,l)
end;

# ╔═╡ 2e7b4b99-c54d-4fe3-9e7c-52a2a3f56206
function optl(F,k)

# Define the zero condition at the parameter value supplied
cond(l) = U(F,l)-k

# Specify a starting guess
l0 = 1

# Find and return the solution
l = find_zero(cond, l0)

end;

# ╔═╡ 986da983-1659-4444-8cae-aef66969e71f
U.(1,optl.(1,4))

# ╔═╡ 73e38704-67b9-4579-ad5e-58bf6392a154
fishvec=collect(range(.1,20, length=101))

# ╔═╡ 0000714f-e8de-4a3a-86c7-0aa86e0b242d
dF.(fishvec,optl.(fishvec,4))

# ╔═╡ 9628f761-6009-4ba1-8402-90ab8add91e2
leisurevec=collect(range(.1,20,length=101))

# ╔═╡ 4cb2ea67-60d7-4cf9-abf4-9123e239aeae
begin
    uplot = plot(
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
	plot!(fishvec,optl.(fishvec,4), linecolor=:black, linestyle=:solid, linewidth=2)
	contour!(fishvec, leisurevec, U, levels=([4,8,12]),
		linecolor=:black, clabels=true)
	# Axis limits
    xlims!(0, fishvec[end])
    ylims!(0, leisurevec[end])
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

   uplot	
end

# ╔═╡ Cell order:
# ╠═e3e3c082-9bbd-11ef-2e34-b1d916a0220f
# ╟─93694dbc-a3b4-46ea-8d94-0eac0a88912e
# ╠═9005f4cc-21d1-4353-9974-70e2fb1b9d8f
# ╠═697728e1-a353-4769-afc6-0665d219516e
# ╠═2e7b4b99-c54d-4fe3-9e7c-52a2a3f56206
# ╠═986da983-1659-4444-8cae-aef66969e71f
# ╠═0000714f-e8de-4a3a-86c7-0aa86e0b242d
# ╠═73e38704-67b9-4579-ad5e-58bf6392a154
# ╠═9628f761-6009-4ba1-8402-90ab8add91e2
# ╠═4cb2ea67-60d7-4cf9-abf4-9123e239aeae
