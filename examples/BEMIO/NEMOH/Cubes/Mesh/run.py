# Import the bemio.mesh_utilities module
from bemio.mesh_utilities import mesh
import numpy as np

# Read WAMIT mesh
r_cube = mesh.read(file_name='r_cube.gdf')

# Save to a NEMOH mesh
r_cube.write(mesh_format='NEMOH')
