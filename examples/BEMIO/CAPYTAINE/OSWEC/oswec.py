# -*- coding: utf-8 -*-
"""
Created on Mon Nov  10 13:35:00 2020

@author: akeeste
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 13:15:35 2020

@author: akeeste
This script recreates the OSWEC model based on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import numpy as np
import os
import sys
sys.path.insert(1,'C:/Users/akeeste/Documents/Software/GitHub/capytaine/my_cases')

import call_capytaine as cc # call_capytaine.py has some mods from david's original function


# Define OSWEC parameters ----------------------------------------------------#
oswec_file = (os.getcwd() + os.path.sep + 'flap.dat',
             os.getcwd() + os.path.sep + 'base_shift.stl')        # mesh files, base_cut.stl, base.dat nemoh, .gdf wamit
oswec_cg = ((0,0,-3.90),
            (0,0,-10.90))                                         # centers of gravity
oswec_name = ('oswec_flap',
              'oswec_base')                                       # body names

oswec_w = np.linspace(0.04, 20.0, 3)                              # wave frequencies. 500 for full run
oswec_headings = np.linspace(0,90,10)                             # wave headings
oswec_depth = 10.90                                               # water depth

oswec_ncFile = os.getcwd() + os.path.sep + 'test.nc'              # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(oswec_ncFile):
    print(f'Output ({oswec_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cc.call_capy(meshFName = oswec_file,
             wCapy     = oswec_w,
             CoG       = oswec_cg,
             headings  = oswec_headings,
             ncFName   = oswec_ncFile,
             body_name = oswec_name,
             depth     = oswec_depth,
             density   = 1000.0)
