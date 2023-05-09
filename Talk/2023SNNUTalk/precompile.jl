#using Pkg;Pkg.add(["DifferentialEquations","AxisArrays","BSON","CSV","DataFrames", "ModelingToolkit","NLopt","Turing","Statistics","StatsPlots","SciMLSensitivity","Optimization","OptimizationOptimJL","Optim","LinearSolve","LaTeXStrings"])

#Pkg.upgrade_manifest()


#using Pkg
#Pkg.activate(".")
#Pkg.instantiate() # install

##
# Precompile to accelerate the computation
using PackageCompiler
@time create_sysimage([:DifferentialEquations, :DiffEqFlux, :Plots, :DataFrames, :Optimization, :Lux, :Turing,:SciMLSensitivity,:CSV,:ComponentArrays], sysimage_path="JuliaSysimage.so", precompile_execution_file="./src/precompile.jl")