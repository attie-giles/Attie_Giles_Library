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

# ╔═╡ 75122120-e1cd-11ef-1cbe-81facddfa1a0
begin  
    import Pkg   
    Pkg.activate()  
    
	using JuMP      # set up a model
	using Ipopt     # find a max or min
	using Roots    # solve a single equation
	using NLsolve  # solve multiple equations
	using ForwardDiff # differentiate a function
	using QuadGK   # integrate a function
    using DynamicalSystems #dynamical systems
    using DifferentialEquations  
    #using Compiler
    #using Flux
    #using Turing  
   # using CairoMakie
	#using OrdinaryDiffEq
   # using  BenchmarkTools
	using Plots     # plot graphs
	using Images
	using PlutoUI   # use sliders, etc., in Pluto
	using LaTeXStrings # use LaTeX in graphs
    #using Printf #allows you to use sprintf
end

# ╔═╡ 28f4b5b9-1835-48c9-aac6-834673fcddb6
PlutoUI.TableOfContents(title="Sections", indent=true, depth=4,aside=true)

# ╔═╡ fee9d888-b6aa-4d23-85f9-c3d8bc67e2ff
md"""
# Optimal Control Thoery and Calculus of Variations
"""

# ╔═╡ 0542bfc1-06ee-4690-bd0f-a21f0a85d90a
md"""
## Review of Differential Equations
"""

# ╔═╡ bea00ffd-d299-4afb-b96a-7c4cb08a505a
md"""
In most scenarios, relevant data only caputes movements or changes in quantities. Rarely is there ever full data on the quantities. Differential equations link the values of variables at one instant in time to its values in other instants and include a derivative of the variable with respect to time. Solutions specify both the time paths of the variable and the steady state if they exist. Will focus on quantitative solutions, nature of approach paths, stability and valu of the steady states. 

Take the logistic growth equations

$\begin{align*}
y_{t+1}&=(1+r) y_t \\
\Leftrightarrow\quad \dfrac{y_{t+1}-y_t}{y_t} &= r
\end{align*}$
Same rule would apply for constant growth $r$ . If this equation specifies an interest accruement where instrerst is paid every $\Delta t$ then we have 

$\begin{align*}
\dfrac{y_{t+\Delta t}-y_t}{y_t} &= r \Delta t \\
\Leftrightarrow\quad \dfrac{y_{t+\Delta t}-y_t}{\Delta t} &= ry_t
\end{align*}$
This is the fundamental theorem of calculus. If the compounding is continuous $\Delta t \rightarrow 0$ then we can rewirte this as

$\begin{equation*}
\dfrac{\Delta y(t)}{\Delta t} \approx \dfrac{dy(t)}{dt}= \dot{y}(t) = ry(t)
\end{equation*}$
which is a differential equation.
 """

# ╔═╡ 2c21309c-1945-45ff-9f7a-dec5b72c682f
md"""
$\dot{y}(t)=ry(t)$ is an example of an ordinary differential equation, termed ordianry as it includes an ordinary derivative and not a partial one. 

Def 1: An ordinary Differential Equation gives the relationship between a function of one variable and its derivative. The solution is a function of one variable and its derivative. The solution is a function that satisfies the relationship 

$\begin{equation*}
\dot{y}(t)= f(y,t) 
\end{equation*}$
with $y$ being $y(t)$.

Def 2: If $y(t)$does explicitly involve $t$ the differential equation is autonomous 

Def 3: If $f(y,t)$ does not explicitly involve $t$ the differential equation is nonautonomous. 

Def 3: $\dot{y}(t)=f(y,t)$ is a first-order differential equation as it only has the first derivative of the unknown function $y(t)$. Differential equations that have derivatives up to and including the ith derivative are ith order differential equations.


 
"""

# ╔═╡ 715a891f-c125-4f26-b2ac-b0971437c755
md"""
## Single First-Order Differential Equations
"""

# ╔═╡ 17c71fdb-385f-4e4b-a298-1cf2370aac4e
md"""
This is a  case of a first-order differential equation

$\begin{equation*}
\dot{x}(t)+P(t)x(t)=Q(t)
\end{equation*}$
where $x(t)$ is the dependent variable. $P(t)$ and $Q(t)$ are independent variables that may vary over time and time is continuous and can be any real number. The time path of the dependent variable from any intitial instant in time, $t=0$, to some terminal instant, $t=T$, is given by the values of $x(t)$ on the time interval $t \in [0,T]$. 

The equation

$\begin{equation*}
\dot{x}(t)+P(t)x(t)=Q(t)
\end{equation*}$
is an example of an autonomous differential equation while 

$\begin{equation*}
\dot{x}(t)+P(t)x(t)=Q(t)+ \delta t
\end{equation*}$
is an example of a nonautonomous differential equation.

In the above examples the part included and interacting with the dependent variable , $P(t)x(t)$, is called homogenous and the part not interacting, $Q(t) \; \text{and}
\; Q(t)+\delta t$, is called nonhomogenous.


"""

# ╔═╡ cdbd7b23-6b6c-4ed7-8ccd-aed0713bb60b
md"""
## The Steady State
"""

