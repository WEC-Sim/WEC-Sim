# Import bemio modules
from bemio.io.wamit import read
from bemio.io.output import write_hdf5

# Load the data
wamit_data = read(out_file='rm3.out')
num_bodies = wamit_data.body[0].num_bodies

# Calculate IRF
for i in xrange(num_bodies):
	wamit_data.body[i].calc_irf_radiation(t_end=60.)
	wamit_data.body[i].calc_ss_radiation()
	wamit_data.body[i].calc_irf_excitation(t_end=157.)

# Save the data in HDF5 format
write_hdf5(wamit_data)
