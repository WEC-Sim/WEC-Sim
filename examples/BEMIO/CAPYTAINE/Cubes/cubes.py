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


# Define cubes parameters ----------------------------------------------------#
cubes_file = (os.getcwd() + os.path.sep + 'r_cube.dat',
             os.getcwd() + os.path.sep + 't_cube.dat')      # mesh files, .dat nemoh, .gdf wamit
cubes_cg = ((0,0,-2.5),
            (100,0,-2.5))                                   # centers of gravity
cubes_name = ('r_cube_capytaine',
              't_cube_capytaine')                           # body names

cubes_w = np.linspace(0.03, 15.0, 3)                        # wave frequencies. 500 for full run
cubes_headings = np.linspace(0,90,10)                       # wave headings
cubes_depth = 20.0                                          # water depth

cubes_ncFile = os.getcwd() + os.path.sep + 'test.nc'        # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(cubes_ncFile):
    print(f'Output ({cubes_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cd = cc.call_capy(meshFName = cubes_file,
             wCapy     = cubes_w,
             CoG       = cubes_cg,
             headings  = cubes_headings,
             ncFName   = cubes_ncFile,
             body_name = cubes_name,
             depth     = cubes_depth,
             density   = 1000.0)
