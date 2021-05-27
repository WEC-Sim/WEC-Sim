# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 13:15:35 2020

@author: akeeste
This script recreates the RM3 model based on sample BEM 
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

# Define RM3 parameters ------------------------------------------------------#
bem_file = (os.getcwd() + os.path.sep + 'float.dat',
            os.getcwd() + os.path.sep + 'spar.dat' ) # mesh files, .dat nemoh, .gdf wamit
bem_cg = ((0,0,-0.72),
          (0,0,-21.29))                              # centers of gravity
bem_name = ('rm3_float',
            'rm3_spar')                              # body names

bem_w = np.linspace(0.02, 5.2, 3)                    # wave frequencies. 260 for full run
bem_headings = np.linspace(0,0,1)                    # wave headings
bem_depth = np.infty                                 # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'test.nc'   # path for output .nc file
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