# ╔═╡ 726b8976-1a51-47a0-a1ac-03911028c13e
md"""
Consider a base equation such as 

$\begin{equation*}
\dot{x}(t)+Px(t)=Q
\end{equation*}$
If a solution exists, it consists of a time path and (possibly) an equilibrium or steady state. If stationary we know 

$\begin{equation*}
\dot{x}(t)=0=-Px(t)+Q
\end{equation*}$
which has the steady state solution 

$\begin{equation*}
x^{ss} = Q/P.
\end{equation*}$
Solution to the Homogenous Equations

The solution to the nonhomogenous differential equation can be found by focusing on the homogenous part 

$\begin{align*}
\dot{x}(t)+Px(t)&=0 \\
\Leftrightarrow\quad \dot{x}(t)&=-Px(t).
\end{align*}$
This differential equation has no equilibrium other than $x=0$. This time path of $x(t)$ can be found several ways, but an intuitive appproach helps to build understanding. What we need is a function that when you take its derivative it returns itself multiplied by $-P$.

$\begin{align*}
x(t)&=e^{-Pt} \\
 \dot{x}(t)&= -Pe^{-Pt} = -Px(t).
\end{align*}$
Constants will have been ommitted, so we simply state that for any constant $K$, $x(t)=Ke^{-Pt}$ is a solution. This is called the general solution when it contains $K$.A definite solution has a value for the constant typically from knowing some boundary condition. For example

$\begin{equation*}
x(0)=x_0=Ke^{-P0}=K 
\end{equation*}$
so the definite solution is

$\begin{equation*}
x(t)=x_0e^{-Pt}
\end{equation*}$
If $P>0$ then as $t \rightarrow \infty, \; x(t) \rightarrow 0$. Similarly, if $P<0$ then as $t \rightarrow \infty, \; x(t) \rightarrow \infty$. 
"""

# ╔═╡ 9d22c3d8-4130-4522-ae2f-3f270d983572
md"""
## Solution to Equation with constant RHS
"""

# ╔═╡ d6109bd3-8898-4ed1-bbf7-7b6c02505e57
md"""

Take the differential equation of the form

$\begin{equation*}
\dot{x}(t)+Px(t)=Q
\end{equation*}$
then if we multiply through by an intergrating factor $e^{Pt}$ we get

$\begin{equation*}
\dot{x}(t) e^{Pt} +Px(t) e^{Pt}=Q e^{Pt}
\end{equation*}$
which can be rewritten as 

$\begin{equation*}
\dfrac{d}{dt}[e^{Pt}x(t)]=Q e^{Pt}
\end{equation*}$
we can then integrate both sides to get

$\begin{align*}
\int \dfrac{d}{dt}[e^{Pt}x(t)]dt &=\int Q e^{Pt} dt \\
e^{Pt}x(t) &= \dfrac{Q}{P} e^{Pt} + K \\
\Leftrightarrow\quad x(t) &= \dfrac{Q}{P} + Ke^{-Pt} .
\end{align*}$
Another example is the equation

$\begin{equation*}
\dot{x} + ax = b(t), \; x(0)=x_0
\end{equation*}$
where a is a constant, but now the LHS is a function of $t$. So we can muliply by the integrating factor $e^{at}$ 

$\begin{equation*}
\dot{x} e^{at} + ax e^{at} = b(t) e^{at}
\end{equation*}$
which can be rewritten at any time $\tau$

$\begin{equation*}
\dfrac{d}{d \tau }[e^{at}x(t)]= b(t) e^{at}
\end{equation*}$
we can then integrate both sides from $0 \; \text{to} \; t$.

$\begin{align*}
\int^t_0 \dfrac{d}{d \tau }[e^{at}x(t)] &= \int^t_0 b(t) e^{at} d\tau \\
e^{at}x(t) - x(0) &= \int^t_0 b(t) e^{at} d\tau \\
e^{at}x(t) &= x_0 + \int^t_0 b(t) e^{at} d\tau \\
x(t) &= e^{-at}x_0 + e^{-at} \int^t_0 b(t) e^{at} d\tau.
\end{align*}$


"""

# ╔═╡ 7ec69410-443f-48c8-a9a7-cccc4f589a5e
md"""
## Quantitative Solutions and Phase Diagrams
"""

# ╔═╡ 5a5fc1a2-c239-4500-916d-bdc67deab539
md"""
Phase diagrams can qualitatively solve differential equations in the single and multi-equation cases. In the single equation case, a qualitative solution is depicted by plotting the $\dot{x}(t)$ on the vertical axis and the $x(t)$ on the horizontal axis. Arrows are employed to show the direction of motion of $x(t)$ over time, and whether the equation is going to approach a steady state or not.
"""

# ╔═╡ 05c468e3-3ef7-43b0-bae9-4314e9c5a4cf
md"""
## Equilibrium Points and Stability
"""

# ╔═╡ b85d2faf-dc13-43d9-8491-82dea67ee5fb
md"""
For autonomous differential Equations of the form:

$\begin{equation*}
\dot{x}(t)=f(x(t))
\end{equation*}$
an equilibrium point $x^{ss}$ is a point that satisfies

$\begin{equation*}
\dot{x}(t)=f(x(t))=0
\end{equation*}$
such that is a solution starts at this point it remains there forever. Implying that if there is a small perturbation in $x$ away from $x^{ss}$ and the perturbation declines over time (toward zero) then $x^{ss}$ is said to be stable. Ifthe perturbation grows over time (away from zero) then $x^{ss}$ is said to be unstable.
"""

# ╔═╡ 2febee16-24e4-4f2c-9034-d2e87e9e8d12
md"""
## Equilibrium Points and Solutions
"""

