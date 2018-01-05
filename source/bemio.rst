
BEMIO
-----
The Boundary Element Method Input/Output (BEMIO) functions are used to preprocess the BEM hydrodynamic data prior to running WEC-Sim, this includes:

* Read BEM results from WAMIT, NEMOH, or AQWA.
* Calculate the radiation and excitation impulse response functions (IRFs).
* Calculate state space realization coefficients for the radiation IRF.
* Save the resulting data in Hierarchical Data Format 5 (HDF5).
* Plot typical hydrodynamic data for user verification.

For more information, refer to the `BEMIO tutorial <http://wec-sim.github.io/WEC-Sim/advanced_features.html#bemio-tutorials>`_ section and the  `BEMIO webinar <http://wec-sim.github.io/WEC-Sim/webinars.html#webinar-1-bemio-and-mcr>`_.


.. Note:: 
	Previously the `python based BEMIO code <http://wec-sim.github.io/bemio/installing.html>`_ was used for this purpose. The python BEMIO functions have been converted to MATLAB and are included in the WEC-Sim source code. The python based BEMIO code will remain available but will no longer be  supported. 

BEMIO Functions
~~~~~~~~~~~~~~~~

**Read_WAMIT:** Reads data from a WAMIT output file

	*hydro = Read_WAMIT(hydro, filename, ex_coeff)*
		* *hydro* – data structure
		* *filename* – WAMIT output file
		* *ex_coeff* - flag indicating the type of excitation force coefficients to read, ‘diffraction’ (default) or ‘haskind’

**Read_NEMOH:** Reads data from a NEMOH working folder

	*hydro = Read_NEMOH(hydro, filedir)*
		* *hydro* – data structure
		* *filedir* – NEMOH working folder, must include:

			* Nemoh.cal
			* Mesh/Hydrostatics.dat (or Hydrostatiscs_0.dat, Hydrostatics_1.dat, etc. for multiple bodies)
			* Mesh/KH.dat (or KH_0.dat, KH_1.dat, etc. for multiple bodies)
			* Results/RadiationCoefficients.tec
			* Results/ExcitationForce.tec

.. Note:: 
	Instructions on how to download and use the open source BEM code NEMOH are provided on the `NEMOH website <https://lheea.ec-nantes.fr/logiciels-et-brevets/nemoh-presentation-192863.kjsp>`_. The NEMOH Mesh.exe code creates the Hydrostatics.dat and KH.dat files (among other files) for one input body at a time. For the Read_NEMOH function to work correctly in the case of a multiple body system, the user must manually rename Hydrostatics.dat and KH.dat files to Hydrostatics_0.dat, Hydrostatics_1.dat, …, and KH_0.dat, KH_1.dat,…, corresponding to the body order specified in the Nemoh.cal file.

**Read_AQWA:** Reads data from AQWA output files

	*hydro = Read_AQWA(hydro, ah1_filename, lis_filename)*
		* *hydro* – data structure
		* *ah1_filename* – .AH1 AQWA output file 
		* *lis_filename* – .LIS AQWA output file

**Normalize:** Normalizes NEMOH and AQWA hydrodynamics coefficients in the same manner that WAMIT outputs are normalized. Specifically, the linear restoring stiffness is normalized as, :math:`C_{i,j}/\rho g`; added mass is normalized as, :math:`A_{i,j}/\rho`; radiation damping is normalized as, :math:`B_{i,j}/\rho \omega`; and, exciting forces are normalized as, :math:`X_i/\rho g`. Typically, this function would not be called directly by the user; it is automatically implemented within the Read_NEMOH and Read_AQWA functions. 

	*hydro = Normalize(hydro)*
		* *hydro* – data structure

**Combine_BEM:** Combines multiple BEM outputs into one hydrodynamic "system". This function requires that all BEM outputs have the same water depth, wave frequencies, and wave headings. This function would be implemented following multiple Read functions and before the IRF, Write_H5, or Plot_BEMIO functions.

	*hydro = Combine_BEM(hydro)*
		* *hydro* – data structure

