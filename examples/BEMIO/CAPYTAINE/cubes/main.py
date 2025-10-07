import os
import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics

input_data_dir = os.path.dirname(__file__)
output_dir = os.path.join(input_data_dir, 'outputs')
os.makedirs(output_dir, exist_ok=True)

r_cube_mesh_file = os.path.join(input_data_dir, "r_cube.dat")
r_cube_mesh = cpt.load_mesh(r_cube_mesh_file, file_format="nemoh")
r_cube_body = cpt.FloatingBody(
    mesh=r_cube_mesh,
    lid_mesh=r_cube_mesh.generate_lid(),
    dofs=cpt.rigid_body_dofs(rotation_center=(0, 0, -2.5)),
    center_of_mass=(0, 0, -2.5),
    name="r_cube"
)
r_cube_body.inertia_matrix = r_cube_body.compute_rigid_body_inertia()
r_cube_body.hydrostatic_stiffness = r_cube_body.immersed_part().compute_hydrostatic_stiffness()

t_cube_mesh_file = os.path.join(input_data_dir, "t_cube.dat")
t_cube_mesh = cpt.load_mesh(t_cube_mesh_file, file_format="dat")
t_cube_body = cpt.FloatingBody(
    mesh=t_cube_mesh,
    lid_mesh=t_cube_mesh.generate_lid(),
    dofs=cpt.rigid_body_dofs(rotation_center=(100.0, 0, -2.5)),
    center_of_mass=(100.0, 0, -2.5),
    name="t_cube"
)
t_cube_body.inertia_matrix = t_cube_body.compute_rigid_body_inertia()
t_cube_body.hydrostatic_stiffness = t_cube_body.immersed_part().compute_hydrostatic_stiffness()

cubes_body = r_cube_body + t_cube_body
# cubes_body.show()  # Uncomment to display the mesh in 3D for verification

test_matrix = xr.Dataset(coords={
    "omega": np.linspace(0.03, 15.0, 500),
    "radiating_dof": list(cubes_body.dofs),
    "wave_direction": np.linspace(0.0, np.pi/2, 10),
    "water_depth": [20.0],
    "rho": [1000.0],
    })

solver = cpt.BEMSolver()
dataset = solver.fill_dataset(test_matrix, cubes_body.immersed_part(), n_jobs=2)

cpt.export_dataset(os.path.join(output_dir, 'cubes_hydrodynamics.nc'), dataset)
export_hydrostatics(output_dir, [r_cube_body, t_cube_body])

