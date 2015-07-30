# Load the needed modules from bemio
from bemio.io.wamit import read
from bemio.io.output import write_hdf5

# Load the data using the wamit module.

wamit_data_f = read(out_file='wamit_data/rbwamit_f.out')

# Calculate IRF and SS coefficients
for i in xrange(wamit_data_f.body[0].num_bodies): #wamit_data_f.body[0].num_bodies
 	wamit_data_f.body[i].calc_irf_radiation(t_end=20.0, n_t=2001, n_w=4001)
	# wamit_data_f.body[i].calc_ss_radiation(max_order=7, r2_thresh=0.95)
	wamit_data_f.body[i].calc_irf_excitation(t_end=20.0, n_t=2001, n_w=4001)

# Save the data in the hdf5 format.
write_hdf5(wamit_data_f,out_file='coer_comp_f.h5')
