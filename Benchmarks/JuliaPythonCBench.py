#%%
import numba
from numpy.random import randn

def normal_test(x):
    return x+x*x+x*x*x

@numba.njit
def numba_test(x):
    return x+x*x+x*x*x
x = randn(1000,1000)
#%%
%timeit normal_test(x)

#%%
%timeit numba_test(x)

