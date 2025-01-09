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

# ╔═╡ 33cb76e6-46a3-11ef-10cc-db2d93867b43
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	#using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ 09dc6914-07ca-4485-990c-0ccad4bbdf8d
md"""
#### Total space
"""

# ╔═╡ e5821f80-82c1-49dd-91a8-7d8572aea212
xmax = 24

# ╔═╡ 11c6a51f-be7c-43fd-bf05-bad0d87cc765
xVec = collect(range(0,xmax,length=101))

# ╔═╡ 44b185ed-9a1b-4e18-bfa4-ac1ee40b9c30
md"""Select function: $(@bind fun Select(
	["ProductionLe" => "Production: labor essential", 
     "ProductionLn" => "Production: labor non-essential", 
     "Revenues"     => "Monopolist revenues", 
     "CostsF0"      => "Long-run costs", 
     "CostsFp"      => "Short-run costs"], 
     default="ProductionLe"))"""

# ╔═╡ b14f91cf-ec1b-401b-a0eb-96d2a2d3a9be
    if fun == "ProductionLe"
		a = 2
		b = 2*(a-1)/xmax
		F = 0
		f(x) = a*x - 0.5*b*x^2
		fp(x) = a - b*x
	elseif fun == "ProductionLn"
		a = 1.5
		F = 6
		b = 2*(F + (a-1)*xmax)/xmax^2
		f(x) = F + a*x - 0.5*b*x^2
		fp(x) = a - b*x
	elseif fun == "Revenues"
		b = 1/3
		# a*(0.5*xmax) - 0.5*b*(0.5*xmax)^2 = ymax
		# a*0.5*xmax - 0.5*b*(0.5*xmax)^2 = xmax
		# a*0.5 - 0.5*b*0.25*xmax = 1
		# a - 0.25*b*xmax = 2
		# a = 2 + 0.25*b*xmax
		a = 2 + 0.25*b*xmax
		f(x) = a*x - 0.5*b*x^2
		fp(x) = a - b*x
	elseif fun == "CostsF0"
		a = 0.05
		# a*xmax + 0.5*b*xmax^2 = ymax
		# a*xmax + 0.5*b*xmax^2 = xmax
		# a + 0.5*b*xmax = 1
		# 0.5*b*xmax = 1 - a
		# b*xmax = 2*(1 - a)
		# b = 2*(1 - a)/xmax
		b = 2*(1 - a)/xmax
		f(x) = a*x + 0.5*b*x^2
		fp(x) = a + b*x
	elseif fun == "CostsFp"
		a = 0
		F = (1-a)*xmax/5
		# F + a*xmax + 0.5*b*xmax^2 = ymax
		# F + a*xmax + 0.5*b*xmax^2 = xmax
		# 0.5*b*xmax^2 = (1 - a)*xmax - F
		# b*xmax^2 = 2*(1 - a)*xmax - 2*F
		# b = (2*(1 - a)*xmax - 2*F)/xmax^2
		b = (2*(1 - a)*xmax - 2*F)/xmax^2
		f(x) = F + a*x + 0.5*b*x^2
		fp(x) = a + b*x
	end

# ╔═╡ 66ec14b4-db61-4b60-9c36-587c5e7047bb
md"""
Axis limits
"""

# ╔═╡ 39139079-a390-4217-af7a-2714d17ffc82
ymax = xmax

# ╔═╡ 2db589f5-3814-4d20-9393-6e8452e52c67
fpmax = maximum(fp.(xVec))

# ╔═╡ 022c9245-80ad-4ca6-b760-8e5eab11bd05
fpmin = minimum(fp.(xVec))

# ╔═╡ c2763124-9ed3-4680-a67d-44d9c90917b6
ymin = min(fpmin,0)

# ╔═╡ ce453afb-97c8-4a26-b0d0-869851dbcfd1
md"""
Nudges
"""

# ╔═╡ 28a9b342-855d-4c6b-bff0-81f7358c842c
begin
	xe = 0.01*xmax
	ye = xe
