from bemio.io import wamit
from bemio.io.output import write_hdf5
import os

import matplotlib.pyplot as plt
plt.close('all')
plt.interactive(True)

# Load the data
wamit_data = wamit.WamitOutput(out_file='./wamit_run/oswec.out')
num_bodies = wamit_data.data[0].num_bodies

# Calculate IRF and plot
for i in xrange(num_bodies):
	wamit_data.data[i].calc_irf_excitation()
	wamit_data.data[i].calc_irf_radiation()
	wamit_data.data[i].calc_ss_radiation()

# Save the data in HDF5 format
write_hdf5(wamit_data)
os.rename('./wamit_run/oswec.h5', './oswec.h5')
