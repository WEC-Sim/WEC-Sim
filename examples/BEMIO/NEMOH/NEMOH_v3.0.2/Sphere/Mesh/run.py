# Import the bemio.mesh_utilities module
from bemio.mesh_utilities import mesh
import numpy as np

# Read WAMIT mesh
sphere = mesh.read(file_name='sphere.gdf')

# Save to a NEMOH mesh
sphere.write(mesh_format='NEMOH')
