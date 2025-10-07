import os
import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics

input_data_dir = os.path.dirname(__file__)
output_dir = os.path.join(input_data_dir, 'outputs')
os.makedirs(output_dir, exist_ok=True)

flap_mesh_file = os.path.join(input_data_dir, "flap.dat")
flap_mesh = cpt.load_mesh(flap_mesh_file, file_format="nemoh")
flap_body = cpt.FloatingBody(
    mesh=flap_mesh,
    lid_mesh=flap_mesh.generate_lid(),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -3.90)),
    center_of_mass=(0, 0, -3.90),
    name="oswec_flap"
)
flap_body.inertia_matrix = flap_body.compute_rigid_body_inertia()
flap_body.hydrostatic_stiffness = flap_body.immersed_part().compute_hydrostatic_stiffness()

base_shift_mesh_file = os.path.join(input_data_dir, "base_shift.stl")
base_shift_mesh = cpt.load_mesh(base_shift_mesh_file, file_format="stl")
base_shift_body = cpt.FloatingBody(
    mesh=base_shift_mesh,
    # no lid for fully immersed base
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -10.90)),
    center_of_mass=(0, 0, -10.90),
    name="oswec_base_shift"
)
base_shift_body.inertia_matrix = base_shift_body.compute_rigid_body_inertia()
base_shift_body.hydrostatic_stiffness = base_shift_body.immersed_part().compute_hydrostatic_stiffness()

oswec_body = flap_body + base_shift_body
# oswec_body.show()  # Uncomment to display the mesh in 3D for verification

test_matrix = xr.Dataset(coords={
    "omega": np.linspace(0.04, 20.0, 500),
    "radiating_dof": list(oswec_body.dofs),
    "wave_direction": np.linspace(0.0, np.pi/2, 10),
    "water_depth": [10.90],
    "rho": [1000.0],
    })

solver = cpt.BEMSolver()
dataset = solver.fill_dataset(test_matrix, oswec_body.immersed_part(), n_jobs=2)

cpt.export_dataset(os.path.join(output_dir, 'oswec_hydrodynamics.nc'), dataset)
export_hydrostatics(output_dir, [flap_body, base_shift_body])

