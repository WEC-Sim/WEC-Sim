"""
This script runs all of the Capytaine cases needed for the WEC-Sim BEMIO examples.
This script runs Capytaine, not BEMIO.

"""

import os
import sys

# Single body cases --------------------------------------------------------#
print('Run sphere case')
os.chdir("./sphere")
os.system('python sphere.py')

print('Run Ellipsoid case')
os.chdir("../ellipsoid")
os.system('python ellipsoid.py')

print('Run Cylinder case') 
os.chdir("../cylinder")
os.system('python cylinder.py')

print('Run Coer_Comp case')
os.chdir("../coer_comp")
os.system('python coer_comp.py')


# # Multiple body cases ------------------------------------------------------#
print('Run Cubes case')
os.chdir("../cubes")
os.system('python cubes.py')

print('Run OSWEC case')
os.chdir("../oswec")
os.system('python oswec.py')

# # Multiple body cases + Parallel Computing (an example of 2 cores) ---------#
print('Run RM3 case')
os.chdir("../rm3")
os.system('python rm3.py')

print('All simulations complete.')




