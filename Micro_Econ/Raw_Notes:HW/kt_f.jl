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

# ╔═╡ 23722982-e4bc-11ee-2329-5752e229c11c
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	#using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 036528b9-9542-4a59-9066-7c20232c01b5
md"""
# Problem setup
"""

# ╔═╡ 781e1a2b-0d16-4d6d-be6a-9922e82b467c
md"""
# Optimization problem

$\begin{align*}
  \max_{x} f(x,\alpha) = -(x - \alpha)^2 + 4
\end{align*}$

subject to

$\begin{align*}
  x &\geq 0\\
  x &\leq 4.
\end{align*}$

"""

# ╔═╡ 4cf026db-37d7-46b6-82c9-85720d79504b
md"""
##### Objective function
"""

# ╔═╡ 1a70f921-0f01-4ff5-b566-71b4a4c0c2b8
begin
	f(x,α) = -(x - α)^2 + 4
	f_x(x,α) = -2*(x - α)
end;

# ╔═╡ 99026a88-2df3-491f-8619-e4b6f284b8b9
md"""
##### Numerical model
"""

# ╔═╡ 178f939b-6d60-463c-849d-cb3c4bdaf864
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
	μopt = round(dual(c2), digits=2)

	return xopt, λopt, μopt
	
end;

# ╔═╡ f1d9874d-20fa-4ccf-819a-74bcab993a7e
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
    @variable(model, μ)

    # Specify the fake objective function
    @NLobjective(model, Max, 1)

    # Specify the constraints (note: \scrL generates ℒ symbol)
    # ℒ = -(x - α)^2 + 4 + λ*x + μ*(4 - x)
    # foc x
    @NLconstraint(model, c1, f_x(x,α) + λ - μ == 0)
        
    # foc λ
    @NLconstraint(model, c2, x >= 0)

    # nn λ
    @NLconstraint(model, c3, λ >= 0)

    # cs λ
    @NLconstraint(model, c4, λ*x == 0)

    # foc μ
    @NLconstraint(model, c5, 4 - x >= 0)

    # nn μ
    @NLconstraint(model, c6, μ >= 0)

    # cs μ
    @NLconstraint(model, c7, μ*(4 - x) == 0)
        
    # Pick starting values
    set_start_value(x, 2)
    set_start_value(λ, 0)
    set_start_value(μ, 0)

    # Find the solution
    JuMP.optimize!(model)

	# Return the solution
	xopt = round(value(x), digits=2)
	λopt = round(value(λ), digits=2)
	μopt = round(value(μ), digits=2)

	return xopt, λopt, μopt
end

# ╔═╡ ddfbc5e0-5c10-42e9-bc88-077446ac21cd
md"""
##### Implicitly defined functions
"""

# ╔═╡ dbe15a58-33e3-4b5e-999d-bcb4d3aef7e9
xopt_true(α) = true_KT(α)[1];

# ╔═╡ a19f3d0c-1033-47ff-a267-953d6d1d3506
xopt_fake(α) = fake_KT(α)[1];

# ╔═╡ 71c16ed8-b03f-4517-80bb-cf5967670cab
λopt_true(α) = true_KT(α)[2];

# ╔═╡ 2f416745-43c5-4a45-ad60-d6444584fbdb
λopt_fake(α) = fake_KT(α)[2];

# ╔═╡ 17be7ae8-ed66-4754-b18e-6cd3df289838
μopt_true(α) = true_KT(α)[3];

# ╔═╡ 19cccd74-dbca-43d9-982f-3750cea86dc5
μopt_fake(α) = fake_KT(α)[3];

# ╔═╡ cc56c922-dc5d-4e3d-9dbe-a39c524dd80e
md"""
##### Optimized objective function
"""

# ╔═╡ 73e47f68-5114-4866-b9c5-248e23703249
fopt_true(α) = f(xopt_true(α),α);

# ╔═╡ 316e7ad1-a247-439f-b5a4-e0842a12b59d
fopt_fake(α) = f(xopt_fake(α),α);

# ╔═╡ 9078bc6a-d6d8-45d9-a812-2c7e8ff7abcc
md"""
##### Parameter $\alpha$
"""

# ╔═╡ de15eb5b-9a3f-4f4b-b32f-9e5d1b1e04d8
α = @bind α Slider(-2:0.1:6, default=2, show_value=true)

# ╔═╡ 0b1792ab-37b6-487e-b464-fa0c7ab03a09
xopt_true(α)

# ╔═╡ fbf36cd2-1bc1-47a5-8d3e-74674e801615
xVec = collect(range(-2,6,length=101))

