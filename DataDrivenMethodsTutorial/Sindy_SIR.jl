using DataDrivenDiffEq
using ModelingToolkit
using OrdinaryDiffEq

using LinearAlgebra

# Create a test problem
function lorenz(u,p,t)
    x, y, z = u

    ẋ = 10.0*(y - x)
    ẏ = x*(28.0-z) - y
    ż = x*y - (8/3)*z
    return [ẋ, ẏ, ż]
end

u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
dt = 0.1
prob = ODEProblem(lorenz,u0,tspan)
sol = solve(prob, Tsit5(), saveat = dt, progress = true)


## Start the automatic discovery
ddprob = ContinuousDataDrivenProblem(sol)

@variables t x(t) y(t) z(t)
u = [x;y;z]
basis = Basis(polynomial_basis(u, 5), u, iv = t)
opt = STLSQ(exp10.(-5:0.1:-1))
ddsol = solve(ddprob, basis, opt, normalize = true)
print(ddsol, Val{true})