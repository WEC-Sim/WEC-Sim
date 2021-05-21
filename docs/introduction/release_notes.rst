.. _intro-release-notes:

Release Notes
=============

Current Release
----------------

`WEC-Sim v4.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.2>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added normal/tangential option for Morison Force (``simu.morisonElement = 2``) `#408 <https://github.com/WEC-Sim/WEC-Sim/pull/408>`_

* Added Drag Body (``body(i).nhBody=2``) `#423 <https://github.com/WEC-Sim/WEC-Sim/pull/423>`_ `#384 <https://github.com/WEC-Sim/WEC-Sim/issues/384>`_

* WEC-Sim output saved to structure `#426 <https://github.com/WEC-Sim/WEC-Sim/pull/426>`_

* Added WEC-Sim parallel execution for batch runs (``wecSimPCT``) using MATLAB parallel computing toolbox `#438 <https://github.com/WEC-Sim/WEC-Sim/pull/438>`_

* Added end stops to PTOs `#445 <https://github.com/WEC-Sim/WEC-Sim/pull/445>`_

* Documentation 

  * Automatically compile docs with TravisCI `#439 <https://github.com/WEC-Sim/WEC-Sim/pull/439>`_

  * Generate docs for master and dev branches of WEC-Sim
  
* Bug Fixes

  * Resolved convolution integral bug for body-to-body interactions  `#444 <https://github.com/WEC-Sim/WEC-Sim/pull/444>`_
  
  * Resolved PTO-Sim bug for linear to rotary conversion blocks  `#247 <https://github.com/WEC-Sim/WEC-Sim/issues/247)>`_ `#485 <https://github.com/WEC-Sim/WEC-Sim/pull/485>`_

  * Resolved variant subsystem labeling bug  `#486 <https://github.com/WEC-Sim/WEC-Sim/pull/486)>`_ `#479 <https://github.com/WEC-Sim/WEC-Sim/issues/479>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.4391330.svg
   :target: https://doi.org/10.5281/zenodo.4391330



Previous Releases
------------------


`WEC-Sim v4.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added passive yaw

* Revised spectral formulations per IEC TC114 TS 62600-2 Annex C

* Updated examples on the `WEC-Sim_Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository

* Added unit tests with Jenkins

* Added API documentation for WEC-Sim classes

* Merged Pull Requests

  * Updated BEMIO for AQWA version comparability `#373 <https://github.com/WEC-Sim/WEC-Sim/pull/373)>`_
  
  * Extended capabilities for ParaView visualization `#355 <https://github.com/WEC-Sim/WEC-Sim/pull/355>`_

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.3924765.svg
   :target: https://doi.org/10.5281/zenodo.3924765
   
   
`WEC-Sim v4.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.0>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added mean drift force calculation

* Added generalized body modes for simulating flexible WEC devices and for structure loading analysis

* Updated BEMIO for mean drift force and generalized body modes

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.3827897.svg
   :target: https://doi.org/10.5281/zenodo.3827897
   


`WEC-Sim v3.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v3.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added wave gauges for three locations

* Added command line documentation for objects

* Added error and warning flags

* Converted Morison Elements to script instead of block

* Converted WEC-Sim and PTO-Sim library files back to slx format

* Fixed plot error in MATLAB 2018b


`WEC-Sim v3.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v3.0>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added option of `equal energy spacing <http://wec-sim.github.io/WEC-Sim/advanced_features.html#irregular-wave-binning>`_ for irregular waves (default)

* Added option to calculate the wave elevation at a location different from the origin

* Added option to define `gamma for JONSWAP spectrum <http://wec-sim.github.io/WEC-Sim/code_structure.html#irregular>`_

* Improved the WEC-Sim simulation speed when using rapid-acceleration mode

* Fixed path bug in BEMIO for LINUX/OSX users

* Changed/Added following WEC-Sim parameters

	* waves.randPreDefined -> `waves.phaseSeed <http://wec-sim.github.io/WEC-Sim/advanced_features.html#irregular-waves-with-seeded-phase>`_
	* waves.phaseRand -> waves.phase           
	* simu.dtFeNonlin -> `simu.dtNL <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-linear-hydrodynamics>`_
	* simu.rampT -> `simu.rampTime <http://wec-sim.github.io/WEC-Sim/code_structure.html#simulation-class>`_
	* Added simu.dtME  to allow specification of `Morison force time-step <http://wec-sim.github.io/WEC-Sim/advanced_features.html#time-step-features>`_


`WEC-Sim v2.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.2>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Added option to save pressure data for non-linear hydro (`simu.pressureDis`)
* Update to moorDyn parser (doesn't require line#.out)  
* Repository cleanup

	* Implemented `Git LFS <https://git-lfs.github.com/>`_ for tracking ``*.h5`` files
	* Added `WEC-Sim Application  repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ as a `submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_
	* Moved `moorDyn <https://github.com/WEC-Sim/moorDyn>`_ to its own repository
	* Removed publications from repository, `available on website <http://wec-sim.github.io/WEC-Sim/publications.html>`_

.. Note::

	GitHub repository history was re-written to make repository *much* smaller. Re-cloning the repository is highly recommended - it should be much faster than before. 


`WEC-Sim v2.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Added MATLAB version of BEMIO (to replace python version)
* Added variable time-step option with 'ode45' by @ratanakso 
* Update to MCR, option to not re-load ``*.h5`` file by @bradling 
* Update to waveClass to allow for definition of min/max wave frequency by @bradling 

.. Note::

	Backward Compatibility: **WEC-Sim v2.1 is not backward compatible**

`WEC-Sim v2.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.0>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Updated WEC-Sim Library (generalized joints/constraints/PTOs)
* Body-to-body interactions for radiation forces
* Morison forces
* Batch run mode (MCR)
* Mooring sub-library implemented in mooringClass (no longer in body or joint)
* More realistic PTO and mooring modeling through PTO-Sim and integration with MoorDyn
* Non-hydrodynamic body option
* Visualization using ParaView

.. Note::

	Backward Compatibility: **WEC-Sim v2.0 is not backward compatible**

`WEC-Sim v1.3 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.3>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Added Morison Elements
* Body2Body Interactions
* Multiple Case Runs (wecSimMCR)
* Moordyn
* Added Non-hydro Bodies
* Morison Forces
* Joint Updates
* Visualization with Paraview
	
`WEC-Sim v1.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.2>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Nonlinear Froude-Krylov hydrodynamics and hydrostatics
* State space radiation
* Wave directionality
* User-defined wave elevation time-series
* Imports non-dimensionalized BEMIO hydrodynamic data (instead of fully dimensional coefficients)
* Variant Subsystems implemented to improve code stability (instead of if statements)
* Bug fixes

.. Note::

	Backward Compatibility: **WEC-Sim v1.2 is not backward compatible**

`WEC-Sim v1.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* WEC-Sim v1.1, `now available on GitHub <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_ 
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on `BEMIO <http://wec-sim.github.io/bemio/#>`_ output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation available on WEC-Sim Website

`WEC-Sim v1.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.0>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Initial release of WEC-Sim (originally on OpenEI, now available on GitHub)
* Available as a static download 
* Documentation available in PDF 


