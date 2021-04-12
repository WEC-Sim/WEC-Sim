# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 13:15:35 2020

@author: akeeste
This script recreates the sphere model based on sample BEM 
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

# Define sphere parameters ---------------------------------------------------#
sphere_file = ((os.getcwd() + os.path.sep + 'sphere.dat'),) # mesh file, .dat nemoh, .gdf wamit
sphere_cg = ((0,0,-2.0),)                                   # center of gravity
sphere_name = ('sphere_cpt',)                               # body name

sphere_w = np.linspace(0.02, 8.4, 3)                        # wave frequencies. 420 for full run
sphere_headings = np.linspace(0,0,1)                        # wave heading
sphere_depth = 50.0                                         # water depth

sphere_ncFile = os.getcwd() + os.path.sep + 'test.nc'       # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(sphere_ncFile):
    print(f'Output ({sphere_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cd, p = cc.call_capy(meshFName = sphere_file,
             wCapy     = sphere_w,
             CoG       = sphere_cg,
             headings  = sphere_headings,
             ncFName   = sphere_ncFile,
             body_name = sphere_name,
             depth     = sphere_depth,
             density   = 1000.0)
