
Introduction
==============

With Most it is possible to simulate Floating Offshore Wind Turbines (FOWTs) thanks to the development of a wind turbine model which can be coupled with the WEC-Sim library. MOST requires several user inputs similar to WEC-Sim including hydrodynamic bodies requiring hydrodynamic coefficients from Boundary Element Method (BEM) software (e.g. Nemoh, Wamit or Ansys Aqwa), mooring, constraints and simulation input details. Differently to WEC-Sim, MOST also includes user inputs relative to the wind turbine, wind and mooring which will be explained in the next sections.

Numerical code added to WEC-Sim is the followings:

=========================   =========================================
**File Type**               **File name**                     
Pre-processing Executable   ``mostIO.m``            
Post-Processing Functions   ``userDefineFunction.m``  
New MATLAB Classes          ``windClass.m`` and ``windTurbineClass.m``  
MOST Simulink Library       ``MOST.slx``          
=========================   =========================================


WEC-Sim source code has also been modified to include further option features relative to the new capabilities. The following code has been modified:

=========================================      ========================================================================== 
**File name**                                  **Description**                     
``initializeWecSim``                           it is modified to add functions relative to the wind, wind turbine 
                                               and new mooring blocks. New functions are created in each relative 
                                               class to read data prepared during  the pre-processing by the user. 
                                               Control parameters are also added to give user choice of which 
                                               control logic will be used.             
``mooringClass``                               it is now also possible to calculate mooring loads (static loads) 
                                               using non-linear look-up tables computed during pre-processing and 
                                               with system displacements as input. Compared to before, the 
                                               mooringClass now also has a function by means of which look-up 
                                               tables are loaded from a file whose name is the new property called 
                                               "lookupTableFile".
``postProcessWecSim`` + ``responseClass``      wind turbine results are post-processed and saved in the same WEC-Sim 
                                               output structure. Examples of outputs are the timeseries of wind turbine 
                                               power, rotor speed, blade pitch and nacelle acceleration.   
=========================================      ==========================================================================  


The following diagram summarises the workflow for the simulation of wave energy converters, which has now been updated to include the simulation of floating offshore wind turbines or hybrid devices. In grey are highlighted the portions of the code introduced with MOST, in green the portions executed by WEC-Sim codes, and in yellow what is carried out by external software.


.. figure:: IMAGE_workflow.png
   :width: 80%
:align: center
