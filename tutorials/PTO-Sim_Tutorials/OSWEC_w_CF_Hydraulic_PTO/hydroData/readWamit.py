from bemio.io.wamit import read
from bemio.io.output import write_hdf5
import os

import matplotlib.pyplot as plt
plt.close('all')
plt.interactive(True)

# Load the data
wamit_data = read(out_file='./wamit_data/oswec.out')
num_bodies = wamit_data.body[0].num_bodies

# Calculate IRF and plot
for i in xrange(num_bodies):
	wamit_data.body[i].calc_irf_excitation(t_end=30.)
	wamit_data.body[i].calc_irf_radiation(t_end=30.)
	# wamit_data.body[i].calc_ss_radiation()

# Save the data in HDF5 format
write_hdf5(wamit_data,out_file='oswec.h5')
