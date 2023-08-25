.. _most-advanced_features:

Advanced Features
=================

Mooring Features
-------------------

MOST includes the possibility to simulate a mooring look-up table which is able to simulate a quasi-static, nonlinear mooring system. 
This option is based on the catenary equations similarly to the open-source code `MAP++ <https://map-plus-plus.readthedocs.io/en/latest/>`_. 


Mooring look-up table
^^^^^^^^^^^^^^^

Properties of the look-up table are defined in "moor_lookup". The mooring look-up table generation code assumes that the mooring 
lines are single and homogeneous mooring lines suspended between two points. Mooring line parameters are required to generate the look-up table:

* Mooring line diameter (m): :code:`d` 
* Mooring line length (m): :code:`L` 
* Linear mass (kg/m): :code:`linear_mass` 
* Sectional stiffness (N): :code:`EA`   
* Fairlead radial position (m): :code:`FL_X` 
* Fairlead vertical position (m): :code:`FL_Z` 
* Anchor radial position (m): :code:`AN_X` 
* Anchor vertical position (m): :code:`AN_Z` 
* Number of lines: :code:`number_lines` 
* Mooring line angles in xy plane (°): :code:`beta` 

Discretization parameters of the look-table include the discretization of the mooring loads for a single line and of the total mooring loads on the platform.
Mooring line discretization parameters are:

* Single line amplitude motion along radial direction (m): :code:`Xampl` 
* Single line discretisation values along radial direction : :code:`Xdiscr` 
* Single line amplitude motion along vertical direction (m): :code:`Zampl` 
* Single line discretisation values along vertical direction: :code:`Zdiscr`   

Total mooring loads discretization parameters are:

* Discretisation along surge dir (m): :code:`X` 
* Discretisation along sway dir (m): :code:`Y` 
* Discretisation along heave dir (m): :code:`Z` 
* Discretisation along roll dir (deg): :code:`RX` 
* Discretisation along pitch dir (deg): :code:`RY` 
* Discretisation along yaw dir (deg): :code:`RZ`  

Wind Features
-------------------
Wind speed can be defined choosing between the two options of the wind class:

* Constant wind conditions
* Turbolent wind conditions

The constant wind speed is constant in time and space while the second option includes the temporal and spatial turbulence of the wind.

.. figure:: WindSpeedOptions.JPG
   :width: 50%

TurbSim look-up table
^^^^^^^^^^^^^^^
The simulation of the wind turbine for turbolent wind conditions requires the generation of a look-up table which relates the temporal 
and spatial variation of wind speed on the wind turbine rotor plane (yz plane). Therefore the wind speed is discretized for 3 variable (2 spatial parameters (y and z) and the time).
The look-up table is generated using "run_turbsim" which computes turbolent wind speeds based on `Turbsim <https://www.nrel.gov/wind/nwtc/turbsim.html>`_ executable. 
Turbolent wind speed values can be defined in "run_turbsim" while other Turbsim parameters can be set-up in the "Turbsim_inputfile.txt" file. A detailed description of using Turbsim 
is given in the `Turbsim <https://www.nrel.gov/wind/nwtc/turbsim.html>`_ page.

Aerodynamic wind loads calculation in the Simulink model requires the average wind speed for each blade. This is found computing the average wind speed for four discretized points along the blade length during the simulation. Relative wind speed for each blade is computed including the influence of the horizontal hub speed and the pitch and yaw rotation of the hub.

Wind turbine Features
-------------------


Wind turbine properties
^^^^^^^^^^^^^^^


Aerodynamic loads
^^^^^^^^^^^^^^^


Control
^^^^^^^^^^^^^^^


TODO - describe the MOST example, how to change it, what the varies parameters mean, etc
Mirror the WEC-Sim user manual/advanced features section
