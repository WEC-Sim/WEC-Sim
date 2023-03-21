"""
Simple example of running Capytaine and Meshmagick for WEC-Sim.

Also see:
Capytaine/docs/user_manual/examples directory
User Manual cookbook in documentation

"""

import capytaine as cpt
import numpy as np
import xarray as xr

# 1. Create a Capytaine 'FloatingBody' and assign appropriate properties and dofs
# A. Create the body from a mesh or a pre-packaged geometry
#    The mesh is the same format as Nemoh: mesh origin at the SWL, cg relative 
#    to the mesh origin.
#    NOTE: input meshes should not have a lid
body = cpt.FloatingBody.from_file('Sphere/sphere.dat') # many file types supported
# body = cpt.Sphere(radius=5.0,center=(0,0,-2),nphi=50,ntheta=50)

# B. Define the center of gravity, this is necessary for the rotational dofs 
#    to be calculated about the center of mass and not the mesh origin
body.center_of_mass = (0,0,-2)

# C. Cut the mesh at the SWL. This may or may not be redundant. It is necessary
#    for the prepackaged Capytaine geometries
body.keep_immersed_part()

# D. Add degrees of freedom
body.add_all_rigid_body_dofs()

# E. Define simulation parameters
freq = np.linspace(0.02, 8.4, 3)
directions = np.linspace(0,np.pi/2,2)


# 2. Define a list of problems to be solved. Can be radiation problems or 
#    diffraction problems. (
#    Uses python 'list comprehension' to easily loop through all dofs / freq
problems = [cpt.RadiationProblem(body=body,
                              radiating_dof=dof,
                              omega=w,
                              sea_bottom=-np.infty,
                              g=9.81,
                              rho=1000.0)
                              for dof in body.dofs for w in freq]
problems += [cpt.DiffractionProblem(body=body,
                                omega=w,
                                wave_direction=heading,
                                sea_bottom=-np.infty,
                                g=9.81,
                                rho=1000.0)
                                for w in freq for heading in directions]

# 3. Define the BEM solver to be used. 
solver = cpt.BEMSolver()

# 4. Loop through the problems and solve each
results = [solver.solve(problem, keep_details=True) for problem in sorted(problems)]

# 5. Create a dataset using the list of results and any hydrostatics output
capyData = cpt.assemble_dataset(results, hydrostatics=False)


###############################################################################
# ** Alternate method to 2-5
#    Create a dataset of parameters. 
#    'fill_dataset()' automatically creates problems and solves them.
#    This method is easy and clean, but has less control on the problem details
test_matrix = xr.Dataset(coords={
    'omega': freq,
    'wave_direction': directions,
    'radiating_dof': list(body.dofs),
    'water_depth': [np.infty],
    })
dataset = solver.fill_dataset(test_matrix, [body], hydrostatics=False)
###############################################################################

# 6. Separate complex values and save to .nc file
ncFName = 'demo.nc'
cpt.io.xarray.separate_complex_values(capyData).to_netcdf(ncFName)

# 7. Use Read_CAPYTAINE() function in WEC-Sim BEMIO