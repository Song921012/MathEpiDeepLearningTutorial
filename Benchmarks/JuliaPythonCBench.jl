using LoopVectorization
using BenchmarkTools
function normal_test(x)
    return x+x*x+x*x*x
end

x = randn(1000,1000)

@btime @. normal_test($x)

@btime @turbo @. normal_test($x)