# Import the bemio.mesh_utilities module
from bemio.mesh_utilities import mesh
import numpy as np

# Read WAMIT mesh
coer_comp = mesh.read(file_name='coer_comp.GDF')

coer_comp.translate(translation_vect=[0.,0.,-.2])

# Save to a NEMOH mesh
coer_comp.write(mesh_format='NEMOH')
