### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 4f20ec38-f88b-11ef-0ba9-41944cc5d811
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
	#using Graphs
	#using GraphPlot
	#using NetworkLayout
	#using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
    #using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ 7a0bdf68-c63c-417c-a81c-4cd90af8dbbc
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ daeab7b8-1559-4355-92f2-cb45f5cfd0b2
md"""
# Take Home 3
"""

# ╔═╡ 0ea71b68-f4d7-4353-a5fa-d2414eb225a7
md"""
## Nullcline 1
"""

# ╔═╡ d76b07aa-02c7-4c6a-a7c6-9712c0f7c899
begin #Parameters
	g = 3.5
	r = 1.7
	c = 10 
	p = 11
end;

# ╔═╡ 0cbf85ff-fd91-43e9-9e0c-26c7f38ff8c4
begin #Equations
	h1(X) = g*X*(1-X) #nullcline 1
	h2(X) = r - g +2*g*X #nullcline 2 implicit
end;

# ╔═╡ c6b50708-5e26-4cf7-898e-0190d8eb1283
Xvec = collect(range(0,1.5,length=200))

# ╔═╡ 4c86703f-949e-4b48-9701-4fb9c90d4aaa
begin
    isocline1 = plot(
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
    plot!(Xvec, h1.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*Xvec[end])
    ylims!(1.2*minimum(h1.(Xvec)), -1.2*minimum(h1.(Xvec)))
    
    # Axis labels
    annotate!(1.071*Xvec[end], 0, text(L"X", :left, :center, 12))
    annotate!(0, -1.212*minimum(h1.(Xvec)), text(L"h", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, .3], [L" ",L"X_1"])
    yticks!([0.001, h1(.3)], [L"0", L"h_1"])

	annotate!(.8, h1(.8), text(L"\dot{X}(t)=0", :left, :bottom, 12))

	 # Key points, with dashed lines to them
   # plot!([.3,.3], [0,h1(.3)], linecolor=:black, linestyle=:dash) 
    plot!([0,.3], [h1(.3),h1(.3)], linecolor=:black, linestyle=:dash)
    scatter!([.3], [h1(.3)], markercolor=:black, markersize=5)
	
	 annotate!(.29, h1(.3)-.4, text(L"\{", :left, :bottom, 12))
	annotate!(.29, h1(.3)-.7, text(L"\epsilon", :left, :bottom, 14))

	plot!([.29,.2],[h1(.3)+.25,h1(.3)+.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([.5,.4],[h1(.3)+.25, h1(.3)+.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([1.1,1],[h1(1)+.25, h1(1)+.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([1.6,1.5],[h1(1.5)+.25, h1(1.5)+.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([.29,.4],[h1(.3)-.25,h1(.3)-.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([.5,.6],[h1(.3)-.25, h1(.3)-.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([.9,1],[h1(1)-.25, h1(1)-.25], arrow=(:closed, 2.0),linecolor=:black)

	plot!([1.3,1.4],[h1(1.5)-.25, h1(1.5)-.25], arrow=(:closed, 2.0),linecolor=:black)
	
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

savefig("isocline1directionalsfinal.pdf")
   isocline1	
end


# ╔═╡ db8eddce-759c-40d4-acdd-52039ea8467a
md"""
## Nullcline 2
"""

# ╔═╡ a7a085a7-097a-4fbd-ac81-6047d23ce874
function h2_fz(X)


# Define the zero condition at the parameter value supplied
cond(X) = h2(X) 


# Specify a starting guess
X0 = 1


# Find and return the solution
X = find_zero(cond, X0)


end;


# ╔═╡ 2b5a927f-fff1-4149-8d08-f5d3aa324467
begin
    isocline2 = plot(
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
     plot!([h2_fz(Xvec),h2_fz(Xvec)], [1.2*minimum(h1.(Xvec)), -1.2*minimum(h1.(Xvec))], linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*Xvec[end])
    ylims!(1.2*minimum(h1.(Xvec)), -1.2*minimum(h1.(Xvec)))
    
    # Axis labels
    annotate!(1.071*Xvec[end], 0, text(L"X", :left, :center, 12))
    annotate!(0, -1.212*minimum(h1.(Xvec)), text(L"h", :center, :bottom, 12))

	annotate!(h2_fz(Xvec)+.01, 1, text(L"\dot{h}(t)=0", :left, :bottom, 12))

	# Axis ticks
    xticks!([0.001, h2_fz(Xvec)], [L" ",L"X_1"])
    yticks!([0.001,.3], [L"0",L"h_1"])

	 # Key points, with dashed lines to them
    plot!([h2_fz(Xvec),h2_fz(Xvec)], [0,.3], linecolor=:black, linestyle=:dash) 
    plot!([0,h2_fz(Xvec)], [.3,.3], linecolor=:black, linestyle=:dash)
    scatter!([h2_fz(Xvec)], [.3], markercolor=:black, markersize=5)

	plot!([h2_fz(Xvec),h2_fz(Xvec)-.05], [.3,.3], line=(:closed, 2.0),linecolor=:grey)

	annotate!(h2_fz(Xvec)-.05, .1, text(L"\epsilon", :left, :bottom, 14))

	plot!([h2_fz(Xvec)-.05,h2_fz(Xvec)-.05],[.3,.8], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)-.05,h2_fz(Xvec)-.05],[2.5,3.1], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)-.05,h2_fz(Xvec)-.05],[-1,-.2], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)-.25,h2_fz(Xvec)-.25],[.3,.8], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)-.25,h2_fz(Xvec)-.25],[2.5,3.1], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)-.25,h2_fz(Xvec)-.25],[-1,-.2], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.05,h2_fz(Xvec)+.05],[.3,-.2], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.05,h2_fz(Xvec)+.05],[2.5,1.8], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.05,h2_fz(Xvec)+.05],[-1,-1.8], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.5,h2_fz(Xvec)+.5],[.3,-.2], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.5,h2_fz(Xvec)+.5],[2.5,1.8], arrow=(:closed, 2.0),linecolor=:black)

	plot!([h2_fz(Xvec)+.5,h2_fz(Xvec)+.5],[-1,-1.8], arrow=(:closed, 2.0),linecolor=:black)
	
	
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

	savefig("nullcline2earrowsboth.pdf")

   isocline2	
