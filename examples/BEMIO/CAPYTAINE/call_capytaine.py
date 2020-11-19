# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 10:08:14 2020

@author: akeeste

Initial working script provided by David Ogden here:
https://github.com/mattEhall/FrequencyDomain/blob/b89dd4f4a732fbe4afde56efe2b52c3e32e22d53/FrequencyDomain.py#L842

This script calls Capytaine
"""

import numpy as np
import capytaine as cpt
import meshmagick.mesh as mmm
import meshmagick.hydrostatics as mmhs
import xarray as xr
import logging as LOG

def __init__(self):
    LOG.info("Capytaine imported.")

def hydrostatics(myBody):
    '''
    use meshmagick functions to calculate and output the hydrostatic stiffness,
    center of gravity, center of buoyancy and displaced volume of a 
    capytaine floating body

    Parameters
    ----------
    myBody : FloatingBody
        A single capytaine floating body.

    Returns
    -------
    myBody: FloatingBody
	The same floating body that is input with the following hydrostatics quantities assigned as attributes:

    stiffness: array [6x1]
        Hydrostatic stiffness of the submerged portion of the body. Currently output as an array of the stiffness matrix components: [S33, S34, S35, S44, S45, S55]
    
    center_of_mass: array [x,y,z]
        Coordinates of the body's center of gravity. If the body does not have 
        a defined cg, the function assumes constant density and this is 
        equivalent to the center of buoyancy (e.g. the center of volume)
    
    center_of_buoyancy: array [x,y,z]
        Coordinates of the body's center of buoyancy. This is the volumetric 
        center of the submerged part of the body.
    
    disp_vol: float
        Displaced volume of water by the submerged body.
    '''
    
    body_mesh = mmm.Mesh(myBody.mesh.vertices, myBody.mesh.faces, name= myBody.mesh.name)
    body_hs = mmhs.Hydrostatics(working_mesh=body_mesh,cog=myBody.center_of_mass,
                                           rho_water=1023.0,grav=9.81)
    
    vo = body_hs.displacement_volume
    cg = myBody.center_of_mass
    cb = body_hs.buoyancy_center
    
    hs_s = [body_hs.S33, body_hs.S34, body_hs.S35, body_hs.S44, body_hs.S45, body_hs.S55]
    hs_s = np.asarray(hs_s)
    myBody.hydrostatic_stiffness = xr.DataArray(data=hs_s, dims=['hydrostatic_S'],
                                coords={'hydrostatic_S': ['S33','S34','S35','S44','S45','S55']},
                                )
    
    myBody.displaced_volume = xr.DataArray(data=np.asarray(vo))
    myBody.center_of_mass = xr.DataArray(data=np.asarray(cg), dims=['xyz'],
                                coords={'xyz': ['x','y','z']},
                                )
    myBody.center_of_buoyancy = xr.DataArray(data=np.asarray(cb), dims=['xyz'],
                            coords={'xyz': ['x','y','z']},
                            )
        
    # return body with hydrostatics data
    return myBody


def call_capy(meshFName, wCapy, CoG=([0,0,0],), headings=[0.0], saveNc=False,
              ncFName=None, wDes=None, body_name=('',), depth=-np.infty,
              density=1025.0):
    '''
    call Capytaine for a given mesh, frequency range and wave headings
    
    May be called with multiple bodies (no B2B interaction). In this case, 
    the meshFName, CoG, body_name should contains the values for each body. Must be a tuple regardless of number of bodies.

    Currently, generalized body modes and body-to-body interaction is not supported for inputs. Development in progress.

    Parameters
    ----------
    meshFName : tuple of strings
        Tuple containing a string for the path to each body's hydrodynamic mesh.
        mesh must be cropped at waterline (OXY plane) and have no lid
    wCapy: array
        array of frequency points to be computed by Capytaine
    CoG: tuple of lists
        tuple contains a 3x1 list of each body's CoG
    headings: list
        list of wave headings to compute
    saveNc: Bool
        save results to .nc file
    ncFName: str
        name of .nc file
    wDes: array
        array of desired frequency points
        (for interpolation of wCapy-based Capytaine data)
    body_name: tuple of strings
        Tuple containing strings. Strings are the names of each body. 
        Prevent the body name from being a long file path
    depth: float
        Water depth. Should be negative. Use decimal value to prevent 
        Capytaine outputting int32 types. Default is -np.infty
    density: float
        Water density. Use decimal value to prevent Capytaine outputting int32 
        types. Default 1025.0

    Returns
    -------
    hydrodynamic coefficients; as computed or interpolated

    Notes
    -----
    TODO:
    - expand to generalized body modes using an additional_dof parameter
    - expand to B2B interactions
    '''
    
    # Create Capytaine floating bodies form each mesh file and calculate 
    # additional body properties (cg, dofs, hydrostatics). 
    body_dict = {}
    for i in np.arange(0, len(meshFName)):
        body_dict["body{0}".format(i)] = cpt.FloatingBody.from_file(meshFName[i])
        body_dict["body{0}".format(i)].center_of_mass = CoG[i]
        body_dict["body{0}".format(i)].keep_immersed_part()
        if body_name != '':
            body_dict["body{0}".format(i)].name = body_name[i]
        body_dict["body{0}".format(i)].add_all_rigid_body_dofs()
        
        # add hydrostatics data (cg, cb, vo, C) to the bodies
        body_dict["body{0}".format(i)] = hydrostatics(body_dict["body{0}".format(i)])
    bodies = list(body_dict.values())
    
    
    # define the hydrodynamic problems
    problems = [cpt.RadiationProblem(body=body1,
                                     radiating_dof=dof,
                                     omega=w,
                                     sea_bottom=depth,
                                     g=9.81,
                                     rho=density)
                                     for body1 in bodies for dof in body1.dofs for w in wCapy]

    problems += [cpt.DiffractionProblem(body=body1,
                                        omega=w,
                                        wave_direction=heading,
                                        sea_bottom=depth,
                                        g=9.81,
                                        rho=density)
                                        for body1 in bodies for w in wCapy for heading in headings]

    # call Capytaine solver
    print(f'\n-------------------------------\n'
          f'Calling Capytaine BEM solver...\n'
          f'-------------------------------\n'
          f'mesh = {meshFName}\n'
          f'w range = {wCapy[0]:.3f} - {wCapy[-1]:.3f} rad/s\n'
          f'dw = {(wCapy[1]-wCapy[0]):.3f} rad/s\n'
          f'no of headings = {len(headings)}\n'
          f'no of radiation & diffraction problems = {len(problems)}\n'
          f'-------------------------------\n')

    solver = cpt.BEMSolver()
    results = [solver.solve(problem, keep_details=True) for problem in sorted(problems)]
    capyData = cpt.assemble_dataset(results,
                                    hydrostatics=True)
    
    # add kochin diffraction results
    # kochin = cpt.io.xarray.kochin_data_array(results, headings)
    # capyData.update(kochin)

    # (optional) save to .nc file
    if saveNc == True:
        cpt.io.xarray.separate_complex_values(capyData).to_netcdf(ncFName)
    
    return capyData