# ╔═╡ ab4f0061-fdc5-4d4f-8412-8587fceb9398
md"""
For a linear differential equation of the form 

$\begin{equation*}
\dot{x}+ax=b
\end{equation*}$
in the case where $b=0$ the equation becomes

$\begin{equation*}
\dot{x}+ax=0
\end{equation*}$
which is called homogenous because if a solution is given by $x(t)$ so then is $Kx(t)$ a solution where $K$ is a constant. The solution to this type of equation will be the equilibrium solution to the homogenous part plus the equilibrium solution to the nonhomogenous part. 

Equation 

$\begin{equation*}
\dot{x}+ax=b 
\end{equation*}$
has solution

$\begin{equation*}
x(t)= \dfrac{b}{a} + Ke^{-at} 
\end{equation*}$
which can be decomposed into parts

$\begin{equation*}
\dot{x}=0 \rightarrow x^e=\dfrac{b}{a}
\end{equation*}$
and 

$\begin{equation*}
x(t)= Ke^{-at}.
\end{equation*}$
"""

# ╔═╡ 0daea97b-eed7-4d6f-ae40-0ed75ec7ced8
md"""
## Linear Stability Analysis
"""

# ╔═╡ ddc17ea8-a31b-4ffe-94fd-9d8aff767feb
md"""
For a differential Equation of the form:

$\begin{equation*}
\dot{x}(t)=f(x(t))
\end{equation*}$
with an equilibrium point $x^{ss}$, consider a small pertubration $\epsilon(t)$ away from $x^{ss}$ so that 

$\begin{equation*}
x(t)=x^{ss}+\epsilon(t)
\end{equation*}$
to determine whether the perturbation grows or shrinks over time, time differentiate both sides 

$\begin{equation*}
\dot{x}(t)=\dot{\epsilon}(t)
\end{equation*}$
and we know that $\dot{x}=f(x(t))$ and that $x(t)=x^{ss}+\epsilon(t)$. Then

$\begin{equation*}
\dot{\epsilon}=f(x^{ss}+\epsilon)
\end{equation*}$
and we can apply a taylor series expansion around $x^{ss}$. Note that a Taylor series expansion is 

$\begin{equation*}
f(a)+\dfrac{f'(a)}{1!}(x-a)+\dfrac{f''(a)}{2!}(x-a)^2+ \cdots \Sigma^\infty_{n=0}\dfrac{f^n}{n!}(x-a)^n
\end{equation*}$
where $a$ is the point we are expanding around. So the Taylor Series expansion is

$\begin{equation*}
\dot{\epsilon}=f(x^{ss})+\dfrac{f'(x^{ss})}{1!}((x^{ss}+\epsilon)-x^{ss})+\dfrac{f''(x^{ss})}{2!}((x^{ss}+\epsilon)-x^{ss})^2 + \cdots 
\end{equation*}$
which simplifies to

$\begin{equation*}
\dot{\epsilon}=f(x^{ss})+f'(x^{ss})\epsilon+\dfrac{f''(x^{ss})}{2!}(\epsilon)^2 + \cdots
\end{equation*}$
And since we are doing a linear stability analysis we are only concerned withthe linear terms

$\begin{equation*}
\dot{\epsilon}=f(x^{ss})+f'(x^{ss})\epsilon
\end{equation*}$
and as we know that $\dot{x}=f(x^{ss})=0$ this reduces to 

$\begin{equation*}
\dot{\epsilon}=f'(x^{ss})\epsilon
\end{equation*}$
where we can understand this as saying that the perturbation grows if $f'>0$ implying that $x^{ss}$ is unstable. Similarly if $f'<0$ then $x^{ss}$ is stable. If $f'=0$ then we need higher order terms to evaluate stability.
"""

# ╔═╡ 1c4c9e27-021b-4139-953f-b6739392137f
md"""
## Systems of Differential Equations
"""

# ╔═╡ b1011514-7a80-4e8b-a6b1-4d7acfba112d
md"""
Take for example the following system:

$\begin{align*}
\dot{x} &= ax + by + p \\
\dot{y} &= cx + dy + q
\end{align*}$
where all coefficients are constants. If the system has nonzero coefficient determine, i.e. 

$\begin{equation*}
\begin{vmatrix} 
a & b\\
c & d \\ 
\end{vmatrix}
\neq 0
\end{equation*}$
it has a unique equilibrium point $(x_0,y_0)$. Writing this system in matrix notation gives

$\begin{equation*}
\begin{bmatrix}
\dot{x} \\
\dot{y}
\end{bmatrix}
=
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
+ 
\begin{bmatrix}
p \\
q
\end{bmatrix}
\end{equation*}$
or

$\begin{equation*}
\begin{bmatrix}
\dot{x} \\
\dot{y}
\end{bmatrix}
=
A
\begin{bmatrix}
x \\
y
\end{bmatrix}
+ 
\begin{bmatrix}
p \\
q
\end{bmatrix}
\end{equation*}$

"""

# ╔═╡ 5168c47c-4bec-4cad-a3a0-9aa64e4a7b48
md"""
Here 

$\begin{equation*}
A =
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\end{equation*}$
the matrix $A$ acts as  the linear transformation on the location vector $\begin{equation*}
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$ to transform it to its derivative. Such as $\dot{x}=f(x(t))$. The goal is still to find $x(t)$ and $y(t)$ so we need to calculate the eigenvalues for this linear transformation because they act as the motive force behind the system. Recall that the eigenvalue equation is $Av=\lambda v$ so for this example it will be

$\begin{equation*}
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\begin{bmatrix}
v_1 \\
v_2
\end{bmatrix}
=
\lambda
\begin{bmatrix}
v_1 \\
v_2
\end{bmatrix}
\end{equation*}$.
So like before we can solve this linear transfomration to find both the eigenvalues and eigenvectors, $(A-\lambda I) v= 0$. So for this particular problem the matrix solution would be

$\begin{equation*}
\begin{bmatrix}
a - \lambda & b \\
c & d- \lambda
\end{bmatrix}
v=0
\end{equation*}$
where for every nonzero $v$ we need to calculate the determinant of the matrix so that it equals zero. 

$\begin{equation*}
\begin{vmatrix}
a - \lambda & b \\
c & d- \lambda
\end{vmatrix}
=0
\end{equation*}$
which simplifies to 

$\begin{align*}
(ad - a \lambda - b \lambda + \lambda^2) - (cb) &= 0 \\
\lambda^2 - (a+d) \lambda + ad-bc  &= 0 \\
\end{align*}$


"""

