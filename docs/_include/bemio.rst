
The Boundary Element Method Input/Output (BEMIO) functions are used to 
pre-process the BEM hydrodynamic data prior to running WEC-Sim. For more 
information about the WEC-Sim workflow, refer to 
:ref:`user-workflow-running-wec-sim`. The following section can also be 
followed in conjunction with the cases in the WEC-Sim/Examples directory in the 
WEC-Sim source code. This includes several cases with WAMIT, NEMOH, Aqwa, and Capytaine. 
For more information, refer to :ref:`webinar1`. BEMIO functions perform the 
following tasks: 

* Read BEM results from **WAMIT**, **NEMOH**, **Aqwa**, or **Capytaine**.
* Calculate the radiation and excitation impulse response functions (IRFs).
* Calculate the state space realization for the radiation IRF.
* Save the resulting data in Hierarchical Data Format 5 (HDF5).
* Plot typical hydrodynamic data for user verification.

.. Note:: 
	Previously the `python based BEMIO code <http://wec-sim.github.io/bemio/installing.html>`_ was used for this purpose. The python BEMIO functions have been converted to MATLAB and are included in the WEC-Sim source code. The python based BEMIO code will remain available but will no longer be  supported. 

BEMIO Functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. autofunction:: functions.BEMIO.readWAMIT

.. autofunction:: functions.BEMIO.readNEMOH

.. Note:: 
	* Instructions on how to download and use the open source BEM code NEMOH are provided on the `NEMOH website <https://lheea.ec-nantes.fr/logiciels-et-brevets/nemoh-presentation-192863.kjsp>`_. 
	* The NEMOH Mesh.exe code creates the ``Hydrostatics.dat`` and ``KH.dat`` files (among other files) for one input body at a time. For the readNEMOH function to work correctly in the case of a multiple body system, the user must manually rename ``Hydrostatics.dat`` and ``KH.dat`` files to ``Hydrostatics_0.dat``, ``Hydrostatics_1.dat``, …, and ``KH_0.dat``, ``KH_1.dat``,…, corresponding to the body order specified in the ``Nemoh.cal`` file.

.. autofunction:: functions.BEMIO.readAQWA

.. autofunction:: functions.BEMIO.readCAPYTAINE

.. autofunction:: functions.BEMIO.normalizeBEM

.. autofunction:: functions.BEMIO.combineBEM

.. autofunction:: functions.BEMIO.radiationIRF

.. autofunction:: functions.BEMIO.radiationIRFSS

.. autofunction:: functions.BEMIO.excitationIRF

.. autofunction:: functions.BEMIO.readBEMIOH5

.. autofunction:: functions.BEMIO.reverseDimensionOrder

.. autofunction:: functions.BEMIO.writeBEMIOH5

.. autofunction:: functions.BEMIO.spectralMoment

.. autofunction:: functions.BEMIO.waveNumber

.. Note::
 	Technically, this step should not be necessary - the MATLAB data structure *hydro* is written to a ``*.h5`` file by BEMIO and then read back into a new MATLAB data structure *hydroData* for each body by WEC-Sim. The reasons this step was retained were, first, to remain compatible with the python based BEMIO output and, second, for the simpler data visualization and verification capabilities offered by the ``*.h5`` file viewer.

.. autofunction:: functions.BEMIO.plotBEMIO


.. _user-advanced-features-bemio-h5:

BEMIO *hydro* Data Structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. Kelley update this
.. Adam with addition of GBM, the labeled 6*Nb sizes may be misleading. Consider changing 6*Nb to sum(dof)

============  ========================  ======================================
**Variable**  **Format**                **Description**
A             [6*Nb,6*Nb,Nf]            radiation added mass
Ainf          [6*Nb,6*Nb]               infinite frequency added mass
B             [6*Nb,6*Nb,Nf]            radiation wave damping
theta         [1,Nh]                    wave headings (deg)
body          {1,Nb}                    body names
cb            [3,Nb]                    center of buoyancy
cg            [3,Nb]                    center of gravity
code          string                    BEM code (WAMIT, NEMOH, Aqwa, or Capytaine)
C             [6,6,Nb]                  hydrostatic restoring stiffness
dof 	      [1, Nb]                   Degrees of freedom (DOF) for each body. Default DOF for each body is 6 plus number of possible generalized body modes (GBM).
exc_im        [6*Nb,Nh,Nf]              imaginary component of excitation force or torque
exc_K         [6*Nb,Nh,length(ex_t)]    excitation IRF
exc_ma        [6*Nb,Nh,Nf]              magnitude of excitation force or torque
exc_ph        [6*Nb,Nh,Nf]              phase of excitation force or torque
exc_re        [6*Nb,Nh,Nf]              real component of excitation force or torque
exc_t         [1,length(ex_t)]          time steps in the excitation IRF
exc_w         [1,length(ex_w)]          frequency step in the excitation IRF
file          string                    BEM output filename
fk_im         [6*Nb,Nh,Nf]              imaginary component of Froude-Krylov contribution to the excitation force or torque
fk_ma         [6*Nb,Nh,Nf]              magnitude of Froude-Krylov excitation component
fk_ph         [6*Nb,Nh,Nf]              phase of Froude-Krylov excitation component
fk_re         [6*Nb,Nh,Nf]              real component of Froude-Krylov contribution to the excitation force or torque
g             [1,1]                     gravity
h             [1,1]                     water depth
Nb            [1,1]                     number of bodies
Nf            [1,1]                     number of wave frequencies
Nh            [1,1]                     number of wave headings
ra_K          [6*Nb,6*Nb,length(ra_t)]  radiation IRF
ra_t          [1,length(ra_t)]          time steps in the radiation IRF
ra_w          [1,length(ra_w)]          frequency steps in the radiation IRF  
rho           [1,1]                     density
sc_im         [6*Nb,Nh,Nf]              imaginary component of scattering contribution to the excitation force or torque
sc_ma         [6*Nb,Nh,Nf]              magnitude of scattering excitation component
sc_ph         [6*Nb,Nh,Nf]              phase of scattering excitation component
sc_re         [6*Nb,Nh,Nf]              real component of scattering contribution to the excitation force or torque
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
omega         [1,Nf]                    wave frequencies
============  ========================  ======================================


Writing Your Own h5 File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The most common way of creating a ``*.h5`` file is using BEMIO to post-process the outputs of a BEM code.
This requires a single BEM solution that contains all hydrodynamic bodies and accounts for body-to-body interactions.
Some cases in which you might want to create your own h5 file are:

* Use experimentally determined coefficients or a mix of BEM and experimental coefficients.
* Combine results from different BEM files and have the coefficient matrices be the correct size for the new total number of bodies.
* Modify the BEM results for any other reason.

MATLAB and Python have functions to read and write ``*.h5`` files easily.
WEC-Sim includes three functions to help you create your own ``*.h5`` file. 
These are found under ``$WECSIM/functions/writeH5/``.
The header comments of each function explain the inputs and outputs. 
An example of how to use ``write_hdf5``  is provided in the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.
The first step is to have all the required coefficients and properties in Matlab in the correct format.
Then the functions provided are used to create and populate the ``*.h5`` file. 

