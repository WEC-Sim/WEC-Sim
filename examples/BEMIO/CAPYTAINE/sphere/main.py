import os
import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics

input_data_dir = os.path.dirname(__file__)
output_dir = os.path.join(input_data_dir, 'outputs')
os.makedirs(output_dir, exist_ok=True)

mesh_file = os.path.join(input_data_dir, "sphere.dat")
mesh = cpt.load_mesh(mesh_file, file_format="nemoh")
# Symmetry defined in header of "sphere.dat" is used.
body = cpt.FloatingBody(
    mesh=mesh,
    lid_mesh=mesh.generate_lid(),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -2.0)),
    center_of_mass=(0, 0, -2.0),
    name="floating_sphere"
)
body.inertia_matrix = body.compute_rigid_body_inertia()
body.hydrostatic_stiffness = body.immersed_part().compute_hydrostatic_stiffness()

# body.show()  # Uncomment to display the mesh in 3D for verification

test_matrix = xr.Dataset(coords={
    "omega": np.linspace(0.02, 8.4, 420),
    "radiating_dof": list(body.dofs),
    "wave_direction": [0],
    "water_depth": [50.0],
    "rho": [1000.0],
    })

solver = cpt.BEMSolver()
dataset = solver.fill_dataset(test_matrix, body.immersed_part(), n_jobs=4)

cpt.export_dataset(os.path.join(output_dir, 'sphere_hydrodynamics.nc'), dataset)
export_hydrostatics(output_dir, body)