end;

# ╔═╡ 8ca5c432-d666-45d8-af03-8f5f9cdc97dc
md"""
Sliver width
"""

# ╔═╡ e20f9e0d-f368-44b7-b961-29125c831384
dx = @bind dx Slider(0.0:0.05:1, default=1, show_value=true)

# ╔═╡ 53cad01d-cc39-4431-bae5-93a64c0ae286
md"""
Implied number of slivers
"""

# ╔═╡ df98589b-ab0e-4414-8af4-8f2204450364
nsmax = Int(ceil(xmax/dx))

# ╔═╡ 73392f6f-db95-47e4-a4ee-e9b0e6bcccae
md"""
`xVec` up to last sliver shown
"""

# ╔═╡ dbe25d8d-0b66-4daa-a57a-ab6d3d45af4e
md"Show total $(@bind showtot CheckBox(default=true))"

# ╔═╡ 4562864d-b95f-4577-a3ab-7f55f223a90e
md"Show marginal curve $(@bind showmrgc CheckBox(default=false))"

# ╔═╡ 962c3ce5-914f-42ba-80d8-a5ba4579e9e6
md"Show average $(@bind showave CheckBox(default=false))"

# ╔═╡ 7580a314-5872-41b4-9108-0badc474fc7d
md"Show average curve $(@bind showavec CheckBox(default=false))"

# ╔═╡ edc23311-b868-4c7f-874c-b3c4d052d5af
md"Show average variable $(@bind showavev CheckBox(default=false))"

# ╔═╡ eb5b3814-f2c2-493d-b896-672902477074
md"Show average fixed $(@bind showavef CheckBox(default=false))"

# ╔═╡ a8ff2aac-4249-42db-b317-b61defe68aa3
md"Show transition $(@bind showtrn CheckBox(default=true))"

# ╔═╡ 2ce50ae8-bd72-4b0e-a032-42e99e09a739
md"Show slivers $(@bind showslv CheckBox(default=true))"

# ╔═╡ 5d366646-b2a7-4dbb-b26d-e2550204a818
md"Show slopes $(@bind showslp CheckBox(default=false))"

# ╔═╡ 6cd54c92-815e-470d-ad70-170c05b439ad
w = @bind w Slider(0.0:0.01:1, default=1, show_value=true)

# ╔═╡ 3c71348e-ec53-4645-bd1c-c890b7c97a3c
ns = @bind ns Slider(0:1:nsmax, default=0, show_value=true)

# ╔═╡ cf78b0e8-845b-4b34-98a6-8af82e04964b
begin
	xVecns = copy(xVec)
	xVecns[xVecns .> ns*dx] .= NaN
end;

