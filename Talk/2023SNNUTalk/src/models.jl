# Cognitive models

## models before
function cognitive1!(du, u, p, t)
    S, V, E, I, R, β, M, C = u
    N, ν0, n, b, ϵ, σ, γ, k, β0, η, ξ, rm, rc, α, θ, c, r = p
    ν = ν0 * (1 - M^n / (b^n + M^n))
    dS = -β * S * I / N - ν * S
    dV = -(1 - ϵ) * β * V * I / N + ν * S
    dE = β * S * I / N + (1 - ϵ) * β * V * I / N - σ * E
    dI = σ * E - γ * I
    dR = γ * I
    dβ = k * β * (β0 * η - β) * (M - C) + ξ * (1 - β / β0)
    dM = rm - (α + η * C^r / (c^r + C^r)) * M
    dC = rc - θ * C
    du .= [dS, dV, dE, dI, dR, dβ, dM, dC]
end

# models now
function cognitive2!(du, u, p, t)
    S, V, E, I, R, β, ν, M1, C1, M2, C2 = u
    N, ϵ, σ, γ, k1, k2, β0, ν0, ξ, η1, η2, η3, η4, rm1, rm2, rc1, rc2, α1, α2, θ1, θ2, c1, c2, c3, c4, r, s = p
    dS = -β * S * I / N - ν * S
    dV = -(1 - ϵ) * β * V * I / N + ν * S
    dE = β * S * I / N + (1 - ϵ) * β * V * I / N - σ * E
    dI = σ * E - γ * I
    dR = γ * I
    dβ = k1 * β * (β0 * η1 - β) * (M1 + C1) + ξ * (1 - β / β0)
    dν = k2 * ν * (ν0 * η3 - ν) * (M2 + C2)
    dM1 = rm1 - (α1 + η1 * C1^r / (c1^r + C1^r)) * M1
    dC1 = rc1 - (θ1 + η2 * M1^s / (c2^s + M1^s)) * C1
    dM2 = rm2 - (α2 + η3 * C2^r / (c3^r + C2^r)) * M2
    dC2 = rc2 - (θ2 + η4 * M2^s / (c4^s + M2^s)) * C2
    du .= [dS, dV, dE, dI, dR, dβ, dν, dM1, dC1, dM2, dC2]
end

# models now
function information!(du, u, p, t)
    M1, C1, M2, C2 = u
    η1, η2, η3, η4, rm1, rm2, rc1, rc2, α1, α2, θ1, θ2, c1, c2, c3, c4, r, s = p
    dM1 = rm1 - (α1 + η1 * C1^r / (c1^r + C1^r)) * M1
    dC1 = rc1 - (θ1 + η2 * M1^s / (c2^s + M1^s)) * C1
    dM2 = rm2 - (α2 + η3 * C2^r / (c3^r + C2^r)) * M2
    dC2 = rc2 - (θ2 + η4 * M2^s / (c4^s + M2^s)) * C2
    du .= [dM1, dC1, dM2, dC2]
end