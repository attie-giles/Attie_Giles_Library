### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ edbae97c-8a43-11ef-0166-b1f4f229a15e
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
    #using DynamicalSystems #dynamical systems
    # using DifferentialEquations  
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 7849b3f6-db19-471a-995e-a39a813baf47
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ fabfa1e7-de7f-42c0-8297-ba1dd67bf08b
md"""
# Model of Honeybee Reproduction
"""

# ╔═╡ abc47153-3461-48b4-a6d9-f2f3563290a8
md"""
## Model Equations
"""

# ╔═╡ 9e08466e-ed53-4023-a947-d040c8c3c05d
begin #Exogenous Variables/ Parameters
	pm=.1 #Fracton of drones that mate
	cw=.25 #Average Worker Consumption normalized
	cq=1.5 #Queen Consumption Normalized
	cd=1 #Average drone Consumption Normalized
	N=1000 #Number of Eggs
	α= 9 #Productivty Coefficient
end;

# ╔═╡ 4229e146-d673-4310-a97c-5e7ef5386ad4
begin #Initial Equations
	g(d)=d*R(d)*ps(d)*pm #Genetic optimization problem
	R(d)=1-(1/2)^d #Total Relatedness Coefficient
	function ps(d) #Drone Survival Percentage
		if (q(d)-(cw*w(d)+cq))/(cd*d) < 0
			return 0
		elseif (q(d)-(cw*w(d)+cq))/(cd*d) > 1 
			return 1
		else 
			return (q(d)-(cw*w(d)+cq))/(cd*d)
		end
	end		
	w(d)=N-d #Number of Eggs 
	q(d)=α*w(d)^(1/2) #Worker production function
	q_w(w)=α*w^(1/2) #Worker Production function in terms of workers
	c(w)=cw*w+cq #Worker and Queen Consumption function
	d(w)=N-w #Drones in terms of workers
	#----------------------------------------------------------------------------#
	#Comparative Graphs
	g1(α,d) = d*R(d)*ps1(α,d)*pm

	function ps1(α,d) #Drone Survival Percentage
		if (q1(α,d)-(cw*w(d)+cq))/(cd*d) < 0
			return 0
		elseif (q1(α,d)-(cw*w(d)+cq))/(cd*d) > 1 
			return 1
		else 
			return (q1(α,d)-(cw*w(d)+cq))/(cd*d)
		end
	end		
	q1(α,d)=α*w(d)^(1/2)

	dg1(α,d)=(dd*R(d)*ps1(α,d)*pm)+(d*dR(d)*ps1(α,d)*pm)+(d*R(d)*dps1(α,d)*pm)

	function dps1(α,d)
	if (q1(α,d)-(cw*w(d)+cq))/(cd*d) < 0
		return 0
	elseif (q1(α,d)-(cw*w(d)+cq))/(cd*d) > 1
		return 0
	else 
		return (d*dq1(α,d)-d*cw*dw(d)-q1(α,d)+cw*w(d)+cq)/(cd*d^2)
	end
	end
	dq1(α,d)=(α/2)*w(d)^(-1/2)*dw(d)
	#----------------------------------------------------------------------------#
	#First Order Conditions
	dg(d)=(dd*R(d)*ps(d)*pm)+(d*dR(d)*ps(d)*pm)+(d*R(d)*dps(d)*pm)
	dd=1
	dR(d)=log(2)*(1/2)^d
	function dps(d)
	if (q(d)-(cw*w(d)+cq))/(cd*d) < 0
		return 0
	elseif (q(d)-(cw*w(d)+cq))/(cd*d) > 1
		return 0
	else 
		return (d*dq(d)-d*cw*dw(d)-q(d)+cw*w(d)+cq)/(cd*d^2)
	end
	end
	dq(d)=(α/2)*w(d)^(-1/2)*dw(d)
	dw(d)=-1
#_______________________________________________________________________________#
	#Countour Functions
	g_c(d,w)= d*R(d)*ps(w,d)*pm #countour g value
	function ps(w,d) #Drone Survival Percentage
		if (q_w(w)-(cw*w+cq))/(cd*d) < 0
			return 0
		elseif (q_w(w)-(cw*w+cq))/(cd*d) > 1 
			return 1
		else 
			return (q_w(w)-(cw*w+cq))/(cd*d)
		end
	end	
