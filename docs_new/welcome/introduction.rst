.. _user-getting-started:

Introduction to WEC-Sim
=======================

This section provides instructions on how to download, install, and test the 

Things to cover:

- reiterate home page data
- WEC-Sim capabilities / core features
- compare to 
- speed / accuracy?
	- reference OC6P1 paper and comparison?
- variety of applications cases
- paraview figures /gifs of Application cases
- cite private industries who have used WEC-Sim?
	- increase their visibility and our credibility

WEC-Sim (Wave Energy Converter SIMulator) is an open-source code for simulating wave energy converters. 
The code is developed in MATLAB/SIMULINK using the multi-body dynamics solver Simscape Multibody. 
WEC-Sim has the ability to model devices that are comprised of hydrodynamic bodies, joints and constraints, power take-of systems, and mooring systems.
Simulations are performed in the time-domain by solving the governing wave energy converter equations of motion in the 6 
rigid Cartesian degrees-of-freedom, plus any number of user-defined modes. 
As long as boundary element method data is available, a body may also move in any number of generalized body modes such as shear, torsion, or bending.
Several interfaces with Simulink are included that allow users to couple WEC-Sim with a wide variety of other models and scripts relevant to their devices.
Complex power take-off systems and advanced control algorithms are just two examples of the advanced tools that can be coupled with WEC-Sim.

Together with PTO and control systems, WEC-Sim is able to model a wide variety of marine devices.
The WEC-Sim Applications repository contains a wide variety of scenarios that WEC-Sim can model. This repository includes both demonstrations of WEC-Sim's advanced features and applications of WEC-Sim to unique devices.

WEC-Sim's capabilities include the ability to model both nonlinear hydrodynamic effects (Froude-Krylov forces and hydrostatic stiffness) and nonhydrodynamic bodies, body-to-body interactions, mooring systems, passive yawing. WEC-Sim contains numerous numerical options and ability to perform highly customizable batch simulations. WEC-Sim can take in data from a variety of boundary element method codes using its BEMIO (BEM-in/out) functionality and can output paraview files for visualization.

The Paraview figures below highlight some of WEC-Sim's capabilities and the various geometries that have been successfully modeled.
