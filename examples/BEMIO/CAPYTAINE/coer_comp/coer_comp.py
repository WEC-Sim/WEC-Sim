"""
This script recreates the coercomp model based on sample BEM 
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

# Define Coercomp parameters -------------------------------------------------#
bem_file = ((os.getcwd() + os.path.sep + 'coer_comp.dat'),) # mesh files, .dat nemoh, .gdf wamit
bem_cg = ((0,0,-0.2),)                                      # center of gravity
bem_name = ('coercomp_cpt',)                                # body name

bem_w = np.linspace(0.1, 80, 800)                           # wave frequencies
bem_headings = np.linspace(0,np.pi/2,10)                    # wave headings
bem_depth = 2.20                                            # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'coer_comp.nc'     # path for output .nc file
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
