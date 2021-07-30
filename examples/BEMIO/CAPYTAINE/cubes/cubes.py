# -*- coding: utf-8 -*-
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

# Add directory with the call_capytaine.py file to the system path.
currentdir = os.path.dirname(os.getcwd())
sys.path.append(currentdir)
import call_capytaine as cc

# Define cubes parameters ----------------------------------------------------#
bem_file = (os.getcwd() + os.path.sep + 'r_cube.dat',
            os.getcwd() + os.path.sep + 't_cube.dat')      # mesh files, .dat nemoh, .gdf wamit
bem_cg = ((0,0,-2.5),
            (100,0,-2.5))                                   # centers of gravity
bem_name = ('r_cube_capytaine',
            't_cube_capytaine')                           # body names

bem_w = np.linspace(0.03, 15.0, 3)                        # wave frequencies. 500 for full run
bem_headings = np.linspace(0,90,10)                       # wave headings
bem_depth = 20.0                                          # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'test.nc'        # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(bem_ncFile):
    print(f'Output ({bem_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cc.call_capy(meshFName = bem_file,
             wCapy     = bem_w,
             CoG       = bem_cg,
             headings  = bem_headings,
             ncFName   = bem_ncFile,
             body_name = bem_name,
             depth     = bem_depth,
             density   = 1000.0)
