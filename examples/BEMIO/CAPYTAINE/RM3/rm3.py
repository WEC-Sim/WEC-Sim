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

import call_capytaine as cc # call_capytaine.py has some mods from david's original function


# Load rm3 mesh file ------------------------------------------------------#
rm3_file = (os.getcwd() + os.path.sep + 'float.dat',
             os.getcwd() + os.path.sep + 'spar.dat') # .dat nemoh, .gdf wamit
rm3_cg = ((0,0,-0.72),
            (0,0,-21.29)) # centers of gravity
rm3_name = ('rm3_float',
            'rm3_spar') # body names

rm3_w = np.linspace(0.02, 5.2, 260) # 260 for full, 3 for tests
rm3_headings = np.linspace(0,0,1)
rm3_depth = -np.infty

rm3_nc = True
rm3_ncFile = os.getcwd() + os.path.sep + 'rm3_full.nc'
# ----------------------------------------------------------------------------#

# if os.path.isfile(rm3_ncFile):
#     print(f'Output ({rm3_ncFile}) file already exists and will be overwritten. '
#           'Do you wish to proceed? (y/n)')
#     ans = input()
#     if ans.lower() != 'y':
#         print('\nEnding simulation. file not overwritten')
#         sys.exit(0)

cc.call_capy(meshFName = rm3_file,
             wCapy     = rm3_w,
             CoG       = rm3_cg,
             headings  = rm3_headings,
             saveNc    = rm3_nc,
             ncFName   = rm3_ncFile,
             body_name = rm3_name,
             depth     = rm3_depth,
             density   = 1000.0)

print('\n\nFunction completed. RM3 data is saved.\n')