# ╔═╡ 898661ff-3c11-40d9-9e04-e06cef4fce82
begin
    p2 = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=0Plots.pt,
    right_margin=0Plots.pt,
    left_margin=0Plots.pt,
	bottom_margin=0Plots.pt,
	showaxis = false,
    #framestyle = :origin,
    aspect_ratio = :equal,
    size=(700,1000),
    #xticks=1:12,
    #yticks=1:12,
    #widen=true,
    #wide=1.02,
    )

    # Checkbox-dependent settings
	if fun == "ProductionLe"
		if showtrn
			sf = 1
			ytickVec = collect(0:1:2)
		else
			sf = 2
			ytickVec = collect(0:1:2)
		end
	elseif fun == "ProductionLn"
		if showtrn
			sf = 1
			ytickVec = collect(0:1:2)
		else
			sf = 2
			ytickVec = collect(0:1:8)
		end
	elseif fun == "Revenues"
		ytickVec = collect(-4:2:4)
		sf = 1
	elseif fun == "CostsF0"
		if showtrn
			sf = 1
		  	ytickVec = collect(0:2:3)
		else
			sf = 2
		  	ytickVec = collect(0:1:3)
		end
	elseif fun == "CostsFp"
		if showtrn
			sf = 1
		  	ytickVec = collect(0:2:5)
		else
			sf = 2
		  	ytickVec = collect(0:1:5)
		end
	end

	# Total-space axis displacement
	if fun == "ProductionLn"
		if showtrn
			dt = 3*sf*ytickVec[end]
		else
			dt = 1.2*sf*ytickVec[end]
		end
	else
		dt = 2*sf*ytickVec[end]
	end

	# Fake dots
    fk = :white
    #fk = :red
    scatter!([-10*xe], [1.3*ymax] .+ dt, 
		markercolor=fk, markerstrokecolor=fk, markerstrokewidth=1, markersize=2)
    scatter!([xmax+10*xe], [ymin-5*ye], 
		markercolor=fk, markerstrokecolor=fk, markerstrokewidth=1, markersize=2)

  	# Slope range
  	ds = 0.1*xmax

  	# Average
  	ave = f(ns*dx)./ns

    # Average variable
    avev = (f(ns*dx) - F)./ns

    # Average fixed
    avef = F./ns

	# Total-marginal slivers
  	if showslv
      for i = 0:ns-1
          if f((i+1)*dx) > f(i*dx)
              clr = :blue
          else
              clr = :orange
          end
            
            # Total-marginal slivers
          if (showtot | showmrgc) & showtrn
              plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx], 
                  w.*(dt .+ [f(i*dx), f(i*dx), f((i+1)*dx), f((i+1)*dx), f(i*dx)])
               .+ (1-w).*sf.*[0, 0, f((i+1)*dx)-f(i*dx), f((i+1)*dx)-f(i*dx), 0],
                  linecolor=:black, linestyle=:solid, linewidth=1,
                  fill=true, fillcolor=clr, fillalpha=0.1)
          end
          if showtot & !showtrn
              plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx], 
                  dt .+ [f(i*dx), f(i*dx), f((i+1)*dx), f((i+1)*dx), f(i*dx)],
                  linecolor=:black, linestyle=:solid, linewidth=1,
                  fill=true, fillcolor=clr, fillalpha=0.1)
          end
          if showmrgc & !showtrn
              plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx], 
                  sf.*[0, 0, f((i+1)*dx)-f(i*dx), f((i+1)*dx)-f(i*dx), 0],
                  linecolor=:black, linestyle=:solid, linewidth=1,
                  fill=true, fillcolor=clr, fillalpha=0.1)
          end

          # Average slivers
  		  if showavev && !showtrn
                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                dt .+ F .+ [i*avev, i*avev, (i+1)*avev, (i+1)*avev, i*avev],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:red, fillalpha=0.1)

                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                sf.*[0, 0, avev, avev, 0],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:red, fillalpha=0.1)
          end
		  if showavef && !showtrn
                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                dt .+ [i*avef, i*avef, (i+1)*avef, (i+1)*avef, i*avef],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:blue, fillalpha=0.1)

                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                sf.*[0, 0, avef, avef, 0],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:blue, fillalpha=0.1)
          end
		  if showave && showtrn
                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                w.*(dt .+ [i*ave, i*ave, (i+1)*ave, (i+1)*ave, i*ave])
                .+ (1-w).*sf.*[0, 0, ave, ave, 0],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:limegreen, fillalpha=0.1)
          end
          if showave && !showtrn
                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                dt .+ [i*ave, i*ave, (i+1)*ave, (i+1)*ave, i*ave],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:limegreen, fillalpha=0.1)

                plot!([i*dx, (i+1)*dx, (i+1)*dx, i*dx, i*dx],
                sf.*[0, 0, ave, ave, 0],
                linecolor=:black, linestyle=:solid, linewidth=1,
                fill=true, fillcolor=:limegreen, fillalpha=0.1)
          end

      end

  	end # if showlsv
	
	# Total-space axes
	plot!([-xe, 1.05*xmax],[dt, dt],
		linecolor=:black, linestyle=:solid, linewidth=1)
	for i = 0:2:24
		plot!([i, i],[dt, dt-ye],
		linecolor=:black, linestyle=:solid, linewidth=1)
		annotate!(i,dt-ye,text(L"%$(i)", :top, :middle, 12))
	end
	plot!([0,0],[dt-ye, dt+ymax+2*ye],
		linecolor=:black, linestyle=:solid, linewidth=1)
	for j = 0:2:ymax
		plot!([-xe, 0],[dt+j, dt+j],
		linecolor=:black, linestyle=:solid, linewidth=1)
		annotate!(-2*xe, dt+j, text(L"%$(Int(j))", :middle, :right, 12))
	end

	# Total-space baseline curve
    plot!(xVec, f.(xVec) .+ dt, 
		linecolor=:lightgray, linestyle=:solid, linewidth=4)
		if fun == "ProductionLe"
			xtl = 0.75*xmax
			ytl = f(xtl)+3*ye
			annotate!(xtl, dt + ytl, 
				text("TP", "Times Bold", :bottom, :center, 14))
		elseif fun == "ProductionLn"
			xtl = 0.75*xmax
			ytl = f(xtl)+5*ye
			annotate!(xtl, dt + ytl, 
				text("TP", "Times Bold", :bottom, :center, 14))
		elseif fun == "Revenues"
			xtl = 0.75*xmax
			ytl = f(xtl)+8*ye
			annotate!(xtl, dt + ytl, 
				text("TR", "Times Bold", :top, :center, 14))	
		elseif fun == "CostsF0"
			xtl = 0.8*xmax
			ytl = f(xtl)-8*ye
			annotate!(xtl, dt + ytl, 
				text("TC", "Times Bold", :top, :center, 14))
		elseif fun == "CostsFp"
			xtl = 0.8*xmax
			ytl = f(xtl)-7*ye
			annotate!(xtl, dt + ytl, 
				text("TC", "Times Bold", :top, :center, 14))
		end

	# Total-space slopes
  	if showslp
      if showave
          plot!([ns*dx-ds, ns*dx+ds], dt .+ 0.1*xe .+ 
		        [f(ns*dx), f(ns*dx)],
		          linecolor=:limegreen, linestyle=:dash, linewidth=1)
          plot!([ns*dx-ds, ns*dx+ds], dt .+ 
		        [f(ns*dx)-f(ns*dx)/(ns*dx)*ds, f(ns*dx)+f(ns*dx)/(ns*dx)*ds],
		          linecolor=:limegreen, linestyle=:solid, linewidth=1)
          if ns > 0
              aslp = f(ns*dx)/(ns*dx)
          else
              aslp = fp(0)
          end
          ax, ay = Plots.unzip(Plots.partialcircle(0, atan(aslp), 30, 0.6*ds))
          plot!(ns*dx .+ ax, dt .+ f(ns*dx) .+ ay,
              linecolor=:limegreen, linestyle=:solid, linewidth=1)
      end
      if showtot
          plot!([ns*dx-ds, ns*dx+ds], dt .- 0.1*xe .+ [f(ns*dx), f(ns*dx)],
		          linecolor=:black, linestyle=:dash, linewidth=1)
          plot!([ns*dx-ds, ns*dx+ds], 
			    dt .+ [f(ns*dx)-fp(ns*dx)*ds, 	f(ns*dx)+fp(ns*dx)*ds],
		          linecolor=:black, linestyle=:solid, linewidth=1)
          mx, my = Plots.unzip(Plots.partialcircle(0, atan(fp(ns*dx)), 30, 0.5*ds))
          plot!(ns*dx .+ mx, dt .+ f(ns*dx) .+ my,
              linecolor=:black, linestyle=:solid, linewidth=1)
      end
  	end

	# Total-space incremental curve
	plot!(xVecns, f.(xVecns) .+ dt, 
		linecolor=:black, linestyle=:solid, linewidth=4)
	
		# Dot
		scatter!([ns*dx], [f.(ns*dx)] .+ dt, 
			markercolor=:white, markerstrokecolor=:black, markerstrokewidth=1, markersize=8)
	if showave
		plot!([0, ns*dx], [0, f.(ns*dx)] .+ dt,
		linecolor=:limegreen, linestyle=:dash, linewidth=2)

	end
	if showavev
		plot!([0, ns*dx], [F, f.(ns*dx)] .+ dt,
		linecolor=:red, linestyle=:dash, linewidth=2)

	end
	if showavef
        plot!([0, xmax], [F, F] .+ dt,
		    linecolor=:black, linestyle=:dash, linewidth=1)
		plot!([0, ns*dx], [0, F] .+ dt,
		    linecolor=:blue, linestyle=:dash, linewidth=2)

		# Dot
		scatter!([ns*dx], [F] .+ dt, 
			markercolor=:white, markerstrokecolor=:blue, markerstrokewidth=1, markersize=8)
	end

	# Marginal-space axes
	plot!([-xe, 1.05*xmax],[0,0],
		linecolor=:black, linestyle=:solid, linewidth=1)
	for i = 0:2:xmax
		plot!([i,i],[0,-ye],
		linecolor=:black, linestyle=:solid, linewidth=1)
		annotate!(i, -ye, text(L"%$(i)", :top, :middle, 12))
	end
	
	plot!([0,0], [ymin-2*ye, sf.*ytickVec[end]+2*ye],
		linecolor=:black, linestyle=:solid, linewidth=1)
	for j = ytickVec
		plot!([-xe,0], sf .* [j,j],
		linecolor=:black, linestyle=:solid, linewidth=1)
		annotate!(-2*xe, sf .* j, text(L"%$(j)", :middle, :right, 12))
	end

  	if showmrgc
     	# Marginal/average space marginal curves
        plot!(xVec, sf .* fp.(xVec).*dx, 
        	linecolor=:lightgray, linestyle=:solid, linewidth=4)
		if fun == "ProductionLe"
			xml = 0.75*xmax
			yml = sf.* fp(xml)*dx + 3*ye
			annotate!(xml, yml, 
				text("MP", "Times Bold", :bottom, :center, 14))
		elseif fun == "ProductionLn"
			xml = 0.75*xmax
			yml = sf.* fp(xml)*dx + 3*ye
			annotate!(xml, yml, 
				text("MP", "Times Bold", :bottom, :center, 14))	
		elseif fun == "Revenues"
			xml = 0.75*xmax
			yml = sf.* fp(xml)*dx - 4*ye
			annotate!(xml, yml, 
				text("MR", "Times Bold", :top, :center, 14))	
		elseif fun == "CostsF0" || fun == "CostsFp"
			xml = 0.8*xmax
			yml = sf.* fp(xml)*dx + 3*ye
			annotate!(xml, yml, 
				text("MC", "Times Bold", :bottom, :center, 14))
		end
     	plot!(xVecns, sf .* fp.(xVecns).*dx, 
     	   linecolor=:black, linestyle=:solid, linewidth=4)

		# Dot
		scatter!([ns.*dx], sf .* [fp.(ns.*dx)], 
			markercolor=:white, markerstrokecolor=:black, 
			markerstrokewidth=1, markersize=8)
  	end

	if showavec
		# Marginal-average space average curves
	    afVec = f.(xVec)./xVec
	    afVec[afVec .> max(2*fpmax,f(1))] .= NaN
        plot!(xVec, sf .* afVec, 
            linecolor=:limegreen, linestyle=:solid, linewidth=4,
            linealpha=0.2)
		if fun == "ProductionLe"
			xal = 0.75*xmax
			yal = sf .* f(xal)/xal + 3*ye
			annotate!(xal, yal, 
				text("AP", "Times Bold", :limegreen, :bottom, :center, 14))
		elseif fun == "ProductionLn"
			xal = 0.75*xmax
			yal = sf .* f(xal)/xal + 3*ye
			annotate!(xal, yal, 
				text("AP", "Times Bold", :limegreen, :bottom, :center, 14))
		elseif fun == "Revenues"
			xal = 0.75*xmax
			yal = sf .* f(xal)/xal + 3*ye
			annotate!(xal, yal, 
				text("AR", "Times Bold", :limegreen, :bottom, :center, 14))
		elseif fun == "CostsF0"
			xal = xmax+xe
			yal = sf .* f(xal)/xal
			annotate!(xal, yal, 
				text("AC", "Times Bold", :limegreen, :center, :left, 14))
		elseif fun == "CostsFp"
	    	xal = 0.15*xmax
			yal = sf .* f(xal)/xal + 2*ye
			annotate!(xal, yal, 
				text("AC", "Times Bold", :limegreen, :bottom, :left, 14))
		end
	    afVecns = f.(xVecns)./xVecns
	    afVecns[afVecns .> max(2*fpmax,f(1))] .= NaN
        plot!(xVecns, sf .* afVecns, 
            linecolor=:limegreen, linestyle=:solid, linewidth=4)

      # Dot
      scatter!([ns.*dx], sf .* [ave], 
          markercolor=:white, markerstrokecolor=:limegreen, 
		  markerstrokewidth=1, markersize=8)
	end

	if showavev
		# Marginal-average space average variable curve
        afvVec = (f.(xVec) .- F)./xVec
	    afvVec[afvVec .> max(2*fpmax,f(1))] .= NaN
        plot!(xVec, sf .* afvVec, 
            linecolor=:red, linestyle=:solid, linewidth=4,
            linealpha=0.2)
		if fun == "ProductionLn"
			xal = 0.32*xmax
			yal = sf .* (f(xal) - F)/xal + 3*ye
			annotate!(xal, yal, 
				text("AVP", "Times Bold", :red, :bottom, :center, 14))
		elseif fun == "CostsFp"
	    	xal = 0.15*xmax
			yal = sf .* f(xal)/xal + 2*ye
			annotate!(xal, yal, 
				text("AC", "Times Bold", :limegreen, :bottom, :left, 14))
		end
        afvVecns = (f.(xVecns) .- F)./xVecns
	    afvVecns[afvVecns .> max(2*fpmax,f(1))] .= NaN
        plot!(xVecns, sf .* afvVecns, 
            linecolor=:red, linestyle=:solid, linewidth=4)

      # Dot
      scatter!([ns.*dx], sf .* [avev], 
          markercolor=:white, markerstrokecolor=:red, 
		  markerstrokewidth=1, markersize=8)
	end

	if showavef
		# Marginal-average space average fixed curve
        affVec = F./xVec
	    affVec[affVec .> max(2*fpmax,f(1))] .= NaN
        plot!(xVec, sf .* affVec, 
            linecolor=:blue, linestyle=:solid, linewidth=4,
            linealpha=0.2)
		if fun == "ProductionLn"
			xal = 0.10*xmax
			yal = sf .* F/xal - 5*ye
			annotate!(xal, yal, 
				text("AFP", "Times Bold", :blue, :bottom, :right, 14))
		elseif fun == "CostsFp"
	    	xal = 0.15*xmax
			yal = sf .* f(xal)/xal + 2*ye
			annotate!(xal, yal, 
				text("AC", "Times Bold", :limegreen, :bottom, :left, 14))
		end
        affVecns = F./xVecns
	    affVecns[affVecns .> max(2*fpmax,f(1))] .= NaN
        plot!(xVecns, sf .* affVecns, 
            linecolor=:blue, linestyle=:solid, linewidth=4)

      # Dot
      scatter!([ns.*dx], sf .* [avef], 
          markercolor=:white, markerstrokecolor=:blue, 
		  markerstrokewidth=1, markersize=8)
	end

	   #=
    # Axis limits
    xlims!(0, 1.01*xVec[end])
    ylims!(0, 1.2*maximum(f.(xVec)))
    
    # Curves
    plot!(xVec, f.(xVec), linecolor=:black, linestyle=:solid, linewidth=2)

    # Axis ticks
    xticks!([0.001, xstar], [L"0", L"x^*"])
    yticks!([0.001, f(0), f(xstar)], [L"0", L"f(0)", L"f(x^*)"])

    # Axis labels
    annotate!(1.02*xlims(pX)[2], 0, text(L"x", :left, :middle, 12))
    annotate!(0, 1.01*ylims(pX)[2], text(L"y", :center, :bottom, 12))
  
    # Curve labels
    flx = 1.5*xstar
    fly = 1.01*f(flx)
    annotate!(flx, fly, text(L"f(x)", :left, :bottom, 12))

    # Key points, with dashed lines to them
    plot!([xstar,xstar], [0,f(xstar)], linecolor=:black, linestyle=:dash) 
    plot!([0,xstar], [f(xstar),f(xstar)], linecolor=:black, linestyle=:dash)
    scatter!([xstar], [f(xstar)], markercolor=:black, markersize=5)
    =#

   p2	