# ╔═╡ cd96b285-5882-4677-bf9f-156eb06a7bb6
md"""
In order to determine the eigenvalues we would need to solve for the roots of this equation. We will get two eigenvalues $\lambda_1$ and $\lambda_2$ which we can use to find the two eigenvectors for this system. 

$\begin{align*}
A v_1 &= \lambda_1 v_1 \\
A v_2 &= \lambda_2 v_2 
\end{align*}$
The two eigenvalues can be put together into a matrix $\Lambda$,

$\begin{equation*}
\Lambda =
\begin{bmatrix}
\lambda_1 & 0 \\
0 & \lambda_2
\end{bmatrix}
\end{equation*}$
So for this system we have the following matrices $AV=V \Lambda$, where V is the two combined eigenvectors

$\begin{equation*}
\begin{bmatrix}
a & b \\
c & d 
\end{bmatrix}
\begin{bmatrix}
v_{11} & v_{21} \\
v_{12} & v_{22} 
\end{bmatrix}
= 
\begin{bmatrix}
v_{11} & v_{21} \\
v_{12} & v_{22} 
\end{bmatrix}
\begin{bmatrix}
\lambda_1 & 0 \\
0 & \lambda_2
\end{bmatrix}
\end{equation*}$
and $V^{-1}AV=\Lambda$
"""

# ╔═╡ ff343ef2-7636-4f60-9cc9-d10797d75a22
md"""
Take the Homogenous System

$\begin{equation*}
\begin{bmatrix}
\dot{x} \\
\dot{y}
\end{bmatrix}
=
A
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
since $A v_i=v_i \lambda_i$, let $u(t)$ and $v(t)$ be the liear combinations of $x(t)$ and $y(t)$ where 

$\begin{equation*}
\begin{bmatrix}
u \\
v
\end{bmatrix}
= V^{-1}
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
time differentiating both sides 

$\begin{equation*}
\begin{bmatrix}
\dot{u} \\
\dot{v}
\end{bmatrix}
= V^{-1}
\begin{bmatrix}
\dot{x} \\
\dot{y}
\end{bmatrix}
\end{equation*}$
Premultiply the orginal system by $V^{-1}$

$\begin{equation*}
V^{-1}
\begin{bmatrix}
\dot{x} \\
\dot{y}
\end{bmatrix}
=
V^{-1} A
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
"""

# ╔═╡ d74c98a0-4606-456c-9705-9df574b9e028
md"""
we can now rewrite this as 

$\begin{equation*}
\begin{bmatrix}
\dot{u} \\
\dot{v}
\end{bmatrix}
=
V^{-1} A
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
where we can multiply the RHS by $VV^{-1}$ since it equals $I$,

$\begin{equation*}
\begin{bmatrix}
\dot{u} \\
\dot{v}
\end{bmatrix}
=
V^{-1} A VV^{-1}
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
which can be rewritten as 

$\begin{equation*}
\begin{bmatrix}
\dot{u} \\
\dot{v}
\end{bmatrix}
=
\Lambda
\begin{bmatrix}
u \\
v
\end{bmatrix}
\end{equation*}$
this simplifies to 

$\begin{align*}
\dot{u}&=\lambda_1 u \\
\dot{v}&= \lambda_2 v
\end{align*}$
which we have solved before

$\begin{align*}
u(t)&=K_1 e^{\lambda_1 t} \\
v(t) &= K_2 e^{\lambda_2 t}
\end{align*}$

"""

# ╔═╡ c217d252-1170-4dae-b31e-ba8540296ddb
md"""
Recall that 

$\begin{equation*}
V
\begin{bmatrix}
u \\
v
\end{bmatrix}
=
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
where this can be rewritten as

$\begin{equation*}
\begin{bmatrix}
v_{11} & v_{21} \\
v_{12} & v_{22}
\end{bmatrix}
\begin{bmatrix}
K_1 e^{\lambda_1 t} \\
K_2 e^{\lambda_2 t}
\end{bmatrix}
=
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
so this can be expanded as 

$\begin{align*}
x(t) &= v_{11} K_1 e^{\lambda_1 t} + v_{21} K_2 e^{\lambda_2 t} \\
y(t) &= v_{12} K_1 e^{\lambda_1 t} + v_{22} K_2 e^{\lambda_2 t}
\end{align*}$
And we can solve the non-homogenous system by 

$\begin{equation*}
\begin{bmatrix}
0 \\
0
\end{bmatrix}
=
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
+ 
\begin{bmatrix}
p \\
q
\end{bmatrix}
\end{equation*}$
which can be rewritten as 

$\begin{equation*}
\begin{bmatrix}
-p \\
-q
\end{bmatrix}
=
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
\end{equation*}$
by Cramer's Rule these are

$\begin{equation*}
x^{ss}=
\dfrac{
\begin{vmatrix}
-p & b \\
-q & d
\end{vmatrix}}
{\begin{vmatrix}
a & b \\
c & d
\end{vmatrix}}
= \dfrac{qb - cd}{ad - cb}
\end{equation*}$
and 

$\begin{equation*}
y^{ss}=
\dfrac{
\begin{vmatrix}
a & -p \\
c & -q
\end{vmatrix}}
{\begin{vmatrix}
a & b \\
c & d
\end{vmatrix}}
= \dfrac{pc - qd}{ad - cb}
\end{equation*}$

"""

