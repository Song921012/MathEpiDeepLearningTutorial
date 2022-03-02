using Pardiso
using SparseArrays
ps = PardisoSolver()

A = sparse(rand(2, 2))
B = rand(2, 2)
X = zeros(2, 2)
solve!(ps, X, A, B)