# ╔═╡ 929eac70-e58e-4a49-8a00-0711235c3f5c
begin
    pX = plot(
    tickdirection=:out,
    tickfontsize=10,
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

	# Upper-bound constraint
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	
    # Curves
	plot!(xVec, f.(xVec,α), linecolor=:black, linestyle=:solid, linewidth=2)

    # Axis limits
    xlims!(-2.1, 6.1)
    ylims!(-0.07, 1.05*maximum(f.(xVec,α)))

	# Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :center, 12))
    annotate!(0, 1.01*ylims(pX)[2], text(L"f", :center, :bottom, 12))
  
    # Extra axis ticks
    annotate!(0, -0.19, text("0", font(10, "Times")))
	annotate!(α, -0.19, text(L"\alpha", font(12, "Times")))
	plot!([α, α],[-0.07, 0], linecolor=:black, linestyle=:solid)

	# Solution value for x
	xopt = true_KT(α)[1]
		
    # Curve labels
	if xopt < 2
    	flx = α + 1
		fly = 1.01*f(flx,α)
    	annotate!(flx, fly, text(L"f(x,\alpha)", :left, :bottom, 12))
	else
		flx = α - 1
		fly = 1.01*f(flx,α)
    	annotate!(flx, fly, text(L"f(x,\alpha)", :right, :bottom, 12))
	end
    
    # Key points, with dashed lines to them
    plot!([xopt,xopt], [0,f(xopt,α)], linecolor=:black, linestyle=:dash) 
    plot!([0,xopt], [f(xopt,α),f(xopt,α)], linecolor=:black, linestyle=:dash)
    scatter!([xopt], [f(xopt,α)], markercolor=:black, markersize=5)

   pX	
end

# ╔═╡ e9e8853b-1016-4256-8c6b-79873ed29557
md"""
#### Solutions for a vector of $\alpha$ values
"""

# ╔═╡ 4fcf5d68-ea08-4340-b440-b215ceb3ae56
αVec = collect(range(-2.1,6.1,length=83))

# ╔═╡ eb7cf247-fa8d-42b2-9e18-7646109afa83
md"Check equivalency: $(@bind check_equivalency CheckBox(default=false))"

# ╔═╡ bead66e4-0728-407b-bef9-7f1de0465bc1
begin
    pxopt = plot(
    tickdirection=:out,
    tickfontsize=10,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )

	# Upper-bound constraint
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	
    # x^*
    plot!(αVec, xopt_true.(αVec), linecolor=:black, linestyle=:solid, linewidth=3)
	if check_equivalency
		plot!(αVec, xopt_fake.(αVec), linecolor=:black, linestyle=:dash, linewidth=5)
	end

    # Axis limits
    xlims!(αVec[1], αVec[end])
    ylims!(-0.05, 4.1)
	
    # Axis labels
    annotate!(1.03*xlims(pxopt)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(pxopt)[2], text(L"x", :center, :bottom, 12))
  
    # Extra axis ticks
    annotate!(0, -0.19, text("0", font(10, "Times")))

    # Curve labels
    xlx = 3
    xly = xopt_true(xlx)
    annotate!(xlx, xly, text(L"x^*\!(\alpha)", :right, :bottom, 12))
	
	#=
    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   pxopt	
end

# ╔═╡ a662cf00-d260-46c4-8d22-e9d15dd5cf91
begin
    pλopt = plot(
    tickdirection=:out,
    tickfontsize=10,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=1.01,
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )

	# Upper-bound constraint
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	
	# λ^*
    plot!(αVec, λopt_true.(αVec), linecolor=:black, linestyle=:solid, linewidth=3)
	if check_equivalency
		plot!(αVec, λopt_fake.(αVec), linecolor=:black, linestyle=:dash, linewidth=5)
	end
  
	# Axis limits
    xlims!(αVec[1], αVec[end])
    ylims!(-0.05, 4.1)
	
    # Axis labels
    annotate!(1.03*xlims(pλopt)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(pλopt)[2], text(L"\lambda", :center, :bottom, 12))
  
    # Extra axis ticks
    annotate!(0, -0.19, text("0", font(10, "Times")))

    # Curve labels
    λlx = -1
    λly = λopt_true(λlx)
    annotate!(λlx, λly, text(L"\lambda^*\!(\alpha)", :right, :top, 12))

	#=
	# Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   pλopt	
end

# ╔═╡ e182dcfb-d644-41ea-9caf-60514bb49139
md"""
λ is keeping the function from going less than zero.
"""

# ╔═╡ c517c307-e453-41e1-bcd4-2e55138d9631
begin
    pμopt = plot(
    tickdirection=:out,
    tickfontsize=10,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=1.01,
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )

	# Upper-bound constraint
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	
    # μ^*
    plot!(αVec, μopt_true.(αVec), linecolor=:black, linestyle=:solid, linewidth=3)
	if check_equivalency
		plot!(αVec, μopt_fake.(αVec), linecolor=:black, linestyle=:dash, linewidth=5)
	end

    # Axis limits
    xlims!(αVec[1], αVec[end])
    ylims!(-0.05, 4.1)
	
    # Axis labels
    annotate!(1.03*xlims(pμopt)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(pμopt)[2], text(L"\mu", :center, :bottom, 12))
  
    # Extra axis ticks
    annotate!(0, -0.19, text("0", font(10, "Times")))

    # Curve labels
    μlx = 5
    μly = μopt_true(μlx)
    annotate!(μlx, μly, text(L"\mu^*\!(\alpha)", :left, :top, 12))

	#=
    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   pμopt	
end

# ╔═╡ 6d9e08a8-0e32-4056-a81f-3967adb199c8
md"""
μ is keeping th function from going more than 4
"""

# ╔═╡ 18b47772-3255-4cc4-ae77-0ec680836041
begin
    pfopt = plot(
    tickdirection=:out,
    tickfontsize=10,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=1.01,
    framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )

	# Upper-bound constraint
	plot!([4, 4],[0, 4], linecolor=:black, linestyle=:dash, linewidth=1)
	
    # f^*
    plot!(αVec, fopt_true.(αVec), linecolor=:black, linestyle=:solid, linewidth=3)
	if check_equivalency
		plot!(αVec, fopt_fake.(αVec), linecolor=:black, linestyle=:dash, linewidth=4)
	end

    # Axis limits
    xlims!(αVec[1], αVec[end])
    ylims!(-0.05, 4.5)
	
    # Axis labels
    annotate!(1.03*xlims(pfopt)[2], 0, text(L"α", :left, :center, 12))
    annotate!(0, 1.01*ylims(pfopt)[2], text(L"f", :center, :bottom, 12))
  
    # Extra axis ticks
    annotate!(0, -0.19, text("0", font(10, "Times")))

    # Curve labels
    foptlx = 2
    foptly = 4
    annotate!(foptlx, foptly, text(L"f^*\!\!(x^*\!\!(\alpha),\alpha)", :center, :bottom, 12))

	#=
    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   pfopt	
end

# ╔═╡ Cell order:
# ╠═23722982-e4bc-11ee-2329-5752e229c11c
# ╟─036528b9-9542-4a59-9066-7c20232c01b5
# ╟─781e1a2b-0d16-4d6d-be6a-9922e82b467c
# ╟─4cf026db-37d7-46b6-82c9-85720d79504b
# ╠═1a70f921-0f01-4ff5-b566-71b4a4c0c2b8
# ╟─99026a88-2df3-491f-8619-e4b6f284b8b9
# ╠═178f939b-6d60-463c-849d-cb3c4bdaf864
# ╠═0b1792ab-37b6-487e-b464-fa0c7ab03a09
# ╠═f1d9874d-20fa-4ccf-819a-74bcab993a7e
# ╟─ddfbc5e0-5c10-42e9-bc88-077446ac21cd
# ╠═dbe15a58-33e3-4b5e-999d-bcb4d3aef7e9
# ╠═a19f3d0c-1033-47ff-a267-953d6d1d3506
# ╠═71c16ed8-b03f-4517-80bb-cf5967670cab
# ╠═2f416745-43c5-4a45-ad60-d6444584fbdb
# ╠═17be7ae8-ed66-4754-b18e-6cd3df289838
# ╠═19cccd74-dbca-43d9-982f-3750cea86dc5
# ╟─cc56c922-dc5d-4e3d-9dbe-a39c524dd80e
# ╠═73e47f68-5114-4866-b9c5-248e23703249
# ╠═316e7ad1-a247-439f-b5a4-e0842a12b59d
# ╟─9078bc6a-d6d8-45d9-a812-2c7e8ff7abcc
# ╠═de15eb5b-9a3f-4f4b-b32f-9e5d1b1e04d8
# ╟─fbf36cd2-1bc1-47a5-8d3e-74674e801615
# ╟─929eac70-e58e-4a49-8a00-0711235c3f5c
# ╟─e9e8853b-1016-4256-8c6b-79873ed29557
# ╠═4fcf5d68-ea08-4340-b440-b215ceb3ae56
# ╟─eb7cf247-fa8d-42b2-9e18-7646109afa83
# ╟─bead66e4-0728-407b-bef9-7f1de0465bc1
# ╠═a662cf00-d260-46c4-8d22-e9d15dd5cf91
# ╟─e182dcfb-d644-41ea-9caf-60514bb49139
# ╟─c517c307-e453-41e1-bcd4-2e55138d9631
# ╟─6d9e08a8-0e32-4056-a81f-3967adb199c8
# ╟─18b47772-3255-4cc4-ae77-0ec680836041