# ╔═╡ 6a6636eb-8383-4409-a37e-584b4dc329c8
md"""
This results in the followiing solution

$\begin{align*}
x(t) &= v_{11} K_1 e^{\lambda_1 t} + v_{21} K_2 e^{\lambda_2 t} + \dfrac{qb - cd}{ad - cb}\\
y(t) &= v_{12} K_1 e^{\lambda_1 t} + v_{22} K_2 e^{\lambda_2 t} + \dfrac{pc - qd}{ad - cb}
\end{align*}$

"""

# ╔═╡ b06e2a96-26b7-417b-accb-a526bc1c491e
md"""
## Phase Diagram
"""

# ╔═╡ 15b0c137-bb0e-4640-8f0b-8d63ce1cc195
md"""
We can depict this qualitative behavior by plotting a phase portrait showing the behavior of $x$ and $y$ over time. These show us where any trajectory will end up from any initial condition. On the phase portrait the directional field gives us the slope of the trajectories. In math this is 

$\begin{equation*}
\dfrac{dy}{dx}=\dfrac{\dot{y}}{\dot{x}}.
\end{equation*}$

"""

# ╔═╡ 04d75ba9-533d-44c0-971c-74dbde902740
md"""
## Stability of Nonlinear Systems
"""

# ╔═╡ a34348de-5db7-49aa-ba56-15ff696e4a05
md"""
For the single Differential Equation

If $y^e$ is an equilibrium point ofthe differential equation $y=F(y)$ then $F(y^e)=0$. if $F'(y^e)<0$ then $y^e$ is an asympototically stable equilibrium. If $F'(y^e)>0$ then $y^e$ is an unstable equilibrium. With a system 

$\begin{equation*}
\dot{x}= F(x)
\end{equation*}$
with steady state $\dot{x}$, the stability conditoin revolves arounf the jacobian matrix at $x^*$, $F^J(x^*)$.

Theorem: If $x^*$ is a steady state ofthe fisrt-order system of differential equations $\dot{x}=F(x)$ then 

1. If each eigenvalue of the jacobian matrix $F^J(x^*)$ at $x^*$ is a negative or have a negative real part, then $x^*$ is an asymptotically stable steady state.

2. If $F^J(x^*)$ has at least one positive real eigenvalue, or one complex eigenvalue with a real part then $x^*$ is an unstable steady state.
"""

# ╔═╡ 733a361f-e146-449a-8dc6-84543ee74b5d
md"""
## Dynamics Class Notes
"""

# ╔═╡ f0460dfd-36fb-4b29-b8b1-7d07af16f601
md"""
Dynamic Optimization 

1. Initial point and Terminal Point

2. Admissable Paths

3. Set of path values that measure performance

4. An objective to maximize or minimize the path value

Optimization: Cake Problem

Say there is a certain amount of cake in a two day period, $x_1$ and $x_2$ respecitvely.The Lagrangian for that problem can be setup as 

$\begin{equation*}
\mathcal{L} = u(x_1) + \beta [u(x_2)+\lambda (R_0 - x_1 - x_2))]
\end{equation*}$
where $u$ is the utility from consuming cake, $\beta$ is the decay rate of utility, and $R_0$ is the total amount of cake. The optimization conditions can be setup with the following optimizatin conditions

$\begin{align*}
\dfrac{\partial \mathcal{L}}{\partial \beta \lambda} &= R-x_1-x_2=0 \\
\dfrac{\partial \mathcal{L}}{\partial x_1} &= u'(x_1) - β\lambda = 0 \\
\dfrac{\partial \mathcal{L}}{\partial x_2} &= β u'(x_2)-β\lambda=0
\end{align*}$
"""

# ╔═╡ 9215f449-2ab6-4a58-bbb0-f88a24e79bbd
begin #parameters
	R=20
end;

# ╔═╡ b3491121-9f54-4fd2-893d-c3b01c564a96
β = @bind β Slider(0.0:0.1:1.0, default=0.5, show_value=true) #cairomakie and PlutoUI do not work together

# ╔═╡ 41853756-2041-44f9-bd69-242442bc41c5
begin #functions
	L(x1,x2) = u(x1)+ β*u(x2)
	u(x) = sqrt(x)
#____________________________________________________________________#
	dL_1(x1,x2) = du(x1)
    dL_2(x1,x2) = β*du(x2) 
	du(x)=.5*x^(-.5)
end;

# ╔═╡ 76ddaae3-6d70-41a0-a83d-33858dd8a523
function Cake_problem(β,R)

    # Set up the numerical model
    model = Model(Ipopt.Optimizer)

    # Suppress solver output
    set_silent(model)

	# Register any functions in the model, including their number of arguments
    register(model, :L, 2, L; autodiff = true)

    # Specify the variables to be optimized over
    @variable(model, x1)
	@variable(model, x2)
        
    # Specify the objective function
    @NLobjective(model, Max, L(x1,x2))

    # Specify the constraints, in == or >= form
    @NLconstraint(model, c1, β*(R-x1-x2) >= 0)
        
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
end;

