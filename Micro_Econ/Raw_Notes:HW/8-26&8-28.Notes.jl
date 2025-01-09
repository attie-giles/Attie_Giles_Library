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

# ╔═╡ 013027b0-63de-11ef-00d8-0f5e499e43c4
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
	using Printf #allows you to use sprintf
end

# ╔═╡ f82a414a-fbee-42f0-9eed-7a771e21eb4b
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 546c1a5e-80d2-4f40-a7ea-98351529b808
md"""
# 8-26 Notes/ Homework
"""

# ╔═╡ 5efa667b-5823-401e-8623-ac4dd3f1441a
md"""
## Using an implicit function
"""

# ╔═╡ 8b727ece-fb97-476b-9e75-32f83c3b2110
function peqY(Y)
	#Define the zero condition, at the parameter values supplied
	cond(p) = Qd_Y(p,Y) - Qs(p)

	#specify a starting 
	pθ = 20

	#Find and return 
	p = find_zero(cond, pθ)
end

# ╔═╡ ea437276-83ff-4ae3-944d-1c9b5cfbd70a
md"""
# 8-28 Notes/ Homework
"""

# ╔═╡ fd906829-e0a6-42e4-ae8f-205cf92b5f73
md"""
Another way of doing implicit functions
"""

# ╔═╡ 5357edb3-7a7f-43c4-8e05-40571ebd9bde
peqY2(Y) = find_zero(p -> Qd_Y(p, Y) - QuickSort(p), 20)

# ╔═╡ 724a8b25-f994-4eb1-bfc8-2e5ca34c5700
md"""
## Plotting and solving the Vanilla Consumer Problem
"""

# ╔═╡ 899eb001-3771-43c1-8d5e-72a835c549d3
md"""
The budget constraint 

$\begin{equation*}
  I = p_1x_1 + p_2x_2
\end{equation*}$

is easy to solve for $x_2$ as an *explicit* function

"""

# ╔═╡ dec96e13-6535-435d-a44f-8277b0dc1042
p1 = 15

# ╔═╡ ac024db5-b844-42ba-ad87-465df15b308f
p2 = 20

# ╔═╡ bd2938aa-1689-4ea2-bc9f-5139aac88f42
I = 120

# ╔═╡ 3c552d6f-8eb2-4869-9ad0-bd59dad35d1a
x2(x1) = (I - p1*x1)/p2

# ╔═╡ 8bc54397-7567-477b-ab66-6cf384165060
p0 = 4

# ╔═╡ 1231bfc5-208f-40f4-9611-0d63a8e1c2f4
function x2find(x1)

# Define the zero condition at the parameter value supplied
cond(x2) = I - (p1*x1 + p2*x2)

# Specify a starting guess
x20 = 4

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ d1c6c0fa-8a09-41a2-ae3f-45d96a8b840e
md"Check implicit function: $(@bind check_implicit CheckBox(default=false))"

# ╔═╡ 853322ce-98a7-427d-a47d-c29ff084af36
md"""
Utility function 

Plot indifference curves for utility levels k = 3, 4, 5, 6
"""

# ╔═╡ 1b160a1b-6e51-4ee1-b72e-b769cf73e5d8
md"""
Modelling Homework Leftovers

the solution "given by" 

$\begin{equation*}
  p - c'(q) = 0
\end{equation*}$

the optimal price is 

$\begin{equation*}
  p = c'(q)

\end{equation*}$

is implcit!
"""

# ╔═╡ 9243413d-38bf-4c27-b99a-049f4dfac9a1
md"""
# 9-4 Work
"""

# ╔═╡ 71f35adc-1f5b-4153-b813-a1fd16677bce
md"""
## Plotting the indifference curves
"""

# ╔═╡ 083b63ac-0e7d-46ab-bc8a-d592d750b042
md"""
Here's the pseudo-code that you should try and turn to actual code, using my vector iteration snippet as a starting point:

- Create a vector of x1 coordinates
- Create a equal-sized vector of x2 coordinates initially filled with NaN values
- Through simple trial and error, find some element of the x1 vector for which  find_zero *does* converge when you give it a specific starting value x20
- If that starting element is at the very beginning of the x1Vec, then loop *up* from it over all the elements of x1Vec, and
    . on the very first iteration of the loop, use the specific value x20 as the starting point for your find_zero (cold start)
    . on every subsequent iteration, use the solution value x2 that you found on the previous iteration as the starting point for find_zero (hot start)
- If the starting element is at the very end of the x1Vec, then do the same, but loop *down* from from it over all the elements of x1Vec
- If the starting point is somewhere in the middle of the x1Vec, then first  loop up from it, and then go back to it and loop down from it.
"""

# ╔═╡ 5f2d3fc7-16a5-405d-99b3-e9b1eb08d79e
α = 0.6

# ╔═╡ b04e16d1-ef33-423c-b62b-530ff0036d97
k = collect(range(3,6,length=4))

