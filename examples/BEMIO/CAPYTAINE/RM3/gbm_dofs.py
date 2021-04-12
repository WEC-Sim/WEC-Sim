# -*- coding: utf-8 -*-
"""
Created on Thu Dec  3 15:31:05 2020

@author: akeeste

Script to create gbm dofs based on an input Capytaine mesh
"""

import capytaine as cpt
import numpy as np

    
def new_dofs(cpt_bodies):
    '''
    Funtion that takes in a capytaine FloatingBody and adds custom GBM dofs to it.
    
    Parameters
    ----------
    cpt_bodies: list
        A list of capytaine FloatingBodies
    
    Returns
    -------
    gbm_dofs: dict of dicts 
        This top level dict holds a dict of dofs for each body. The dict of dofs
        defines the generalized body modes for that body. This format allows an
        inconsistent number of GBM dofs per body, depending on what is desired.
        
        Example:
        gbm_dofs['plate'] --> dof_dict
        doc_dict['Surge'] --> [[1 0 0],[1 0 0],[1 0 0],...[1 0 0]]
    '''

    gbm_dofs = {}
    
    # For different GBM dofs in each body #####################################
    # Body 0 GBM dofs
    b0 = {}
    b0["Bulge"] = cpt_bodies[0].mesh.faces_normals
    b0["x-shear"] = np.array(
        [(np.cos(np.pi*z/2), 0, 0) 
         for x, y, z in cpt_bodies[0].mesh.faces_centers]
        )
    
    # Body 1 GBM dofs
    b1 = {}
    b1["x-shear"] = np.array(
        [(np.cos(np.pi*z/2), 0, 0) 
         for x, y, z in cpt_bodies[1].mesh.faces_centers]
        )
    b1["Bulge"] = cpt_bodies[1].mesh.faces_normals
    
    gbm_dofs[body_names[0]] = b0
    gbm_dofs[body_names[1]] = b1
    
    
    # When using the same GBM dofs for all bodies #############################
    # for body in cpt_bodies:
    #     b = {}
    #     b["Bulge"] = body.mesh.faces_normals
    #     b["x-shear"] = np.array(
    #         [(np.cos(np.pi*z/2), 0, 0)
    #          for x, y, z in body.mesh.faces_centers]
    #         )
    #     gbm_dofs[body.name] = b
    
    return gbm_dofs
