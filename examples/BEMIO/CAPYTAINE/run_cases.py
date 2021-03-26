# '-*- coding: utf-8 -*-
"""
Created on Wed Nov 18 11:32:31 2020

@author: akeeste

This script runs all of the Capytaine cases needed for the WEC-Sim bemio examples.
This script runs Capytaine, not BEMIO.

"""
import os
# num of problems in each case is nFrequencies*(nHeadings + nDof*nBodies)
# total: ~47,000 problems, ~10 cases/minute, 81 hours run time

# Single body cases --------------------------------------------------------#
print('Run sphere case') # 2940 problems, ~30 min (no b2b). 
os.chdir("./Sphere")
import sphere

print('Run Ellipsoid case') # 2156 problems, ~30 min (no b2b). 
os.chdir("../Ellipsoid")
import ellipsoid

print('Run Cylinder case') # 3675 problems, ~30 min (no b2b). 
os.chdir("../Cylinder")
import cylinder

print('Run Coer_Comp case') # 12800 problems, ~7 hours (no b2b). 
os.chdir("../Coer_Comp")
import coer_comp


# # Multiple body cases ------------------------------------------------------#
print('Run Cubes case') # 11000 problems, 8.5 hours (new b2b)
os.chdir("../Cubes")
import cubes

print('Run RM3 case') # 3380 problems, 21 hours (new b2b)
os.chdir("../RM3")
import rm3

print('Run OSWEC case') # 11000 problems, 43 hours (new b2b)
os.chdir("../OSWEC")
import oswec


print('All simulations complete.')




