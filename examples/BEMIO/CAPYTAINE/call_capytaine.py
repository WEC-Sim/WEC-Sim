# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 10:08:14 2020

@author: akeeste

Initial working script by David Ogden from:
https://github.com/mattEhall/FrequencyDomain/blob/b89dd4f4a732fbe4afde56efe2b52c3e32e22d53/FrequencyDomain.py#L842

"""

import numpy as np
# import xarray as xr
import capytaine as cpt
import meshmagick.mesh as mmm
import meshmagick.hydrostatics as mmhs
import xarray as xr
import logging as LOG
import os
# import sys

def __init__(self):
    LOG.info("Capytaine imported.")


def hydrostatics(myBody):
    '''
    use meshmagick functions to calculate and output the hydrostatic stiffness,
    interia, center of gravity, center of buoyancy and displaced volume of a 
    capytaine body

    Parameters
    ----------
    myBody : FloatingBody
        A single capytaine floating body.

    Returns
    -------
    stiffness: array [6x6]
        Hydrostatic stiffness of the submerged portion of the body
    
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
    
    cg = myBody.center_of_mass
    
    # meshmagick currently has issue if a body is copmletely submerged (OSWEC base)
    # use try-except statement to catch this error use alternate function for cb/vo
    # if completely submerged, stiffness is 0
    body_mesh = mmm.Mesh(myBody.mesh.vertices, myBody.mesh.faces, name= myBody.mesh.name)
    try:
        body_hs = mmhs.Hydrostatics(working_mesh=body_mesh,cog=myBody.center_of_mass,
                                            rho_water=1023.0,grav=9.81)
        vo = body_hs.displacement_volume
        cb = body_hs.buoyancy_center
        
        # # initialize stiffness matrix. Currently meshmagick on does 5 stiffness components (no gbm)
        # k_hs = np.zeros([6*nbod, 6*nbod])
        # tmp = [[body_hs.S33, body_hs.S34, body_hs.S35],
        #         [body_hs.S34, body_hs.S44, body_hs.S45],
        #         [body_hs.S35, body_hs.S45, body_hs.S55]]
        # k_hs[i*6+2:i*6+5,i*6+2:i*6+5] = tmp
        # myBody.hydrostatic_stiffness = myBody.add_dofs_labels_to_matrix(k_hs)
        
        hs_s = [body_hs.S33, body_hs.S34, body_hs.S35, body_hs.S44, body_hs.S45, body_hs.S55]
    except:
        # TODO: function to calculate the cb from mesh panels
        vo = body_mesh.volume
        cb = cg
        hs_s = [0, 0, 0, 0, 0, 0]
    
    
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

    

def call_capy_gbm(meshFName, wCapy, CoG=[0,0,0], headings=[0.0], saveNc=False,
              ncFName=None, wDes=None, body_name='', depth=-np.infty,
              density=1025.0,additional_dofs_dir=None):
    '''
    Variation of the call_capy function to develop GBM functionality
    
    additional_dofs should be a dict of dicts (one dict of gbm dofs for each body)
    that defines generalized body modes for the body
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
        
        # if body_name[i] in additional_dofs:
        #     for k,v in additional_dofs[body_name[i]].items():
        #         body_dict["body{0}".format(i)].dofs[k] = v
        
        # add hydrostatics data (cg, cb, vo, C) to the bodies
        body_dict["body{0}".format(i)] = hydrostatics(body_dict["body{0}".format(i)])
    bodies = list(body_dict.values())
    
    # TODO: might need to call extra file to do this right. creating a custom gbm dof is easiest if the mesh is present
    # 1. pass flag or gbm_dofs.py file name to call_capy
    # 2. pass mesh to a local gbm_dofs.py script
    # 3. in the local gbm_dofs.py script, create dofs based on body mesh that is passed in
    # 4. pass dof dict back to call_capy and continue adding to body
    if additional_dofs_dir is not None:
        old_dir = os.getcwd()
        os.chdir(additional_dofs_dir)
        import gbm_dofs
        additional_dofs = gbm_dofs.new_dofs(body_name, bodies)
        
        if body_name[i] in additional_dofs:
            for k,v in additional_dofs[body_name[i]].items():
                body_dict["body{0}".format(i)].dofs[k] = v
        
        os.chdir(old_dir)
    
    
    # get indices where each bodies mesh starts/ends
    imesh = np.zeros(len(bodies)+1,'int') # [0, nMesh1, nMesh2, nMesh3, ...]
    imesh[0] = int(imesh[0])
    for i,body in zip(np.arange(0,len(bodies),1),bodies):
        imesh[i+1] = int(imesh[i] + len(bodies[i].dofs['Surge']))
    
    # are these 3 lines still needed? maybe running problems on combo will give correct b2b added mass and rad damping
    combo = bodies[0]
    for i in np.arange(1,len(bodies),1):
        combo += bodies[i]
    
    # dict of combined dofs for both bodies
    if len(bodies)>1:
        all_dofs = cpt.FloatingBody.combine_dofs(bodies)
        
        # remove old non-body-specific dofs
        std_dofs = bodies[0].dofs.copy()
        for body in bodies:
            for dof in std_dofs:
                del body.dofs[dof]
    else:
        all_dofs = bodies[0].dofs
            
    
    # add new b2b dofs
    for i,body in zip(np.arange(0,len(bodies),1),bodies):
        for new_dof in all_dofs:
            # ndofs = int(len(all_dofs[new_dof])/len(bodies))
            # body.dofs[new_dof] = all_dofs[new_dof][ndofs*i:ndofs*(i+1),:]
            body.dofs[new_dof] = all_dofs[new_dof][imesh[i]:imesh[i+1],:]

    
    # define the hydrodynamic problems with all body dofs
    # do not use: results +=; results.merge; results.update() 
    #    - these add or replace results instead of appending. Add problems insteads
    problems = [cpt.RadiationProblem(body=body1,
                                      radiating_dof=dof,
                                      omega=w,
                                      sea_bottom=depth,
                                      g=9.81,
                                      rho=density)
                                      for body1 in bodies for dof in all_dofs for w in wCapy]
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
    
    # use to test read_capytaine_v1() ability to catch and reorder dofs
    # sorted_idofs = ["Heave", "Sway", "Pitch", "Surge", "Yaw", "Roll"]
    # sorted_rdofs = ["Sway", "Heave", "Surge", "Roll", "Pitch", "Yaw"]
    # capyData = capyData.sel(radiating_dof=sorted_idofs, influenced_dof=sorted_rdofs)


    # save to .nc file
    cpt.io.xarray.separate_complex_values(capyData).to_netcdf(ncFName)
    
    return capyData, problems



def call_capy(meshFName, wCapy, CoG=([0,0,0],), headings=[0.0], saveNc=False,
              ncFName=None, wDes=None, body_name=('',), depth=-np.infty,
              density=1025.0):
    '''
    call Capytaine for a given mesh, frequency range and wave headings
    This function is taken from David Ogden's work 
    (see https://github.com/mattEhall/FrequencyDomain/blob/b89dd4f4a732fbe4afde56efe2b52c3e32e22d53/FrequencyDomain.py#L842 for the original function).
    
    May be called with multiple bodies (automatically implements B2B). In this case, 
    the meshFName, CoG, body_name should be a tuple of the values for each body
    
    Dependencies
    ------------
    Hydrostatics requires one minor change to Capytaine/io/xarray.py line 166 
    from:
        for body_property in ['mass','hydrostatic_stiffness']
    to:
        for body_property in ['mass', 'center_of_buoyancy', 'center_of_mass', 'displaced_volume' ,'hydrostatic_stiffness']
    
    

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
    
    # get indices where each bodies mesh starts/ends
    imesh = np.zeros(len(bodies)+1,'int') # [0, nMesh1, nMesh2, nMesh3, ...]
    imesh[0] = int(imesh[0])
    for i,body in zip(np.arange(0,len(bodies),1),bodies):
        imesh[i+1] = int(imesh[i] + len(bodies[i].dofs['Surge']))
            
    # add gbm dofs here or before
    
    # are these 3 lines still needed? maybe running problems on combo will give correct b2b added mass and rad damping
    combo = bodies[0]
    for i in np.arange(1,len(bodies),1):
        combo += bodies[i]
    
    # combine hydrostatics for all bodies
    vo = np.zeros([len(bodies)])
    cg = np.zeros([len(bodies),3])
    cb = np.zeros([len(bodies),3])
    khs = np.zeros([len(bodies),6])
    body_dof = []
    for i in np.arange(0,len(bodies)):
        vo[i] = np.asarray(bodies[i].displaced_volume)
        cg[i][:] = np.asarray(bodies[i].center_of_mass)
        cb[i][:] = np.asarray(bodies[i].center_of_buoyancy)
        khs[i][:] = np.asarray(bodies[i].hydrostatic_stiffness)
        body_dof.append('body'+str(i))
    
    combo.displaced_volume =      xr.DataArray(data=np.asarray(vo), dims=['bodies'],
                                               coords={'bodies': body_dof})
    combo.center_of_mass =        xr.DataArray(data=np.asarray(cg), dims=['bodies','xyz'],
                                               coords={'xyz': ['x','y','z'],
                                                       'bodies': body_dof},
                                               )
    combo.center_of_buoyancy =    xr.DataArray(data=np.asarray(cb), dims=['bodies','xyz'],
                                               coords={'xyz': ['x','y','z'],
                                                       'bodies': body_dof},
                                               )
    combo.hydrostatic_stiffness = xr.DataArray(data=np.asarray(khs), dims=['bodies','hydrostatic_S'],
                                               coords={'hydrostatic_S': ['S33','S34','S35','S44','S45','S55'],
                                                       'bodies': body_dof},
                                               )
        
    
    # define the hydrodynamic problems with all body dofs
    # do not use: results +=; results.merge; results.update() 
    #    - these add or replace results instead of appending. Add problems insteads
    problems = [cpt.RadiationProblem(body=combo,
                                      radiating_dof=dof,
                                      omega=w,
                                      sea_bottom=depth,
                                      g=9.81,
                                      rho=density)
                                      for dof in combo.dofs for w in wCapy]
    problems += [cpt.DiffractionProblem(body=combo,
                                        omega=w,
                                        wave_direction=heading,
                                        sea_bottom=depth,
                                        g=9.81,
                                        rho=density)
                                        for w in wCapy for heading in headings]
    

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
    
    # use to test read_capytaine_v1() ability to catch and reorder dofs
    # sorted_idofs = ["Heave", "Sway", "Pitch", "Surge", "Yaw", "Roll"]
    # sorted_rdofs = ["Sway", "Heave", "Surge", "Roll", "Pitch", "Yaw"]
    # capyData = capyData.sel(radiating_dof=sorted_idofs, influenced_dof=sorted_rdofs)


    # save to .nc file
    cpt.io.xarray.separate_complex_values(capyData).to_netcdf(ncFName)
    
    return capyData, problems
