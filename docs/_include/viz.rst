

This section describes how to use ParaView for visualizing data from a WEC-Sim simulation. 
Using ParaView visualization improves on the SimMechanics explorer by:

* Visualizing the wave field
* Visualizing the cell-by-cell non-linear hydrodynamic forces (when using nonlinear buoyancy and Froude-Krylov wave excitation)
* Allowing data manipulation and additional visualization options

However, the SimMechanics explorer shows the following information not included in the ParaView visualization:

* Location of center of gravity
* Location of different frames (e.g. PTO and Constraint frames)

Visualization with ParaView requires additional output files to be written to a ``vtk`` directory. 
This makes the WEC-Sim simulation take more time and the case directory larger, so it should only be used when additional visualization is desired. 
Users will also need to have some familiarity with using ParaView.
For more information about using ParaView for visualization, refer to the :ref:`webinar4`, and the **Paraview_Visualization** examples on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.


Install ParaView and WEC-Sim Macros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
First, install `ParaView 5.9.1 <http://www.paraview.org/>`_.  
Then, add the WEC-Sim specific macros with the following steps:

* Open ParaView
* Click on ``Macros => Add new macro``
* Navigate to the WEC-Sim ``source/functions/paraview`` directory
* Select the first file and click ``OK``
* Repeat this for all files in the ``source/functions/paraview`` directory


ParaView Visualization Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following table lists the WEC-Sim simulation parameters that can be specified in the ``wecSimInputFile`` to control the ParaView visualization. Note, the ``body.viz`` properties are also used for the SimMechanics explorer visualization.

+---------------------------------------------------------------------------------------+
| WEC-Sim Visualization using ParaView                                                  |
+===========================+===========================================================+
| Variable                  | Description                                               |
+---------------------------+-----------------------------------------------------------+
| | ``simu.paraview``       | | 0 to not output ParaView files [default]                |
|                           | | 1 to output ParaView files                              |
+---------------------------+-----------------------------------------------------------+
| ``simu.StartTimeParaview``| time (s) to start ParaView visualization                  |
+---------------------------+-----------------------------------------------------------+
| ``simu.EndTimeParaview``  | time (s) to end ParaView visualization	                |
+---------------------------+-----------------------------------------------------------+
| ``simu.dtParaview``       | time step between adjacent ParaView frames [default 1]    |
+---------------------------+-----------------------------------------------------------+
| ``simu.pathParaviewVideo``| directory to create ParaView visualization files          |
+---------------------------+-----------------------------------------------------------+
| | ``simu.nlHydro``        | | 0 for no non-linear hydro [default]                     |
|                           | | 1 for non-linear hydro with mean free surface           |
|                           | | 2 for non-linear hydro with instantaneous free surface  |
+---------------------------+-----------------------------------------------------------+
| ``simu.domainSize``       | size of ground and water planes in meters [default 200]   |
+---------------------------+-----------------------------------------------------------+
| ``simu.dtOut``            | simulation output sampling time step [default dt]         |
+---------------------------+-----------------------------------------------------------+
| ``body(i).viz.color``     | [RGB] body color [default [1 1 0]]                        |
+---------------------------+-----------------------------------------------------------+   
| ``body(i).viz.opacity``   | body opacity [default 1]                                  |
+---------------------------+-----------------------------------------------------------+
| | ``body(i).bodyparaview``| | 0 to exclude body from ParaView visualization           |
|                           | | 1 to include body in ParaView visualization [default]   |
+---------------------------+-----------------------------------------------------------+   
| ``waves.viz.numPointsX``  | wave plane discretization: number of X points [default 50]|
+---------------------------+-----------------------------------------------------------+   
| ``waves.viz.numPointsY``  | wave plane discretization: number of Y points [default 50]|
+---------------------------+-----------------------------------------------------------+   


WEC-Sim Visualization in ParaView
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When ``simu.paraview`` is set to 1, a ``vtk`` directory is created inside the WEC-Sim $CASE directory. 
All files necessary for ParaView visualization are located there.
To view in ParaView:

