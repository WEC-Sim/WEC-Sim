# '-*- coding: utf-8 -*-
"""
Created on Wed Nov 18 11:32:31 2020

@author: akeeste

This script runs all of the current cases for WEC-Sim bemio examples.

"""
import os
# num of problems in each case is bodies*frequencies*(headings + dof)
# total: 41,211  cases, ~100 cases/minute, 7 hours run time

# # Single body cases --------------------------------------------------------#
# print('Run sphere case') # 2940, ~30 min (no b2b). 
# os.chdir("./Sphere")
# import sphere

# print('Run Ellipsoid case') # 2156, ~30 min (no b2b). 
# os.chdir("../Ellipsoid")
# import ellipsoid

# print('Run Cylinder case') # 3675, ~30 min (no b2b). 
# os.chdir("../Cylinder")
# import cylinder

# print('Run Coer_Comp case') # 12800, ~7 hours (no b2b). 
# os.chdir("../Coer_Comp")
# import coer_comp


# # Multiple body cases ------------------------------------------------------#
print('Run Cubes case') # 16000, ~1.5 hours (no b2b). 22000, 1.75 hours (old b2b). 11000, 8.5 hours (new b2b)
os.chdir("./Cubes")
import cubes

# print('Run RM3 case') # 3640, ~2.5 hours (no b2b). 6760, 2.5 hours (old b2b). 3380, 21 hours (new b2b)
# os.chdir("../RM3")
# import rm3

print('Run OSWEC case') # 16000, 6.5 hours (no b2b). 11000, 43 hours (new b2b)
os.chdir("../OSWEC")
import oswec


print('All simulations complete.')




