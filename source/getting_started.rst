.. _getting_started:

Getting Started
===============
This section provides instructions on how to download and install the `WEC-Sim <https://github.com/WEC-Sim/WEC-Sim>`_ code, and how to run the MATLAB BEMIO preprocessing functions

MATLAB Toolbox Requirements
------------------------------
WEC-Sim was developed in **MATLAB R2015b**, and requires the following toolboxes:

==============================================  ====================		
**Required Toolbox**                            **Supported Version**
MATLAB		                                Version 8.6 (R2015b)
Simulink                                        Version 8.6 (R2015b)
Simscape                                        Version 3.14 (R2015b)
SimMechanics (Simscape Multibody in R2016a)   	Version 4.7 (R2015b)
==============================================  ====================	

Ensure that the correct version of MATLAB and the required toolboxes are installed by typing ``ver`` in the MATLAB Command Window:

.. code-block:: matlabsession

	>> ver
	--------------------------------------------------------------------------------------
	MATLAB Version: 8.6.0.267246 (R2015b)
	--------------------------------------------------------------------------------------
	MATLAB                                                Version 8.6         (R2015b)
	Simulink                                              Version 8.6         (R2015b)
	SimMechanics                                          Version 4.7         (R2015b)
	Simscape                                              Version 3.14        (R2015b)

.. Note::
	**SimMechanics** is now called **Simscape Multibody** in **R2016a** or later version.

Downloading WEC-Sim
------------------------
WEC-Sim is distributed through the `WEC-Sim GitHub site <https://github.com/WEC-Sim/wec-sim>`_. There are three ways of obtaining WEC-Sim, each of which are described in the following section.
 
Option 1: Clone with GitHub (Recommended for Users)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WEC-Sim can be obtained by locally `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the repository hosted on GitHub using the shell::

	>> git clone https://github.com/WEC-Sim/WEC-Sim

This method is recommended for users because the local copy of WEC-Sim can easily be updated to the latest version of the code hosted on the GitHub repository by using the pull command::

	>> git pull

Option 2: Fork with Git (Recommended for Developers)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you are planning to contribute to the WEC-Sim code, please follow the `forking instructions <https://help.github.com/articles/fork-a-repo/>`_  provided by GitHub. Should you make improvements to the code that you would like included in the WEC-Sim master code, please make a `pull request <https://help.github.com/articles/using-pull-requests/>`_ so that your improvement can be merged into `WEC-Sim master <https://github.com/WEC-Sim/WEC-Sim>`_, and included in future releases.

Option 3: Static Code Download 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The easiest way to obtain a copy of WEC-Sim is to download the static release of latest tagged `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.

.. Note::
	This is a static download of the WEC-Sim code. If you chose this method, you will have to re-download the code in order to receive code updates.


Installing WEC-Sim
---------------------
Once you have downloaded the WEC-Sim source code, follow the steps described in this section to install WEC-Sim. The WEC-Sim source code directory will be referred to as **$wecSim**

Step 1: Add WEC-Sim Source Code to MATLAB Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the ``$wecSim/wecSimStartup.m`` file

.. literalinclude:: wecSimStartup.m
   :language: matlab

Copy the code in the ``wecSimStartup.m`` shown above and paste it into the ``startup.m`` file located in the `MATLAB Startup Folder <http://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html>`_. Set the ``wecSimPath`` variable to the ``$wecSim`` folder, and open the ``startup.m`` file by typing ``open startup.m`` into the MATLAB Command Window: 

.. code-block:: matlabsession

	>> open startup.m

Verify the path was set up correctly by checking that the WEC-Sim source directory (``$wecSim``) is listed in the MATLAB. This is done by typing ``path`` into the MATLAB Command Window:

.. code-block:: matlabsession

	>> path


Step 2: Add WEC-Sim Library to Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the Simulink Library Browser by typing ``simulink`` into the MATLAB Command Window:

.. code-block:: matlabsession

	>> simulink
	
Once the Simulink Library Browser opens, `Refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. The WEC-Sim Library of Body Elements, Constraints, Frames Moorings, and PTOs should now be visible, as shown in the figure below. The WEC-Sim library should now be accessible every time Simulink is opened. For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

.. figure:: _static/WEC-Sim_Library.jpg
   :align: center
    
   ..
    
   *WEC-Sim Library*

BEMIO
-----------------------------------
The Boundary Element Method Input/Output (BEMIO) functions are used to preprocess the BEM hydrodynamic data prior to running WEC-Sim, this includes:

* Read BEM results from WAMIT, NEMOH, or AQWA.
* Calculate the radiation and excitation impulse response functions (IRFs).
* Calculate state space realization coefficients for the radiation IRF.
* Save the resulting data in Hierarchical Data Format 5 (HDF5).
* Plot typical hydrodynamic data for user verification.

.. Note:: 
	Previously, the python based `BEMIO code <http://wec-sim.github.io/bemio/installing.html>`_ was used for this purpose. To avoid the inefficiencies associated with supporting two code platforms, the python BEMIO functions have been converted to MATLAB, and will now be automatically downloaded with the WEC-Sim code. The python based BEMIO code will remain available, but will no longer be actively supported. Also, the mesh manipulation capabilities of the  python based BEMIO code have not yet been converted to MATLAB, however, it is intended that they will be in a future release. 

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
	Instructions on how to download and use the open source BEM code NEMOH are provided on the `NEMOH website <http://lheea.ec-nantes.fr/doku.php/emo/nemoh/start>`_. The NEMOH Mesh.exe code creates the Hydrostatics.dat and KH.dat files (among other files) for one input body at a time. For the Read_NEMOH function to work correctly in the case of a multiple body system, the user must manually rename Hydrostatics.dat and KH.dat files to Hydrostatics_0.dat, Hydrostatics_1.dat, …, and KH_0.dat, KH_1.dat,…, corresponding to the body order specified in the Nemoh.cal file.

