.. _release_notes:

Release Notes
-------------

`WEC-Sim v2.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.2>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Added option to save pressure data for non-linear hydro (`simu.pressureDis`)
* Update to moorDyn parser (doesn't require line#.out)  
* Repository cleanup
		* Implemented `Git LFS <https://git-lfs.github.com/>`_ for tracking *.h5 files
		* Added `WEC-Sim Application  repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ as a `submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_
		* Moved `moorDyn <https://github.com/WEC-Sim/moorDyn>`_ to its own repository
		* Removed publications from repository, `available on website <http://wec-sim.github.io/WEC-Sim/publications.html>`_

.. Note::

	GitHub repository history was re-written to make repository *much* smaller. Re-cloning the repository is highly recommended - it should be much faster than before. 


`WEC-Sim v2.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.1>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Added MATLAB version of BEMIO (to replace python version)
* Added variable time-step option with 'ode45' by @ratanakso 
* Update to MCR, option to not re-load *.h5 file by @bradling 
* Update to waveClass to allow for definition of min/max wave frequency by @bradling 

.. Note::

	Backward Compatibility: **WEC-Sim v2.1 is not backword compatible**

`WEC-Sim v2.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.0>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Updated WEC-Sim Library (generalized joints/constraints/PTOs)
* Body-to-body interactions for radiation forces
* Morrison forces
* Batch run mode (MCR)
* Mooring sub-library implemented in mooringClass (no longer in body or joint)
* More realistic PTO and mooring modelling through PTO-Sim and integration with MoorDyn
* Non-hydrodynamic body option
* Visualization using ParaView

.. Note::

	Backward Compatibility: **WEC-Sim v2.0 is not backword compatible**

`WEC-Sim v1.3 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.3>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Added Morison Elements
* Body2Body Interactions
* Multiple Case Runs (wecSimMCR)
* Moordyn
* Added Non-hydro Bodies
* Morrison Forces
* Joint Updates
* Visualization with Paraview
	
`WEC-Sim v1.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.2>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Nonlinear Froude-Krylov hydrodynamics and hydrostatics
* State space radiation
* Wave directionality
* User-defined wave elevation time-series
* Imports non-dimensionalized BEMIO hydrodynamic data (instead of fully dimensional coefficients)
* Variant Subsystems implemented to improve code stability (instead of if statements)
* Bug fixes

.. Note::

	Backward Compatibility: **WEC-Sim v1.2 is not backword compatible**

`WEC-Sim v1.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* WEC-Sim v1.1, `now available on GitHub <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_ 
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on `BEMIO <http://wec-sim.github.io/bemio/#>`_ output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation available on WEC-Sim Website

`WEC-Sim v1.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.0>`_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Initial release of WEC-Sim (oringially on OpenEI, now available on GitHub)
* Available as a static download 
* Documentation available in PDF 


