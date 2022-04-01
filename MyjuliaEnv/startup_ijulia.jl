ENV["JUPYTER"] = "F:/Anaconda/envs/ML/Scripts/jupyter.exe"
try
    @eval using Revise
catch e
    @warn "Error initializing Revise" exception = (e, catch_backtrace())
end