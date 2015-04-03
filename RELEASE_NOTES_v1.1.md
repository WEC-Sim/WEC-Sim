# Release Notes for WEC-Sim v1.1
Release data: 2 April 2015

## New in v1.1
1. Improvements in code stability through modifications to the added mass, radiation damping calculations, and impulse response function calculations
2. Implementation of state space representation of convolution integral term in the Cummins Equation
3. Implementation of a new input format for hydrodynamic data. Specifically, we developed a new boundary element method data format (the **bemio** format) using the [Hierarchical Data Format 5 (HDF5)](http://www.hdfgroup.org/). A python library that provides functionality to read data from WAMIT, NEMOH, and AQWA and write the data to the bemio format used by WEC-Sim is provided.
4. Documentation moved to GitHub wiki
