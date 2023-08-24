.. _most-advanced_features:

Advanced Features
=================

Mooring Features
-------------------

MOST includes the possibility to simulate a mooring look-up table which is able to simulate a quasi-static, nonlinear mooring system. 
This option is based on the catenary equations similarly to the open-source code `MAP++ <https://map-plus-plus.readthedocs.io/en/latest/>`_. 


Mooring look-up table
^^^^^^^^^^^^^^^

Properties of the look-up table are defined in the moor_lookup script. The mooring look-up table generation code assumes that the mooring lines are single lines 
Mooring line parameters are required to generate the look-up table:

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

TurbSim look-up table
^^^^^^^^^^^^^^^


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
