"""
This script recreates the RM3 model based on sample BEM 
parameters from WEC-Sim (frequency range, directions, etc)

"""

# setup environment
import os
os.environ["OMP_NUM_THREADS"] = "2" 

import numpy as np
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

bem_w = np.linspace(0.02, 5.2, 260)                  # wave frequencies
bem_headings = np.linspace(0,np.pi/2,1)              # wave headings
bem_depth = np.infty                                 # water depth

bem_ncFile = os.getcwd() + os.path.sep + 'rm3.nc'    # path for output .nc file

num_threads = 2                                      # number of threads for parallelization (in wave frequency)
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
                 density   = 1000.0,
                 num_threads = num_threads)