**Radiation_IRF:** Calculates the normalized radiation impulse response function.

	:math:`\overline{K}_{i,j}(t) = {\frac{2}{\pi}}\intop_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega`

	*hydro = Radiation_IRF(hydro, t_end, n_t, n_w, w_min, w_max)*
			* *hydro* – data structure
			* *t_end* – calculation range for the IRF, where the IRF is calculated from t = 0 to t_end, and the default is 100 s
			* *n_t* – number of time steps in the IRF, the default is 1001
			* *n_w* – number of frequency steps used in the IRF calculation (hydrodynamic coefficients are interpolated to correspond), the default is 1001
			* *w_min* – minimum frequency to use in the IRF calculation, the default is the minimum frequency from the BEM data
			* *w_max* – maximum frequency to use in the IRF calculation, the default is the maximum frequency from the BEM data.

**Radiation_IRF_SS:** Calculates the state space (SS) realization of the radiation IRF. If this function is used, it must be implemented after the Radiation_IRF function.

	*hydro = Radiation_IRF_SS(hydro, Omax, R2t)*
		* *hydro* – data structure
		* *Omax* – maximum order of the SS realization, the default is 10
		* *R2t* – :math:`R^2` threshold (coefficient of determination) for the SS realization, where :math:`R^2` may range from 0 to 1, and the default is 0.95

**Excitation_IRF:** Calculates the excitation impulse response function.

	:math:`\overline{K}_i(t) = {\frac{1}{2\pi}}\intop_{-\infty}^{\infty}{\frac{X_i(\omega,\beta)e^{i{\omega}t}}{{\rho}g}}d\omega`

	*hydro = Excitation_IRF(hydro, t_end, n_t, n_w, w_min, w_max)*
			* *hydro* – data structure
			* *t_end* – calculation range for the IRF, where the IRF is calculated from t = -t_end to t_end, and the default is 100 s
			* *n_t* – number of time steps in the IRF, the default is 1001
			* *n_w* – number of frequency steps used in the IRF calculation (hydrodynamic coefficients are interpolated to correspond), the default is 1001
			* *w_min* – minimum frequency to use in the IRF calculation, the default is the minimum frequency from the BEM data
			* *w_max* – maximum frequency to use in the IRF calculation, the default is the maximum frequency from the BEM data.

**Write_H5:** Writes the hydro data structure to a ``*.h5`` file. 

	Write_H5(hydro)
		* *hydro* – data structure

.. Note::
 	Technically, this step should not be necessary - the MATLAB data structure *hydro* is written to a ``*.h5`` file by BEMIO and then read back into a new MATLAB data structure *hydroData* for each body by WEC-Sim. The reasons this step was retained were, first, to remain compatible with the python based BEMIO output and, second, for the simpler data visualization and verification capabilities offered by the ``*.h5`` file viewer.

**Plot_BEMIO:** Plots the added mass, radiation damping, radiation IRF, excitation force magnitude, excitation force phase, and excitation IRF for each body in the heave, surge and pitch degrees of freedom. 

	*Plot_BEMIO(hydro)*
		* *hydro* – data structure

.. Note::
	In the future, this will likely be changed to a userDefinedBEMIO.m function, similar to WEC-Sim’s userDefinedFunctions.m, such that users can interactively modify or plot any BEM hydrodynamic variable of interest.


BEMIO *hydro* Data Structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

