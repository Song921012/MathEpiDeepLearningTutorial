using Distributions
using Expectations
using StatsBase
using InformationGeometry
dist = LogNormal()
E = expectation(dist)
@show E(x->x^2)
dist1 = Gamma()
E1 = expectation(dist1)
@show E1(x->x^2)

crossentropy([0.2, 0.3, 0.5], [0.3, 0.4, 0.3])

lognormalpdf = x -> pdf(dist,x)

loggammapdf = x -> pdf(dist1,x)

E(x -> lognormalpdf(x))

A = rand(dist,1000)

B = rand(dist1,1000)

dist2 = Normal(1,3)

dist3 = Normal(5,2)

C = kldivergence(dist2,dist3)
KullbackLeibler(dist2,dist3)

D = kldivergence(dist1,dist)
KullbackLeibler(dist,dist3)

E1(x -> log(lognormalpdf(x)))- E1(x -> log(loggammapdf(x)))

KullbackLeibler(x->loggammapdf(x),y->lognormalpdf(y),HyperCube([-20,20]); Carlo=true, N=Int(3e6))

KullbackLeibler(x->pdf(Normal(1,3),x),y->pdf(Normal(5,2),y),HyperCube([-20,20]); Carlo=true, N=Int(3e6))
KullbackLeibler(Normal(1,3),Normal(5,2))
