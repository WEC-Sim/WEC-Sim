Release Notes
=============

WEC-Sim v1.2 Release Notes
--------------------------------
* Nonlinear Froude-Krylov hydrodynamics and hydrostatics
* State space radiation
* Wave directionality
* User-defined wave elevation time-series
* Imports non-dimensionalized BEMIO hydrodynamic data (instead of fully dimensional coefficients)
* 'Variant Subsystems' implemented to improve code stability (instead of if statements)
* Bug fixes

WEC-Sim v1.1 Release Notes
--------------------------------
* `WEC-Sim v1.1 download <https://github.com/WEC-Sim/WEC-Sim/releases>`_ available on GitHub
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on `BEMIO <http://wec-sim.github.io/bemio/#>`_ output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation available on `WEC-Sim website <http://wec-sim.github.io/WEC-Sim>`_

WEC-Sim Backward Compatibility 
--------------------------------
* Simulink models created in WEC-Sim v1.0 will work provided users have not broken the library link in the .slx model file.
* The input files need to be modified to be compatible with WEC-Sim due to changes in hydrodynamic data input format, variable name changes, and code structure improvements.

Features Under Development
---------------------------
* Morison Elements
* Body2Body Interactions
* NOTE: features currently under development are available on the `WEC-Sim 'dev' branch <https://github.com/WEC-Sim/WEC-Sim/tree/dev>`_