### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ d1fdcce2-2050-11f0-1e09-69d24dcb454a
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
	#using DataStructures
    #using Compiler
    #using Flux
    #using Turing  
    using CairoMakie
	#using GraphMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	#using Plots     # plot graphs
	#using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end


# ╔═╡ d1f575c1-7ee1-4482-b218-199f218cef9d
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ fbe0a06f-eb2f-4fa0-bfea-cf07be62a869
md"""
# Take Home 6
"""

# ╔═╡ 599b9521-1f0e-4718-94a6-4036c48e9e1b
md"""
## Graphical Representations
"""

# ╔═╡ c0829fad-2352-4305-b3d0-8b28bac5e330
begin #parameters
	r = 1.15
	K= 10.0
	α = 0.1 
	s = 1.5
	L = 75.0
end;

# ╔═╡ 36815130-717d-4646-b1c5-76a97b6edd17
md"""
### Minimum Effort
"""

# ╔═╡ 32a1e23c-b516-47c6-8c2a-70bbfc1422de
begin #effort level
	E_0 = 0
end;

# ╔═╡ 636fdb0d-0e16-4466-bd50-b420891d96d8
begin 
	v = LinRange(0, 100, 1000) # avoids X = 0

	#X_isocline: 
	Y_isocline_X = -(r .* v .* (1 .- v ./ K) .+ E_0 .* v) ./ (α .* v)

	#Y isocline
	Y_line = fill(L, length(v))
end;

# ╔═╡ f6334a55-670a-4ecb-a3e1-53cdfb8a1d11
#vector field function
	f(p) = begin
		Y, X = p 
		dx = r.* X .* (1 .- X ./ K) .+ α .* X .* Y .- E_0 .* X
		dy = s .* Y .* (1 .- Y ./ L)
		Point2f(dy, dx) 
	end;

# ╔═╡ 729c5935-bb4e-4fef-84d0-af983f2b49df
begin
	fig, ax, _ = streamplot(f, 0..100, 0..100, colormap = :viridis)
	ax.xlabel = "Y"
	ax.ylabel = "X"
	lines!(ax, v, Y_isocline_X, color = :grey, label = "X-isocline", linewidth = 2)
	lines!(ax, Y_line, v, color =:grey, label = "Y-isocline", linewidth = 2)
	xlims!(ax, 0, 100)
	ylims!(ax, 0, 100)
	fig
end

# ╔═╡ d4d33349-a1dc-4f73-abc4-8ec98ab84ed6
save("phaseplane1.png", fig)

# ╔═╡ 9ab7bf1b-fde6-4c05-8787-eb097253955c
md"""
### Maximum Effort
"""

# ╔═╡ 87ce54e3-025d-448b-ad49-33c9d87715d4
begin
	E_max = 3
end;

# ╔═╡ 2eeade06-b1b6-4586-a653-c4a7fe4a553a
begin 
	v2 = LinRange(0, 100, 1000) # avoids X = 0

	#X_isocline: 
	Y_isocline_X2 = -(r .* v2 .* (1 .- v2 ./ K) .+ E_max .* v2) ./ (α .* v2)

	#Y isocline
	Y_line2 = fill(L, length(v2))
end;

# ╔═╡ e56d05e1-d5ee-4f34-94f2-6f65fd5de662
f_2(p) = begin
	Y, X = p
	dx_2 = r*X*(1 - X/K)+ α * X * Y - E_max * X
	dy_2 = s * Y * (1- Y/L)
	Point2f(dy_2, dx_2)
end;

# ╔═╡ 392fcc85-d040-4487-b57f-3a157203af13
begin 
	fig2, ax2, _ = streamplot(f_2, 0..100, 0..100, colormap = :viridis)
	ax2.xlabel = "Y"
	ax2.ylabel = "X"
	lines!(ax2, v2, Y_isocline_X2, color = :grey, label = "X-isocline", linewidth = 2)
	lines!(ax2, Y_line2, v2, color =:grey, label = "Y-isocline", linewidth = 2)
	xlims!(ax2, 0, 100)
	ylims!(ax2, 0, 100)
	fig2