============  ========================  ======================================
**Variable**  **Format**                **Description**
A             [6*N,6*N,Nf]              added mass
Ainf          [6*N,6*N]                 infinite frequency added mass
B             [6*N,6*N,Nf]              radiation damping
beta          [1,Nh]                    wave headings (deg)
body          {1,N}                     body names
C             [6,6,N]                   hydrostatic restoring stiffness
cb            [3,N]                     center of buoyancy
cg            [3,N]                     center of gravity
code          string                    BEM code (WAMIT, AQWA, or NEMOH)
ex_im         [6*N,Nh,Nf]               imaginary component of excitation
ex_K          [6*N,Nh,length(ex_t)]     excitation IRF
ex_ma         [6*N,Nh,Nf]               magnitude of excitation force
ex_ph         [6*N,Nh,Nf]               phase of excitation force
ex_re         [6*N,Nh,Nf]               real component of excitation
ex_t          [1,length(ex_t)]          time steps in the excitation IRF
ex_w          [1,length(ex_w)]          frequency step in the excitation IRF
file          string                    BEM output filename
g             [1,1]                     gravity
h             [1,1]                     water depth
N             [1,1]                     number of bodies
Nf            [1,1]                     number of wave frequencies
Nh            [1,1]                     number of wave headings
ra_K          [6*N,6*N,length(ra_t)]    radiation IRF
ra_t          [1,length(ra_t)]          time steps in the radiation IRF
ra_w          [1,length(ra_w)]          frequency steps in the radiation IRF  
rho           [1,1]                     density
ss_A          [6*N,6*N,ss_O,ss_O]       state space A matrix
ss_B          [6*N,6*N,ss_O,1]          state space B matrix
ss_C          [6*N,6*N,1,ss_O]          state space C matrix
ss_conv       [6*N,6*N]                 state space convergence flag
ss_D          [6*N,6*N,1]               state space D matrix
ss_K          [6*N,6*N,length(ra_t)]    state space radiation IRF
ss_O          [6*N,6*N]                 state space order
ss_R2         [6*N,6*N]                 state space R2 fit
T             [1,Nf]                    wave periods
Vo            [1,N]                     displaced volume
w             [1,Nf]                    wave frequencies
============  ========================  ======================================


BEMIO Tutorials
~~~~~~~~~~~~~~~~

The BEMIO tutorials are included in the ``$Source/tutorials/BEMIO`` directory in the WEC-Sim source code. For more information, refer to the `BEMIO webinar <http://wec-sim.github.io/WEC-Sim/webinars.html#webinar-1-bemio-and-mcr>`_.


Writing Your Own h5 File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The most common way of creating a ``*.h5`` file is using BEMIO to post-process the outputs of a BEM code.
This requires a single BEM solution that contains all hydrodynamic bodies and accounts for body interactions.
Some cases in which you might want to create your own h5 file are:

* Use experimentally determined coefficients or a mix of BEM and experimental coefficients.
* Combine results from different BEM files and have the coefficient matrices be the correct size for the new total number of bodies.
* Modify the BEM results for any other reason.

MATLAB and Python have functions to read and write ``*.h5`` files easily.
WEC-Sim includes three functions to help you create your own ``*.h5`` file. 
These are found under ``$Source/functions/writeH5/``.
The header comments of each function explain the inputs and outputs. 
An example of how to use ``write_hdf5``  is provided in the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.
The first step is to have all the required coefficients and properties in Matlab in the correct format.
Then the functions provided are used to create and populate the ``*.h5`` file. 

.. Note::

	The new ``*.h5`` file will not have the impulse response function coefficients required for the convolution integral.
	BEMIO is currently being modified to allow for reading an existing ``*.h5`` file.
	This would allow you to read in the ``*.h5`` file you created, calculate the required impulse response functions and state space coefficients, and re-write the ``*.h5`` file.

.. Note::

	BEMIO is currently being modified to allow for the combination of different ``*.h5`` files into a single file.
	This would allow for the BEM of different bodies to be done separately, and BEMIO would take care of making the coefficient matrices the correct size.

Refining STL File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
An STL file with suitably small panel areas is required for the nonlinear hydrodynamics option in WEC-Sim to yield accurate results. Softwares used to generate ``*.stl`` files often represent flat panels with straight edges with the minimum number of required triangles. This can result in ``*.stl`` files with large panel areas. 

The script ``refine_stl`` in the BEMIO directory performs a simple mesh refinement on an ``*.stl`` file by subdividing each panel with an area above the specified threshold into four smaller panels with new vertices at the mid-points of the original panel edges. This procedure is iterated for each panel until all panels have an area below the specified threshold, as in the example rectangle. 


.. figure:: _static/rectangles.png 
   :width: 300pt 
   :align: center

In this way, the each new panel retains the aspect ratio of the original panel. Note that the linear discretization of curved edges is not refined via this algorithm. The header comments of the function explain the inputs and outputs. This function calls ``import_stl_fast``, included with the WEC-Sim distribution, to import the ``.*stl`` file.