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
os.chdir("./sphere")
os.system('python sphere.py')

print('Run Ellipsoid case') # 2156 problems, ~30 min (no b2b). 
os.chdir("../ellipsoid")
os.system('python ellipsoid.py')

print('Run Cylinder case') # 3675 problems, ~30 min (no b2b). 
os.chdir("../cylinder")
os.system('python cylinder.py')

print('Run Coer_Comp case') # 12800 problems, ~7 hours (no b2b). 
os.chdir("../coer_comp")
os.system('python coer_comp.py')


# # Multiple body cases ------------------------------------------------------#
print('Run Cubes case') # 11000 problems, 8.5 hours (new b2b)
os.chdir("../cubes")
os.system('python cubes.py')

print('Run OSWEC case') # 11000 problems, 43 hours (new b2b)
os.chdir("../oswec")
os.system('python oswec.py')

# # Multiple body cases + Parallel Computing (an example of 2 cores) ---------#
print('Run RM3 case') # 3380 problems, 21 hours (new b2b)
os.chdir("../rm3")
os.system('python rm3.py')

print('All simulations complete.')




