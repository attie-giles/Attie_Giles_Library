### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 391583ec-f519-11ef-3142-1b3d0753e442
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
	using GameTheory
	using Graphs
	using GraphPlot
	using NetworkLayout
	using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
    using CairoMakie
	using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	#using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end

# ╔═╡ 81a25507-593c-4368-bbc6-e37a309527c8
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ 0856e0d4-515e-4f52-8eea-043ace6748a1
md"""
# Game Theory Hw 3
"""

# ╔═╡ 54331390-cb70-4177-9b40-edaf9caf1750
md"Using Makie: $(@bind makie_box CheckBox(default=false))"

# ╔═╡ 1e95d08b-80d8-4b7e-a8cf-1ce6adf2f0d7
md"""
A Risk-Averse individual prefers the mean of any lottery to the lottery itself. 
"""

# ╔═╡ c1f9fa38-431b-412d-94dc-f61ef9f43aea
md"""
### Game Tree 1
"""

# ╔═╡ cfcd1c08-3d7f-465c-bd5c-69f177ecdc4b
begin
if makie_box == true 
# Define adjacency matrix
adj_matrix = [0 1 1 ;
			  0 0 0 ;
			  0 0 0 ]

# Create directed graph
g = SimpleDiGraph(adj_matrix)

# Define layout
layout = Buchheim()

# Plot the graph
fig, ax, graph_obj = graphplot(g, layout=layout, node_size=10, node_color=:white, nlabels=[L"w_0",L" 0",L"2w_0"], nlabels_align=(:center, :center),nlabels_distance=4, elabels=["1/2","1/2"], nlabels_fontsize=25, elabels_fontsize=25)


hidedecorations!(ax)  # Hides axis labels and ticks
hidespines!(ax)        # Hides the border around the plot

fig
elseif makie_box == false
	 "Makie turned off"
end
end

# ╔═╡ f2e9de08-3a36-4dfd-858c-e3f777c61cb3
md"""
### Game Tree 2
"""

# ╔═╡ 6cd81f0c-945c-4dd3-b9e6-0146e0805028
begin
if makie_box == true
# Define adjacency matrix
adj_matrix2 = [0 1 1 ;
			  0 0 0 ;
			  0 0 0 ]

# Create directed graph
g2 = SimpleDiGraph(adj_matrix2)

# Define layout
layout2 =  Buchheim()

# Plot the graph
fig2, ax2, graph_obj2 = graphplot(g2, layout=layout2, node_size=20, node_color=:white, nlabels=[L"w_0",L"0",L"2w_0"], nlabels_align=(:bottom, :center),nlabels_distance=-25, elabels=[L"\{0.5\}-w_0",L"\{0.5\} +w_0"], nlabels_fontsize=25, elabels_fontsize=25)


hidedecorations!(ax2)  # Hides axis labels and ticks
hidespines!(ax2)        # Hides the border around the plot

fig2
elseif makie_box == false
	 "Makie turned off"
end

end

# ╔═╡ 7140f845-a712-4837-89b7-6145d07a33f0
md"""
### Game Tree 3
"""

# ╔═╡ b9bfaab9-240b-4068-9a22-653a4abc8a19
begin
if makie_box == true
# Define adjacency matrix
adj_matrix3 = [0 1 1 ;
			  0 0 0 ;
			  0 0 0 ]

# Create directed graph
g3 = SimpleDiGraph(adj_matrix3)

# Define layout
layout3 =  Buchheim()

# Plot the graph
fig3, ax3, graph_obj3 = graphplot(g3, layout=layout3, node_size=20, node_color=:white, nlabels=[L"\tilde{w}", L"w̲", L"2\tilde{w}"], nlabels_align=(:bottom, :center), nlabels_distance=-25, elabels=[L"\{0.5\} -(\tilde{w} - w̲)", L"\{0.5\} + \tilde{w}"], nlabels_fontsize=22, elabels_fontsize=25)


hidedecorations!(ax3)  # Hides axis labels and ticks
hidespines!(ax3)        # Hides the border around the plot

fig3
	
	elseif makie_box == false
	 "Makie turned off"
end

end

# ╔═╡ 90b16318-3518-4670-9179-460e469be4c1
md"""
### Game Tree 4
"""

# ╔═╡ 358fccbe-00dd-48b9-b2ad-8b029c153d0a
begin
if makie_box == true
# Define adjacency matrix
adj_matrix4 = [0 1 1 ;
			  0 0 0 ;
			  0 0 0 ]

# Create directed graph
g4 = SimpleDiGraph(adj_matrix4)

# Define layout
layout4 =  Buchheim()

# Plot the graph
fig4, ax4, graph_obj4 = graphplot(g4, layout=layout4, node_size=20, node_color=:white, nlabels=[L"w_0", L"w̲", L"w_0+\tilde{w}"], nlabels_align=(:bottom, :center), nlabels_distance=-25, elabels=[L"\{0.5\}- (w_0-w̲)", L"\{0.5\} + \tilde{w}"], nlabels_fontsize=18, elabels_fontsize=25)


hidedecorations!(ax4)  # Hides axis labels and ticks
hidespines!(ax4)        # Hides the border around the plot

fig4
	
	elseif makie_box == false
	 "Makie turned off"
end

end

# ╔═╡ d9c842b5-e501-4299-93e6-73bf6bb6d9bf
md"""
## Plots
"""

# ╔═╡ cd1cb366-ff49-4ab5-a7fb-e05830ff86d0
begin #Equations
	U(x) = sqrt(x)#utility function
	U1(w_0) = U(w_0) #utility of initial wealth
	U2(w_u,w_0,w_t) = 0.5*U(w_u) + 0.5*U(w_0+w_t) #utility from playing the lottery
