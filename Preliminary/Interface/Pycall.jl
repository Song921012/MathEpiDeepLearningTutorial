using PyCall
# Method One
py"[1,2]"
py"""
import numpy as np

def sinpi(x):
    return np.sin(np.pi * x)
"""
py"sinpi"(1)


# Method Two: autoconverte the object and can easily import python modules.
np = pyimport("numpy")
pd = pyimport("pandas")

A = np.array([[1, 2], [3, 4]])
B = [1 2; 3 4]
B == A