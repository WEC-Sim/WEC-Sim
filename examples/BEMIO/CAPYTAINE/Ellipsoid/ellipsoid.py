# -*- coding: utf-8 -*-
"""
Created on Thu Nov  10 13:15:35 2020

@author: akeeste
This script recreates an ellipsoid model based on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import numpy as np
import os
import sys
sys.path.insert(1,'C:/Users/akeeste/Documents/Software/GitHub/capytaine/my_cases')

import call_capytaine as cc # call_capytaine.py has some mods from david's original function


# Define ellipsoid parameters ------------------------------------------------#
ellipsoid_file = ((os.getcwd() + os.path.sep + 'ellipsoid.dat'),) # mesh file, .dat nemoh, .gdf wamit
ellipsoid_cg = ((0,0,0),)                                         # center of gravity
ellipsoid_name = ('ellipsoid_cpt',)                               # body name

ellipsoid_w = np.linspace(0.03, 9.24, 3)                          # wave frequencies. 308 for full run
ellipsoid_headings = np.linspace(0,0,1)                           # wave heading
ellipsoid_depth = np.infty                                        # water depth

ellipsoid_ncFile = os.getcwd() + os.path.sep + 'test.nc'          # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(ellipsoid_ncFile):
    print(f'Output ({ellipsoid_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cc.call_capy(meshFName = ellipsoid_file,
             wCapy     = ellipsoid_w,
             CoG       = ellipsoid_cg,
             headings  = ellipsoid_headings,
             ncFName   = ellipsoid_ncFile,
             body_name = ellipsoid_name,
             depth     = ellipsoid_depth,
             density   = 1000.0)