**Read_AQWA:** Reads data from AQWA output files

	*hydro = Read_AQWA(hydro, ah1_filename, lis_filename)*
		* *hydro* – data structure
		* *ah1_filename* – .AH1 AQWA output file 
		* *lis_filename* – .LIS AQWA output file

**Normalize:** Normalizes NEMOH and AQWA hydrodynamics coefficients in the same manner that WAMIT outputs are normalized. Specifically, the linear restoring stiffness is normalized as, :math:`C_{i,j}/\rho g`; added mass is normalized as, :math:`A_{i,j}/\rho`; radiation damping is normalized as, :math:`B_{i,j}/\rho \omega`; and, exciting forces are normalized as, :math:`X_i/\rho g`. Typically, this function would not be called directly by the user; it is automatically implemented within the Read_NEMOH and Read_AQWA functions. 

	*hydro = Normalize(hydro)*
		* *hydro* – data structure

**Combine_BEM:** Combines multiple BEM outputs into one hydrodynamic ‘system.’ This function requires that all BEM outputs have the same water depth, wave frequencies, and wave headings. This function would be implemented following multiple Read functions and before the IRF, Write_H5, or Plot_BEMIO functions.

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

**Write_H5:** Writes the hydro data structure to a .h5 file. 

	Write_H5(hydro)
		* *hydro* – data structure

.. Note::
 	Technically, this step should not be necessary - the MATLAB data structure *hydro* is written to a .h5 file by BEMIO, and then read back into a new MATLAB data structure *hydroData* for each body by WEC-Sim. The reasons this step was retained were first, to remain compatible with the python based BEMIO output, and second, for the simpler data visualization and verification capabilities offered by the .h5 file viewer.

**Plot_BEMIO:** Plots the added mass, radiation damping, radiation IRF, excitation force magnitude, excitation force phase, and excitation IRF for each body in the heave, surge and pitch degrees of freedom. 

	*Plot_BEMIO(hydro)*
		* *hydro* – data structure

.. Note::
	In the future, this will likely be changed to a userDefinedBEMIO.m function, similar to WEC-Sim’s userDefinedFunctions.m, such that users can interactively modify or plot any BEM hydrodynamic variable of interest.

BEMIO *hydro* Data Structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

============  ========================  ======================================
**Variable**  **Format**                **Description**
A             [6*Nb,6*Nb,Nf]            added mass
Ainf          [6*Nb,6*Nb]               infinite frequency added mass
B             [6*Nb,6*Nb,Nf]            radiation damping
beta          [1,Nh]                    wave headings (deg)
body          {1,Nb}                    body names
C             [6,6,Nb]                  hydrostatic restoring stiffness
cb            [3,Nb]                    center of buoyancy
cg            [3,Nb]                    center of gravity
code          string                    BEM code (WAMIT, AQWA, or NEMOH)
ex_im         [6*Nb,Nh,Nf]              imaginary component of excitation
ex_K          [6*Nb,Nh,length(ex_t)]    excitation IRF
ex_ma         [6*Nb,Nh,Nf]              magnitude of excitation force
ex_ph         [6*Nb,Nh,Nf]              phase of excitation force
ex_re         [6*Nb,Nh,Nf]              real component of excitation
ex_t          [1,length(ex_t)]          time steps in the excitation IRF
ex_w          [1,length(ex_w)]          frequency step in the excitation IRF
file          string                    BEM output filename
g             [1,1]                     gravity
h             [1,1]                     water depth
Nb            [1,1]                     number of bodies
Nf            [1,1]                     number of wave frequencies
Nh            [1,1]                     number of wave headings
ra_K          [6*Nb,6*Nb,length(ra_t)]  radiation IRF
ra_t          [1,length(ra_t)]          time steps in the radiation IRF
ra_w          [1,length(ra_w)]          frequency steps in the radiation IRF  
rho           [1,1]                     density
ss_A          [6*Nb,6*Nb,ss_O,ss_O]     state space A matrix
ss_B          [6*Nb,6*Nb,ss_O,1]        state space B matrix
ss_C          [6*Nb,6*Nb,1,ss_O]        state space C matrix
ss_conv       [6*Nb,6*Nb]               state space convergence flag
ss_D          [6*Nb,6*Nb,1]             state space D matrix
ss_K          [6*Nb,6*Nb,length(ra_t)]  state space radiation IRF
ss_O          [6*Nb,6*Nb]               state space order
ss_R2         [6*Nb,6*Nb]               state space R2 fit
T             [1,Nf]                    wave periods
Vo            [1,Nb]                    displaced volume
w             [1,Nf]                    wave frequencies
============  ========================  ======================================

BEMIO Tutorials
~~~~~~~~~~~~~~~~

.. Note::
	Coming soon!




