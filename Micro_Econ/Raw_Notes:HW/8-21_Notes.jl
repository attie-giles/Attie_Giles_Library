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

# ╔═╡ 94b8ef14-5e82-11ef-3e88-7179b5375a05
begin  
    import Pkg   
    Pkg.activate()  
    
	#using JuMP      # set up a model
	#using Ipopt     # find a max or min
	using Roots    # solve a single equation
	#using NLsolve  # solve multiple equations
	#using ForwardDiff # differentiate a function
	#using QuadGK   # integrate a function
	using Plots     # plot graphs
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
end

# ╔═╡ c131cd1e-d269-4df4-910b-83918c020172
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4, aside=true)

# ╔═╡ ab57ac6b-53ff-448b-988b-56ddcdc2ea75
md"""
# 8-21 Notes/HW
"""

# ╔═╡ 188fc659-76be-4905-a87f-7804d5c2428a
md"""
## Solving for the price at when a particular quantity is demanded
"""

# ╔═╡ 52b2e676-b666-40ba-a5a3-dfc7c4fe1bba
md"""
### Case with linear demand
"""

# ╔═╡ 155b1732-526f-4136-91fd-2c2e6d060f97
Pmin = 0

# ╔═╡ efd8534e-f2ec-486e-8dc4-0736d064be2a
Pmax = 100

# ╔═╡ 1fa602bf-ae6a-49f1-b9da-83f32d912b55
pvec = collect(range(Pmin, Pmax, length=101))

# ╔═╡ 70156498-95f2-46ee-a663-759ac104d398
md"""
### Numerical Solution using a 'While' Loop
"""

# ╔═╡ e71594e7-be1c-4a09-928b-312d52816a0b
Qd_l(p) = 24 - 0.4*p;

# ╔═╡ 4bac54e7-0be6-4306-8b74-f4c93e580225
Qt = @bind Qt Slider(0.0:0.1:50, default=16, show_value=true)

