# -*- coding: utf-8 -*-
"""
Created on Thu Nov  10 13:15:35 2020

@author: akeeste
This script recreates an coercomp model based on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import numpy as np
import os
import sys
sys.path.insert(1,'C:/Users/akeeste/Documents/Software/GitHub/capytaine/my_cases')

import call_capytaine as cc # call_capytaine.py has some mods from david's original function


# Define Coercomp parameters -------------------------------------------------#
coercomp_file = ((os.getcwd() + os.path.sep + 'coer_comp.dat'),) # mesh files, .dat nemoh, .gdf wamit
coercomp_cg = ((0,0,-0.2),)                                      # center of gravity
coercomp_name = ('coercomp_cpt',)                                # body name

coercomp_w = np.linspace(0.1, 80, 3)                             # wave frequencies. 800 for full run
coercomp_headings = np.linspace(0,90,10)                         # wave headings
coercomp_depth = 2.20                                            # water depth

coercomp_ncFile = os.getcwd() + os.path.sep + 'test.nc'          # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(coercomp_ncFile):
    print(f'Output ({coercomp_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cc.call_capy(meshFName = coercomp_file,
             wCapy     = coercomp_w,
             CoG       = coercomp_cg,
             headings  = coercomp_headings,
             ncFName   = coercomp_ncFile,
             body_name = coercomp_name,
             depth     = coercomp_depth,
             density   = 1000.0)
