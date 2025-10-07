import os
import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics

input_data_dir = os.path.dirname(__file__)
output_dir = os.path.join(input_data_dir, 'outputs')
os.makedirs(output_dir, exist_ok=True)

mesh_file = os.path.join(input_data_dir, "coer_comp.dat")
mesh = cpt.load_mesh(mesh_file, file_format="nemoh")
body = cpt.FloatingBody(
    mesh=mesh,
    lid_mesh=mesh.generate_lid(),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -0.2)),
    center_of_mass=(0, 0, -0.2),
    name="coer_comp"
)
body.inertia_matrix = body.compute_rigid_body_inertia()
body.hydrostatic_stiffness = body.immersed_part().compute_hydrostatic_stiffness()

# body.show()  # Uncomment to display the mesh in 3D for verification

test_matrix = xr.Dataset(coords={
    "omega": np.linspace(0.1, 80, 800),
    "radiating_dof": list(body.dofs),
    "wave_direction": np.linspace(0, np.pi/2, 10),
    "water_depth": [2.20],
    "rho": [1000.0],
    })

solver = cpt.BEMSolver()
dataset = solver.fill_dataset(test_matrix, body.immersed_part(), n_jobs=4)

cpt.export_dataset(os.path.join(output_dir, 'coer_comp_hydrodynamics.nc'), dataset)
export_hydrostatics(output_dir, body)

