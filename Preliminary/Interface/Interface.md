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


# Julia Call Python: PyCall

[JuliaPy/PyCall.jl: Package to call Python functions from the Julia language](https://github.com/JuliaPy/PyCall.jl)

Import python function and modules. `pyimport(module)`, and then you can easily use these functions in Julia.

```julia
module MyModule

using PyCall

function __init__()
    py"""
    import numpy as np

    def one(x):
        return np.sin(x) ** 2 + np.cos(x) ** 2
    """
end

two(x) = py"one"(x) + py"one"(x)

end
```



