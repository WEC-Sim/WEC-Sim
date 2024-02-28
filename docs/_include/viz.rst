

This section describes how to use ParaView for visualizing data from a WEC-Sim simulation. 
Using ParaView visualization improves on the SimMechanics explorer by:

* Visualizing the wave field
* Visualizing the cell-by-cell nonlinear hydrodynamic forces (when using nonlinear buoyancy and Froude-Krylov wave excitation)
* Allowing data manipulation and additional visualization options

However, the SimMechanics explorer shows the following information not included in the ParaView visualization:

* Location of center of gravity
* Location of different frames (e.g. PTO and Constraint frames)

Visualization with ParaView requires additional output files to be written to a ``vtk`` directory. 
This makes the WEC-Sim simulation take more time and the case directory larger, so it should only be used when additional visualization is desired. 
Users will also need to have some familiarity with using ParaView.
For more information about using ParaView for visualization, refer to the :ref:`webinar4`, and the `Paraview_Visualization <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Paraview_Visualization>`_ examples on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.


Install ParaView and WEC-Sim Macros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
First, install `ParaView 5.11.1 <http://www.paraview.org/>`_.  
Then, add the WEC-Sim specific macros:

* Open ParaView
* Click on ``Macros => Add new macro``
* Navigate to the WEC-Sim ``source/functions/paraview`` directory
* Select the first file and click ``OK``
* Repeat this for all .py files in the ``source/functions/paraview`` directory


WEC-Sim Visualization in ParaView
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When ``simu.paraview.option = 1``, a ``vtk`` directory is created inside the WEC-Sim $CASE directory. 
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
You can color waves and bodies by any of the available properties and apply any of the ParaView filters. The figures below show some of the visualization possibilities afforded by using ParaView with WEC-Sim.


.. figure:: /_static/images/overview/rm3_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Reference Model 3 <https://github.com/WEC-Sim/WEC-Sim/tree/main/examples/RM3>`_


.. figure:: /_static/images/overview/oswec_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Bottom-fixed Oscillating Surge WEC (OSWEC) <https://github.com/WEC-Sim/WEC-Sim/tree/main/examples/OSWEC>`_


.. figure:: /_static/images/overview/sphere_freedecay_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Sphere <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Free_Decay>`_


.. figure:: /_static/images/overview/ellipsoid_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Ellipsoid <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Nonlinear_Hydro>`_


.. figure:: /_static/images/overview/gbm_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Barge with Four Flexible Body Modes <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Generalized_Body_Modes>`_


.. figure:: /_static/images/overview/wigley_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   Wigley Ship Hull


.. figure:: /_static/images/overview/wecccomp_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   `Wave Energy Converter Control Competition (WECCCOMP) Wavestar Device <https://github.com/WEC-Sim/WECCCOMP>`_

.. figure:: /_static/images/overview/oc6_iso_side.png
   :width: 400pt
   :figwidth: 400pt
   :align: center

   OC6 Phase I DeepCwind Floating Semisubmersible
   





