Release Notes
============================

WEC-Sim-1.1
---------------------------
New in v1.1
~~~~~~~~~~~~~~~~~~
#. Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
#. Implementation of state space representation of convolution integral term in the Cummins Equation
#. Implementation of a new input format for hydrodynamic data. Specifically, we developed a new boundary element method data format (the `bemio` format) using the `Hierarchical Data Format 5 <http://www.hdfgroup.org/>`_ (HDF5). A python library that provides functionality to read data from WAMIT, NEMOH, and AQWA and write the data to the bemio format used by WEC-Sim is provided.
#. Documentation moved to GitHub wiki

Backwards compatibility with WEC-Sim-1.0
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Simulink models created in WEC-Sim-1.0 provided users have not broke the library link in the .slx model file.
* The input files need to be modified to be compatible with WEC-Sim-1.1 due to changes in hydrodynamic data input format (see WEC-Sim-1.1 documentation), some variable name changes, and code structure improvements.
* MATLAB 2014b is required to run WEC-Sim-1.1.