end

# ╔═╡ 48904c03-d9b1-4b8f-be12-049589ecf33e
fun

# ╔═╡ 18f4c187-8449-48ba-9768-2c320384d86b
showave

# ╔═╡ 75f1bf3f-55a0-4b8d-9614-ab4eaf0a45c8
showavev

# ╔═╡ 34ddc308-2c78-40de-becb-e7f938cc3526
showavef

# ╔═╡ Cell order:
# ╠═33cb76e6-46a3-11ef-10cc-db2d93867b43
# ╟─09dc6914-07ca-4485-990c-0ccad4bbdf8d
# ╠═e5821f80-82c1-49dd-91a8-7d8572aea212
# ╠═11c6a51f-be7c-43fd-bf05-bad0d87cc765
# ╠═44b185ed-9a1b-4e18-bfa4-ac1ee40b9c30
# ╠═b14f91cf-ec1b-401b-a0eb-96d2a2d3a9be
# ╟─66ec14b4-db61-4b60-9c36-587c5e7047bb
# ╠═39139079-a390-4217-af7a-2714d17ffc82
# ╠═2db589f5-3814-4d20-9393-6e8452e52c67
# ╠═022c9245-80ad-4ca6-b760-8e5eab11bd05
# ╠═c2763124-9ed3-4680-a67d-44d9c90917b6
# ╟─ce453afb-97c8-4a26-b0d0-869851dbcfd1
# ╠═28a9b342-855d-4c6b-bff0-81f7358c842c
# ╟─8ca5c432-d666-45d8-af03-8f5f9cdc97dc
# ╠═e20f9e0d-f368-44b7-b961-29125c831384
# ╟─53cad01d-cc39-4431-bae5-93a64c0ae286
# ╠═df98589b-ab0e-4414-8af4-8f2204450364
# ╟─73392f6f-db95-47e4-a4ee-e9b0e6bcccae
# ╠═cf78b0e8-845b-4b34-98a6-8af82e04964b
# ╟─dbe25d8d-0b66-4daa-a57a-ab6d3d45af4e
# ╟─4562864d-b95f-4577-a3ab-7f55f223a90e
# ╟─962c3ce5-914f-42ba-80d8-a5ba4579e9e6
# ╟─7580a314-5872-41b4-9108-0badc474fc7d
# ╟─edc23311-b868-4c7f-874c-b3c4d052d5af
# ╟─eb5b3814-f2c2-493d-b896-672902477074
# ╟─a8ff2aac-4249-42db-b317-b61defe68aa3
# ╟─2ce50ae8-bd72-4b0e-a032-42e99e09a739
# ╟─5d366646-b2a7-4dbb-b26d-e2550204a818
# ╠═6cd54c92-815e-470d-ad70-170c05b439ad
# ╟─3c71348e-ec53-4645-bd1c-c890b7c97a3c
# ╠═898661ff-3c11-40d9-9e04-e06cef4fce82
# ╠═48904c03-d9b1-4b8f-be12-049589ecf33e
# ╠═18f4c187-8449-48ba-9768-2c320384d86b
# ╠═75f1bf3f-55a0-4b8d-9614-ab4eaf0a45c8
# ╠═34ddc308-2c78-40de-becb-e7f938cc3526
