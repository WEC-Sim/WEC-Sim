import os
import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics

input_data_dir = os.path.dirname(__file__)
output_dir = os.path.join(input_data_dir, 'outputs')
os.makedirs(output_dir, exist_ok=True)

float_mesh_file = os.path.join(input_data_dir, "float.dat")
float_mesh = cpt.load_mesh(float_mesh_file, file_format="nemoh")
float_body = cpt.FloatingBody(
    mesh=float_mesh,
    lid_mesh=float_mesh.generate_lid(faces_max_radius=0.4),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -0.72)),
    center_of_mass=(0, 0, -0.72),
    name="rm3_float"
)
float_body.inertia_matrix = float_body.compute_rigid_body_inertia()
float_body.hydrostatic_stiffness = float_body.immersed_part().compute_hydrostatic_stiffness()

spar_mesh_file = os.path.join(input_data_dir, "spar.dat")
spar_mesh = cpt.load_mesh(spar_mesh_file, file_format="nemoh")
spar_body = cpt.FloatingBody(
    mesh=spar_mesh,
    lid_mesh=spar_mesh.generate_lid(faces_max_radius=0.4),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -21.29)),
    center_of_mass=(0, 0, -21.29),
    name="rm3_spar"
)
spar_body.inertia_matrix = spar_body.compute_rigid_body_inertia()
spar_body.hydrostatic_stiffness = spar_body.immersed_part().compute_hydrostatic_stiffness()

rm3_body = float_body + spar_body
# rm3_body.show()  # Uncomment to display the mesh in 3D for verification

test_matrix = xr.Dataset(coords={
    "omega": np.linspace(0.02, 5.2, 260),
    "radiating_dof": list(rm3_body.dofs),
    "wave_direction": [0],
    "water_depth": [np.inf],
    "rho": [1000.0],
    })

solver = cpt.BEMSolver()
dataset = solver.fill_dataset(test_matrix, rm3_body.immersed_part(), n_jobs=2)

cpt.export_dataset(os.path.join(output_dir, 'rm3_hydrodynamics.nc'), dataset)
export_hydrostatics(output_dir, [float_body, spar_body])

