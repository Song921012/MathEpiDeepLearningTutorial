ENV["PYTHON"] = "F:/Anaconda/envs/ML/python.exe"
ENV["JUPYTER"] = "F:/Anaconda/envs/ML/Scripts/jupyter.exe"
ENV["JULIA_PARDISO"] = "F:/Code/PARDISO"
ENV["CMDSTAN"] = "C:/Users/12475/Documents/.cmdstanr/cmdstan-2.29.0"
try
    using Revise
catch e
    @warn "Error initializing Revise" exception = (e, catch_backtrace())
end
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end
end

atreplinit() do repl
    try
        @eval begin
            using Logging: global_logger
            using TerminalLoggers: TerminalLogger
            global_logger(TerminalLogger())
        end
    catch
    end
end