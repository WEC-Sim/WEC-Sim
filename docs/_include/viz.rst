

This section describes how to setup, output, and use Paraview files for visualizing a WEC-Sim simulation. 
For more information about using Paraview for visualization, refer to the :ref:`webinar4`, and the **Viz** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.

Using Paraview visualization improves on SimMechanics's explorer by:

* Visualization of the wave field
* Visualization of the cell-by-cell non-linear hydrodynamic forces (when using nonlinear buoyancy and Froude-Krylov wave excitation)
* Allow data manipulation and more visualization options

On the other hand the SimMechanics explorer shows the following information not shown in Paraview visualizing:

* Location of the center of gravity
* Location of the different frames including PTO and Constraint frames

Visualization with paraview requires many files to be written, which makes the WEC-Sim simulation take significantly more time, and makes the directory significantly larger. 
It should only be turned on when visualization is desired. The user also needs to have some familiarity with using Paraview.


Getting Started - Installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You will need to install `Paraview <http://www.paraview.org/>`_ and install and setup Python.  
Next you will need to add some WEC-Sim specific macros, as follows:

* Open Paraview
* Click on ``Macros => Add new macro``
* Navigate to the WEC-Sim ``source/functions/paraview_macros`` directory
* Select the first file and click ``OK``
* Repeat this for all files in the ``paraview_macros directory.``


Setting Up Paraview Output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following table shows the variables that can be specified in the ``wecSimInputFile`` to control the Paraview visualization. The ``body.viz`` properties are also used in the SimMechanics explorer visualization.

+---------------------------------------------------------------------------------------+
| WEC-Sim Visualization using Paraview                                                  |
+===========================+===========================================================+
| Variable                  | Description                                               |
+---------------------------+-----------------------------------------------------------+
| | ``simu.paraview``       | | 0 to not output Paraview files [default]                |
|                           | | 1 to output Paraview files                              |
+---------------------------+-----------------------------------------------------------+
| ``simu.StartTimeParaview``| time (s) to start Paraview visualization                  |
+---------------------------+-----------------------------------------------------------+
| ``simu.EndTimeParaview``  | time (s) to end Paraview visualization	                |
+---------------------------+-----------------------------------------------------------+
| ``simu.dtParaview``       | time step between adjacent Paraview frames [default 1]    |
+---------------------------+-----------------------------------------------------------+
| ``simu.pathParaviewVideo``| directory to create Paraview visualization files          |
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
| | ``body(i).bodyparaview``| | 0 to exclude body from Paraview visualization           |
|                           | | 1 to include body in Paraview visualization [default]   |
+---------------------------+-----------------------------------------------------------+   
| ``waves.viz.numPointsX``  | wave plane discretization: number of X points [default 50]|
+---------------------------+-----------------------------------------------------------+   
| ``waves.viz.numPointsY``  | wave plane discretization: number of Y points [default 50]|
+---------------------------+-----------------------------------------------------------+   


Outputs and Opening in Paraview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When ``simu.paraview`` is set to 1, a user-specified directory containing ``vtk`` is created. 
All files necessary for Paraview visualization are located there.
To view in Paraview:

* Open the ``YOUR_PATH/vtk/filename.pvd`` file in Paraview
* Click ``Apply``
* With the model selected in the pipeline, run the ``WEC-Sim`` macro
* Move the camera to desired view
* Click the green arrow (play) button

The WEC-Sim macro:

* Extracts each body, sets the color and opacity, and renames them
* Extracts the waves, sets color and opacity, and renames
* Creates the ground plane
* Sets the camera to ``parallel view``


Basic Visualization Manipulation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
After opening the ``.pvd`` file and running the ``WEC-Sim`` macro you can do a number of things to visualize the simulation in different ways. 
You can color waves and bodies by any of the available properties and apply any of the Paraview filters.

The video below shows three different views of the OSWEC model described in the tutorials.
On the bottom right view the wave elevation is used to color the free surface. The top right view uses the ``slice`` filter.

.. raw:: html

	<iframe width="420" height="315" src="https://www.youtube.com/embed/KcsLi38Xjv0" frameborder="0" allowfullscreen></iframe>



Visualizing Non-Linear Buoyancy and Froude-Krylov Wave Excitation
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

The video below shows three different views of the RM3 model described in the tutorials.
The top right shows glyphs of the non-linear Froude-Krylov pressure acting on the float. 
The bottom right shows the float colored by hydrostatic pressure.

 .. raw:: html

	<iframe width="420" height="315" src="https://www.youtube.com/embed/VIPXsS8h9pg" frameborder="0" allowfullscreen></iframe>

