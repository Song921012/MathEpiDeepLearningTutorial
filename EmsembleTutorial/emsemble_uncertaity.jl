using DifferentialEquations
using LinearAlgebra, DiffEqSensitivity, Optim
using Flux: flatten, params
using DiffEqFlux, Flux
using Plots
using Flux: train!
using NNlib
using GalacticOptim
using Optim
using Turing, Distributions

# Import MCMCChain, Plots, and StatsPlots for visualizations and diagnostics.
using MCMCChains, StatsPlots

# Set a seed for reproducibility.
using Random
Random.seed!(14);

# Data generation
function SEIAR(du,u,p,t)
    β, k1, k2, σ, ρ, γ1, γ2 = p
   S, E, I, A = u
   du[1] = - β*S*(I+k1*E+k2*A)/1000
   du[2] = β*S*(I+k1*E+k2*A)/1000 - σ*E
   du[3] =  σ*(1-ρ)*E-γ1*I
   du[4] = σ*ρ*E-γ2*A
   du[5] = σ*E
end
u_0 = [1000, 1, 1, 1,0]
p_data = [0.3,0.3,0.3,1/5.2,0.3,1/10,1/10]
tspan_data = (0.0, 50)
prob_data = ODEProblem(SEIAR,u_0,tspan_data,p_data)
data_solve = solve(prob_data, Tsit5(),abstol=1e-12, reltol=1e-12, saveat = 0.5)
data_withoutnois = Array(data_solve)
data = data_withoutnois + Float32(10)*randn(eltype(data_withoutnois), size(data_withoutnois))
tspan_predict = (0.0, 4.0)
prob_predict = ODEProblem(SEIAR,u_0,tspan_predict,p_data)
test_data = solve(prob_predict, Tsit5(),abstol=1e-12, reltol=1e-12, saveat = 0.1)

plot(data_solve.t, data[3,:])

# Model generation
function SEIAR_pred(du,u,p,t)
    β, k1, k2, ρ= p
    σ, γ1, γ2 = 1/5.2,1/10,1/10
   S, E, I, A = u
   du[1] = - β*S*(I+k1*E+k2*A)/1000
   du[2] = β*S*(I+k1*E+k2*A)/1000 - σ*E
   du[3] =  σ*(1-ρ)*E-γ1*I
   du[4] = σ*ρ*E-γ2*A
   du[5] = σ*E
end
u_0 = [1000, 1, 1, 1,0]
p_0 = [0.1,0.1,0.1,0.1]
prob_pred = ODEProblem(SEIAR_pred,u_0,tspan_data,p_0)

function train(θ)
    Array(concrete_solve(prob_pred, Vern7(), u_0, θ, saveat=0.5,
                         abstol=1e-6, reltol=1e-6,
                         sensealg=InterpolatingAdjoint(autojacvec=ReverseDiffVJP())))
end
function loss(θ,p)
    pred = train(θ)
    sum(abs2, (data[5,:] .- pred[5,:])) + sum(abs2, (data[3,:] .- pred[3,:])) # + 1e-5*sum(sum.(abs, params(ann)))
end
println(loss([0.3,0.3,0.3,0.3],p_0))
lb = [0, 0.01, 0, 0]
ub = [1,1,1,1]
using GalacticOptim: OptimizationProblem
using Optim
prob = OptimizationProblem(loss, p_0, lb = lb, ub = ub)
sol = solve(prob, NelderMead())

# Data visualization
p_min = sol.u
tspan_predict = (0.0,200)
prob_test = ODEProblem(SEIAR,u_0,tspan_predict,p_data)
data_test = Array(solve(prob_test, Tsit5(),abstol=1e-12, reltol=1e-12, saveat = 0.5))
scatter(data_test[5,:],label = "Train Acc")
scatter!(data_test[3,:],label = "Train I")
prob_prediction = ODEProblem(SEIAR_pred, u_0, tspan_predict, p_min)
data_prediction = Array(solve(prob_prediction, Tsit5(), saveat = 0.5))
plot!(data_prediction[5,:],label=["Learn ACC"])
plot!(data_prediction[3,:],label=["Learn I"])


Turing.setadbackend(:forwarddiff)
@model function fitSEIAR(data, prob1) # data should be a Vector
    σ ~ InverseGamma(2, 3) # ~ is the tilde character
    β ~ truncated(Normal(0.1,0.5),0,1)
    k1 ~ truncated(Normal(0.1,0.5),0,1)
    k2 ~ truncated(Normal(0.1,0.5),0,1)
    ρ ~ truncated(Normal(0.1,0.5),0,1)

    p = [β,k1,k2,ρ]
    prob = remake(prob1, p=p)
    predicted = solve(prob,Tsit5(),saveat=0.5)

    for i = 1:length(predicted)
        data[1,i] ~ Normal(predicted[i][3], σ)
        data[2,i] ~ Normal(predicted[i][5], σ) # predicted[i][2] is the data for y - a scalar, so we use Normal instead of MvNormal
    end
end
model = fitSEIAR(data[[3,5],:], prob_pred)
chain = sample(model, NUTS(.45), MCMCThreads(), 5000, 3, progress=false,init_theta = sol.u)
println(chain)
plot(chain)

using DataFrames
chain
println(describe(chain))
println(DataFrame(chain))

chain_array = Array(chain)

function prob_func(prob,i,repeat)
    remake(prob,p=chain_array[rand(1:12000),1:4])
end
ensemble_prob = EnsembleProblem(prob_pred,prob_func=prob_func)
sim = solve(ensemble_prob,Tsit5(),EnsembleThreads(),trajectories=100)
plot(sim)
simm  = EnsembleSummary(sim;quantiles=[0.05,0.95])
plot(simm,error_style=:bars)
plot(simm,fillalpha=0.3)
plot(simm,idxs = [2,3], fillalpha=0.3)
xlabel!("days")
ylabel!("Case")
using DifferentialEquations.EnsembleAnalysis
timestep_mean(sim,3)



#We can compute the mean and the variance at the 3rd timestep using:

m,v = timestep_meanvar(sim,3)
#or we can compute the mean and the variance at the t=0.5 using:

m,v = timepoint_meanvar(sim,0.5)
#We can get a series for the mean and the variance at each time step using:

m_series,v_series = timeseries_steps_meanvar(sim)
#or at chosen values of t:

ts = 0:0.1:1
m_series = timeseries_point_mean(sim,ts)
#Note that these mean and variance series can be directly plotted. We can compute covariance matrices similarly:

timeseries_steps_meancov(sim) # Use the time steps, assume fixed dt
timeseries_point_meancov(sim,0:1//2^(3):1,0:1//2^(3):1) # Use time points, interpolate