end;

# ╔═╡ 5b1061e6-7d57-46c0-ba03-593814986e71
dvec=collect(range(0,N,length=N+1))

# ╔═╡ 4621eeb6-1763-4ac4-a37d-671a8f5a0739
wvec=collect(range(0,1300,length=N+1))

# ╔═╡ 1850af2e-c345-443e-80e1-a44fd4542e04
function dopt(d)

# Define the zero condition at the parameter value supplied
cond(d) = dg(d)

# Specify a starting guess
d0 = 800

# Find and return the solution
d = find_zero(cond, d0)

end;

# ╔═╡ 47b33ac6-d265-494e-b9e6-eb2b2c058036
g(dopt(dvec))

# ╔═╡ 17029d11-bde1-4381-977f-b0df4710ba27
function dopt1(α,d)
# Define the zero condition at the parameter value supplied
cond(d) = dg1(α,d)

# Specify a starting guess
d0 = 800

# Find and return the solution
d = find_zero(cond, d0)

end;

# ╔═╡ c25e0405-84f2-4060-93f6-48396fda4a12
md"""
## Optimal Genetic Value
"""

# ╔═╡ f9797d4b-0983-43be-866c-855bb94f387a
md"""
## Optimal Drone Survival
"""

# ╔═╡ d6dea762-be57-43fa-b4e4-676cfc2a459d
begin
    Dronesurvivalplot = plot(
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
	#Drone Survival Curve
    plot!(dvec, ps.(dvec).*dvec, linecolor=:black, linestyle=:solid, linewidth=2)
	
	# Key points, with dashed lines to them
	#optimum drone eggs
    plot!([dopt(dvec),dopt(dvec)], [0,ps.(dopt(dvec)).*dopt(dvec)], linecolor=:black, linestyle=:dash) 
    plot!([0,dopt(dvec)], [ps.(dopt(dvec)).*dopt(dvec),ps.(dopt(dvec)).*dopt(dvec)], linecolor=:black, linestyle=:dash)
    scatter!([dopt(dvec)], [ps.(dopt(dvec)).*dopt(dvec)], markercolor=:black, markersize=5)
	# Axis limits
    xlims!(0, 1.05*dvec[end])
    ylims!(0, 1.2*maximum(ps.(dvec).*dvec))
	 # Curve labels
    flx2 = 250
    fly2 = 6*ps(flx2)*flx2
    annotate!(flx2, fly2, text(L"p_s(d) \; ⋅ \; d", :left, :bottom, 12))
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

   Dronesurvivalplot	
end

# ╔═╡ 9ec49f37-d15b-4222-a490-f18188a7f7b9
md"""
## Drone Survival Function
"""

# ╔═╡ 6c95dd36-ebae-43af-b795-e1aecac35024
md"""
## Optimal Genetic Value as a function of Workers
"""

# ╔═╡ e4ea6990-2f8c-480c-8e25-a47d0ba83f47
begin
    workerplot = plot(
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
    plot!(w.(dvec), g.(dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	# Key points, with dashed lines to them
    plot!([w.(dopt(dvec)),w.(dopt(dvec))], [0,g.(dopt(dvec))], linecolor=:black, linestyle=:dash) 
    plot!([0,w.(dopt(dvec))], [g.(dopt(dvec)),g.(dopt(dvec))], linecolor=:black, linestyle=:dash)
    scatter!([w.(dopt(dvec))], [g.(dopt(dvec))], markercolor=:black, markersize=5)
	 # Axis limits
    xlims!(0, 1.05*dvec[end])
    ylims!(0, 1.2*maximum(g.(dvec)))
	# Curve labels
    flx4 = 500
    fly4 = 1.01*g(500)
    annotate!(flx4, fly4, text(L"g(w)", :left, :bottom, 12))
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

   workerplot	
end

# ╔═╡ 80251bf9-660c-47c9-957d-f48468a68661
function wbar(W) #worker max

# Define the zero condition at the parameter value supplied
cond(w) = q_w(w) - c(w)

# Specify a starting guess
w0 = 1000

# Find and return the solution
w = find_zero(cond, w0)

end;

# ╔═╡ a25f67e2-4fb5-4e02-992a-3b568b50babb
function alpha() #worker max

# Define the zero condition at the parameter value supplied
cond(α) = α* N^(1/2) - c(N) 

# Specify a starting guess
α0 = 10

# Find and return the solution
α = find_zero(cond, α0)

end;

# ╔═╡ 255c77b5-86bc-483a-b789-4812939f5602
begin #different alpha paramters
	α1=7 
	α2 = alpha()
	α3 = 9
end;

# ╔═╡ afb4f0b7-ca89-4f19-aa86-ea1621c955fd
function wunderbar(W) #worker min

# Define the zero condition at the parameter value supplied
cond(w) = q_w(w) - c(w)

# Specify a starting guess
w0 = .01

# Find and return the solution
w = find_zero(cond, w0)

end;

# ╔═╡ afa51f5f-9e2c-494f-9429-9b547681cb95
begin
    Gplot = plot(
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

	#Gplot
	
   # plot!(dvec, g.(dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha=7
	plot!(dvec, g1.(α1,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha = alpha()
	plot!(dvec, g1.(α2,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha=9
	plot!(dvec, g1.(α3,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	
	 # Optimal Drone Lines
  #  plot!([dopt(dvec),dopt(dvec)], [0,g.(dopt(dvec))], linecolor=:black, linestyle=:dash) 
   # plot!([0,dopt(dvec)], [g.(dopt(dvec)),g.(dopt(dvec))], linecolor=:black, linestyle=:dash)
   # scatter!([dopt(dvec)], [g.(dopt(dvec))], markercolor=:black, markersize=5)
	
	 # Optimal Drone Lines
	#alpha=7
   plot!([dopt1(α1,dvec),dopt1(α1,dvec)], [0,g1.(α1,dopt1(α1,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α1,dvec)], [g1.(α1,dopt1(α1,dvec)),g1.(α1,dopt1(α1,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α1,dvec)], [g1.(α1,dopt1(α1,dvec))], markercolor=:black, markersize=5)
	
	#alpha=alpha()
   plot!([dopt1(α2,dvec),dopt1(α2,dvec)], [0,g1.(α2,dopt1(α2,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α2,dvec)], [g1.(α2,dopt1(α2,dvec)),g1.(α2,dopt1(α2,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α2,dvec)], [g1.(α2,dopt1(α2,dvec))], markercolor=:black, markersize=5)

	#alpha=9
   plot!([dopt1(α3,dvec),dopt1(α3,dvec)], [0,g1.(α3,dopt1(α2,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α3,dvec)], [g1.(α3,dopt1(α3,dvec)),g1.(α3,dopt1(α3,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α3,dvec)], [g1.(α3,dopt1(α3,dvec))], markercolor=:black, markersize=5)

	#minimum drones
	# plot!([d(wbar(wvec)),d(wbar(wvec))], [0,1.2*maximum(g.(dvec))], linecolor=:black, linestyle=:dash)

	#maximum drones
	# plot!([d(wunderbar(wvec)),d(wunderbar(wvec))], [0,1.2*maximum(g.(dvec))], linecolor=:black, linestyle=:dash)
	
	# Axis limits
    xlims!(0, 1.05*dvec[end])
    ylims!(0, 1.2*maximum(g.(dvec)))
	
	 # Axis ticks
   # xticks!([dopt(dvec),0.001,d(wbar(wvec)),d(wunderbar(wvec))], [ L"d^*",L"0",L"\underline{d}", L"\overline{d}"])

	# xticks!([dopt(dvec),d(wbar(wvec)),d(wunderbar(wvec))], [L"d^*",L"\underline{d} \approx 0",L"\overline{d}"])
   # yticks!([0.001, g.(dopt(dvec))], [L"0", L"g(d^*)"])
	#comparative graphs 
	xticks!([dopt1(α1,dvec),dopt1(α2,dvec),dopt1(α3,dvec),d(wbar(wvec)),d(wunderbar(wvec)),0.001], [L"d_1^*",L"d_2^*",L"d_3^*",L"\underline{d} \approx 0",L"\overline{d}",L"0"])
    yticks!([0.001,  g1.(α1,dopt1(α1,dvec)), g1.(α2,dopt1(α2,dvec)), g1.(α3,dopt1(α3,dvec)) ], [L"0", L"g_1(d_1^*)",L"g_2(d_2^*)",L"g_3(d_3^*)"])

	#xticks!([d(wunderbar(wvec)),0.001], [L"\overline{d}",L"0"])
   # yticks!([0.001], [L"0"])
	
	 # Axis labels
    annotate!(1.02*xlims(Gplot)[2], 0.1, text(L"d", :left, :center, 12))
    annotate!(0, 1.01*ylims(Gplot)[2], text(L"g", :center, :bottom, 12))
	
	# Curve labels
   # flx = 300
    #fly = 1.07*g(flx)
	#annotate!(flx-70, fly-.5, text(L"g(d)", :left, :bottom, 12))
	
	#alpha=7
	flxa1 = 550
    flya1 = g1.(α1,flxa1)
	annotate!(flxa1-70, flya1-.25, text(L"g_1(d)", :left, :bottom, 12))

	#alpha=alpha()
	flxa2 = 550
    flya2 = g1.(α2,flxa2)
	annotate!(flxa2-70, flya2-.25, text(L"g_2(d)", :left, :bottom, 12))

	#alpha=9
	flxa3 = 459
    flya3 = g1.(α3,flxa3)
	annotate!(flxa3-70, flya3-.25, text(L"g_3(d)", :left, :bottom, 12))

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
	#savefig("Gplot3.pdf")
	#savefig("Gplotcomp1.pdf")
	Gplot
end

# ╔═╡ a01b8c5c-a29b-4bf3-b31c-d12b81bd4c34
begin
    Psplot = plot(
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
	#Drone survival Curve
    #plot!(dvec, ps.(dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha=7
	plot!(dvec, ps1.(α1,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha = alpha()
	plot!(dvec, ps1.(α2,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	#alpha=9
	plot!(dvec, ps1.(α3,dvec), linecolor=:black, linestyle=:solid, linewidth=2)
	
	 # dopt
   # plot!([dopt(dvec),dopt(dvec)], [0,ps.(dopt(dvec))], linecolor=:black, linestyle=:dash) 
    #plot!([0,dopt(dvec)], [ps.(dopt(dvec)),ps.(dopt(dvec))], linecolor=:black, linestyle=:dash)
    #scatter!([dopt(dvec)], [ps.(dopt(dvec))], markercolor=:black, markersize=5)
	
	#minimum drones
	# plot!([d(wbar(wvec)),d(wbar(wvec))], [0,1.2*maximum(g.(dvec))], linecolor=:black, linestyle=:dash)

	#alpha=7
  plot!([dopt1(α1,dvec),dopt1(α1,dvec)], [0,ps1.(α1,dopt1(α1,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α1,dvec)], [ps1.(α1,dopt1(α1,dvec)),ps1.(α1,dopt1(α1,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α1,dvec)], [ps1.(α1,dopt1(α1,dvec))], markercolor=:black, markersize=5)
	
	#alpha=alpha()
   plot!([dopt1(α2,dvec),dopt1(α2,dvec)], [0,ps1.(α2,dopt1(α2,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α2,dvec)], [ps1.(α2,dopt1(α2,dvec)),ps1.(α2,dopt1(α2,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α2,dvec)], [ps1.(α2,dopt1(α2,dvec))], markercolor=:black, markersize=5)

	#alpha=9
   plot!([dopt1(α3,dvec),dopt1(α3,dvec)], [0,ps1.(α3,dopt1(α3,dvec))], linecolor=:black, linestyle=:dash) 
   plot!([0,dopt1(α3,dvec)], [ps1.(α3,dopt1(α3,dvec)),ps1.(α3,dopt1(α3,dvec))], linecolor=:black, linestyle=:dash)
    scatter!([dopt1(α3,dvec)], [ps1.(α3,dopt1(α3,dvec))], markercolor=:black, markersize=5)

	#maximum drones
	# plot!([d(wunderbar(wvec)),d(wunderbar(wvec))], [0,1.2*maximum(g.(dvec))], linecolor=:black, linestyle=:dash)
	
	 # Axis ticks
   # xticks!([dopt(dvec),d(wbar(wvec)),d(wunderbar(wvec)),0.001], [L"d^*",L"\underline{d}",L"\overline{d}",L"0"])
	
	 #xticks!([dopt(dvec),d(wbar(wvec)),d(wunderbar(wvec))], [L"d^*",L"\underline{d} \approx 0",L"\overline{d}"])
	
   # yticks!([0.001, ps.(dopt(dvec))], [L"0", L"p_s(d^*)"])

	xticks!([dopt1(α1,dvec),dopt1(α2,dvec),dopt1(α3,dvec),d(wbar(wvec)),d(wunderbar(wvec)),0.0001], [L"d_1^*",L"d_2^*",L"d_3^*",L"\underline{d} \approx 0",L"\overline{d}", L"0"])
   yticks!([0.001,  ps1.(α1,dopt1(α1,dvec)), ps1.(α2,dopt1(α2,dvec)), ps1.(α3,dopt1(α3,dvec)) ], [L"0", L"p_{s1}(d_1^*)",L"p_{s2}(d_2^*)",L"p_{s3}(d_3^*)"])
	# Axis ticks
   #xticks!([dopt1(α1,dvec),d(wunderbar(wvec)),0.0001,dopt1(α2,dvec)], [L"d_1^*",L"\overline{d}", L"0",L"d_2^*"])
   # yticks!([0.001,  ps1.(α1,dopt1(α1,dvec)),ps1.(α2,dopt1(α2,dvec))], [L"0", L"p_{s1}(d_1^*)",L"p_{s2}(d_2^*)"])
	
	 # Axis labels
    annotate!(1.07*dvec[end], 0, text(L"d", :left, :center, 12))
    annotate!(0, .3, text(L"p_s", :center, :bottom, 12))
	
	# Curve labels
   # flx3 = 300
   # fly3 = 1*ps(flx3)
    #annotate!(flx3-50, fly3+.03, text(L"p_s(d)", :left, :bottom, 12))

	#alpha=7
	flx2a1 = 300
    fly2a1 = ps1.(α1,flx2a1)
	annotate!(flx2a1-70, fly2a1, text(L"p_{s1}(d)", :left, :bottom, 12))

	#alpha=alpha()
	flx2a2 = 300
    fly2a2 = ps1.(α2,flx2a2)
	annotate!(flx2a2-200, fly2a2+.01, text(L"p_{s2}(d)", :left, :bottom, 12))

	#alpha=9
	flx2a3 = 300
    fly2a3 = ps1.(α3,flx2a3)
	annotate!(flx2a3, fly2a3, text(L"p_{s3}(d)", :left, :bottom, 12))

	 # Axis limits
    xlims!(0, 1.05*dvec[end])
    ylims!(0, .3)
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
#savefig("Psplot3.pdf")
	#savefig("Psplotcomp3.pdf")
   Psplot	
end

# ╔═╡ b997a64a-e691-4225-8717-4d50094416f6
md"""
## Indifference Curves
"""

# ╔═╡ 251e6f54-471b-46c7-b6ac-c7132590481a
begin
    Indifference = plot(
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
    
    #Indifference
	contour!(dvec, wvec, g_c, levels=[1,2,3,4,5,6,7,7.96], 
		linecolor=:lightgray, clabels=false)

	#Indifference
	contour!(dvec, wvec, g_c, levels=[g_c(dopt(dvec),w(dopt(dvec)))], 
		linecolor=:red, clabels=false)
	
	#Egg Constraint
	plot!(dvec, w.(dvec), linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 2000)
    ylims!(0, 2000)

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

   Indifference	
end

# ╔═╡ dc2cdd5c-b100-4f25-b353-e6d2d0f2ddbf
g(dopt(dvec))

# ╔═╡ 8954aa2e-3c00-4de0-a653-3a5aa5296c7e
g_c(dopt(dvec),w(dopt(dvec)))

# ╔═╡ 7f9c87c0-b8f4-4eb5-bffc-0b9e0ee57e09
md"""
## Worker Production and Consumption
"""

# ╔═╡ d6658c99-0f9e-41ba-a74f-b3e178d2a53b
begin
    workerconsumption = plot(
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

	#Production function
    plot!(wvec, q_w.(wvec), linecolor=:black, linestyle=:solid, linewidth=2) 
	
	#consumption function
	plot!(wvec, c.(wvec), linecolor=:black, linestyle=:solid, linewidth=2) 
	
	#Worker upperbar
	plot!([wbar(wvec),wbar(wvec)],[0,1.2*d.(0)], linecolor=:black, linestyle=:dash, linewidth=2) 

	#Drone calorie needs
	plot!(wvec, cd*d.(wvec), linecolor=:black, linestyle=:solid, linewidth=2) 
	
	 
	
	# Axis limits
    #xlims!(0, 1.05*N)
	xlims!(0, 1.05*wbar(wvec)[end])
    ylims!(0, 1*ylims(workerconsumption)[2])
	
	 # Key points, with dashed lines to them
	#optimal Production function
    plot!([w.(dopt(dvec)),w.(dopt(dvec))], [0,q_w(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash) 
    plot!([0,w.(dopt(dvec))], [q_w(w.(dopt(wvec))),q_w(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash)
    scatter!([w.(dopt(dvec))], [q_w(w.(dopt(dvec)))], markercolor=:black, markersize=5)
	
	# Key points, with dashed lines to them
	#Optimal consumption for drones and workers
	plot!([w.(dopt(dvec)),w.(dopt(dvec))], [0,d(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash) 
	plot!([0,w.(dopt(dvec))], [d(w.(dopt(dvec))),d(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash)
	scatter!([w.(dopt(dvec))], [d(w.(dopt(dvec)))], markercolor=:black, markersize=5)
	plot!([0,w.(dopt(dvec))], [c(w.(dopt(dvec))),c(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash)
    scatter!([w.(dopt(dvec))], [c(w.(dopt(dvec)))], markercolor=:black, markersize=5)
	
	 # Axis labels
    annotate!(1.02*xlims(workerconsumption)[2], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.01*ylims(workerconsumption)[2], text(L"calories", :center, :bottom, 12))
	
	# Axis ticks
    xticks!([0.001, w.(dopt(dvec)), wbar(wvec),N], [L"\underbar{w} \approx 0", L"w^*",L"\overline{w}",L"N"])
	#xticks!([0.001, w.(dopt(dvec)), wbar(wvec)], [L"\underbar{w} \approx 0", L"w^*",L"\overline{w}=N"])
    yticks!([q_w(w.(dopt(dvec))),c(w.(dopt(dvec))), d(0), d(w.(dopt(dvec)))], [L"q(w^{*})",L"c(w^{*})",L"c(\overline{d})",L"c(d^{*})"])
	

	 # Curve labels 
	#production function
    flxq = 350
    flyq = 1.01*q_w(flxq)
    annotate!(flxq, flyq, text(L"q(w)", :left, :bottom, 12))
	
	#consumption for workers and queen
	flxc = 500
    flyc = .75*c(flxq)
    annotate!(flxc, flyc, text(L"c_ww+c_q", :left, :bottom, 12))

	#Consumption of Drones
	flxd = 300
    flyd = 1.01*d(flxd)
    annotate!(flxd, flyd, text(L"c_d d", :left, :bottom, 12))

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
#savefig("consprodplot3.pdf")
   workerconsumption	
end

# ╔═╡ e1ebbd0e-b33e-46f2-ac87-c96584b2b13a
begin
    workerconsumption2 = plot(
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
	#Plot of calories left to drones
    plot!(wvec, q_w.(wvec) .- c.(wvec), linecolor=:black, linestyle=:solid, linewidth=2)

	#Plot of calories drones need
	plot!(wvec, cd*d.(wvec), linecolor=:black, linestyle=:solid, linewidth=2)
	
	#Worker upperbar
	plot!([wbar(wvec),wbar(wvec)],[0,1.2*d.(0)], linecolor=:black, linestyle=:dash, linewidth=2)
	
	# Axis limits
    #xlims!(0, 1.05*N)
	xlims!(0, 1.05*wbar(wvec)[end])
    ylims!(0, 1*ylims(workerconsumption2)[2])
	
	 # Axis labels
    annotate!(1.02*xlims(workerconsumption2)[2], 0, text(L"w", :left, :center, 12))
    annotate!(0, 1.01*ylims(workerconsumption2)[2], text(L"calories", :center, :bottom, 12))

	 #Worker Consumption Label
    flxq2 = 350
    flyq2 = .5*(q.(flxq2) .- c.(flxq2))
    annotate!(flxq2, flyq2, text(L"q(w)-c_ww-c_q", :left, :bottom, 12))
	
	#Drone Consumption Label
	flxd2 = 300
    flyd2 = 1.01*d(flxd)
    annotate!(flxd2, flyd2, text(L"c_d d", :left, :bottom, 12))

	 # Key points, with dashed lines to them
	#optimal workers to calories left to drones
    plot!([w.(dopt(dvec)),w.(dopt(dvec))], [0,q_w(w.(dopt(dvec))) .- c.(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash) 
    plot!([0,w.(dopt(dvec))], [q_w(w.(dopt(wvec))).- c.(w.(dopt(dvec))),q_w(w.(dopt(dvec))).- c.(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash)
    scatter!([w.(dopt(dvec))], [q_w(w.(dopt(wvec))).- c.(w.(dopt(dvec))),q_w(w.(dopt(dvec))).- c.(w.(dopt(dvec)))], markercolor=:black, markersize=5)

	#optimal workers to calories drones need to survive
	 plot!([w.(dopt(dvec)),w.(dopt(dvec))], [0, cd*d.(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash) 
	plot!([0,w.(dopt(dvec))], [cd*d.(w.(dopt(dvec))),cd*d.(w.(dopt(dvec)))], linecolor=:black, linestyle=:dash)
    scatter!([w.(dopt(dvec))], [cd*d.(w.(dopt(dvec))),cd*d.(w.(dopt(dvec)))], markercolor=:black, markersize=5)
	
	  # Axis ticks
    xticks!([0.001, w.(dopt(dvec)), wbar(wvec),N], [L"\underbar{w} \approx 0", L"w^*",L"\overline{w}",L"N"])
	#xticks!([0.001, w.(dopt(dvec)), wbar(wvec)], [L"\underbar{w} \approx 0", L"w^*",L"\overline{w}=N"])
    yticks!([q_w(w.(dopt(wvec))).- c.(w.(dopt(dvec))), cd*d.(w.(dopt(dvec)))], [L"q(w^*)-c(w^*)", L"c(d^*)"])
	
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

	#savefig("workerconsumptionplot3.pdf")

   workerconsumption2	
end

# ╔═╡ 0eb2019c-b62e-4bcf-ab12-e9844d062e62
md"""
## Comparing Values
"""

# ╔═╡ 5334dfec-ceed-4a68-b820-744fc969c20b
md"""
## Results
"""

# ╔═╡ 47da746d-90f4-44ee-a9f2-0de3d8d5586e
md"""
Optimal G Value
"""

# ╔═╡ 32d58058-91ff-4562-84da-a901f64faa4c
g(dopt(dvec))

# ╔═╡ 6c2e9e12-07f8-4037-89c1-9cde53d92355
md"""
Optimal Drone to Worker Egg ratio
"""

# ╔═╡ 530c6898-ba7b-4ff9-a64d-e07c9e28e5bd
dopt(dvec)/w.(dopt(dvec))

# ╔═╡ 8e0cd84f-12e9-40ab-b000-c2c251ec63fe
md"""
Optimal Drone to Worker Survival Ratio
"""

# ╔═╡ 66303c32-166b-4599-90f8-7f73163652b7
(dopt(dvec)*ps.(dopt(dvec)))/w.(dopt(dvec))

# ╔═╡ da8f52eb-ddf9-4ae5-b481-985047c6ee45
md"""
Optimal Drone Survival Percentage
"""

# ╔═╡ c3f5d16e-1141-4e17-a253-3e56e8aea41e
ps.(dopt(dvec))

# ╔═╡ 3ef96ac6-1390-4eca-8f89-1948b0c482d5
md"""
## Notes to self
"""

# ╔═╡ bafefbf5-34c7-4167-9457-294a31c0b5d6
md"""
Plot 1 α=7
"""

# ╔═╡ ad0a3a00-516e-4ca1-8c0e-ffbfcebf5893
md"""
Plot 2 
"""

# ╔═╡ fe3b22ab-d1e6-472d-9846-95e2ada0f3b4
alpha()

# ╔═╡ fd032b7d-a582-45f2-807f-ccb677261c3d
md"""
Plot 3 α=9
"""

# ╔═╡ Cell order:
# ╠═edbae97c-8a43-11ef-0166-b1f4f229a15e
# ╠═7849b3f6-db19-471a-995e-a39a813baf47
# ╟─fabfa1e7-de7f-42c0-8297-ba1dd67bf08b
# ╟─abc47153-3461-48b4-a6d9-f2f3563290a8
# ╠═9e08466e-ed53-4023-a947-d040c8c3c05d
# ╠═255c77b5-86bc-483a-b789-4812939f5602
# ╠═4229e146-d673-4310-a97c-5e7ef5386ad4
# ╠═5b1061e6-7d57-46c0-ba03-593814986e71
# ╠═4621eeb6-1763-4ac4-a37d-671a8f5a0739
# ╠═1850af2e-c345-443e-80e1-a44fd4542e04
# ╠═47b33ac6-d265-494e-b9e6-eb2b2c058036
# ╠═17029d11-bde1-4381-977f-b0df4710ba27
# ╟─c25e0405-84f2-4060-93f6-48396fda4a12
# ╠═afa51f5f-9e2c-494f-9429-9b547681cb95
# ╟─f9797d4b-0983-43be-866c-855bb94f387a
# ╠═d6dea762-be57-43fa-b4e4-676cfc2a459d
# ╟─9ec49f37-d15b-4222-a490-f18188a7f7b9
# ╠═a01b8c5c-a29b-4bf3-b31c-d12b81bd4c34
# ╟─6c95dd36-ebae-43af-b795-e1aecac35024
# ╠═e4ea6990-2f8c-480c-8e25-a47d0ba83f47
# ╠═80251bf9-660c-47c9-957d-f48468a68661
# ╠═a25f67e2-4fb5-4e02-992a-3b568b50babb
# ╠═afb4f0b7-ca89-4f19-aa86-ea1621c955fd
# ╟─b997a64a-e691-4225-8717-4d50094416f6
# ╟─251e6f54-471b-46c7-b6ac-c7132590481a
# ╠═dc2cdd5c-b100-4f25-b353-e6d2d0f2ddbf
# ╠═8954aa2e-3c00-4de0-a653-3a5aa5296c7e
# ╟─7f9c87c0-b8f4-4eb5-bffc-0b9e0ee57e09
# ╠═d6658c99-0f9e-41ba-a74f-b3e178d2a53b
# ╠═e1ebbd0e-b33e-46f2-ac87-c96584b2b13a
# ╟─0eb2019c-b62e-4bcf-ab12-e9844d062e62
# ╟─5334dfec-ceed-4a68-b820-744fc969c20b
# ╟─47da746d-90f4-44ee-a9f2-0de3d8d5586e
# ╟─32d58058-91ff-4562-84da-a901f64faa4c
# ╟─6c2e9e12-07f8-4037-89c1-9cde53d92355
# ╟─530c6898-ba7b-4ff9-a64d-e07c9e28e5bd
# ╟─8e0cd84f-12e9-40ab-b000-c2c251ec63fe
# ╟─66303c32-166b-4599-90f8-7f73163652b7
# ╟─da8f52eb-ddf9-4ae5-b481-985047c6ee45
# ╟─c3f5d16e-1141-4e17-a253-3e56e8aea41e
# ╟─3ef96ac6-1390-4eca-8f89-1948b0c482d5
# ╟─bafefbf5-34c7-4167-9457-294a31c0b5d6
# ╟─ad0a3a00-516e-4ca1-8c0e-ffbfcebf5893
# ╟─fe3b22ab-d1e6-472d-9846-95e2ada0f3b4
# ╟─fd032b7d-a582-45f2-807f-ccb677261c3d
