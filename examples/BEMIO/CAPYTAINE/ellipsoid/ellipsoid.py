"""
This script recreates the ellipsoid model based on sample BEM 
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

# Define ellipsoid parameters ------------------------------------------------#
bem_file = ((os.getcwd() + os.path.sep + 'ellipsoid.dat'),) # mesh file, .dat nemoh, .gdf wamit
bem_cg = ((0,0,0),)                                         # center of gravity
bem_name = ('ellipsoid_cpt',)                               # body name

bem_w = np.linspace(0.03, 9.24, 308)                        # wave frequencies
bem_headings = np.linspace(0,np.pi/2,1)                     # wave heading
bem_depth = np.infty                                        # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'ellipsoid.nc'     # path for output .nc file
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

