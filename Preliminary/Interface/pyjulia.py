#%%
from julia import DifferentialEquations as de
def f(x,p,t):
    y = x*(1.0-x)
    return y
prob = de.ODEProblem(f,0.1,(0.0,1.0))
sol = de.solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)

#%%
using Plots
plot(sol,linewidth=5,title="Solution to the linear ODE with a thick line",
     xaxis="Time (t)",yaxis="u(t) (in μm)",label="My Thick Line!") # legend=false
plot!(sol.t, t->0.5*exp(1.01t),lw=3,ls=:dash,label="True Solution!")