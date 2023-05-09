# Codes for estimating parameters

@doc raw"""
    cognitiveopt!(N::Real, θ, acc, cases, datatspan, pknown, lb, ub, alg)
Parameter Estimation
Parameters: (population, estimated parameters, acc,cases,datatspan,pknown, lb,ub,alg)
"""
function cognitiveopt!(N, θ, acc, cases, datatspan, pknown, lb, ub, alg)
    prob_pred = cognitiveprob!(N, θ, acc, pknown)
    data_daily_to_learn = @view cases[datatspan]
    #data_to_learn = @view acc[datatspan]
    function loss(θ, p)
        pred = simulate!(prob_pred, N, θ, datatspan, pknown)
        #mid = zeros(length(acc))
        #mid[2:end] =  pred[10, 1:end-1]
        #pred_daily =  pred[10, :] - mid
        #cases_learn = pred_daily[datatspan]
        #accpred = pred[10,:]
        #acc_learn =  accpred[datatspan]
        loss = sum(abs2, (log.(acc[datatspan]) .- log.(pred[10, :])))
        #+ sum(abs2, (log.(data_daily_to_learn .+ 1) .- log.(cases_learn .+ 1))) # + 1e-5*sum(sum.(abs, params(ann)))
    end
    #println(loss(θ, nothing))
    loss1 = OptimizationFunction(loss, Optimization.AutoZygote())
    prob = OptimizationProblem(loss1, θ, lb=lb, ub=ub)
    sol1 = Optimization.solve(prob, alg, maxiters=1000)
    return sol1.u
end


@doc raw"""
    controlcognitiveopt!(N::Real, θ, acc, cases, datatspan, pknown, lb, ub, alg)
Parameter Estimation
Parameters: (population, estimated parameters, acc,cases,datatspan,pknown, lb,ub,alg)
"""
function controlcognitiveopt!(N, θ, acc, cases, datatspan, pknown, lb, ub, alg)
    prob_pred = controlcognitiveprob!(N, θ, acc, pknown)
    data_daily_to_learn = @view cases[datatspan]
    #data_to_learn = @view acc[datatspan]
    function loss(θ, p)
        pred = controlsimulate!(prob_pred, N, θ, datatspan, pknown)
        #mid = zeros(length(acc))
        #mid[2:end] =  pred[10, 1:end-1]
        #pred_daily =  pred[10, :] - mid
        #cases_learn = pred_daily[datatspan]
        #accpred = pred[10,:]
        #acc_learn =  accpred[datatspan]
        loss = sum(abs2, (log.(acc[datatspan]) .- log.(pred[10, :])))
        #+ sum(abs2, (log.(data_daily_to_learn .+ 1) .- log.(cases_learn .+ 1))) # + 1e-5*sum(sum.(abs, params(ann)))
    end
    #println(loss(θ, nothing))
    loss1 = OptimizationFunction(loss, Optimization.AutoZygote())
    prob = OptimizationProblem(loss1, θ, lb=lb, ub=ub)
    sol1 = Optimization.solve(prob, alg, maxiters=1000)
    return sol1.u
end