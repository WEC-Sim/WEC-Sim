# Import the bemio.mesh_utilities module
from bemio.mesh_utilities import mesh
import numpy as np

# Read WAMIT mesh
base = mesh.read(file_name='base.GDF')

# Save to a NEMOH mesh
base.write(mesh_format='NEMOH')
