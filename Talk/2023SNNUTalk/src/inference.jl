# Codes for bayesian inference for parameters

@doc raw"""
    cognitiveinference!(du,u,p,t)
Bayesian inference of the data
"""
function cognitiveinference!(N, θ, acc, cases, datatspan, pknown, lb, ub)
    @model function fitmodel(data, prob1) # data should be a Vector
        ϵ ~ InverseGamma(2, 3) # ~ is the tilde character
        ρ ~ truncated(Normal(0.4, 0.5), lb[1], ub[1])
        σ ~ truncated(Normal(0.2, 0.001), lb[2], ub[2])
        h ~ truncated(Normal(0.8, 0.001), lb[3], ub[3])
        α ~ truncated(Normal(0.2, 0.001), lb[4], ub[4])
        B = pknown[1]
        μ = pknown[2]
        δ = pknown[3]
        ϕ = pknown[4]
        p = [B, μ, ρ, σ, δ, h, ϕ]
        u0 = [N - 1.0, 1.0, 0.0, α * N, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        prob = remake(prob1, u0=u0, p=p)
        predicted = solve(prob, Vern7(), saveat=datatspan)
        for i = 1:length(predicted)
            data[i] ~ Normal(predicted[i][10], ϵ)
        end
    end
    Turing.setadbackend(:forwarddiff)
    prob_pred = cognitiveprob!(N, θ, acc, pknown)
    data_daily_to_learn = @view cases[datatspan]
    data_to_learn = @view acc[datatspan]
    model = fitmodel(data_to_learn, prob_pred)
    chain = sample(model, NUTS(0.45), MCMCThreads(), 2000, 3, progress=false, init_theta=θ)
    pmin = [mean(chain[:ρ]), mean(chain[:σ]), mean(chain[:h]), mean(chain[:α])]
    return chain, pmin
end

@doc raw"""
    controlcognitiveinference!(du,u,p,t)
Bayesian inference of the data
"""
function controlcognitiveinference!(N, θ, acc, cases, datatspan, pknown, lb, ub)
    @model function fitmodel(data, prob1) # data should be a Vector
        ϵ ~ InverseGamma(2, 3) # ~ is the tilde character
        p0 ~ truncated(Normal(0.4, 0.5), lb[1], ub[1])
        pend ~ truncated(Normal(0.4, 0.5), lb[2], ub[2])
        r ~ truncated(Normal(0.05, 0.01), lb[3], ub[3])
        σ ~ truncated(Normal(0.2, 0.001), lb[4], ub[4])
        h ~ truncated(Normal(0.8, 0.001), lb[5], ub[5])
        α ~ truncated(Normal(0.2, 0.001), lb[6], ub[6])
        B = pknown[1]
        μ = pknown[2]
        δ = pknown[3]
        ϕ = pknown[4]
        p = [B, μ, p0, pend, r, σ, δ, h, ϕ]
        u0 = [N - 1.0, 1.0, 0.0, α * N, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        prob = remake(prob1, u0=u0, p=p)
        predicted = solve(prob, Vern7(), saveat=datatspan)
        for i = 1:length(predicted)
            data[i] ~ Normal(predicted[i][10], ϵ)
        end
    end
    Turing.setadbackend(:forwarddiff)
    prob_pred = controlcognitiveprob!(N, θ, acc, pknown)
    data_daily_to_learn = @view cases[datatspan]
    data_to_learn = @view acc[datatspan]
    model = fitmodel(data_to_learn, prob_pred)
    chain = sample(model, NUTS(0.45), MCMCThreads(), 2000, 3, progress=true, init_theta=θ)
    pmin = [mean(chain[:p0]), mean(chain[:pend]), mean(chain[:r]), mean(chain[:σ]), mean(chain[:h]), mean(chain[:α])]
    return chain, pmin
end