end


# ╔═╡ 385cd47a-2883-4392-8037-ed46a3a7f9ee
md"""
## Nullcline 3
"""

# ╔═╡ 235410fb-289a-4e58-bbc4-692ec7fb83df
begin
    isocline3 = plot(
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
    plot!(Xvec, h1.(Xvec), linecolor=:black, linestyle=:solid, linewidth=2)

	plot!([h2_fz(Xvec),h2_fz(Xvec)], [1.2*minimum(h1.(Xvec)), -1.2*minimum(h1.(Xvec))], linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 1.05*Xvec[end])
    ylims!(1.2*minimum(h1.(Xvec)), -1.2*minimum(h1.(Xvec)))
    
    # Axis labels
    annotate!(1.071*Xvec[end], 0, text(L"X", :left, :center, 12))
    annotate!(0, -1.212*minimum(h1.(Xvec)), text(L"h", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, h2_fz(Xvec)], [L" ", L"X^{ss}"])
    yticks!([0.001, h1.(h2_fz(Xvec))], [L"0", L"h^{ss}"])

	annotate!(.8, h1(.8), text(L"\dot{X}(t)=0", :left, :bottom, 12))

	annotate!(h2_fz(Xvec)+.01, 1, text(L"\dot{h}(t)=0", :left, :bottom, 12))

	# Key points, with dashed lines to them
    plot!([h2_fz(Xvec),h2_fz(Xvec)], [0,h1.(h2_fz(Xvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,h2_fz(Xvec)], [h1.(h2_fz(Xvec)),h1.(h2_fz(Xvec))], linecolor=:black, linestyle=:dash)
    scatter!([h2_fz(Xvec)], [h1.(h2_fz(Xvec))], markercolor=:red, markersize=5)

	plot!([.2,h2_fz(Xvec)],[h2_fz(Xvec),h1.(h2_fz(Xvec))], arrow=(:closed, 2.0),linecolor=:green)
	plot!([.15,.2],[-.1,h2_fz(Xvec)], arrow=(:closed, 2.0),linecolor=:green)
	plot!([.1,.15],[-.5,-.1], arrow=(:closed, 2.0),linecolor=:green)

	plot!([.35,h2_fz(Xvec)],[1,h1.(h2_fz(Xvec))], arrow=(:closed, 2.0),linecolor=:green)
	plot!([.5,.35],[1.3,1], arrow=(:closed, 2.0),linecolor=:green)
	

	#arrow
	 plot!([.1,.1],[1,1.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.1,0],[1,1], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([.1,.1],[2,2.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.1,0],[2,2], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([.1,.1],[-1,-.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.1,.2],[-1,-1], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([.1,.1],[-2,-1.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.1,.2],[-2,-2], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([.5,.5],[1.5,1], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.5,.4],[1.5,1.5], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([1,1],[1.5,1], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([1,.9],[1.5,1.5], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([.5,.5],[-1,-1.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([.5,.6],[-1,-1], arrow=(:closed, 2.0),linecolor=:black)

	#arrow
	 plot!([1,1],[-1,-1.5], arrow=(:closed, 2.0),linecolor=:black)
	 plot!([1,1.1],[-1,-1], arrow=(:closed, 2.0),linecolor=:black)

	

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

	savefig("totaldirectionalswithapproach.pdf")
   isocline3	
end


# ╔═╡ b2cb8bdb-69a7-4c01-bd8c-5a0dad6f7edb
begin #eigenvalues
	Trace=r
	Det(X,h) = -(g^2)+g*r-2*g*r*X+4*g^2*X+(2*g*X)^2 + ((-2*g*(p-c*h))/c)
end;

# ╔═╡ 942a43dd-f001-4c0e-acd3-78ee64e10632
Trace^2

# ╔═╡ 2807cb78-45df-41ce-b22c-ae977b9a9cfe
4*Det(h2_fz(Xvec), h1(h2_fz(Xvec)))

# ╔═╡ Cell order:
# ╠═4f20ec38-f88b-11ef-0ba9-41944cc5d811
# ╠═7a0bdf68-c63c-417c-a81c-4cd90af8dbbc
# ╟─daeab7b8-1559-4355-92f2-cb45f5cfd0b2
# ╟─0ea71b68-f4d7-4353-a5fa-d2414eb225a7
# ╠═0cbf85ff-fd91-43e9-9e0c-26c7f38ff8c4
# ╠═d76b07aa-02c7-4c6a-a7c6-9712c0f7c899
# ╠═c6b50708-5e26-4cf7-898e-0190d8eb1283
# ╠═4c86703f-949e-4b48-9701-4fb9c90d4aaa
# ╟─db8eddce-759c-40d4-acdd-52039ea8467a
# ╠═a7a085a7-097a-4fbd-ac81-6047d23ce874
# ╠═2b5a927f-fff1-4149-8d08-f5d3aa324467
# ╟─385cd47a-2883-4392-8037-ed46a3a7f9ee
# ╟─235410fb-289a-4e58-bbc4-692ec7fb83df
# ╠═b2cb8bdb-69a7-4c01-bd8c-5a0dad6f7edb
# ╠═942a43dd-f001-4c0e-acd3-78ee64e10632
# ╠═2807cb78-45df-41ce-b22c-ae977b9a9cfe
