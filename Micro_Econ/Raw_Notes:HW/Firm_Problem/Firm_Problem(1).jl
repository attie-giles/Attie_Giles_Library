### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 3499f0f8-752d-11ef-3a4b-290f7bac0a94
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
end

# ╔═╡ 5865c684-ef1d-4a7c-8d43-097aa13aae06
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 4a5e76c0-51e9-4ca6-a315-daf320af8da0
Lvec = collect(range(0,100,length=101))

# ╔═╡ f694d7cd-6c80-4e23-9917-428187a0cb83
π(L)=-(L-10)^2+30

# ╔═╡ 1e379014-3bf8-4759-9d3c-66f8748fd901
begin
    profitgraph1 = plot(
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
    plot!(Lvec, π.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 plot!([0,40], [30,30], linecolor=:red, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 40)
    ylims!(0, 40)
	 # Axis labels
    annotate!(37, 1, text(L"Labor", :left, :middle, 12))
    annotate!(1, 40, text(L"Profit", :center, :bottom, 12))
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
savefig("foc1.pdf")
   profitgraph1	
end

# ╔═╡ b9799ef6-4e8c-405d-bffe-33ccf0fe7181
π1(L)=(L-10)^2+30

# ╔═╡ aff98823-10eb-4213-9eee-b1c65ecd82ce
begin
    profitgraph2 = plot(
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
    plot!(Lvec, π1.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 plot!([0,40], [30,30], linecolor=:red, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 40)
    ylims!(0, 70)
	 # Axis labels
    annotate!(37, 2, text(L"Labor", :left, :middle, 12))
    annotate!(1, 70, text(L"Profit", :center, :bottom, 12))
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
savefig("foc2.pdf")
   profitgraph2
end

# ╔═╡ 117348cf-1ead-4ac5-9aa4-e807982e7c41
π2(L)=(L-10)^2+30

# ╔═╡ 31378b18-785c-4399-b4fb-2e12a0499407
begin
    profitgraph3 = plot(
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
    plot!(Lvec, π2.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2)
	 plot!([0,40], [30,30], linecolor=:red, linestyle=:solid, linewidth=2)
	# Axis limits
    xlims!(0, 40)
    ylims!(0, 70)
	 # Axis labels
    annotate!(37, 2, text(L"Labor", :left, :middle, 12))
    annotate!(1, 70, text(L"Profit", :center, :bottom, 12))
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
savefig("foc3.pdf")
   profitgraph3
end

# ╔═╡ b179fc52-60b1-4454-82c9-1dd0838c11e1
P=4

# ╔═╡ 84655837-516e-4702-b958-64c9e6471049
w=2

# ╔═╡ 473399e4-0425-49ea-b387-2e8aaef8f2cd
π3(L)=P*L^(5/6)-w*L

# ╔═╡ 4483b40b-ec84-4840-aaeb-45519120a298
begin
    totalspace1 = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
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
    plot!(Lvec, π3.(Lvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Profit")
	plot!(Lvec, P.*Lvec.^(5/6), linecolor=:black, linestyle=:solid, linewidth=2, label="Revenue")
    plot!(Lvec, w.*Lvec, linecolor=:blue, linestyle=:solid, linewidth=2, label="Cost")
	# Axis labels
    annotate!(97, 1, text(L"Labor", :left, :middle, 12))
    annotate!(3, 200, text(L"Dollars", :center, :bottom, 12))
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
savefig("totalspace1.pdf")
   totalspace1
end

# ╔═╡ c42c6a61-6ef3-4c4b-864e-3a4f3fc7cd13
dπ3(L)=(5/6)*P*L^(-1/6)-w

# ╔═╡ 5cddbc11-69d1-4675-930c-bfc4528a4679
dR(L)=(5/6)*P*L^(-1/6)

# ╔═╡ b718fb84-bc36-414e-ba47-9e2307980ca2
function findl()

# Define the zero condition at the parameter value supplied
cond(L) = (5/6)*P*L^(-1/6) - w

# Specify a starting guess
r0 = 20

# Find and return the solution
L = find_zero(cond, r0)

end;

# ╔═╡ 080397eb-08cd-4aed-b858-c71929d3524e
findl()

# ╔═╡ 92bf31ae-41f0-4ebd-812d-8c88622eefec
π3(findl())

# ╔═╡ de19f5d4-697e-441c-9260-2120a41d88ec
begin
    totalspace2 = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
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
    plot!(Lvec, dπ3.(Lvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Marginal Profit")
	plot!(Lvec, dR.(Lvec), linecolor=:black, linestyle=:solid, linewidth=2, label="Maringal Revenue")
    plot!([0,Lvec[end]],[w,w], linecolor=:blue, linestyle=:solid, linewidth=2, label="Maringal Cost")
	# Axis labels
    annotate!(95, .4, text(L"Labor", :left, :middle, 12))
    annotate!(3, 10, text(L"Dollars", :center, :bottom, 12))
	 # Axis limits
    xlims!(0, 100)
    ylims!(0, 10)
	 # Key points, with dashed lines to them
    plot!([findl(),findl()], [0,dR(findl())], linecolor=:black, linestyle=:dash, label="Optimal Labor") 
    scatter!([findl()], [dR(findl())], markercolor=:black, markersize=5,label="Maximized Profit")
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
savefig("marginalspace.pdf")
   totalspace2
end

# ╔═╡ fa3ec81b-6900-4715-8ffa-9338b4712848
π4(q)=P*q-w*q^(6/5)

# ╔═╡ 34c9426d-58c1-45bb-a38a-8c9841cd0b21
#qvec = copy(Lvec)
qvec = collect(range(0,100,1001))

# ╔═╡ 96022e64-771e-4751-9c58-3f0f098befd4
begin
    totalspace3 = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
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
    plot!(qvec, π4.(qvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Profit")
	plot!(qvec, P.*qvec, linecolor=:black, linestyle=:solid, linewidth=2, label="Revenue")
    plot!(qvec, w.*qvec.^(6/5), linecolor=:blue, linestyle=:solid, linewidth=2, label="Cost")
	# Axis labels
    annotate!(90, 4, text(L"Quantity", :left, :middle, 12))
    annotate!(3, 200, text(L"Dollars", :center, :bottom, 12))
	# Axis limits
    xlims!(0, qvec[end])
    ylims!(0, 200)
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
savefig("totalspace2.pdf")
   totalspace3
end

# ╔═╡ 6629ba4f-923c-4437-8015-1dc2c29172e8
dπ4(q)=P-(6/5)*w*q^(1/5)

# ╔═╡ 5966f021-f3d4-4c8c-b51e-1482c4a4c984
dC(q)=(6/5)*w*q^(1/5)

# ╔═╡ 531de2cf-d08b-4b9d-8a98-b6385a770ea6
function findq()

# Define the zero condition at the parameter value supplied
cond(q) = P-(6/5)*w*q^(1/5)

# Specify a starting guess
q0 = 1

# Find and return the solution
q = find_zero(cond, q0)

end;

# ╔═╡ 87dd2b34-7e3b-461f-b0c6-70b49d649fe3
findq()

# ╔═╡ 05c1803e-0b0e-48e6-b870-0b3f9e46c307
π4(findq())

# ╔═╡ b622ee9c-076b-4b93-886a-6aa09a536d21
begin
    marginalspace2 = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
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
    plot!(qvec, dπ4.(qvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Marginal Profit")
	plot!(qvec, dC.(qvec), linecolor=:blue, linestyle=:solid, linewidth=2, label="Maringal Cost")
    plot!([0,qvec[end]],[P,P], linecolor=:black, linestyle=:solid, linewidth=2, label="Maringal Revenue")
	# Axis labels
    annotate!(90, .3, text(L"Quantity", :left, :middle, 12))
    annotate!(3, 10, text(L"Dollars", :center, :bottom, 12))
	 # Axis limits
    xlims!(0, 100)
    ylims!(0, 10)
	 # Key points, with dashed lines to them
    plot!([findq(),findq()], [0,dC(findq())], linecolor=:black, linestyle=:dash, label="Optimal Quantity") 
    scatter!([findq()], [dC(findq())], markercolor=:black, markersize=5,label="Maximized Profit")
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
savefig("marginalspace2.pdf")
   marginalspace2
end

# ╔═╡ Cell order:
# ╠═3499f0f8-752d-11ef-3a4b-290f7bac0a94
# ╠═5865c684-ef1d-4a7c-8d43-097aa13aae06
# ╠═4a5e76c0-51e9-4ca6-a315-daf320af8da0
# ╠═f694d7cd-6c80-4e23-9917-428187a0cb83
# ╠═1e379014-3bf8-4759-9d3c-66f8748fd901
# ╠═b9799ef6-4e8c-405d-bffe-33ccf0fe7181
# ╟─aff98823-10eb-4213-9eee-b1c65ecd82ce
# ╠═117348cf-1ead-4ac5-9aa4-e807982e7c41
# ╟─31378b18-785c-4399-b4fb-2e12a0499407
# ╠═473399e4-0425-49ea-b387-2e8aaef8f2cd
# ╠═b179fc52-60b1-4454-82c9-1dd0838c11e1
# ╠═84655837-516e-4702-b958-64c9e6471049
# ╠═4483b40b-ec84-4840-aaeb-45519120a298
# ╠═c42c6a61-6ef3-4c4b-864e-3a4f3fc7cd13
# ╠═5cddbc11-69d1-4675-930c-bfc4528a4679
# ╠═b718fb84-bc36-414e-ba47-9e2307980ca2
# ╠═080397eb-08cd-4aed-b858-c71929d3524e
# ╠═92bf31ae-41f0-4ebd-812d-8c88622eefec
# ╠═de19f5d4-697e-441c-9260-2120a41d88ec
# ╠═fa3ec81b-6900-4715-8ffa-9338b4712848
# ╠═34c9426d-58c1-45bb-a38a-8c9841cd0b21
# ╠═96022e64-771e-4751-9c58-3f0f098befd4
# ╠═6629ba4f-923c-4437-8015-1dc2c29172e8
# ╠═5966f021-f3d4-4c8c-b51e-1482c4a4c984
# ╠═531de2cf-d08b-4b9d-8a98-b6385a770ea6
# ╠═87dd2b34-7e3b-461f-b0c6-70b49d649fe3
# ╠═05c1803e-0b0e-48e6-b870-0b3f9e46c307
# ╠═b622ee9c-076b-4b93-886a-6aa09a536d21