# ╔═╡ 6c076aa4-4792-4c8b-839b-86645ad2096e
U(x1, x2) = x1^(α) * x2^(1-α)

# ╔═╡ d9e8d937-de97-4ee9-b783-6307419ce493
function Util(x1, k)

# Define the zero condition at the parameter value supplied, in this case the zero condition is 3, beause that's the utility level to reach.
cond1(x2) = k - U(x1,x2)

# Specify a starting guess
U1 = 1

# Find and return the solution
x2 = find_zero(cond1, U1)

end;

# ╔═╡ 198bbc54-595c-4ad0-b408-beab6f5ed808
x1vec = collect(range(0.1, 13, length=10001))

# ╔═╡ f2a19553-4ee4-440a-a22a-9a68f410853c
# ╠═╡ disabled = true
#=╠═╡
x2vec = copy(x1vec)
  ╠═╡ =#

# ╔═╡ 44d80ce4-6428-4d47-a1fa-9c802f7d920f
begin
    budgetcontraint = plot(
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
	    if check_implicit
		 # Plot the implicit function in red
	  plot!(x1vec, x2find.(x1vec), linecolor=:red, linewidth=2)
    end


	
	# Axis limits
    xlims!(0, 1.05*x1vec[end])
    ylims!(0, 1.2*maximum(x2.(x1vec)))

	# Axis labels
    annotate!(1.02*xlims(budgetcontraint)[2], 0, text(L"x1", :left, :center, 12))
    annotate!(0, 1.01*ylims(budgetcontraint)[2], text(L"x2", :center, :bottom, 12))

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

   budgetcontraint	
end

# ╔═╡ 3b73747e-c113-4d23-8d43-84b572e7a08c
Util.(x1vec,3)

# ╔═╡ b333dfcf-c268-41a0-9f02-89c46e4f8925
x1nvec = collect(range(0,10,length=1001))

# ╔═╡ e6a88d36-13dd-4b39-8c43-7e253ba5dc9e
function Hot_Start(x1, k)
	cond1(x2) = k - U(x1,x2)
	for i = 1:length(x1nvec) 
	x20 = x1nvec[i]
		try 
		x2=find_zero(cond1, x20)
			return x2
		catch e
			if isa(e, TypeError)
				continue
			end
		end
	end
end
	

# ╔═╡ 849e3aa2-2160-4f9f-b29a-c62f742b092c
function tangent(x1) #find zero for the total Space
	cond1(x2) = I - (p1*x1 + p2*x2) - U(x1,x2)
	U1 = 1
	x20 = find_zero(cond1,U1)
end

# ╔═╡ 832335a3-2d01-4535-8477-5b242930f5c7
function tangent2(x1) #find zero for the marginal Space
	cond1(x2) = p1/p2 - (α*x2)/(x1*(1-α))
	U1 = 1
	x20 = find_zero(cond1,U1)
end

# ╔═╡ d6118808-793e-41f0-a588-9ee56004edf1
function tangent3() #Set the values for this function to search for the tangent values along the x1vec 
	x1opt = 0
	x2opt = 0
	k=0
	for i=1:1:5000
		if .999*tangent(x1vec[i]) <= tangent2(x1vec[i]) <= 1.001*tangent(x1vec[i])
			x1opt = x1vec[i]
			x2opt = x2(x1opt)
		end
	end
 	k = (x1opt)^α*(x2opt)^(1-α)
	return k
end

# ╔═╡ 097e9abe-038a-40a8-8fbb-417d911c844d
tangent3()

# ╔═╡ cd5e86e3-a2eb-4adb-babc-c93e76b555df
function tangent4() #Set the values for this function to search for the tangent values along the x1vec 
	x1opt = 0
	x2opt = 0
	k=0
	for i=1:1:5000
		if .999*tangent(x1vec[i]) <= tangent2(x1vec[i]) <= 1.001*tangent(x1vec[i])
			x1opt = x1vec[i]
			x2opt = x2(x1opt)
		end
	end
 	k = (x1opt)^α*(x2opt)^(1-α)
	return [x1opt, x2opt]
end

# ╔═╡ 40df2b5c-3a2d-4274-b18f-6f19570ed3eb
tangent4()

# ╔═╡ d4d0ff05-1c08-49fb-b279-4769b28b4d68
md"Plot Indifference Curves Implicitly: $(@bind Plot_indifference_curves_Implicitly CheckBox(default=false))"

# ╔═╡ 72531710-e4fc-41b5-8095-fe99d3b4dfa1
begin
    Utility = plot(
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
   	if Plot_indifference_curves_Implicitly == true
		for n = 1:1:4
	plot!(x1vec, Util.(x1vec, k[n]), linecolor=:black, linestyle=:solid, linewidth=2)
		end
	end

	xlims!(0, 5)
    ylims!(0, 500)

	 # Axis labels
    annotate!(1.02*xlims(Utility)[2], 0, text(L"x1", :left, :center, 12))
    annotate!(0, 1.01*ylims(Utility)[2], text(L"x2", :center, :bottom, 12))
	
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

   Utility	
end

# ╔═╡ b9365aa3-1cc0-40e6-b027-a542bf18979c
md"Plot Indifference Curves Cold Start: $(@bind Plot_indifference_curves_Cold CheckBox(default=false))"

# ╔═╡ 39c1a25a-8efc-490c-8b9a-adea95531fdf
md"Plot Indifference Curves Hot Start: $(@bind Plot_indifference_curves_Hot CheckBox(default=false))"

# ╔═╡ d5ecc102-e6f2-4e17-9ad2-ae0349d4b02e
md"Plot Indifference Curves Contour Command: $(@bind Plot_indifference_curves_Countour CheckBox(default=false))"

# ╔═╡ 425b879d-4f06-4b0c-a4a8-a711b2b22139
md"Tangent Curve: $(@bind tangent_curve CheckBox(default=false))"

# ╔═╡ bb9de44f-34e8-4556-89b7-96b7aa2b75df
begin
    Utility2 = plot(
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
		if tangent_curve==true
		plot!(x1vec, Util.(x1vec, tangent3()), linecolor=:red, linestyle=:solid, linewidth=2)
			 # Axis ticks
    xticks!([0.001, tangent4()[1]], [L"0", L"x1^*"])
    yticks!([0.001, x2(0), x2(tangent4()[1])], [L"0", L"x2(0)", L"x2^*"])
		# Key points, with dashed lines to them
    plot!([tangent4()[1],tangent4()[1]], [0,x2(tangent4()[1])], linecolor=:black, linestyle=:dash) 
    plot!([0,tangent4()[1]], [x2(tangent4()[1]),x2(tangent4()[1])], linecolor=:black, linestyle=:dash)
    scatter!([tangent4()[1]], [x2(tangent4()[1])], markercolor=:black, markersize=5)
		end

	if Plot_indifference_curves_Hot==true
		
		for n = 1:1:4
	plot!(x1vec, Hot_Start.(x1vec, k[n]), linecolor=:black, linestyle=:solid, linewidth=2)
		end
	end
		
   	  	if Plot_indifference_curves_Implicitly == true
		for n = 1:1:4
	plot!(x1vec, Util.(x1vec, k[n]), linecolor=:black, linestyle=:solid, linewidth=2)
		end
	end
	plot!(x1vec, x2.(x1vec), linecolor=:black, linestyle=:solid, linewidth=2)

	if Plot_indifference_curves_Countour == true
	contour!(x1nvec, x1nvec, U, levels=(3:6))
	end
		
	xlims!(0, 5)
    ylims!(0, 500)

	 # Axis labels
	annotate!(10.5, 0, text(L"x1", :left, :center, 12))
    annotate!(0, 10, text(L"x2", :center, :bottom, 12))
	# Axis limits
    xlims!(0, 10)
    ylims!(0, 10)
	 
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

   Utility2
end

# ╔═╡ 472aebc2-3f9e-4c5f-bd3a-a0ce0846bbea
md"""
# 10-9 HW
"""

# ╔═╡ 830c1c66-e899-470a-a02f-5c075484424c
md"""
## Kuhn-Tucker Conditions
"""

# ╔═╡ d2c4db1d-94d6-4aa8-b5e1-4bc6d7c0be64
xkvec=collect(range(-2.1,6.1,length=101))

# ╔═╡ 448d17f3-3594-4f2b-b664-34731e58a9a4
βvec=copy(xkvec)

# ╔═╡ b1278710-7025-4461-8783-60c40e515667
f(x,β)=-(x-β)^2+4 #Initial Condition

# ╔═╡ 39644fe2-fc3d-42ac-8aeb-e8546eda9184
f_x(x,β)=-2*(x-β)

# ╔═╡ 99405549-eca2-42e6-b27c-01aa3944a0f1
β = @bind β Slider(-2.1:0.1:6.1, default=2, show_value=true)

# ╔═╡ 4d7859cd-a115-4d6c-b683-9421f9c84b91
function xopt(x)

# Define the zero condition at the parameter value supplied
cond(x) = f_x(x,β)

# Specify a starting guess
x0 = 1

# Find and return the solution
x = find_zero(cond, x0)

end;

# ╔═╡ b55b7e5d-774a-479f-98ae-e83c35c0da92
md"""
This presents the optimal x and y values f based on whatver the parameter β is. Because we have predetermined that x can only range from 0 to 4 this implies that when the function shifts a certain amount then the new optimum values will change when those constraints are reached. 
"""

# ╔═╡ 59b96650-ba53-42ab-bb2d-78aaa323cfaf
begin
    fplot = plot(
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
    plot!(xkvec, f.(xkvec,β), linecolor=:black, linestyle=:solid, linewidth=2)
	 # Axis limits
    xlims!(xkvec[1], xkvec[end])
    ylims!(-.07, 1.05*maximum(f.(xkvec,β)))
 
		if xopt(xkvec)<0
	plot!([0,0], [0,f(0,β)], linecolor=:black, linestyle=:dash) 
    plot!([0,0], [f(0,β),f(0,β)], linecolor=:black, linestyle=:dash)
    scatter!([0], [f(0,β)], markercolor=:black, markersize=5)
		elseif xopt(xkvec)>4
	plot!([4,4], [0,f(4,β)], linecolor=:black, linestyle=:dash) 
    plot!([0,4], [f(4,β),f(4,β)], linecolor=:black, linestyle=:dash)
    scatter!([4], [f(4,β)], markercolor=:black, markersize=5)
	else 
	plot!([xopt(xkvec),xopt(xkvec)], [0,f(xopt(xkvec),β)], linecolor=:black, linestyle=:dash) 
    plot!([0,xopt(xkvec)], [f(xopt(xkvec),β),f(xopt(xkvec),β)], linecolor=:black, linestyle=:dash)
    scatter!([xopt(xkvec)], [f(xopt(xkvec),β)], markercolor=:black, markersize=5)
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

   fplot	
end

# ╔═╡ f6ae68a1-0722-43ac-a8ec-51958b478f15
function βoptx(β)

# Define the zero condition at the parameter value supplied
cond(x) = f_x(x,β)

# Specify a starting guess
x0 = 1

# Find and return the solution
x = find_zero(cond, x0)
	if x < 0
		return 0
	elseif x > 4
		return 4
	else 
		return x
	end

end;

# ╔═╡ e4a5a6a2-c796-423e-a572-33baeb81be20
md"""
This function graphs how the optimum value of x will change as β changes. Due to the first order condition x and β must always equal each other. Doing this creates a slope of one between 0 and 4 because whenever β increases by 1 unit, so does x. However, outside those values x won't change at all, it will be stuck at 4 no matter how high β goes, similarly the same with the minimum. 
"""

# ╔═╡ 48929e14-dfee-47d6-8b0f-d7587784ec3c
begin
    kuhntucker = plot(
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
    plot!(βvec, βoptx.(βvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	 # Axis limits
    xlims!(βvec[1], βvec[end])
    ylims!(-.05, 4.1)
	 # Curve labels
    flx = 2
    fly = βoptx(flx)+1
    annotate!(flx, fly, text(L"x^*(α)", :left, :bottom, 12))
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

   kuhntucker	
end

# ╔═╡ 6d26d68d-f97a-4deb-9c91-b20fc61b1537
L(x,β,λ,μ)=f(x,β)+λ*x+μ*(4-x)

# ╔═╡ e7da8542-391c-4682-a572-1182d0677794
L_x(x,β,λ,μ)=f_x(x,β)+λ-μ

# ╔═╡ e799781d-5025-47e8-90c6-cf27772e971b
function λopt(x,β,μ)

# Define the zero condition at the parameter value supplied
cond(λ) = L_x(x,β,λ,μ)

# Specify a starting guess
λ0 = 1

# Find and return the solution
λ = find_zero(cond, λ0)
	if λ < 0
		return 0
	else 
		return λ
	end

end;

# ╔═╡ 6f45a4ae-f170-471a-98df-b4992d466386
md"""
When analyzing the change in the Lagrangian shadow values that bind the constraints, in the Lagrangian λ binds x, meaning that whenever the β gets to a point that without λ it would no longer optimize the function, λ offsets those changes and makes sure that the function is still optimized and that the first derivative is still 0. So as β gets more negative then λ will get more positive.  
"""

# ╔═╡ 300606f1-0b3f-465e-8dbc-778c27b449e5
begin
    pλopt = plot(
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
    plot!(βvec, λopt.(0,βvec,0), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	 # Axis limits
    xlims!(βvec[1], βvec[end])
    ylims!(-0.05, 4.1)
    # Curve labels
	λlx = -1
    λly = λopt(0,λlx,0)
    annotate!(λlx, λly, text(L"\lambda^*\!(\alpha)", :right, :top, 12))
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

   pλopt	
end

# ╔═╡ 5ba10475-cd16-4d9c-adfd-2adda3171f74
function μopt(x,β,λ)

# Define the zero condition at the parameter value supplied
cond(μ) = L_x(x,β,λ,μ)

# Specify a starting guess
μ0 = 1

# Find and return the solution
μ = find_zero(cond, μ0)
	if μ < 0
		return 0
	else 
		return μ
	end

end;

# ╔═╡ 2bea6ada-fe6a-4668-8c77-f32e485752c4
md"""
Similar to λ, μ offsets the function of f in the opposite way. When β reaches a certan point then that will result in the maxiumum value of f changing unless there is a force like μ pushing it back down so we can still have a f_x being 0. 
"""

# ╔═╡ 9a04511e-7119-4239-9fa2-9c32830d9891
begin
    pμopt = plot(
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
    plot!(βvec, μopt.(4,βvec,0), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	 # Axis limits
    xlims!(βvec[1], βvec[end])
    ylims!(-0.05, 4.1)
    # Curve labels
	μlx = 5
    μly = μopt(4,μlx,0)
    annotate!(μlx, μly, text(L"\mu^*\!(\alpha)", :left, :top, 12))
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

   pμopt	
end

# ╔═╡ 68561321-3e50-46d6-b152-dd4a627f6b1b
md"""
This function analyzes how the optimum values of f will change when β or what I'm referring to as α in my graph because that's the symbol Klaas used. The function is at a bliss point of f^*=4 when β is between the ranges of 0 and 4, but as soon as it deviates away from those points the maximum values start to go down. 
"""

# ╔═╡ becd9293-36f7-472d-8f37-0091e202edd1
begin
    fopt = plot(
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
    plot!(βvec, f.(βoptx.(βvec),βvec) , linecolor=:black, linestyle=:solid, linewidth=2)
		plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	# Curve labels
    foptlx = 2
    foptly = 4
    annotate!(foptlx, foptly, text(L"f^*\!\!(x^*\!\!(\alpha),\alpha)", :center, :bottom, 12))
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

   fopt	
end

# ╔═╡ 43670cda-2626-4e05-97b0-1c1f3c01fe32
md"""
# 10-16 Notes
"""

# ╔═╡ ecc80420-3568-479f-8f63-0c2e709dce32
md"""
$\max_{x_1,x_2}U=4x_1+4x_2-x_1^2-x_2^2$ 

subject to 

$Y ≥ x_1+x_2$
"""

# ╔═╡ 5d9983a8-35b1-493e-a30d-d9e6f7d51ef2
begin 
	Ukuhn(x1,x2)=4*x1 +4*x2 -x1^2 -x2^2
	U_x1(x1)=4-2x1
	U_x2(x2)=4-2x2
	LU(x1,x2,λ,Y)=Ukuhn(x1,x2)+λ*(Y-x1-x2)
	L_x1(x1,λ)=U_x1(x1)-λ
	L_x2(x2,λ)=U_x2(x2)-λ
	L_λ(x1,x2,Y)=Y-x1-x2
end;

# ╔═╡ cc6a2e0d-1824-4e85-b749-a1550eb9d9ef
x1kuhnvec=collect(range(-2,6,length=101))

# ╔═╡ 87f1bdcc-abf6-4e51-a5b8-34a313fd657a
x2kuhnvec=copy(x1kuhnvec)

# ╔═╡ 534195a6-1b7e-4e8c-b0d3-8ba60ffedc42
λvec=copy(x1kuhnvec)

# ╔═╡ 5129079b-19c6-4cf9-bd4b-4761f9d3e123
x2kuhn = @bind x2kuhn Slider(0.0:0.1:2, default=0.0, show_value=true)

# ╔═╡ 00a96361-ad8d-4c1a-aca7-9cb29c2ad9e4
function U_x1opt(x1)

# Define the zero condition at the parameter value supplied
cond(x1) = U_x1(x1)

# Specify a starting guess
x10 = 1

# Find and return the solution
x1 = find_zero(cond, x10)

end;

# ╔═╡ 0d393ecd-397d-452a-b158-a421e2de4452
begin
    Ux1kuhn = plot(
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
    plot!(x1kuhnvec, Ukuhn.(x1kuhnvec,x2kuhn), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
    plot!([U_x1opt(x1kuhnvec),U_x1opt(x1kuhnvec)], [0,Ukuhn.(U_x1opt(x1kuhnvec),x2kuhn)], linecolor=:black, linestyle=:dash) 
    plot!([0,U_x1opt(x1kuhnvec)], [Ukuhn.(U_x1opt(x1kuhnvec),x2kuhn),Ukuhn.(U_x1opt(x1kuhnvec),x2kuhn)], linecolor=:black, linestyle=:dash)
    scatter!([U_x1opt(x1kuhnvec)], [Ukuhn.(U_x1opt(x1kuhnvec),x2kuhn)], markercolor=:black, markersize=5)
 	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 10)
	# Axis labels
    annotate!(6, .5, text(L"x1", :left, :center, 12))
    annotate!(0, 10, text(L"U", :center, :bottom, 12))
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

   Ux1kuhn	
end

# ╔═╡ e8bb8c2a-535f-4941-a8d7-06dbe853510f
x1kuhn = @bind x1kuhn Slider(0.0:0.1:2, default=0.0, show_value=true)

# ╔═╡ 45ca0ea6-1547-494c-a04b-48e2299381e0
function U_x2opt(x2)

# Define the zero condition at the parameter value supplied
cond(x2) = U_x2(x2)

# Specify a starting guess
x20 = 1

# Find and return the solution
x2 = find_zero(cond, x20)

end;

# ╔═╡ 11eb5a0b-76f0-490a-87ee-5a25cf52dee4
begin
    Ux2kuhn = plot(
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
    plot!(x2kuhnvec, Ukuhn.(x1kuhn,x2kuhnvec), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
   plot!([U_x2opt(x2kuhnvec),U_x2opt(x2kuhnvec)], [0,Ukuhn.(x1kuhn,U_x2opt(x2kuhnvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,U_x2opt(x2kuhnvec)], [Ukuhn.(x1kuhn,U_x2opt(x2kuhnvec)),Ukuhn.(x1kuhn,U_x2opt(x2kuhnvec))], linecolor=:black, linestyle=:dash)
    scatter!([U_x2opt(x2kuhnvec)], [Ukuhn.(x1kuhn,U_x2opt(x2kuhnvec))], markercolor=:black, markersize=5)
 	# Axis limits
    xlims!(-2, 6)
    ylims!(0, 10)
	# Axis labels
    annotate!(6, .2, text(L"x2", :left, :center, 12))
    annotate!(0, 10, text(L"U", :center, :bottom, 12))
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

   Ux2kuhn	
end

# ╔═╡ 2674dd78-927a-411e-9251-5c214033c096
function λoptkuhn(x1)

# Define the zero condition at the parameter value supplied
cond(λ) = L_x1(x1,λ)

# Specify a starting guess
λ10 = 10

# Find and return the solution
λ = find_zero(cond, λ10)
if λ <= 0
	return 0
elseif λ >= 4 
	return 4
else 
	return λ
end
end;

# ╔═╡ 89cb9272-e7e9-40fc-a973-f8badb4cdca3
begin
    λoptkuhnx1 = plot(
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
    plot!(x1kuhnvec, λoptkuhn.(x1kuhnvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 # Axis limits
    xlims!(-2, 6)
    ylims!(0, 10)
	
    annotate!(1, 2.5, text(L"λ^*(x_1)", :left, :bottom, 12))

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

   λoptkuhnx1	
end

# ╔═╡ b6955324-8537-466d-9b18-d3dad145ff74
function λoptkuhn2(x2)

# Define the zero condition at the parameter value supplied
cond(λ) = L_x2(x2,λ)

# Specify a starting guess
λ20 = 10

# Find and return the solution
λ = find_zero(cond, λ20)
if λ <= 0
	return 0
elseif λ >= 4 
	return 4
else 
	return λ
end
end;

# ╔═╡ 5eae7c48-72ca-4ca8-b4bb-0217d089bfd4
begin
    λoptkuhnx2 = plot(
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
    plot!(x2kuhnvec, λoptkuhn2.(x2kuhnvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 # Axis limits
    xlims!(-2, 6)
    ylims!(0, 10)
	
    annotate!(1, 2.5, text(L"λ^*(x_2)", :left, :bottom, 12))

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

   λoptkuhnx2
end

# ╔═╡ 2a86bec0-ad4e-4353-9766-5002a7da2dfd
function λoptkuhnY(x1,x2)

# Define the zero condition at the parameter value supplied
cond(Y) = L_λ(x1,x2,Y)

# Specify a starting guess
Y10 = 10

# Find and return the solution
Y = find_zero(cond, Y10)
if Y <= 0
	return 0
elseif Y >= 4 
	return 4
else 
	return Y
end
end;

# ╔═╡ d10d81e5-656e-432d-b4b1-cdedaef4522c
begin
    λptYplot = plot(
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
    plot!(x1kuhnvec, λoptkuhnY.(x1kuhnvec,0), linecolor=:black, linestyle=:solid, linewidth=2)
	
	 annotate!(2, 3, text(L"Y^*(x_1,0)", :left, :bottom, 12))
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

   λptYplot	
end

# ╔═╡ 67a76813-90b0-477a-a61b-0400d626dc1a
begin
    λptYplotx2 = plot(
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
    plot!(x2kuhnvec, λoptkuhnY.(0,x2kuhnvec), linecolor=:black, linestyle=:solid, linewidth=2)
	
	 annotate!(2, 3, text(L"Y^*(0,x_2)", :left, :bottom, 12))
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

   λptYplotx2
end

# ╔═╡ a38f7474-dc4b-44b5-b742-023c1e6bbdd3
begin
    optlagrange = plot(
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
    plot!(x1kuhnvec, LU.(x1kuhnvec,0,λoptkuhn.(x1kuhnvec),λoptkuhnY.(x1kuhnvec,0)), linecolor=:black, linestyle=:solid, linewidth=2)
	 # Axis limits
    xlims!(-2, 6)
    ylims!(0, 10)
	annotate!(2, 4, text(L"L(x_1,0,λ^*,Y^*)", :left, :bottom, 12))
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

   optlagrange	
end

# ╔═╡ 910ae060-dcc0-4524-9486-574b804a8ebc
function true_KT(Y)
	
    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :Ukuhn, 2, Ukuhn; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, x1)
	@variable(model, x2)
        
    # Specify the objective function
    @NLobjective(model, Max, Ukuhn(x1,x2))

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
end

# ╔═╡ d754dad7-5971-42ce-96ea-0c5e2b0fee2e
x1optkuhn(Y)=true_KT(Y)[1]

# ╔═╡ 2097dd9b-96d1-4f24-8da0-264ac66ae7a1
x2optkuhn(Y)=true_KT(Y)[2]

# ╔═╡ 869704fc-2388-4418-be43-9de3c0b3a4b8
λoptkuhn1(Y)=true_KT(Y)[3]

# ╔═╡ b9d6748c-e56a-460d-a8bd-6ef0d5817c24
Y = @bind Y Slider(0.0:0.1:10.0, default=4.0, show_value=true)

# ╔═╡ 7f49e7d4-35c2-491b-9f7b-683882dd1273
x2new(x1)=Y-x1

# ╔═╡ d226c0ac-77c5-4a8e-aef0-f10804eeb6c3
Ukuhnopt=Ukuhn(x1optkuhn(Y),x2optkuhn(Y))

# ╔═╡ 42b65048-afb8-4a54-919c-3c64fade5e0e
begin
    contourplotkuhn = plot(
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
    plot!(x1kuhnvec, x2new.(x1kuhnvec), linecolor=:black, linestyle=:solid, linewidth=2)
	contour!(x1kuhnvec, x1kuhnvec, Ukuhn, levels=(4:.5:10), linecolor=:gray)
	contour!(x1kuhnvec, x1kuhnvec, Ukuhn, levels=([Ukuhnopt]), linecolor=:black)
	# Key points, with dashed lines to them
    plot!([x1optkuhn(Y),x1optkuhn(Y)], [0,x2optkuhn(Y)], linecolor=:black, linestyle=:dash) 
    plot!([0,x1optkuhn(Y)], [x2optkuhn(Y),x2optkuhn(Y)], linecolor=:black, linestyle=:dash)
    scatter!([x1optkuhn(Y)], [x2optkuhn(Y)], markercolor=:black, markersize=5)
	# Axis limits
    xlims!(0, 10)
    ylims!(0, 10)
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

   contourplotkuhn	
end

# ╔═╡ Cell order:
# ╠═013027b0-63de-11ef-00d8-0f5e499e43c4
# ╠═f82a414a-fbee-42f0-9eed-7a771e21eb4b
# ╠═546c1a5e-80d2-4f40-a7ea-98351529b808
# ╠═5efa667b-5823-401e-8623-ac4dd3f1441a
# ╠═8b727ece-fb97-476b-9e75-32f83c3b2110
# ╠═ea437276-83ff-4ae3-944d-1c9b5cfbd70a
# ╟─fd906829-e0a6-42e4-ae8f-205cf92b5f73
# ╠═5357edb3-7a7f-43c4-8e05-40571ebd9bde
# ╠═724a8b25-f994-4eb1-bfc8-2e5ca34c5700
# ╠═899eb001-3771-43c1-8d5e-72a835c549d3
# ╠═f2a19553-4ee4-440a-a22a-9a68f410853c
# ╠═dec96e13-6535-435d-a44f-8277b0dc1042
# ╠═ac024db5-b844-42ba-ad87-465df15b308f
# ╠═bd2938aa-1689-4ea2-bc9f-5139aac88f42
# ╠═3c552d6f-8eb2-4869-9ad0-bd59dad35d1a
# ╠═8bc54397-7567-477b-ab66-6cf384165060
# ╠═1231bfc5-208f-40f4-9611-0d63a8e1c2f4
# ╟─d1c6c0fa-8a09-41a2-ae3f-45d96a8b840e
# ╟─44d80ce4-6428-4d47-a1fa-9c802f7d920f
# ╟─853322ce-98a7-427d-a47d-c29ff084af36
# ╠═3b73747e-c113-4d23-8d43-84b572e7a08c
# ╠═72531710-e4fc-41b5-8095-fe99d3b4dfa1
# ╟─1b160a1b-6e51-4ee1-b72e-b769cf73e5d8
# ╟─9243413d-38bf-4c27-b99a-049f4dfac9a1
# ╟─71f35adc-1f5b-4153-b813-a1fd16677bce
# ╟─083b63ac-0e7d-46ab-bc8a-d592d750b042
# ╠═e6a88d36-13dd-4b39-8c43-7e253ba5dc9e
# ╠═5f2d3fc7-16a5-405d-99b3-e9b1eb08d79e
# ╠═b04e16d1-ef33-423c-b62b-530ff0036d97
# ╠═d9e8d937-de97-4ee9-b783-6307419ce493
# ╠═6c076aa4-4792-4c8b-839b-86645ad2096e
# ╠═198bbc54-595c-4ad0-b408-beab6f5ed808
# ╠═b333dfcf-c268-41a0-9f02-89c46e4f8925
# ╠═849e3aa2-2160-4f9f-b29a-c62f742b092c
# ╠═832335a3-2d01-4535-8477-5b242930f5c7
# ╠═d6118808-793e-41f0-a588-9ee56004edf1
# ╠═097e9abe-038a-40a8-8fbb-417d911c844d
# ╠═cd5e86e3-a2eb-4adb-babc-c93e76b555df
# ╠═40df2b5c-3a2d-4274-b18f-6f19570ed3eb
# ╟─d4d0ff05-1c08-49fb-b279-4769b28b4d68
# ╟─b9365aa3-1cc0-40e6-b027-a542bf18979c
# ╟─39c1a25a-8efc-490c-8b9a-adea95531fdf
# ╟─d5ecc102-e6f2-4e17-9ad2-ae0349d4b02e
# ╟─425b879d-4f06-4b0c-a4a8-a711b2b22139
# ╠═bb9de44f-34e8-4556-89b7-96b7aa2b75df
# ╠═472aebc2-3f9e-4c5f-bd3a-a0ce0846bbea
# ╠═830c1c66-e899-470a-a02f-5c075484424c
# ╠═d2c4db1d-94d6-4aa8-b5e1-4bc6d7c0be64
# ╠═448d17f3-3594-4f2b-b664-34731e58a9a4
# ╠═b1278710-7025-4461-8783-60c40e515667
# ╠═39644fe2-fc3d-42ac-8aeb-e8546eda9184
# ╠═4d7859cd-a115-4d6c-b683-9421f9c84b91
# ╠═99405549-eca2-42e6-b27c-01aa3944a0f1
# ╟─b55b7e5d-774a-479f-98ae-e83c35c0da92
# ╠═59b96650-ba53-42ab-bb2d-78aaa323cfaf
# ╠═f6ae68a1-0722-43ac-a8ec-51958b478f15
# ╟─e4a5a6a2-c796-423e-a572-33baeb81be20
# ╟─48929e14-dfee-47d6-8b0f-d7587784ec3c
# ╠═6d26d68d-f97a-4deb-9c91-b20fc61b1537
# ╠═e7da8542-391c-4682-a572-1182d0677794
# ╠═e799781d-5025-47e8-90c6-cf27772e971b
# ╟─6f45a4ae-f170-471a-98df-b4992d466386
# ╟─300606f1-0b3f-465e-8dbc-778c27b449e5
# ╠═5ba10475-cd16-4d9c-adfd-2adda3171f74
# ╟─2bea6ada-fe6a-4668-8c77-f32e485752c4
# ╟─9a04511e-7119-4239-9fa2-9c32830d9891
# ╟─68561321-3e50-46d6-b152-dd4a627f6b1b
# ╟─becd9293-36f7-472d-8f37-0091e202edd1
# ╟─43670cda-2626-4e05-97b0-1c1f3c01fe32
# ╟─ecc80420-3568-479f-8f63-0c2e709dce32
# ╠═5d9983a8-35b1-493e-a30d-d9e6f7d51ef2
# ╠═cc6a2e0d-1824-4e85-b749-a1550eb9d9ef
# ╠═87f1bdcc-abf6-4e51-a5b8-34a313fd657a
# ╠═534195a6-1b7e-4e8c-b0d3-8ba60ffedc42
# ╠═5129079b-19c6-4cf9-bd4b-4761f9d3e123
# ╠═00a96361-ad8d-4c1a-aca7-9cb29c2ad9e4
# ╟─0d393ecd-397d-452a-b158-a421e2de4452
# ╠═e8bb8c2a-535f-4941-a8d7-06dbe853510f
# ╠═45ca0ea6-1547-494c-a04b-48e2299381e0
# ╟─11eb5a0b-76f0-490a-87ee-5a25cf52dee4
# ╠═2674dd78-927a-411e-9251-5c214033c096
# ╟─89cb9272-e7e9-40fc-a973-f8badb4cdca3
# ╟─b6955324-8537-466d-9b18-d3dad145ff74
# ╟─5eae7c48-72ca-4ca8-b4bb-0217d089bfd4
# ╠═2a86bec0-ad4e-4353-9766-5002a7da2dfd
# ╟─d10d81e5-656e-432d-b4b1-cdedaef4522c
# ╟─67a76813-90b0-477a-a61b-0400d626dc1a
# ╟─a38f7474-dc4b-44b5-b742-023c1e6bbdd3
# ╠═910ae060-dcc0-4524-9486-574b804a8ebc
# ╠═d754dad7-5971-42ce-96ea-0c5e2b0fee2e
# ╠═2097dd9b-96d1-4f24-8da0-264ac66ae7a1
# ╠═869704fc-2388-4418-be43-9de3c0b3a4b8
# ╠═7f49e7d4-35c2-491b-9f7b-683882dd1273
# ╠═b9d6748c-e56a-460d-a8bd-6ef0d5817c24
# ╠═d226c0ac-77c5-4a8e-aef0-f10804eeb6c3
# ╠═42b65048-afb8-4a54-919c-3c64fade5e0e
