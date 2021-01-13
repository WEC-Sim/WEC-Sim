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
sys.path.insert(1,'C:/Users/akeeste/Documents/Software/GitHub/capytaine/my_cases')

import call_capytaine as cc


# Define RM3 parameters ------------------------------------------------------#
rm3_file = (os.getcwd() + os.path.sep + 'float.dat',
             os.getcwd() + os.path.sep + 'spar.dat') # mesh files, .dat nemoh, .gdf wamit
rm3_cg = ((0,0,-0.72),
          (0,0,-21.29))                              # centers of gravity
rm3_name = ('rm3_float',
            'rm3_spar')                              # body names

rm3_w = np.linspace(0.02, 5.2, 3)                    # wave frequencies. 260 for full run
rm3_headings = np.linspace(0,0,1)                    # wave headings
rm3_depth = np.infty                                 # water depth

rm3_ncFile = os.getcwd() + os.path.sep + 'test.nc'   # path for output .nc file
# ----------------------------------------------------------------------------#

# check that old output is not being overwritten (runs take awhile)
if os.path.isfile(rm3_ncFile):
    print(f'Output ({rm3_ncFile}) file already exists and will be overwritten. '
          'Do you wish to proceed? (y/n)')
    ans = input()
    if ans.lower() != 'y':
        print('\nEnding simulation. file not overwritten')
        sys.exit(0)

# Run Capytaine
cd, p = cc.call_capy(meshFName = rm3_file,
              wCapy     = rm3_w,
              CoG       = rm3_cg,
              headings  = rm3_headings,
              ncFName   = rm3_ncFile,
              body_name = rm3_name,
              depth     = rm3_depth,
              density   = 1000.0)
