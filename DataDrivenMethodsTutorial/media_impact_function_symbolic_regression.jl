using SymbolicRegression
using Bijectors
I = collect(0:0.1:10)
f(x) = 0.2exp(-0.01*x)*x
Y = f.(I)

options = SymbolicRegression.Options(
    binary_operators=(+, *, /, -),
    unary_operators=(exp,),
    npopulations=20
)

hallOfFame = EquationSearch(I', Y, niterations=5, options=options, numprocs=4)
dominating = calculateParetoFrontier(I, Y, hallOfFame, options)
eqn = node_to_symbolic(dominating[end].tree, options)