# -*- coding: utf-8 -*-
"""
Created on Thu Nov  10 13:15:35 2020

@author: akeeste
This script recreates the cylinder model based on sample BEM 
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

# Define cylinder parameters -------------------------------------------------#
bem_file = ((os.getcwd() + os.path.sep + 'cylinder.dat'),) # mesh file, .dat nemoh, .gdf wamit
bem_cg = ((0,0,0),)                                        # center of gravity
bem_name = ('cylinder_cpt',)                               # body name

bem_w = np.linspace(0.04, 21.0, 3)                         # wave frequencies. 525 for full run
bem_headings = np.linspace(0,0,1)                          # wave heading
bem_depth = 3.0                                            # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'test.nc'         # path for output .nc file
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
