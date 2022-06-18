using DifferentialEquations
using LinearAlgebra, DiffEqSensitivity, Optim
using Flux: flatten, params
using DiffEqFlux, Flux
using Plots
using Flux:train!
using NNlib

function dxdt_train(du, u, p, t)
    x, y, z = u
    du[1] = 10.0*(y - x)
    du[2] = x*(28.0-z) - y
    du[3] = x*y - (8/3)*z
end
u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
dt = 0.1
prob = ODEProblem(dxdt_train,u0,tspan)
ts = collect(0.0:0.1:tspan[2])
prob_train = ODEProblem{true}(dxdt_train, u0, tspan, p=nothing)
data_train = Array(solve(prob_train, Tsit5(), saveat=ts))
A = [PolynomialBasis(2), PolynomialBasis(2)]
nn0 = TensorLayer(A, 1)
nn1 = TensorLayer(A, 1)
nn2 = TensorLayer(A, 1)
nn2([0.1,0.1])
f = x -> min(100one(x), x)

function dxdt_pred(du, u, p, t)
    x, y, z = u
    du[1] = 10*(y - x)
    du[2] = x*(p[1]-z) - y
    du[3] = x*y -  (8/3)*z
end

function dxdt_pred1(du, u, p, t)
    x, y, z = u
    du[1] = nn0([x,y],p[1:4])[1]
    du[2] = nn1([x,z],p[5:8])[1] - p[13]*y
    du[3] = nn2([x,y],p[9:12])[1] - p[14]*z
end

α = 27*ones(1)

prob_pred = ODEProblem{true}(dxdt_pred, u0, tspan, p=nothing)
function predict_adjoint(θ)
    x = Array(solve(prob_pred, Tsit5(), p=θ, saveat=ts))
end
  
function loss_adjoint(θ)
    x = predict_adjoint(θ)
    loss = log.(x) - log.(data_train)
    return loss
end
  
function cb(θ, l)
    @show l
    return false
end
res1 = DiffEqFlux.sciml_train(loss_adjoint, α, ADAM(0.02), cb=cb, maxiters=500)
res2 = DiffEqFlux.sciml_train(loss_adjoint, res1.u, BFGS(), cb=cb)#, maxiters=10000)
opt = res2.u
data_pred = predict_adjoint(opt)
plot(ts, data_train[1,:], label="X (ODE)")
plot!(ts, data_train[2,:], label="Y (ODE)")
plot!(ts, data_train[3,:], label="Z (ODE)")
plot!(ts, data_pred[1,:], label="X (NN)")
plot!(ts, data_pred[2,:],label="V (NN)")
plot!(ts, data_pred[3,:], label="Z (NN)")

using DiffEqFlux, DifferentialEquations, Plots

ann_node = FastChain(FastDense(2, 32, tanh), FastDense(32,2, tanh))

using Pkg, Dates
 Pkg.gc(collect_delay = Day(0))

using PackageCompiler
 create_sysimage([:DifferentialEquations,:DiffEqFlux,:Flux,:Turing,:Plots,:DataFrames,:Symbolics,:ModelingToolkit,:GalacticOptim,:LinearSolve,:DiffEqSensitivity,:DiffEqOperators,:ForwardDiff,:ReverseDiff,:Zygote,:Catalyst,:JuMP,:MLJ,:Graphs,:InfiniteOpt,:NeuralPDE,:DataDrivenDiffEq,:GLMakie,:ApproxFun,:AugmentedGaussianProcesses,:DynamicalSystems,:POMDPs, :ReinforcementLearning,:GeometricFlux], sysimage_path="JuliaSysimage.dll")