# ╔═╡ e7b4375b-c39d-4c6b-aa0c-642e0cc01eee
begin 
	x1_opt(β,R) = Cake_problem(β,R)[1]
	x2_opt(β,R) = Cake_problem(β,R)[2]
	λ_opt(β,R) = Cake_problem(β,R)[3]
end;

# ╔═╡ e23f5ec2-e25b-4577-941a-e545cb880e24
xvec = collect(range(0,R,length=101))

# ╔═╡ f5370f37-eefa-42ab-946d-d488965e0693
begin
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
    plot!(xvec, dL_1.(xvec,R .- xvec), linecolor=:black, linestyle=:solid, linewidth=2)
	plot!(xvec, dL_2.(xvec,R .- xvec), linecolor=:black, linestyle=:solid, linewidth=2)

	# Key points, with dashed lines to them
    plot!([x1_opt(β,R),x1_opt(β,R)], [0,du(x1_opt(β,R))], linecolor=:black, linestyle=:dash) 
    plot!([0,x1_opt(β,R)], [du(x1_opt(β,R)),du(x1_opt(β,R))], linecolor=:black, linestyle=:dash)
    scatter!([x1_opt(β,R)], [du(x1_opt(β,R))], markercolor=:black, markersize=5)

	plot!([R,R], [0,1.1], linecolor=:black, linestyle=:solid) 

	# Axis limits
    xlims!(0, 1.05*xvec[end])
    ylims!(0, 1.2*maximum(dL_1.(xvec,R .- xvec)))
    
    # Axis labels
    annotate!(1.071*xvec[end], 0, text(L"R", :left, :center, 12))
    annotate!(0, 1.1, text(L"U", :center, :bottom, 12))

	# Axis ticks
    xticks!([0.001, x1_opt(β,R),R], [L"0", L"x_1^*",L"R"])
    yticks!([0.001 ,du(x1_opt(β,R))], [L"0", L"du(x_1^*)"])

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
end


# ╔═╡ 0d0ad1d5-e75c-4109-93b0-02b0c7a69cde
md"""
All dynamic optimum problems have 

1. A time step $t$, if continuous $t \in (0,T)$

2. State variable x(t) that;  State of the decision maker in time $t$, taken as given by the decision maker, future of $x$ are in part determined by the decision maker.

3. Choice or control variables, u(t): determines outcome in current period and influence transitions of state variables

Given $x(t)$ and $u(t)$ the instantaneous rate of change in the state variable is given by a state equation: 

$\begin{equation*}
\dfrac{dx(t)}{dt} = \dot{x}(t)=f(x(t),u(t),t), x(0)=x_0
\end{equation*}$

Net Benefit - $F(x(t),u(t),t)$: instantaneous net benefit that accrues to the planner during the planning horizon - flow performance 

Salvage Value $S(x(T),T)$: Net benefits that accrue after the palnning horizon.

Objective Functional: $J = \int^{\infty}_{0} \underbrace{F(x(t),u(t),t)}_{\text{Flow Performance}}dt + \underbrace{S(x(T),T)}_{\text{Salvage Value}}$

Constraints on Control

An admissable control trajectory, $u(t), \; t \in [0,T]$ is piecewise continuous and satisfies 

$\begin{equation*}
u(t) \in \Omega(t), \; t \in [0,T]
\end{equation*}$
where $\Omega(t)$ determined by economics or physiological constraints on the valus $u(t)$ can take at $t$, $(0 \geq u(t) \geq \overline{u})$
"""

# ╔═╡ 86514108-e3c3-48a7-a0ff-1d25bea79fe7
md"""
**Optimal Control Problem**

Problem we face is to find $u^*(t)$ which maximizes the objective functional subject to the state equation and the control constraints 

$\begin{equation*}
\max_{u(t) \in \Omega(t)} J = \int^\infty_0 F(x,u,t)dt + S(x(T),T)
\end{equation*}$
subject to 

$\begin{align*}
\dot{x}(t) &= f(x,u,t) \\
x(0) &= x_0
\end{align*}$
where 

$\begin{align*}
u^*(t):& \; \text{Optimal Control} \\
x^*(t):& \; \text{Optimal State Trajectory}
\end{align*}$

"""

# ╔═╡ 65f0be5a-ba4c-4297-8803-3e070619614e
md"""
**Intuitive Derivation of the Maximum Principle**

(ignore Salvage, typical Optimal Control Problem is to)

1. $\max_{u} \int^{\infty}_0F(x,u,t)dt$ 

subject to $\dot{x}=f(x,u,t), \; x(0)=x_0$

2. $H(x,u,t, \lambda) = F(x,u,t) + \lambda f(x,u,t)$

the conditions that characterize the opt

3. Maximum Principle

i. $\max_{u} F(x,u,t) \; \forall t \in [0,T]$ (First-order Condition).This condition characterizes the optimum. 

ii. $\dfrac{\partial H}{\partial x} = - \dot{\lambda}$ (Portfolio Balance Condition)

iii. $\dfrac{\partial H}{\partial \lambda} = \dot{x}, \; x(0)=x_0$ (Dynamic Constraint Condition)

iv. $\lambda(T)=0$ (Transversality Condition)

To be continued
"""