# ╔═╡ 692f96cc-93f9-47cf-ba12-db967d32dbdf
begin
    pQd_l = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Linear Deamand"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #yticks=0:5:25,
    )


    # Curves
    plot!(Qd_l.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis labels
    annotate!(1.222*xlims(pQd_l)[2], 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.05*ylims(pQd_l)[2], text(L"P", :center, :bottom, 12))

	 # Key points, with dashed lines to them
    plot!([Qd_l(Qt),Qd_l(Qt)], [0,Qt], linecolor=:black, linestyle=:dash) 
    plot!([0,Qd_l(Qt)], [Qt,Qt], linecolor=:black, linestyle=:dash)
    scatter!([Qd_l(Qt)], [Qt], markercolor=:black, markersize=5)
	
	# Axis limits
    xlims!(0, 1.2*maximum(Qd_l.(pvec)))
    ylims!(0, 1.05*pvec[end])

	 # Axis ticks
    xticks!([0.001, Qd_l(Qt)], [L"0", L"Q^*"])
    yticks!([0.001, Qt], [L"0", L"P^*"])
	
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

   pQd_l
end

# ╔═╡ 7331692a-2cc7-431e-91c5-38179a1c1929
function hw2()
#note I could not run his 'While' function, so this is my own for function
#Parse the quantity demanded to get a nymber
QD = Qt
#Initialize the price
price=0
	for p1 = Pmin : .0001 : Pmax
		Q = Qd_l(p1)
			if .999*QD<Q<1.001*QD
				break
			end
				price=p1
	end
	md" $QD Quantity Demanded gives price \$$(round(price, digits=2))"
end;

# ╔═╡ 1b8fe2a1-9ef8-4370-a9d9-62238ea71002
hw2()

# ╔═╡ 8232cf74-a0d6-481a-8603-300b3c67f1f0
Qd_l(Qt)

# ╔═╡ 4fa1ac7a-9e09-49be-a4d3-9894011d7a70
md"""
### Case with non-linear demand
"""

# ╔═╡ 429cfee7-0b1e-4d67-8e71-35f7ac55de8d
md"""
### Numerically using find zero
"""

# ╔═╡ 05f96d6e-1449-43ff-9a25-b36afb20170d
p₀= 14

# ╔═╡ 3495e3ad-bb98-4102-aa27-c52f8278ba39
md"""
### Case with Nonlinear Demand

Add a Supply function
"""

# ╔═╡ f4f34334-40ad-4da3-bdcb-29f4c4afd5ce
Qd(p) = 24*exp(-0.02*p) - 0.1*p

# ╔═╡ 541778d5-dc75-4e84-8ec5-45f84382f17f
zero_cond(p)=Qd(p)-Qt;

# ╔═╡ ab263b73-4489-4a1e-98f3-8126c6fc4538
psol2 = find_zero(zero_cond, p₀)

# ╔═╡ 308049c0-f707-416e-88b4-803fbad8d5a2
begin
    pqd = plot(
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
    
     plot!(Qd.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis labels
    annotate!(1.02*xlims(pqd)[2], 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.01*ylims(pqd)[2], text(L"P", :center, :bottom, 12))
	# Key points, with dashed lines to them
    plot!([Qt,Qt], [0,psol2], linecolor=:black, linestyle=:dash) 
    plot!([0,Qt], [psol2,psol2], linecolor=:black, linestyle=:dash)
	scatter!([Qt], [psol2], markercolor=:black, markersize=5)
	
	# Axis ticks
   # xticks!([0, Qt], [L"0", L"Q^t=16"])
    #yticks!([0, psol2], [L"0", L"p \approx 15.6"])

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

   pqd
end

# ╔═╡ a30a25ca-0253-440b-bc36-efae06c2e3a5
Qd(psol2)

# ╔═╡ ca2621f1-96eb-4443-ab70-d34b9d438216
Qs(p) = -3 +0.6*p

# ╔═╡ 8f8b7032-331c-480d-b307-0f1ec42f3adc
zero_cond2(p) = Qd(p)-Qs(p)

# ╔═╡ d42bf701-50f9-4ab1-af07-b4804951d763
psol4 = find_zero(zero_cond2,p₀)

# ╔═╡ db4e212d-61da-40a8-ba5b-1e063f0f613c
Qs.(pvec)

# ╔═╡ 86cb1be4-6db2-435b-b214-0a49b0ef2552
Qsvec=Qs.(pvec)

# ╔═╡ 8706af80-7b92-498c-b1ad-b0fd19eadb8f
Qsvec[Qsvec.<0] .= NaN

# ╔═╡ 0c6871b0-2c1e-4f07-b3e8-f97eb7285a6c
begin
    psd = plot(
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
    plot!(Qd.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Qsvec, pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	# Axis labels
    annotate!(26, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 120, text(L"P", :center, :bottom, 12))

	 # Key points, with dashed lines to them
    plot!([Qd(psol4),Qd(psol4)], [0,psol4], linecolor=:black, linestyle=:dash) 
    plot!([0,Qd(psol4)], [psol4,psol4], linecolor=:black, linestyle=:dash)
    scatter!([Qd(psol4)], [psol4], markercolor=:black, markersize=5)

	 # Curve labels
    flx = .14*Qd(psol4)
    fly = 2.3*psol4
    annotate!(flx, fly, text(L"Demand", :left, :bottom, 12))

	 # Curve labels
    flx = 2*Qd(psol4)
    fly = 2*psol4
    annotate!(flx, fly, text(L"Supply", :left, :bottom, 12))

	 # Axis limits
    xlims!(0, 1.05*maximum(Qd.(pvec)))
	ylims!(0, 1.2*pvec[end])
	
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

   psd
end

# ╔═╡ 130ad6d2-6448-411e-95e9-c707af3bc0cf
md"""
### Mathematical Solution
"""

# ╔═╡ f3efdbc7-258c-4bd7-9b9c-4b40268fe7cb
zero_cond1(p)=Qd(p)-Qs(p)

# ╔═╡ 7815bcdc-0523-424f-8876-0310a13155a2
p₀1 = 20

# ╔═╡ 8696968c-f1e7-441a-83a7-89e796e8cd9d
psol3 = find_zero(zero_cond1, p₀1)

# ╔═╡ f0ecd1a0-98e5-4eb1-9c37-a6a44e20a9b1
md"""
# Hw Questions
"""

# ╔═╡ 3e649ce3-a187-42ec-ad3a-b87e9a1c7029
md"""
## Solving for Equilibrium Price and output as a function of income
"""

# ╔═╡ 88c1813f-d083-462f-a724-6c3f340004c5
Ymin = 4

# ╔═╡ d1624491-f911-411d-ae5b-e7133033d420
Ymax = 24

# ╔═╡ a7b19086-9afa-4c84-acc8-bf9e4087029b
Yvec = collect(range(Ymin, Ymax, length=100))

# ╔═╡ 09c3adc5-c321-42c2-9981-089beba53a12
Qd_Ymin(p) = 6*exp(-0.02*p) - 0.3*p + Ymin

# ╔═╡ 410d923f-7e28-44b4-bdd8-40971a46737a
Qd_Ymax(p) = 6*exp(-0.02*p) - 0.3*p + Ymax

# ╔═╡ de8dc0e3-e28a-4450-bf14-fe3657c606b9
Qs1(p) = -3 +0.6*p;

# ╔═╡ 198987f3-ed13-4155-a253-3c71f05b3394
Y1(p) = Qs1(p) - 6*exp(-0.02*p) + 0.3*p;

# ╔═╡ 6916d833-d84b-4716-8eaf-b503182771c1
Qmax = 33.41

# ╔═╡ 9ce839e4-cbc3-46bf-b803-f8ed7fc111a9
Qmin = 12.92

# ╔═╡ 3ac50cc3-e5ff-4eea-91fa-0f9ccaff532b
Qvec = collect(range(Qmin, Qmax, length=101))

# ╔═╡ a6f944d9-3a6c-46b7-bdde-04bc267dcd42
md"""
 Generate
* a (Q,p)-space supply-demand graph that shows demand shifting in and out when you move a Y slider
* a (Y,p)-space graph that plots equilibrium price against a range of incomes from Ymin = 4 to Ymax = 24
* a (Y,Q)-space graph that plots equilibrium quantity against that same income range
"""

# ╔═╡ ba51a0e4-7a65-4a7f-beb8-69de9e7b1e47
md"""
* Q: Quantity
* p: Price
* Y:Income
"""

# ╔═╡ 74e417ed-59e8-4ac4-a69b-cf370f6da588
Y = @bind Y Slider(Ymin:.1:Ymax, default=10, show_value=true)

# ╔═╡ 5ec3896e-0486-4d64-8049-5eb1d0ca9332
Qd_Y(p) = 6*exp(-0.02*p) - 0.3*p + Y;

# ╔═╡ bb34b442-9098-4037-a099-3fd8b1d7c7bf
zero_cond3(p) = Qd_Y(p)-Y;

# ╔═╡ 8f500b24-5687-4c8b-9764-c49f95ee42bc
QYsolve = find_zero(zero_cond3,p₀1)

# ╔═╡ 020840ff-6174-4c76-a69e-2c56e4420d7e
zero_cond4(p) = Qd_Y(p) - Qs1(p);

# ╔═╡ a6ab75b3-0c46-4942-8899-251dfef9f5fb
Qsolve = find_zero(zero_cond4, p₀1)

# ╔═╡ a2456744-80be-4aa3-96b8-f1fe155e4d1b
md"""
### Question 1
"""

# ╔═╡ 50a6be58-d7f6-4661-9f17-96791a364db7
begin
    pQd_Y = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Supply and Demand Graph"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
   # yticks=0:5:25,
    )
    
    # Curves
    plot!(Qd_Y.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(Qs1.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)
	
	# Axis labels
    annotate!(31, 0, text(L"Q", :left, :center, 12))
    annotate!(0, 30, text(L"P", :center, :bottom, 12))
	
	# Key points, with dashed lines to them
    plot!([Qs1(Qsolve),Qs1(Qsolve)], [0,Qsolve], linecolor=:black, linestyle=:dash) 
    plot!([0,Qs1(Qsolve)], [Qsolve,Qsolve], linecolor=:black, linestyle=:dash)
    scatter!([Qs1(Qsolve)], [Qsolve], markercolor=:black, markersize=5)

	
	# Axis limits
    xlims!(0, 30)
    ylims!(0, 30)

	# Axis ticks
  #  xticks!([0.001, Qs1(Qsolve)], [L"0", L"Q^*"])
   # yticks!([0.001, 0, Qsolve], [L"0", L"0", L"P^*"])
	
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

   pQd_Y	
end

# ╔═╡ 03c1e6e5-a5e2-4892-82bd-5136a4146f58
md"""
### Question 2
"""

# ╔═╡ d151a4cb-1f17-486c-b294-d936d09c6cac
begin
    YPplot = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Equilibrium Price Graph"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(Y1.(pvec), pvec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis labels
    annotate!(31, 0, text(L"Y", :left, :center, 12))
    annotate!(0, 30, text(L"P", :center, :bottom, 12))

	# Axis limits
    xlims!(0, 30)
    ylims!(0, 30)
	
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

   YPplot
end

# ╔═╡ 6473bef6-c782-472b-8985-5c242715f1b2
md"""
Note: in the the next two classes notes there is a function to find the implicit function so that you don't have to solve it analytically then put it in
"""

# ╔═╡ 7fea20e7-09fc-45da-8bbb-6e9f4cff7950
md"""
### Question 3
"""

# ╔═╡ 8d060b27-ce79-4fcb-bd38-2623307399e7
begin
    YQplot = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Equilibrum Quantity Graph"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(Y1.(pvec), Qvec, linecolor=:black, linestyle=:solid, linewidth=2)

	 # Axis limits
    xlims!(0, 30)
    ylims!(0, 30)
	
	# Axis labels
    annotate!(30, 1, text(L"Y", :left, :center, 12))
    annotate!(0, 31, text(L"Q", :center, :bottom, 12))
	
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

   YQplot	
end

# ╔═╡ c02f3986-c132-4f1f-a5ea-8b5a9a4dfa76
md"""
### How do firms in perfectly competitve Industries choose their output level?

Firms in perfectly competitve industries, under the assumption that each firm manager is rational, will set their output levels to maximize Profit. This can be modeled under the following set of formulas.

$\begin{equation*}
  Profit = Revenue - Cost
\end{equation*}$

Revenue can be modeled under the average sale price of each good, multiplied by the total number of goods sold

$\begin{equation*}
  R = P*q
\end{equation*}$

Where $\begin{equation*}
  q
\end{equation*}$ is the total number of goods sold, and $\begin{equation*}
  P
\end{equation*}$ is the average sale price of each good.

Cost can be modeled as the average wage rate per employee multiplied by the total number of empleyees, plus the average cost it requires to manufacture each good multiplies by the total amount of good manufactured. 

$\begin{equation*}
  C = w̄*N_e + \alpha * q
\end{equation*}$

Where $\begin{equation*}
  w̄
\end{equation*}$ is the average wage rate for the employees, $\begin{equation*}
  Nₑ 
\end{equation*}$ is the total number of emplyees, $\begin{equation*}
  \alpha
\end{equation*}$ is the amount it costs to manufacture each good, and $\begin{equation*}
  q
\end{equation*}$ is the amount of goods manufactured. Combining these two equations into a profit equation gives 

$\begin{equation*}
  π = P*q -  w̄*N_e - \alpha * q
\end{equation*}$ 
where π is profit.

The perfectly rational manager in a perfeclty competitive economoy is going to set output so as to maximize prfoit which would be where there is the largest difference between total Revenues and total Cost.

"""

# ╔═╡ f548e4ec-351e-471e-94c5-b5a6b3d87476
P̄vec = collect(range(1, 100, length=100));

# ╔═╡ 57348667-1889-49ca-a51c-564e51993496
α = @bind α Slider(0.0:.001:.1, default=.05, show_value=true)

# ╔═╡ 4ba90fff-61e1-427b-aa7d-ef85f5c7968a
p = @bind p Slider(0.00:0.10:100, default=1.00, show_value=true)

# ╔═╡ d8d2eaac-d737-4139-9322-11182cc85711
R(q) = q * p;

# ╔═╡ 4d312fe9-5064-4c15-9bfc-aac66c3a0a84
qvec = collect(range(1, 100, length=101));

# ╔═╡ cfeb763f-e62d-4cf8-b252-346bdf23d1c9
c(q) =  exp(α*q) - 1;

# ╔═╡ a6602e61-af80-456e-b8b9-6c47f3e77828
π(q) = q * p - exp(α*q) + 1;

# ╔═╡ 11b5f42e-aff9-490b-8a5b-6b7c8be33bc5
md"""
Under the assumption that wages are negligible in this industry and that the main driver of costs is the amount to produce each good, we can use the function

$\begin{equation*}
  C(q) = ℯ^{α*q} -1 
\end{equation*}$

to model the costs for the firm to produce each good. Likewise the revenues of the firm can be modeled as 

$\begin{equation*}
  R(q) = q * P
\end{equation*}$

which gives a profit function of 

$\begin{equation*}
  π(q) = q * P - ℯ^{\alpha*q} +1 
\end{equation*}$

In this model the average sale price, which in a perfectly competitive industry would be set by the market is \$$(round(p, digits=2)). Below is a model of the total amount of Revenues and Costs for a given quantity produced and sold, assuming all that is produced is sold.
"""



# ╔═╡ ef73d8b4-9c6d-4a93-b11e-4b5a6308f8f6
begin
    totalspace = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Total Space"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(qvec, R.(qvec), linecolor=:black, linestyle=:solid, linewidth=2, label="Total Revenue")
	plot!(qvec, c.(qvec), linecolor=:blue, linestyle=:solid, linewidth=2, label="Total Cost")
	plot!(qvec, π.(qvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Total Profit")

	# Axis labels
    annotate!(1.05*xlims(totalspace)[2], 0, text(L"Q", :left, :center, 12))
    annotate!(0, 1.01*ylims(totalspace)[2], text(L"P", :center, :bottom, 12))
	
	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(R.(qvec)))
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

   totalspace
end

# ╔═╡ 27b0b409-261d-4569-b321-9ec8ccc8cc72
md"""
For the firm trying to maximuze product they are going to set output at the point where marginal revenues equalis marginal cost. 

$\begin{equation*}
  \frac{dR}{dq} = \frac{dC}{dq}
\end{equation*}$

The derivative of the Revenue function with respect to $\begin{equation*}
  q
\end{equation*}$ is 

$\begin{equation*}
  \frac{dR}{dq} = P 
\end{equation*}$

and the derivative of the Cost function with respect to $\begin{equation*}
  q
\end{equation*}$ is

$\begin{equation*}
  \frac{dC}{dq} = α*ℯ^{\alpha*q}
\end{equation*}$

modeling this below and setting them equal, will determine the optimal output of goods to produce. This gives a marginal Profit function of

$\begin{equation*}
  \frac{dπ}{dq} = P - \alpha*ℯ^{\alpha*q}
\end{equation*}$
"""

# ╔═╡ f4d787cd-8df7-400b-86b1-fd41aa7ac520
dR(q) = p;

# ╔═╡ 90b9256e-9d01-4dbe-a12a-e5686cf0d870
dC(q) = α*exp(α*q) ;

# ╔═╡ 9681fa1f-4ff5-40e3-9493-2cf89c30b1d2
dπ(q) = p - α*exp(α*q);

# ╔═╡ ea2e44c1-273f-44c5-9220-0c6cbea2c27d
zerocond5(q)= dR(q) - dC(q);

# ╔═╡ 585c0bf8-3493-4e54-811a-38b0eff3f42b
x = 5;

# ╔═╡ a7ebff3e-3bc4-4c73-8328-d05dbb746c08
rcsolve = find_zero(zerocond5, x);

# ╔═╡ 52f80517-ef9b-4157-93e8-79efaecc3b26
solution = round(rcsolve);

# ╔═╡ 0fe951ac-3792-466c-85a5-ca1f0100b991
begin
    marginalspace = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=true,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Marginal Space"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
	 plot!(qvec, dR.(qvec), linecolor=:black, linestyle=:solid, linewidth=2, label="Marginal Revenue")
 	plot!(qvec, dC.(qvec), linecolor=:blue, linestyle=:solid, linewidth=2, label="Marginal Cost")
	plot!(qvec, dπ.(qvec), linecolor=:red, linestyle=:solid, linewidth=2, label="Marginal Profit")
	
	# Key points, with dashed lines to them
    plot!([rcsolve,rcsolve], [0,dR(rcsolve)], linecolor=:black, linestyle=:dash,label="Equlibrium Quantity") 
    scatter!([rcsolve], [dR(rcsolve)], markercolor=:black, markersize=5, label="Equilibrium Point")

	# Axis limits
    xlims!(0, 1.05*qvec[end])
    ylims!(0, 1.2*maximum(dR.(qvec)))
	
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

   marginalspace
end

# ╔═╡ f37f05c0-6f93-4112-a484-c4ae8bce0ec3
md"""
Given that the revenue function has a constant slope and the cost function is exponential, the optimial amount of product to produce under these conditions is $solution
"""

# ╔═╡ dd96db43-a128-43c1-829a-b27a3cff9355
md"""
### Say yes to the mess
"""

# ╔═╡ 12cd510b-cb57-44ce-a596-25edfd452e8f
md"""
The method of saying yes to the mess is in it's essence the method of learning through the constant chaos of self-instruction, failure, experimentation, and finally little successes. The Plug and chug way can be seen as the way of very neatly and orderly copying what the teacher wrote in class, learning how to use certain methods to solve certain problems, but grasp no real understanding for the underlying structure. The yes to the mess way can be modeled as a type of exponetial graph that grows very slowly during the periods of failure and experimentation, but in the long run proves to be much more beneficial than the plug and chug method which has very real limits to growth. Modeling each, we say that the Yes to the Mess method is a type of exponetial equation,

$\begin{equation*}
  YestoMessKnowledge(effort) = ℯ^{\alpha*effort} -1 
\end{equation*}$

where $\begin{equation*}
  \alpha
\end{equation*}$ is the ease of learning parameter where a higher $\begin{equation*}
  \alpha
\end{equation*}$ means the subject is easier to learn. Compare that to the Plug and Chug method which can be modeled as a logarithmic model where the effort applied levels out over time because of a lack of understanding of the underlying structure.

$\begin{equation*}
  PlugandChugKnowledge(effort) = log(effort)
\end{equation*}$

As can be seen below, using these models, the Yes to the Mess model has a longer struggle period before high amounts of knowledge is gained, vs the plug and chug which receives knowledge early, but levels out even with more effort.
"""

# ╔═╡ aed4591f-ce04-4c38-b718-b1d164a3abc0
evec = collect(range(0, 150, length=200));

# ╔═╡ 5730a983-5236-430a-b62c-ad1c4c4aa2b4
plugandchug(e) = log(e);

# ╔═╡ 38242936-4db1-4590-8988-f4628ae84a75
α1 = @bind α1 Slider(0.0:0.01:0.1, default=0.05, show_value=true)

# ╔═╡ b4cc3b2d-8939-4d0e-86f1-2fc76d2c7317
yestomess(e) = exp(α1*e)-1;

# ╔═╡ 0fe73152-8cb8-42a2-b873-bf43f8f0f7d6
begin
    utility = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=:right,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title="Yes to Mess vs Plug and Chug",
	#xlabel!("Effort"),
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(evec, plugandchug.(evec), linecolor=:black, linestyle=:solid, linewidth=2, label="Plug and Chug")
	plot!(evec, yestomess.(evec), linecolor=:blue, linestyle=:solid, linewidth=2, label= "Yes to the Mess")
	
	# Axis limits
    xlims!(0, 2*evec[end])
    ylims!(0, 2*maximum(plugandchug.(evec)))

	 # Axis labels
    annotate!(1.01*xlims(utility)[2], .5, text(L"Effort", :left, :center, 10))
    annotate!(0, 1.01*ylims(utility)[2], text(L"Knowledge", :center, :bottom, 10))
	
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

   utility
end

# ╔═╡ 157ae0ba-b873-4223-a765-d28f6fc1deb3
md"""
### My Story
"""

# ╔═╡ 9c956984-89f8-4be5-a7b6-75ecb49494be
md"""
A financial firm is experiencing an odd trend of trades, their Revenue seems to be alternating according to an augmented set of sine and cosine waves, while their costs seem to falling with each trade because the number of traders they have at the firm is nearly constant. Where the total Revenue can be modeled as 

$\begin{equation*}
  R(q) = sin(q) +cos(q)*(q)
\end{equation*}$

where $\begin{equation*}
  q
\end{equation*}$ is the quantity produced. And the cost of producing the total quantity is 

$\begin{equation*}
  C(q) = log(q) +40
\end{equation*}$

So this firm is facing the problem of having a somewhat chaotic revenue patterns that seem to amplify with each new period and are wondering where to set output. If they decide to stop trading, investors in the company will leave and go elsewhere, but the managers get nervous when the market peaks and they begin to lose money.
"""

# ╔═╡ 32b9dc5a-1d4d-4b81-8608-fa3b7cec351f
Rfalling(q) = sin(q) + cos(q)*(q);

# ╔═╡ 57ad1ab3-4ead-496a-afe7-68f353a94563
Cfalling(q) = log(q)+40;

# ╔═╡ 66b3dcab-baa8-4572-b4fa-893345177fa3
πfalling(q) = sin(q) + cos(q)*(q) - log(q)-40;

# ╔═╡ 055e6211-9e86-46b7-b372-f8049ac79b44
begin
	falling = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=:top,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title= "Total Space"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(qvec, Rfalling.(pvec), linecolor=:black, linestyle=:solid, linewidth=2, label="Revenue")
	plot!(qvec, Cfalling.(pvec), linecolor=:blue, linestyle=:solid, linewidth=2,label="Cost")
	plot!(qvec, πfalling.(pvec), linecolor=:red, linestyle=:solid, linewidth=2,label="Profit")

	# Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(Rfalling.(pvec)))
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

	falling
end

# ╔═╡ aed55cca-821e-4c5a-9ca7-b8e220d964e5
dRfalling(q) = cos(q) + cos(q)-sin(q)*q;

# ╔═╡ b6368483-bb2d-493c-b14a-ba9d13aad284
dCfalling(q) = 1/q;

# ╔═╡ 69079d90-16a8-4b27-9b2a-643ba9c6ca1a
dπfalling(q) =  cos(q) + cos(q)-sin(q)*q - 1/q;

# ╔═╡ e14c9c6a-b4fd-4c9a-a497-65109c522a8a
begin
    dfalling = plot(
    tickdirection=:out,
    tickfontsize=12,
    tickfont=:Times,
    grid=false,
    legend=false,
    top_margin=18Plots.pt,
    right_margin=18Plots.pt,
    left_margin=12Plots.pt,
    widen=false,
	title = "Marginal Space"
    #widen=1.02,
    #framestyle = :origin,
    #aspect_ratio = :equal,
    #size=(800,1200),
    #xticks=0:5:25,
    #yticks=0:5:25,
    )
    
    # Curves
    plot!(pvec, dRfalling.(qvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(pvec, dCfalling.(qvec), linecolor=:blue, linestyle=:solid, linewidth=2)
    plot!(pvec, dπfalling.(qvec), linecolor=:red, linestyle=:solid, linewidth=2)

	# Axis limits
    xlims!(0, 1.05*pvec[end])
    ylims!(0, 1.2*maximum(dRfalling.(pvec)))
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

   dfalling	
end

# ╔═╡ a762dee7-2f0d-41b3-84b1-6a06bf15de78
md"""
In this model though it is tough to see the marginal profit is essentually equivalent to the marginal revenue, with marginal costs approaching zero. So under this circumstance it is rational for the company to continue to keep producing more and more product each time to try and regain that lost total profit.
"""

# ╔═╡ Cell order:
# ╠═94b8ef14-5e82-11ef-3e88-7179b5375a05
# ╠═c131cd1e-d269-4df4-910b-83918c020172
# ╟─ab57ac6b-53ff-448b-988b-56ddcdc2ea75
# ╟─188fc659-76be-4905-a87f-7804d5c2428a
# ╟─52b2e676-b666-40ba-a5a3-dfc7c4fe1bba
# ╠═155b1732-526f-4136-91fd-2c2e6d060f97
# ╠═efd8534e-f2ec-486e-8dc4-0736d064be2a
# ╠═1fa602bf-ae6a-49f1-b9da-83f32d912b55
# ╠═692f96cc-93f9-47cf-ba12-db967d32dbdf
# ╟─70156498-95f2-46ee-a663-759ac104d398
# ╠═e71594e7-be1c-4a09-928b-312d52816a0b
# ╠═4bac54e7-0be6-4306-8b74-f4c93e580225
# ╠═7331692a-2cc7-431e-91c5-38179a1c1929
# ╠═1b8fe2a1-9ef8-4370-a9d9-62238ea71002
# ╠═8232cf74-a0d6-481a-8603-300b3c67f1f0
# ╠═4fa1ac7a-9e09-49be-a4d3-9894011d7a70
# ╠═308049c0-f707-416e-88b4-803fbad8d5a2
# ╠═429cfee7-0b1e-4d67-8e71-35f7ac55de8d
# ╠═ab263b73-4489-4a1e-98f3-8126c6fc4538
# ╠═541778d5-dc75-4e84-8ec5-45f84382f17f
# ╠═05f96d6e-1449-43ff-9a25-b36afb20170d
# ╠═a30a25ca-0253-440b-bc36-efae06c2e3a5
# ╠═3495e3ad-bb98-4102-aa27-c52f8278ba39
# ╠═f4f34334-40ad-4da3-bdcb-29f4c4afd5ce
# ╠═ca2621f1-96eb-4443-ab70-d34b9d438216
# ╠═8f8b7032-331c-480d-b307-0f1ec42f3adc
# ╠═d42bf701-50f9-4ab1-af07-b4804951d763
# ╠═db4e212d-61da-40a8-ba5b-1e063f0f613c
# ╠═86cb1be4-6db2-435b-b214-0a49b0ef2552
# ╠═8706af80-7b92-498c-b1ad-b0fd19eadb8f
# ╟─0c6871b0-2c1e-4f07-b3e8-f97eb7285a6c
# ╠═130ad6d2-6448-411e-95e9-c707af3bc0cf
# ╠═f3efdbc7-258c-4bd7-9b9c-4b40268fe7cb
# ╠═bb34b442-9098-4037-a099-3fd8b1d7c7bf
# ╠═7815bcdc-0523-424f-8876-0310a13155a2
# ╠═8f500b24-5687-4c8b-9764-c49f95ee42bc
# ╠═8696968c-f1e7-441a-83a7-89e796e8cd9d
# ╠═f0ecd1a0-98e5-4eb1-9c37-a6a44e20a9b1
# ╟─3e649ce3-a187-42ec-ad3a-b87e9a1c7029
# ╠═88c1813f-d083-462f-a724-6c3f340004c5
# ╠═d1624491-f911-411d-ae5b-e7133033d420
# ╠═a7b19086-9afa-4c84-acc8-bf9e4087029b
# ╠═5ec3896e-0486-4d64-8049-5eb1d0ca9332
# ╠═09c3adc5-c321-42c2-9981-089beba53a12
# ╠═410d923f-7e28-44b4-bdd8-40971a46737a
# ╠═198987f3-ed13-4155-a253-3c71f05b3394
# ╠═de8dc0e3-e28a-4450-bf14-fe3657c606b9
# ╠═020840ff-6174-4c76-a69e-2c56e4420d7e
# ╠═a6ab75b3-0c46-4942-8899-251dfef9f5fb
# ╠═6916d833-d84b-4716-8eaf-b503182771c1
# ╠═9ce839e4-cbc3-46bf-b803-f8ed7fc111a9
# ╠═3ac50cc3-e5ff-4eea-91fa-0f9ccaff532b
# ╟─a6f944d9-3a6c-46b7-bdde-04bc267dcd42
# ╟─ba51a0e4-7a65-4a7f-beb8-69de9e7b1e47
# ╠═74e417ed-59e8-4ac4-a69b-cf370f6da588
# ╟─a2456744-80be-4aa3-96b8-f1fe155e4d1b
# ╠═50a6be58-d7f6-4661-9f17-96791a364db7
# ╟─03c1e6e5-a5e2-4892-82bd-5136a4146f58
# ╠═d151a4cb-1f17-486c-b294-d936d09c6cac
# ╠═6473bef6-c782-472b-8985-5c242715f1b2
# ╟─7fea20e7-09fc-45da-8bbb-6e9f4cff7950
# ╟─8d060b27-ce79-4fcb-bd38-2623307399e7
# ╟─c02f3986-c132-4f1f-a5ea-8b5a9a4dfa76
# ╠═f548e4ec-351e-471e-94c5-b5a6b3d87476
# ╠═d8d2eaac-d737-4139-9322-11182cc85711
# ╠═57348667-1889-49ca-a51c-564e51993496
# ╠═4ba90fff-61e1-427b-aa7d-ef85f5c7968a
# ╠═4d312fe9-5064-4c15-9bfc-aac66c3a0a84
# ╠═cfeb763f-e62d-4cf8-b252-346bdf23d1c9
# ╠═a6602e61-af80-456e-b8b9-6c47f3e77828
# ╟─11b5f42e-aff9-490b-8a5b-6b7c8be33bc5
# ╠═ef73d8b4-9c6d-4a93-b11e-4b5a6308f8f6
# ╠═27b0b409-261d-4569-b321-9ec8ccc8cc72
# ╠═f4d787cd-8df7-400b-86b1-fd41aa7ac520
# ╠═90b9256e-9d01-4dbe-a12a-e5686cf0d870
# ╠═9681fa1f-4ff5-40e3-9493-2cf89c30b1d2
# ╠═ea2e44c1-273f-44c5-9220-0c6cbea2c27d
# ╠═585c0bf8-3493-4e54-811a-38b0eff3f42b
# ╠═a7ebff3e-3bc4-4c73-8328-d05dbb746c08
# ╠═52f80517-ef9b-4157-93e8-79efaecc3b26
# ╟─0fe951ac-3792-466c-85a5-ca1f0100b991
# ╟─f37f05c0-6f93-4112-a484-c4ae8bce0ec3
# ╟─dd96db43-a128-43c1-829a-b27a3cff9355
# ╟─12cd510b-cb57-44ce-a596-25edfd452e8f
# ╠═aed4591f-ce04-4c38-b718-b1d164a3abc0
# ╠═5730a983-5236-430a-b62c-ad1c4c4aa2b4
# ╠═38242936-4db1-4590-8988-f4628ae84a75
# ╠═b4cc3b2d-8939-4d0e-86f1-2fc76d2c7317
# ╟─0fe73152-8cb8-42a2-b873-bf43f8f0f7d6
# ╟─157ae0ba-b873-4223-a765-d28f6fc1deb3
# ╟─9c956984-89f8-4be5-a7b6-75ecb49494be
# ╟─32b9dc5a-1d4d-4b81-8608-fa3b7cec351f
# ╟─57ad1ab3-4ead-496a-afe7-68f353a94563
# ╟─66b3dcab-baa8-4572-b4fa-893345177fa3
# ╟─055e6211-9e86-46b7-b372-f8049ac79b44
# ╟─aed55cca-821e-4c5a-9ca7-b8e220d964e5
# ╟─b6368483-bb2d-493c-b14a-ba9d13aad284
# ╟─69079d90-16a8-4b27-9b2a-643ba9c6ca1a
# ╟─e14c9c6a-b4fd-4c9a-a497-65109c522a8a
# ╟─a762dee7-2f0d-41b3-84b1-6a06bf15de78
