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
cylinder_file = ((os.getcwd() + os.path.sep + 'cyl_R1D1.dat'),) # mesh file, .dat nemoh, .gdf wamit
cylinder_cg = ((0,0,1),)                                        # center of gravity
cylinder_name = ('cylinder_cpt',)                               # body name

cylinder_w = np.linspace(0.01, 5.0, 1000)                         # wave frequencies. 525 for full run
cylinder_headings = np.linspace(0,0,1)                          # wave heading
cylinder_depth = 3.0                                            # water depth

cylinder_ncFile = os.getcwd() + os.path.sep + 'test.nc'         # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(cylinder_ncFile):
    print(f'Output ({cylinder_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cc.call_capy(meshFName = cylinder_file,
             wCapy     = cylinder_w,
             CoG       = cylinder_cg,
             headings  = cylinder_headings,
             ncFName   = cylinder_ncFile,
             body_name = cylinder_name,
             depth     = cylinder_depth,
             density   = 1000.0)
