"""
Created on Thu Nov  10 13:15:35 2020

@author: akeeste

This script recreates the cubes model on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import numpy as np
import os
import sys
sys.path.insert(1,'C:/Users/akeeste/Documents/Software/GitHub/capytaine/my_cases')

import call_capytaine as cc # call_capytaine.py has some mods from david's original function


# Load cubes mesh file ------------------------------------------------------#
cubes_file = (os.getcwd() + os.path.sep + 'r_cube.dat',
             os.getcwd() + os.path.sep + 't_cube.dat') # .dat nemoh, .gdf wamit
cubes_cg = ((0,0,-2.5),
            (100,0,-2.5)) # centers of gravity
cubes_name = ('r_cube_capytaine',
              't_cube_capytaine') # body names

cubes_w = np.linspace(0.03, 15.0, 500) # 500 for full, 3 for tests
cubes_headings = np.linspace(0,90,10)
cubes_depth = -20.0

cubes_nc = True
cubes_ncFile = os.getcwd() + os.path.sep + 'cubes_full.nc'
# ----------------------------------------------------------------------------#

# if os.path.isfile(cubes_ncFile):
#     print(f'Output ({cubes_ncFile}) file already exists and will be overwritten. '
#           'Do you wish to proceed? (y/n)')
#     ans = input()
#     if ans.lower() != 'y':
#         print('\nEnding simulation. file not overwritten')
#         sys.exit(0)

cc.call_capy(meshFName = cubes_file,
             wCapy     = cubes_w,
             CoG       = cubes_cg,
             headings  = cubes_headings,
             saveNc    = cubes_nc,
             ncFName   = cubes_ncFile,
             body_name = cubes_name,
             depth     = cubes_depth,
             density   = 1000.0)

print('\n\nFunction completed. Cubes data is saved.\n')
