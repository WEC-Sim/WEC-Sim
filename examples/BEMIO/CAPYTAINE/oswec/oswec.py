"""
This script recreates the OSWEC model based on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import os
os.environ["OMP_NUM_THREADS"] = "1" 

import numpy as np
import sys

# Add directory with the call_capytaine.py file to the system path.
currentdir = os.path.dirname(os.getcwd())
sys.path.append(currentdir)
import call_capytaine as cc

# Define OSWEC parameters ----------------------------------------------------#
bem_file = (os.getcwd() + os.path.sep + 'flap.dat',
            os.getcwd() + os.path.sep + 'base_shift.stl')       # mesh files, base_cut.stl, base.dat nemoh, .gdf wamit
bem_cg = ((0,0,-3.90),
          (0,0,-10.90))                                         # centers of gravity
bem_name = ('oswec_flap',
            'oswec_base')                                       # body names

bem_w = np.linspace(0.04, 20.0, 500)                            # wave frequencies
bem_headings = np.linspace(0,np.pi/2,10)                        # wave headings
bem_depth = 10.90                                               # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'oswec.nc'             # path for output .nc file
# ----------------------------------------------------------------------------#

# Run Capytaine
if __name__ == '__main__':
    cc.call_capy(meshFName = bem_file,
                 wCapy     = bem_w,
                 CoG       = bem_cg,
                 headings  = bem_headings,
                 ncFName   = bem_ncFile,
                 body_name = bem_name,
                 depth     = bem_depth,
                 density   = 1000.0)