# ╔═╡ 776f8d00-1780-453d-8d4b-3a38a2c209fd
md"""
**Dynamic Programming and the Maximum Principle**

The Hamilton-Jacobi-Bellman Equation

Suppose $V(x,t): E^n \times E^1 \rightarrow E^1$ is a function whose value is the maximum of the objective function of the control problem for the system, given that we start at time $t$ and state $x$. That is

$\begin{equation*}
V(x,t) = \max_{u(s) \in \Omega(s)}[\int^T_tF(x(s),u(s),s)ds+S(x(T),T)], 
\end{equation*}$
where $s \geq T$

$\begin{equation*}
\dfrac{dx(s)}{ds}=f(x(s),u(s).s), \; x(t)=x
\end{equation*}$

Bellman (1957) in his book on dynamic programming states the principle of
optimality as follows:

"An optimal policy has the property that, whatever the initial state and initial decision are, the
remaining decision must constitute an optimal policy with regard to the outcome resulting
from the initial decision."
"""

# ╔═╡ e03ab25a-edc9-4c8a-a199-4b0a99f9926f
md"""
Intuitively this principle is obvious, for if we were to start in state $x$ at time $t$ and did not folllow an optimal parth from then on, there would then exist a better path from $t$ to $T$, hence we could improve the proposed solution by following a better path.

Say we were to have a some optimal path $x^*(t)$ in the state-time space and two nearby points $(x,t)$ and $(x+\delta x, t+ \delta t)$, where $\delta t$ is a small increment of time and $x+ \delta x = x(t+\delta t)$. The value function changes from $V(x,t)$ to $V(x+\delta x, t + \delta t)$ between these two points. By the principle of optimality, the change in the objective functon is made up of two parts: first, the incremental change in $J$ from $t$ to $t+ \delta t$, which is given by the integral of $F(x,u,t)$ from $t$ to $t+ \delta t$; second, the value function $V(x + \delta x, t + \delta t)$ at time $t + \delta t$. The control action $u(\tau)$ should be chosen to lie in $\Omega(\tau), \; t \in [t,t+\delta t]$, and to maxmizethe sum of these terms. In equation form this is

$\begin{equation*}
V(x,t) = \max_{u(\tau) \in \Omega(\tau), \tau \in [t,t+\delta t]} \int^{t+ \delta t}_{t} F[x(\tau),u(\tau),\tau] d \tau + V[x(t+\delta t), t+ \delta t]
\end{equation*}$
where $\delta t$ represents a small increment in $t$. it is instructive to compare this equation to the definition above. Since $F$ is a continuous function, the integral is approximately $F(x,u,t)\delta t$ so we can rewrite it as

$\begin{equation*}
V(x,t) = \max_{u \in \Omega(t)}\{F(x,u,t) \delta t + V[x(t+\delta t), t+ \delta t]\} + o(\delta t)
\end{equation*}$
where $o(\delta t)$ denotes a collection of higher-order terms in $\delta t$. We can make an assumption that the value function $V$ is a continuosly differentiable function of its arguments. This allows us to use the Taylor series expansion of $V$ with rest to $\delta t$ and obtain

$\begin{equation*}
V[x(t+\delta t), t+\delta t] = V(x,t)+[V_x(x,t)\dot{x}+V_t(x,t)]\delta t + o(\delta t)
\end{equation*}$
where $V_x$ and $V_t$ are partial derivatives of $V(x,t)$ with respect to $x$ and $t$. Since we know that $\dot{x}(t)=f(x(t),u(t),t)$ we can then use that information to generate the following equation

$\begin{equation*}
V(x,t)= \max_{u \in \Omega(t)} \{F(x,u,t)\delta t + V(x,t) + V_x(x,t)f(x,u,t)\delta t + V_t(x,t)\delta t\} + o(\delta t)
\end{equation*}$
Canceling $V(x,t)$ on both sides and then dividing by $\delta t$ we get 

$\begin{equation*}
0 = \max_{u \in \Omega(t)} \{F(x,u,t)+V_x(x,t)f(x,u,t)+V_t(x,t)\} + \dfrac{o(\delta t)}{\delta t} 
\end{equation*}$
Now let $\delta t \rightarrow 0$ nad obtain the following equation

$\begin{equation*}
0 = \max_{u \in \Omega(t)} \{F(x,u,t)+V_x(x,t)f(x,u,t)+V_t(x,t)\}
\end{equation*}$
"""

# ╔═╡ df298cfc-3f5b-4e70-8a47-1e59b59e756d
md"""
for which the boundary condition is 

$\begin{equation*}
V(x,t)=S(x,t).
\end{equation*}$
This boundary condition follows from the fact that the value function at $t=T$ is simply the salvage value function. The components of the vector $V_x(x,t)$ can be interpreted as the marginal contributions of the state variables $x$ to the value function or the maximized objective function. We denote the marginal return vector (along the optimal path $x^*(t))$ by the adjoint (row) vector $\lambda(t) \in E^n$, i.e

$\begin{equation*}
\lambda(t) = V_x(x^*(t),t) := V_x(x,t) |_{x=x^*(t)}
\end{equation*}$
From the preceding remark, we can interpret $\lambda(t)$ as the per unit change in the objective function value for a small change in $x^*(t)$ at time t.In other words, $\lambda(t)$ is the highest hypothetical unit price which a rational decision maket would be willing to pay for an infinitesimal addition to $x^*(t)$. 

Next we introduce a function $H ; E^n \times E^m \times E^n \times E^1 \rightarrow E^1$ called the Hamiltonian 

$\begin{equation*}
H(x,u,\lambda,t)=F(x,u,t) + \lambda f(x,u,t)
\end{equation*}$
we can rewrite equation 

$\begin{equation*}
0 = \max_{u \in \Omega(t)} \{F(x,u,t)+V_x(x,t)f(x,u,t)+V_t(x,t)\}
\end{equation*}$
as

$\begin{equation*}
\max_{u \in \Omega(t)}[H(x,u,V_x,t)+V_t]=0
\end{equation*}$
called the Hamiltonian-Jacobi-Bellman equation.
"""

