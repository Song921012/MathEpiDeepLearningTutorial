# Julia Call R: RCall
[Introduction · RCall.jl](https://juliainterop.github.io/RCall.jl/stable/)

Activate R environment:
> In Repl, `$`
> In script, `R"*"`, `R"""*"""` for long
> IJulia support graphoutput
> Weave do not support graphoutput
> 

Conversions:

RCall supports conversions to and from most base Julia types, functions, and popular Statistics packages, e.g., DataFrames, CategoricalArrays and AxisArrays.

Converse Julia Type to R Type:

> @rput z in Julia Environment (The same variable name)
> $z or $(julia code) in R Environment
> robject(julia type) (not callable in R environment)

Converse R Type to Julia Type:
> @rget z in Julia Environment. (The same variable name)
> rcopy(R"")