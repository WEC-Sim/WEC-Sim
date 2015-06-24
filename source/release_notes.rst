Release Notes
=============

New Features in WEC-Sim v1.1
---------------------------
* Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
* Implementation of state space representation of radiation damping convolution integral calculation
* New hydrodynamic data format based on `BEMIO <https://github.com/WEC-Sim/bemio>`_ output, a python code that reads data from WAMIT, NEMOH, and AQWA and writes to the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5) format used by WEC-Sim.
* Documentation moved online: http://wec-sim.github.io/WEC-Sim/

Compatibility with WEC-Sim v1.0
---------------------------
* Simulink models created in WEC-Sim v1.0 will work provided users have not broken the library link in the .slx model file.
* The input files need to be modified to be compatible with WEC-Sim v1.1 due to changes in hydrodynamic data input format, variable name changes, and code structure improvements.
* MATLAB 2014b is required to run WEC-Sim v1.1.

Features Under Development
---------------------------
* User-defined irregular wave input
* Morison elements
* Wave-directionality
* Non-linear hydrostatics and hydrodynamics
* NOTE: Demonstration versions of features are available in the 'dev' branch