# ╔═╡ 1f55f577-7c67-4e3d-9032-99f07ab30197
md"""
The Hamilton-Jacobi-Bellman (HJB) equation is a nonlinear partial differential equation that provides necessary and sufficient conditions for optimality of a control with respect to a loss function. Its solution is the value function of the optimal control problem which, once known, can be used to obtain the optimal control by taking the maximizer (or minimizer) of the Hamiltonian involved in the HJB equation.

The equation is a result of the theory of dynamic programming which was pioneered in the 1950s by Richard Bellman and coworkers. The connection to the Hamilton–Jacobi equation from classical physics was first drawn by Rudolf Kálmán. In discrete-time problems, the analogous difference equation is usually referred to as the Bellman equation.

While classical variational problems, such as the brachistochrone problem, can be solved using the Hamilton–Jacobi–Bellman equation, the method can be applied to a broader spectrum of problems. Further it can be generalized to stochastic systems, in which case the HJB equation is a second-order elliptic partial differential equation. A major drawback, however, is that the HJB equation admits classical solutions only for a sufficiently smooth value function, which is not guaranteed in most situations. Instead, the notion of a viscosity solution is required, in which conventional derivatives are replaced by (set-valued) subderivatives.
"""

# ╔═╡ Cell order:
# ╠═75122120-e1cd-11ef-1cbe-81facddfa1a0
# ╠═28f4b5b9-1835-48c9-aac6-834673fcddb6
# ╟─fee9d888-b6aa-4d23-85f9-c3d8bc67e2ff
# ╟─0542bfc1-06ee-4690-bd0f-a21f0a85d90a
# ╟─bea00ffd-d299-4afb-b96a-7c4cb08a505a
# ╟─2c21309c-1945-45ff-9f7a-dec5b72c682f
# ╟─715a891f-c125-4f26-b2ac-b0971437c755
# ╟─17c71fdb-385f-4e4b-a298-1cf2370aac4e
# ╟─cdbd7b23-6b6c-4ed7-8ccd-aed0713bb60b
# ╟─726b8976-1a51-47a0-a1ac-03911028c13e
# ╟─9d22c3d8-4130-4522-ae2f-3f270d983572
# ╟─d6109bd3-8898-4ed1-bbf7-7b6c02505e57
# ╟─7ec69410-443f-48c8-a9a7-cccc4f589a5e
# ╟─5a5fc1a2-c239-4500-916d-bdc67deab539
# ╟─05c468e3-3ef7-43b0-bae9-4314e9c5a4cf
# ╟─b85d2faf-dc13-43d9-8491-82dea67ee5fb
# ╟─2febee16-24e4-4f2c-9034-d2e87e9e8d12
# ╟─ab4f0061-fdc5-4d4f-8412-8587fceb9398
# ╟─0daea97b-eed7-4d6f-ae40-0ed75ec7ced8
# ╟─ddc17ea8-a31b-4ffe-94fd-9d8aff767feb
# ╟─1c4c9e27-021b-4139-953f-b6739392137f
# ╟─b1011514-7a80-4e8b-a6b1-4d7acfba112d
# ╟─5168c47c-4bec-4cad-a3a0-9aa64e4a7b48
# ╟─cd96b285-5882-4677-bf9f-156eb06a7bb6
# ╟─ff343ef2-7636-4f60-9cc9-d10797d75a22
# ╟─d74c98a0-4606-456c-9705-9df574b9e028
# ╟─c217d252-1170-4dae-b31e-ba8540296ddb
# ╟─6a6636eb-8383-4409-a37e-584b4dc329c8
# ╟─b06e2a96-26b7-417b-accb-a526bc1c491e
# ╟─15b0c137-bb0e-4640-8f0b-8d63ce1cc195
# ╟─04d75ba9-533d-44c0-971c-74dbde902740
# ╟─a34348de-5db7-49aa-ba56-15ff696e4a05
# ╟─733a361f-e146-449a-8dc6-84543ee74b5d
# ╟─f0460dfd-36fb-4b29-b8b1-7d07af16f601
# ╠═41853756-2041-44f9-bd69-242442bc41c5
# ╠═9215f449-2ab6-4a58-bbb0-f88a24e79bbd
# ╠═76ddaae3-6d70-41a0-a83d-33858dd8a523
# ╠═b3491121-9f54-4fd2-893d-c3b01c564a96
# ╠═e7b4375b-c39d-4c6b-aa0c-642e0cc01eee
# ╟─e23f5ec2-e25b-4577-941a-e545cb880e24
# ╟─f5370f37-eefa-42ab-946d-d488965e0693
# ╟─0d0ad1d5-e75c-4109-93b0-02b0c7a69cde
# ╟─86514108-e3c3-48a7-a0ff-1d25bea79fe7
# ╟─65f0be5a-ba4c-4297-8803-3e070619614e
# ╟─776f8d00-1780-453d-8d4b-3a38a2c209fd
# ╟─e03ab25a-edc9-4c8a-a199-4b0a99f9926f
# ╟─df298cfc-3f5b-4e70-8a47-1e59b59e756d
# ╟─1f55f577-7c67-4e3d-9032-99f07ab30197
