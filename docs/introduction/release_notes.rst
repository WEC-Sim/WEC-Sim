.. _intro-release-notes:

Release Notes
=============

`WEC-Sim v4.4 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.4>`_
--------------------------------------------------------------------------------
  
* New Features

  * Added WEC-Sim Library blocks for cable, spherical constraint, and spherical pto `#712 <https://github.com/WEC-Sim/WEC-Sim/pull/712>`_ `#675 <https://github.com/WEC-Sim/WEC-Sim/pull/675>`_ 
  
  * Added feature to add/remove WEC-Sim path and create temp directory for each run `#685 <https://github.com/WEC-Sim/WEC-Sim/pull/685>`_ `#686 <https://github.com/WEC-Sim/WEC-Sim/pull/686>`_    
   
  * Updated WEC-Sim Library to 2020b and saved Simulink Library Functions to (`*.m`) files `#686 <https://github.com/WEC-Sim/WEC-Sim/pull/686>`_    `#654 <https://github.com/WEC-Sim/WEC-Sim/pull/654>`_    
   
  * Split WEC-Sim Library into sublibraries for each class `#720 <https://github.com/WEC-Sim/WEC-Sim/pull/720>`_ 
  
  * Restructured WEC-Sim Continuous Integration tests into class-based tests `#620 <https://github.com/WEC-Sim/WEC-Sim/pull/620>`_    

  * Added wave visualization with wave markers and post-processing `#736 <https://github.com/WEC-Sim/WEC-Sim/pull/736>`_  `#678 <https://github.com/WEC-Sim/WEC-Sim/pull/678>`_    
  
  * Moved nonlinear hydrodynamics and morison elements to properties of the Body Class `#692 <https://github.com/WEC-Sim/WEC-Sim/pull/692>`_    
   
* Documentation 

  * Added developer manual content for WEC-Sim Library, Run from Simulink, Simulink Functions, Added Mass, Software Tests `#728 <https://github.com/WEC-Sim/WEC-Sim/pull/728>`_ 
  
  * Added user manual content for troubleshooting WEC-Sim `#641 <https://github.com/WEC-Sim/WEC-Sim/pull/641>`_ 

  * Updated content for PTO-Sim, ParaView, WEC-Sim Applications and Tutorials `#668 <https://github.com/WEC-Sim/WEC-Sim/pull/668>`_ `#642 <https://github.com/WEC-Sim/WEC-Sim/pull/642>`_ `#649 <https://github.com/WEC-Sim/WEC-Sim/pull/649>`_ `#643 <https://github.com/WEC-Sim/WEC-Sim/pull/643>`_ 
  
  * Added multi-version documentation for ``master`` and ``dev`` branches `#630 <https://github.com/WEC-Sim/WEC-Sim/pull/630>`_ 
      
   
* Bug Fixes

  * Resolved bug with macro for ParaView 5.9 `#459 <https://github.com/WEC-Sim/WEC-Sim/pull/459>`_ 
  
  * Resolved bugs in BEMIO with Read_Capytaine, READ_AQWA, and Write_H5 functions `#727 <https://github.com/WEC-Sim/WEC-Sim/pull/727>`_  `#694 <https://github.com/WEC-Sim/WEC-Sim/pull/694>`_  `#636 <https://github.com/WEC-Sim/WEC-Sim/pull/636>`_ 
  
  * Resolved bug with variable time-step solver `#656 <https://github.com/WEC-Sim/WEC-Sim/pull/656>`_ 

* Issues and Pull Requests
  
  * \> 57 issues closed since v4.3

  * \> 54 PRs merged since v4.3

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.5608563.svg
   :target: https://doi.org/10.5281/zenodo.5608563


Previous Releases
------------------


`WEC-Sim v4.3 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.3>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* New Features

  * Added the ability for WEC-Sim to be run directly from Simulink `#503 <https://github.com/WEC-Sim/WEC-Sim/pull/503>`_ `#512 <https://github.com/WEC-Sim/WEC-Sim/pull/512>`_ `#548 <https://github.com/WEC-Sim/WEC-Sim/pull/548>`_
   
  * Added capability to read Capytaine (.nc) output. Includes examples of running Capytaine with hydrostatics `#464 <https://github.com/WEC-Sim/WEC-Sim/pull/464>`_
   
  * Created a more accurate infinite frequency added mass calculation `#517 <https://github.com/WEC-Sim/WEC-Sim/pull/517>`_
   
  * Added ability for setInitDisp to intake multiple initial rotations `#516 <https://github.com/WEC-Sim/WEC-Sim/pull/516>`_ `#586 <https://github.com/WEC-Sim/WEC-Sim/pull/586>`_
   