Two examples using Paraview for visualization of WEC-Sim data are provided in the `Paraview_Visualization <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Paraview_Visualization>`_ directory of the WEC-Sim Applications repository.
The `RM3_MoorDyn_Viz <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Paraview_Visualization/RM3_MoorDyn_Viz>`_ example uses ParaView for WEC-Sim data visualization of a WEC-Sim model coupled with `MoorDyn <http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn>`_ to simulate a mooring system for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ geometry.
The `OSWEC_NonLinear_Viz <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Paraview_Visualization/OSWEC_NonLinear_Viz>`_ example uses ParaView for WEC-Sim data visualization of a WEC-Sim model with `nonlinear Hydro <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation>`_ to simulate nonlinear wave excitation on the flap of the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec.>`_ geometry.

MoorDyn Visualization in ParaView
""""""""""""""""""""""""""""""""""""

The video below shows three different views of the RM3 model with MoorDyn.
The left view uses the WEC-Sim macro.
The top right view uses the ``slice`` filter.
The bottom right view shows the free surface colored by wave elevation.

.. raw:: html

        <iframe width="560" height="315" src="https://www.youtube.com/embed/yL6LHdYTBIo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>




Nonlinear Hydro Visualization in ParaView
""""""""""""""""""""""""""""""""""""""""""""""
When using nonlinear buoyancy and Froude-Krylov wave excitation the paraview files also contain cell data for the bodies.
The cell data are:

* Cell areas
* Hydrostatic pressures
* Linear Froude-Krylov pressures
* Nonlinear Froude-Krylov pressures

The ``pressureGlyphs`` macro calculates cell normals, and cell centers. It then creates the following glyphs:

* Hydrostatic pressure
* Linear Froude-Krylov pressure
* Nonlinear Froude-Krylov pressure
* Total pressure (hydrostatic plus nonlinear Froude-Krylov)
* Froude-Krylov delta (nonlinear minus linear)

To view WEC-Sim nonlinear hydro data in ParaView:

* Open the ``$CASE/vtk/<filename>.pvd`` file in ParaView
* Select the WEC-Sim model in the pipeline, and run the ``WEC-Sim`` macro
* Move the camera to desired view
* Select the WEC-Sim model again in the pipeline, and run the ``pressureGlyphs`` macro
* Select which features to visualize in the pipeline
* Click the green arrow (play) button

The video below shows three different views of the OSWEC model with non-linear hydrodynamics.
The top right shows glyphs of the nonlinear Froude-Krylov pressure acting on the float. 
The bottom right shows the device colored by hydrostatic pressure.

 .. raw:: html

	<iframe width="560" height="315" src="https://www.youtube.com/embed/JfKxQ1AgQBk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>


Loading a ParaView State File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If a previous ``*.pvsm`` ParaView state file was saved, the state can be applied to a ``*.pvd`` ParaView file. To load a state file:

* Open the ``$CASE/vtk/<filename>.pvd`` file in ParaView
* Click on ``File => Load State``
* Select the desired ``$CASE/<filename>.pvsm`` Paraview state file to apply
* Select the "Search files under specified directory" option, specify the desired WECS-Sim ``$CASE/vtk/`` directory, and click ``OK``

Paraview state files are provided for both `Paraview_Visualization <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/main/Paraview_Visualization>`_ examples provided onthe WEC-Sim Applications repository, one for the RM3 using MoorDyn, and another for the OSWEC with nonlinear hydro.


ParaView Visualization Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following table lists the WEC-Sim simulation parameters that can be specified in the ``wecSimInputFile`` to control the ParaView visualization. Note, the ``body.viz`` properties are also used for the SimMechanics explorer visualization.

+----------------------------------------------------------------------------------------+
| WEC-Sim Visualization using ParaView                                                   |
+============================+===========================================================+
| Variable                   | Description                                               |
+----------------------------+-----------------------------------------------------------+
| | ``simu.paraview.option`` | | 0 to not output ParaView files [default]                |
|                            | | 1 to output ParaView files                              |
+----------------------------+-----------------------------------------------------------+
| ``simu.paraview.startTime``| time (s) to start ParaView visualization                  |
+----------------------------+-----------------------------------------------------------+
| ``simu.paraview.endTime``  | time (s) to end ParaView visualization                    |
+----------------------------+-----------------------------------------------------------+
| ``simu.paraview.dt``       | time step between adjacent ParaView frames [default 1]    |
+----------------------------+-----------------------------------------------------------+
| ``simu.paraview.path``     | directory to create ParaView visualization files          |
+----------------------------+-----------------------------------------------------------+
| | ``simu.nonlinearHydro``  | | 0 for no nonlinear hydro [default]                      |
|                            | | 1 for nonlinear hydro with mean free surface            |
|                            | | 2 for nonlinear hydro with instantaneous free surface   |
+----------------------------+-----------------------------------------------------------+
| ``simu.domainSize``        | size of ground and water planes in meters [default 200]   |
+----------------------------+-----------------------------------------------------------+
| ``simu.dtOut``             | simulation output sampling time step [default dt]         |
+----------------------------+-----------------------------------------------------------+
| ``body(i).viz.color``      | [RGB] body color [default [1 1 0]]                        |
+----------------------------+-----------------------------------------------------------+
| ``body(i).viz.opacity``    | body opacity [default 1]                                  |
+----------------------------+-----------------------------------------------------------+
| | ``body(i).paraview``     | | 0 to exclude body from ParaView visualization           |
|                            | | 1 to include body in ParaView visualization [default]   |
+----------------------------+-----------------------------------------------------------+
| ``waves.viz.numPointsX``   | wave plane discretization: number of X points [default 50]|
+----------------------------+-----------------------------------------------------------+
| ``waves.viz.numPointsY``   | wave plane discretization: number of Y points [default 50]|
+---------------------------+------------------------------------------------------------+