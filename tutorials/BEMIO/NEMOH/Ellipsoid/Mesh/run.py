# Import the bemio.mesh_utilities module
from bemio.mesh_utilities import mesh
import numpy as np

# Read WAMIT mesh
ellipsoid = mesh.read(file_name='ellipsoid.gdf')

# Save to a NEMOH mesh
ellipsoid.write(mesh_format='NEMOH')