end

# ╔═╡ ed2ecd13-0704-4c78-8ac3-6d5f20fb039a
save("phaseplane2.png", fig2)

# ╔═╡ 14684450-3692-41a0-aac8-b3920a6fc5bb
md"""
### Really Large Maximum Effort
"""

# ╔═╡ d60b82ea-1b96-4eaa-b3e3-938e6e8ae156
begin
	E_max_l = 10
end;

# ╔═╡ 7d7d4a8c-6050-4afb-8128-903fd6112fe6
begin 

	#X_isocline: 
	Y_isocline_X3 = -(r .* v2 .* (1 .- v2 ./ K) .+ E_max_l .* v2) ./ (α .* v2)

	#Y isocline
	Y_line3 = fill(L, length(v2))
end;

# ╔═╡ bf697f5a-67af-4cc6-9028-3e44a929be81
f_3(p) = begin
	Y, X = p
	dx_3 = r*X*(1 - X/K)+ α * X * Y - E_max_l * X
	dy_3 = s * Y * (1- Y/L)
	Point2f(dy_3, dx_3)
end;

# ╔═╡ 060291bb-1809-4104-bcd6-d7ca18027411
begin 
	fig3, ax3, _ = streamplot(f_3, 0..100, 0..100, colormap = :viridis)
	ax3.xlabel = "Y"
	ax3.ylabel = "X"
	lines!(ax3, v2, Y_isocline_X3, color = :grey, label = "X-isocline", linewidth = 2)
	lines!(ax3, Y_line3, v2, color =:grey, label = "Y-isocline", linewidth = 2)
	xlims!(ax3, 0, 100)
	ylims!(ax3, 0, 100)
	fig3
end

# ╔═╡ a11ca4ab-3deb-40c1-85fa-8964f8e7004b
save("phaseplane3.png", fig3)

# ╔═╡ c5501965-3065-4e95-ba04-4806ed3cd59c
md"""
### Optimal Recovery Paths
"""

# ╔═╡ Cell order:
# ╠═d1fdcce2-2050-11f0-1e09-69d24dcb454a
# ╠═d1f575c1-7ee1-4482-b218-199f218cef9d
# ╟─fbe0a06f-eb2f-4fa0-bfea-cf07be62a869
# ╟─599b9521-1f0e-4718-94a6-4036c48e9e1b
# ╠═c0829fad-2352-4305-b3d0-8b28bac5e330
# ╟─36815130-717d-4646-b1c5-76a97b6edd17
# ╠═32a1e23c-b516-47c6-8c2a-70bbfc1422de
# ╠═636fdb0d-0e16-4466-bd50-b420891d96d8
# ╠═f6334a55-670a-4ecb-a3e1-53cdfb8a1d11
# ╠═729c5935-bb4e-4fef-84d0-af983f2b49df
# ╠═d4d33349-a1dc-4f73-abc4-8ec98ab84ed6
# ╟─9ab7bf1b-fde6-4c05-8787-eb097253955c
# ╠═87ce54e3-025d-448b-ad49-33c9d87715d4
# ╠═2eeade06-b1b6-4586-a653-c4a7fe4a553a
# ╠═e56d05e1-d5ee-4f34-94f2-6f65fd5de662
# ╠═392fcc85-d040-4487-b57f-3a157203af13
# ╠═ed2ecd13-0704-4c78-8ac3-6d5f20fb039a
# ╟─14684450-3692-41a0-aac8-b3920a6fc5bb
# ╠═d60b82ea-1b96-4eaa-b3e3-938e6e8ae156
# ╠═7d7d4a8c-6050-4afb-8128-903fd6112fe6
# ╠═bf697f5a-67af-4cc6-9028-3e44a929be81
# ╠═060291bb-1809-4104-bcd6-d7ca18027411
# ╠═a11ca4ab-3deb-40c1-85fa-8964f8e7004b
# ╟─c5501965-3065-4e95-ba04-4806ed3cd59c