* Open the ``$CASE/vtk/<filename>.pvd`` file in ParaView
* Select the WEC-Sim model in the pipeline, and run the ``WEC-Sim`` macro
* Move the camera to desired view
* Click the green arrow (play) button

The ``WEC-Sim`` macro:

* Extracts each body, sets the color and opacity, and renames them
* Extracts the waves, sets color and opacity, and renames
* Creates the ground plane
* Sets the camera to top view


After opening the ``.pvd`` file and running the ``WEC-Sim`` macro you can do a number of things to visualize the simulation in different ways. 
You can color waves and bodies by any of the available properties and apply any of the ParaView filters.
The video below shows three different views of the OSWEC model described in the tutorials.
The left view uses the WEC-Sim macro.
The top right view uses the ``slice`` filter.
The bottom right view shows the free surface colored by wave elevation. 

.. raw:: html

	<iframe width="420" height="315" src="https://www.youtube.com/embed/KcsLi38Xjv0" frameborder="0" allowfullscreen></iframe>


An example using Paraview for visualization of WEC-Sim data is provided in the ``Paraview_Visualization`` directory on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.
The **RM3_MoorDyn_Viz** example uses ParaView for WEC-Sim data visualization of a WEC-Sim model coupled with [MoorDyn](http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn) to simulate a mooring system for the [RM3](http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3) geometry. 


Non-Linear Hydro Visualization in ParaView
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When using non-linear buoyancy and Froude-Krylov Wave Excitation the paraview files also contain cell data for the bodies.
The cell data are:

* Cell areas
* Hydrostatic pressures
* Linear Froude-Krylov pressures
* Non-linear Froude-Krylov pressures

The ``pressureGlyphs`` macro calculates cell normals, and cell centers. It then creates the following glyphs:

* Hydrostatic Pressure
* Linear Froude-Krylov pressure
* Non-linear Froude-Krylov pressure
* Total pressure (hydrostatic plus non-linear Froude-Krylov)
* Froude-Krylov delta (non-linear minus linear)

To view WEC-Sim non-linear hydro data in ParaView:

* Open the ``$CASE/vtk/<filename>.pvd`` file in ParaView
* Select the WEC-Sim model in the pipeline, and run the ``WEC-Sim`` macro
* Move the camera to desired view
* Select the non-linear hydro body in the pipeline, and run the ``pressureGlyphs`` macro
* Select which features to visualize in the pipeline
* Click the green arrow (play) button

The video below shows three different views of the RM3 model described in the tutorials.
The top right shows glyphs of the non-linear Froude-Krylov pressure acting on the float. 
The bottom right shows the float colored by hydrostatic pressure.

 .. raw:: html

	<iframe width="420" height="315" src="https://www.youtube.com/embed/VIPXsS8h9pg" frameborder="0" allowfullscreen></iframe>


An example using Paraview for visualization of non-linear hydro WEC-Sim data is provided in the ``Paraview_Visualization`` directory on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.
The **OSWEC_NonLinear_Viz** example uses ParaView for WEC-Sim data visualization of a WEC-Sim model with [Non-linear Hydro](http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation) to simulate non-linear wave excitation on the flap of the [OSWEC](http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec) geometry. 

Loading a ParaView State File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If a previous `*.pvsm`` ParaView state file was saved, the state can be applied to a ``*.pvd`` ParaView file. To load a state file:

* Open the ``$CASE/vtk/<filename>.pvd`` file in ParaView
* Click on ``File => Load State``
* Select the desired ``$CASE/<filename>.pvsm`` Paraview state file to apply
* Select the "Search files under specified directory" option, specify the desired WECS-Sim ``$CASE/vtk/`` directory, and click ``OK``

Paraview state files are provided for both **Paraview_Visualization** examples on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository, one for the RM3 using MoorDyn, and another for the OSWEC with non-linear hydro.