* Documentation 

  * Restructured into four manuals: introduction, theory, user and development `#455 <https://github.com/WEC-Sim/WEC-Sim/pull/455>`_ `#557 <https://github.com/WEC-Sim/WEC-Sim/pull/557>`_
   
  * Update of code structure section `#455 <https://github.com/WEC-Sim/WEC-Sim/pull/455>`_, links `#649 <https://github.com/WEC-Sim/WEC-Sim/pull/649>`_ , diagrams `#643 <https://github.com/WEC-Sim/WEC-Sim/pull/643>`_, paraview `#642 <https://github.com/WEC-Sim/WEC-Sim/pull/642>`_, 
   
  * Added section on suggested troubleshooting `#641 <https://github.com/WEC-Sim/WEC-Sim/pull/641>`_ 
   
* Continuous integration tests 

  * Overhaul and speed up of tests `#508 <https://github.com/WEC-Sim/WEC-Sim/pull/508>`_ `#620 <https://github.com/WEC-Sim/WEC-Sim/pull/620>`_
   
  * Extension of tests to the applications cases `#7 <https://github.com/WEC-Sim/WEC-Sim_Applications/pull/7>`_
   
* Clean up

  * Created issue templates on GitHub `#575 <https://github.com/WEC-Sim/WEC-Sim/pull/575>`_ `#634 <https://github.com/WEC-Sim/WEC-Sim/pull/634>`_ 
   
  * Updated Morison Element warning flags `#408 <https://github.com/WEC-Sim/WEC-Sim/pull/408>`_
   
  * Clean up response class methods `#491 <https://github.com/WEC-Sim/WEC-Sim/pull/491>`_ `#514 <https://github.com/WEC-Sim/WEC-Sim/pull/514>`_ 
   
  * Clean up paraview output functions `#490 <https://github.com/WEC-Sim/WEC-Sim/pull/490>`_
   
* Bug Fixes

  * Paraview macros and .pvsm files `#459 <https://github.com/WEC-Sim/WEC-Sim/pull/459>`_
   
  * BEMIO read mean drift force in R2021a `#636 <https://github.com/WEC-Sim/WEC-Sim/pull/636>`_
   
  * PTO-Sim calling workspace `#632 <https://github.com/WEC-Sim/WEC-Sim/pull/632>`_
   
  * Combine_BEM Ainf initialization `#611 <https://github.com/WEC-Sim/WEC-Sim/pull/611>`_

* Issues and Pull Requests
  
  * \> 100 issues closed since v4.2

  * \> 45 PRs merged since v4.2

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.5122959.svg
   :target: https://doi.org/10.5281/zenodo.5122959



`WEC-Sim v4.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v4.2>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* New Features

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

* Added option of :ref:`equal energy spacing <user-advanced-features-irregular-wave-binning>` for irregular waves (default)

* Added option to calculate the wave elevation at a location different from the origin

* Added option to define :ref:`gamma for JONSWAP spectrum <user-code-structure-irregular>`

* Improved the WEC-Sim simulation speed when using rapid-acceleration mode

* Fixed path bug in BEMIO for LINUX/OSX users

* Changed/Added following WEC-Sim parameters

  *  waves.randPreDefined -> :ref:`waves.phaseSeed <user-advanced-features-seeded-phase>`
	
  *  waves.phaseRand -> waves.phase           
	
  *  simu.dtFeNonlin -> :ref:`simu.dtNL <user-advanced-features-nonlinear>`
	
  * simu.rampT -> :ref:`simu.rampTime <user-code-structure-simulation-class>`
	
  * Added simu.dtME  to allow specification of :ref:`Morison force time-step <user-advanced-features-time-step>`


`WEC-Sim v2.2 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.2>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added option to save pressure data for nonlinear hydro (`simu.pressureDis`)

* Update to moorDyn parser (doesn't require line#.out)  

* Repository cleanup

  * Implemented `Git LFS <https://git-lfs.github.com/>`_ for tracking ``*.h5`` files
	
  *  Added `WEC-Sim Application  repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ as a `submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_
	
  *  Moved `moorDyn <https://github.com/WEC-Sim/moorDyn>`_ to its own repository
	
  *  Removed publications from repository, :ref:`available on website <intro-publications>`



`WEC-Sim v2.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v2.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Added MATLAB version of BEMIO (to replace python version)

* Added variable time-step option with 'ode45' by @ratanakso 

* Update to MCR, option to not re-load ``*.h5`` file by @bradling 

* Update to waveClass to allow for definition of min/max wave frequency by @bradling 

.. Note::

	**WEC-Sim v2.1 is not backward compatible**

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

	**WEC-Sim v2.0 is not backward compatible**

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
* Imports nondimensionalized BEMIO hydrodynamic data (instead of fully dimensional coefficients)
* Variant Subsystems implemented to improve code stability (instead of if statements)
* Bug fixes

.. Note::

	**WEC-Sim v1.2 is not backward compatible**

`WEC-Sim v1.1 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* WEC-Sim v1.1, `now available on GitHub <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.1>`_ 
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on :ref:`BEMIO <user-advanced-features-bemio>` output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation available on WEC-Sim Website

`WEC-Sim v1.0 <https://github.com/WEC-Sim/WEC-Sim/releases/tag/v1.0>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Initial release of WEC-Sim (originally on OpenEI, now available on GitHub)
* Available as a static download 
* Documentation available in PDF 


