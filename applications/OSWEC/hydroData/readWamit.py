from bemio.io import wamit
from bemio.io.output import write_hdf5

import matplotlib.pyplot as plt
plt.close('all')
plt.interactive(True)

# Load the data
w = wamit.WamitOutput(out_file='oswec.out')

print w.data[0].num_bodies

# Calculate IRF and plot
for i in xrange(w.data[0].num_bodies):
	w.data[i].calc_irf_excitation()
#	w.data[i].calc_ss_excitation()

# Save the data in HDF5 format
write_hdf5(w)