end;

# ╔═╡ 29174b60-a032-4844-a648-fe3a890dc79c
begin #parameters
	w_0 = 100
	w_u = 50
end;

# ╔═╡ 90428c51-85ce-4aaa-9e9c-e37baa08b0d1
wtvec = collect(range(0,300,length=400))

# ╔═╡ 78854f2e-6afb-423f-9631-f659ae3a7566
function indiff(w_u,w_0,w_t)

	# Define th zero condition at the parameter value supplied
	cond(w_t) = U2(w_u,w_0,w_t) - U1(w_0)


	# Specify a starting guess
	wt0 =100


	# Find and return the solution
	wt = find_zero(cond, wt0)


end;

# ╔═╡ bffef86f-04ea-4fac-afc5-cdbbd9d38647
begin
	if makie_box == false
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
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(wtvec, U2.(w_u,w_0,wtvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!([0,wtvec[end]], [U1(w_0),U1(w_0)], linecolor=:black, linestyle=:solid,linewidth=2)
	
	# Axis limits
    xlims!(0, 1.05*wtvec[end])
    ylims!(0, 1.2*maximum(U2.(w_u,w_0,wtvec)))
	
	 # Axis labels
    annotate!(1.071*wtvec[end], 0, text(L"\tilde{w}", :left, :center, 12))
    annotate!(0, 1.212*maximum(U2.(w_u,w_0,wtvec)), text(L"U", :center, :bottom, 12))

	annotate!(130, U2.(w_u,w_0,200), text(L"\frac{U(\underbar{w})}{2}+ \frac{U(w_0+\tilde{w})}{2}", :left, :bottom, 12))

	annotate!(250, U1(w_0), text(L"U(w_0)", :left, :bottom, 12))

	# Axis ticks
    xticks!([0.001, indiff(w_u,w_0,wtvec)], [L"0", L"\tilde{w}^*"])
    yticks!([0.001], [L"0"])

	plot!([indiff(w_u,w_0,wtvec),indiff(w_u,w_0,wtvec)], [0,U2.(w_u,w_0,indiff(w_u,w_0,wtvec))], linecolor=:black, linestyle=:dash) 
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

	elseif makie_box == true
		"Makie turned on"
	end
end


# ╔═╡ 5a2f9bf4-1536-4e71-ab57-2cb6cb076591
md"""
## Game Tree 5
"""

# ╔═╡ 0bf206b9-7ad2-4441-a0c3-dc0b666c1747
begin
if makie_box == true
# Define adjacency matrix
adj_matrix5 = [0 1 1 0 0 0 0 ;
			   0 0 0 1 1 0 0 ;
			   0 0 0 0 0 1 1 ;
			   0 0 0 0 0 0 0 ;
		       0 0 0 0 0 0 0 ;
			   0 0 0 0 0 0 0 ;
		       0 0 0 0 0 0 0 ]

# Create directed graph
g5 = SimpleDiGraph(adj_matrix5)

# Define layout
layout5 =  Buchheim()

# Plot the graph
fig5, ax5, graph_obj5 = graphplot(g5, layout=layout5, node_size=25, node_color=:white, nlabels=[L"w_0", L"U", L" F", L"w_0 + \tilde{w}", L"w̲", L"w̲", L"w_0 + \tilde{w}"], nlabels_align=(:bottom, :center), nlabels_distance=-25, elabels=[L"1- \alpha", L"\alpha", L"4/9",L"5/9",L"1/3",L"2/3"], nlabels_fontsize=18, elabels_fontsize=18)


hidedecorations!(ax5)  # Hides axis labels and ticks
hidespines!(ax5)        # Hides the border around the plot

fig5

	elseif makie_box == false
	 "Makie turned off"
end

end

# ╔═╡ Cell order:
# ╠═391583ec-f519-11ef-3142-1b3d0753e442
# ╠═81a25507-593c-4368-bbc6-e37a309527c8
# ╟─0856e0d4-515e-4f52-8eea-043ace6748a1
# ╟─54331390-cb70-4177-9b40-edaf9caf1750
# ╟─1e95d08b-80d8-4b7e-a8cf-1ce6adf2f0d7
# ╟─c1f9fa38-431b-412d-94dc-f61ef9f43aea
# ╟─cfcd1c08-3d7f-465c-bd5c-69f177ecdc4b
# ╟─f2e9de08-3a36-4dfd-858c-e3f777c61cb3
# ╟─6cd81f0c-945c-4dd3-b9e6-0146e0805028
# ╟─7140f845-a712-4837-89b7-6145d07a33f0
# ╟─b9bfaab9-240b-4068-9a22-653a4abc8a19
# ╟─90b16318-3518-4670-9179-460e469be4c1
# ╠═358fccbe-00dd-48b9-b2ad-8b029c153d0a
# ╟─d9c842b5-e501-4299-93e6-73bf6bb6d9bf
# ╠═cd1cb366-ff49-4ab5-a7fb-e05830ff86d0
# ╠═29174b60-a032-4844-a648-fe3a890dc79c
# ╠═90428c51-85ce-4aaa-9e9c-e37baa08b0d1
# ╠═78854f2e-6afb-423f-9631-f659ae3a7566
# ╟─bffef86f-04ea-4fac-afc5-cdbbd9d38647
# ╟─5a2f9bf4-1536-4e71-ab57-2cb6cb076591
# ╠═0bf206b9-7ad2-4441-a0c3-dc0b666c1747
