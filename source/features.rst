.. _features:

Advanced Features
===================
This sections provides an overview of the advanced features of the WEC-Sim code that were not covered in the `Tutorials <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_ section.


.. BEMIO

.. include:: bemio.rst


State-Space Representation
---------------------------------
The convolution integral term in the equation of motion can be linearized using the state-space representation as described in the Theory Section. To use state-space representation, the **simu.ssCalc** simulationClass variable must be defined in the WEC-Sim input file, for example:

	:code:`simu.ssCalc = 1` 

Non-Linear Hydrodynamics 
---------------------------------
WEC-Sim has the option to include the non-linear hydrostatic restoring and Froude-Krylov forces when solving the system dynamics of WECs, accounting for the weakly nonlinear effect on the body hydrodynamics. To use non-linear hydrodyanmics, the **simu.nlHydro** simulationClass variable must be defined in the WEC-Sim input file, for example: 

	:code:`simu.nlHydro = 2`  
	
For more information about non-linear hydrodynamics, refer to the webinar `available here <http://wec-sim.github.io/WEC-Sim/webinars.html#wec-sim-webinar-2-nonlinear-hydro-non-hydro-b2b>`_, 


Non-Linear Settings
~~~~~~~~~~~~~~~~~~~~~
	**simu.nlHydro**  - 
	The nonlinear hydrodynamics option can be used by setting :code:`simu.nlHydro = 2` or :code:`simu.nlHydro = 1` in your WEC-Sim input file. Typically, :code:`simu.nlHydro = 2` is recommended if nonlinear hydrodynamic effects need to be used. Note that :code:`simu.nlHydro = 1` only considers the nonlinear restoring and Froude-Krylov forces based on the body position and mean wave elevation. 

	**simu.dtFeNonlin** - 
	An option available to reduce the nonlinear simulation time is to specify a nonlinear time step, :code:`simu.dtFeNonlin=N*simu.dt`, where N is number of increment steps. The nonlinear time step specifies the interval at which the nonlinear hydrodynamic forces are calculated. As the ratio of the nonlinear to system time step increases, the computation time is reduced, again, at the expense of the simulation accuracy.


.. Note::

	 WEC-Sim's nonlinear hydrodynamic option may be used for regular or irregular waves but not with user-defined irregular waves. 


STL File Generation
~~~~~~~~~~~~~~~~~~~~~~
	When the nonlinear option is turned on, the geometry file (``*.stl``) (previously only used for visualization purposes in linear simulations) is used as the discretized body surface on which the non-linear pressure forces are integrated. A good STL mesh resolution is required for the WEC body geometry file(s) when using the non-linear hydrodynamics in WEC-Sim. The simulation accuracy will increase with increased surface resolution (i.e. the number of discretized surface panels specified in the .stl file), but the computation time will also increase. 
	
	There are many ways to generate an STL file; however, it is important to verify the quality of the mesh before running WEC-Sim simulations with the non-linear hydro flag turned on. An STL file can be exported from from most CAD programs, but few allow adaquate mesh refinement. A good program to perform STL mesh refinement is `Rhino3d <https://www.rhino3d.com/>`_. Some helpful resources explaining how to generate and refine an STL mesh in Rhino3d are: https://wiki.mcneel.com/rhino/meshfaqdetails and https://vimeo.com/80925936.	
	
.. Note::

	 All STL files must be saved as ASCII (not binary)
 

Non-Linear Tutorial - Heaving Ellipsoid
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	The body tested in the study is an ellipsoid with a cross- section characterized by semi-major and -minor axes of 5.0 m and 2.5 m in the wave propagation and normal directions, respectively . The ellipsoid is at its equilibrium position with its origin located at the mean water surface. The mass of the body is then set to 1.342×105 kg, and the center of gravity is located 2 m below the origin.

	.. _nonlinearEllipsoid:

	.. figure:: _static/nonlinearEllipsoid.png
	    :width: 350pt
	    :align: center

	STL file with the discretized body surface is shown below (``ellipsoid.stl``)

	.. _nonlinearMesh:

	.. figure:: _static/nonlinearMesh.png
	    :width: 250pt
	    :align: center

	The single-body heave only WEC model is shown below (``nonLinearHydro.slx``)

	.. _nonlinearWEC:

	.. figure:: _static/nonlinearWEC.png
	    :width: 450pt
	    :align: center

	The WEC-Sim input file used to run the non-linear hydro WEC-Sim simulation:

	.. _nonLinaerwecSimInputFile:

	.. literalinclude:: nonLinaerwecSimInputFile.m
	   :language: matlab

	Simulation and post-processing is the same process as described in `Tutorial Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>_`.


Non-Hydrodynamic Bodies
---------------------------------
For some simulations, it might be important to model bodies that do not have hydrodynamic forces acting on them. This could be bodies that are completely outside of the water but are still connected through a joint to the WEC bodies, or it could be bodies deeply submerged to the point where the hydrodynamics may be neglected. WEC-Sim allows for bodies which have no hydrodynamic forces acting on them and for which no BEM data is provided.

To do this, use a Body Block from the WEC-Sim  Library and initialize it in the WEC-Sim input file as any other body but leave the name of the ``h5`` file as an empty string. Specify :code:`body(i).nhBody = 1;` and specify body name, mass, moments of inertia, cg, geometry file, location, and displaced volume. You can also specify visualization options and initial displacement.

To use non-hydrodynamic bodies, the following bodyClass variable must be defined in the WEC-Sim input file, for example:

	:code:`body(i).nhBody = 1` 


For more information about non-hydro bodies, refer to the webinar `available here <http://wec-sim.github.io/WEC-Sim/webinars.html#wec-sim-webinar-2-nonlinear-hydro-non-hydro-b2b>`_, 

Body-To-Body Interactions
---------------------------------
WEC-Sim allows for body-to-body interactions in the radiation force calculation, thus allowing the motion of one body to impart a force on all other bodies. The radiation matrices for each body (radiation damping and added mass) required by WEC-Sim and contained in the ``*.h5`` file. **For body-to-body interactions with N total hydrodynamic bodies, the** ``*h5`` **data structure is [(6\*N), 6]**.

When body-to-body interactions are used, the augmented [(6\*N), 6] matrices are multiplied by concatenated velocity and acceleration vectors of all hydrodynamic bodies. For example, the radiation damping force for body(2) in a 3-body system with body-to-body interactions would be calculated as the product of a [1,18] velocity vector and a [18,6] radiation damping coefficients matrix.

To use body-to-body interactions, the following simulationClass variable must be defined in the WEC-Sim input file, for example:

	:code:`simu.b2b = 1`
	
For more information about b2b interactions, refer to the webinar `available here <http://wec-sim.github.io/WEC-Sim/webinars.html#wec-sim-webinar-2-nonlinear-hydro-non-hydro-b2b>`_, 	

.. Note::

	By default, body-to-body interactions  are off (:code:`simu.b2b = 0`), and only the *[1+6\*(i-1):6\*i, 1:6]* sub-matrices are used for each body (where **i** is the body number).

Time-Step Features
---------------------------------

Fixed Time-Step (ode4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	When running WEC-Sim with a fixed time-step, 100-500 time-steps per wave period is typically sufficient to provide accurate hydrodynamic force calculations. However, smaller time steps may be required (such as when coupling WEC-Sim with MoorDyn or PTO-Sim). To reduce the required WEC-Sim simulation time, a different time step size may be specified for nonlinear hydrodynamics and for convolution integral calculations. 

	The following variables may be changed in the simulationClass:

	* Fixed time-step: :code:`simu.dt` 
	* Output time-step: :code:`simu.dtOut` 
	* Nonlinear hydrodynamics time-step: :code:`simu.dtFeNonlin=N*simu.dt` 
	* Convolution integral time-step: :code:`simu.dtCITime=N*simu.dt` 

.. Note::

	ode4 with a fixed time-step is the WEC-Sim default solver (where N is number of increment steps, default: N=1)

Variable Time-Step (ode45)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	To run WEC-Sim with a variable time-step, the following variables must be changed in the simulationClass:

	* Change numerical solver: :code:`simu.solver='ode45'` 
	* Set max time-step: :code:`simu.dtMax` 


Body Mass and Geometry Features
---------------------------------
The mass of each body must be specified in the  WEC-Sim input file. The following features are available:

* **Floating Body** - the user may set :code:`body(i).mass = 'equilibrium'` which will calculate the body mass based on displaced volume and water density. If :code:`simu.nlhydro = 0`, then the mass is calculated using the dispaced volume contained in the ``*.h5`` file. If :code:`simu.nlhydro = 1` or :code:`simu.nlhydro = 2`, then the mass is calculated using the displaced volume of the provided STL geometry file.

* **Fixed Body** - if the mass is unknown (or not important to the dynamics), the user may specify :code:`body(i).mass = 'fixed'` which will set the mass to 999 kg and moment of inertia to [999 999 999] kg-m^2.

* **Import STL** - to read in the geometry (stl) into Matlab use the :code:`body(i).bodyGeo` method in the bodyClass. This method will import the mesh details (vertices, faces, normals, areas, centroids) into the :code:`body(i).bodyGeometry` property. This method is also used for non-linear hydrodynamics and ParaView visualization files. Users can then visualize the geometry using the :code:`body(i).plotStl` method.


Constraint and PTO Features
---------------------------------
The default linear and rotational constraints and PTOs are allow for heave and pitch motions of the follower relative to the base.
To obtain a linear or rotational constraint in a different direction you must modify the constraint's or PTO's coordinate orientation.
The important thing to remember is that a linear constraint or PTO will always allow motion along the joint's Z-axis, and a rotational constraint or PTO will allow rotation about the joint's Y-axis.
To obtain translation along or rotation about a different direction relative to the global frame, you must modify the orientation of the joint's coordinate frame.
This is done by setting the constraint's or PTO's :code:`orientation.z` and :code:`orientation.y` properties which specify the new direction of the Z- and Y- joint coordinates.
The Z- and Y- directions must be perpendicular to each other.

As an example, if you want to constrain body 2 to surge motion relative to body 1 using a linear constraint, you would need the constraint's Z-axis to point in the direction of the global surge (X) direction.
This would be done by setting :code:`constraint(i).orientation.z=[1,0,0]` and the Y-direction to any perpendicular direction (can be left as the default y=[0 1 0]).
In this example, the Y-direction would only have an effect on the coordinate on which the constraint forces are reported but not on the dynamics of the system.
Similarly if you want to obtain a yaw constraint you would use a rotational constraint and align the constraint's Y-axis with the global Z-axis.
This would be done by setting :code:`constraint(i).orientation.y=[0,0,1]` and the  z-direction to a perpendicular direction (say [0,-1,0]).


Additionally, by combining constraints and PTOs in series you can obtain different motion constraints. 
For example, a massless rigid rod between two bodies, hinged at each body, can be obtained by using a two rotational constraints in series, both rotating in pitch, but with different locations.
A roll-pitch constraint can also be obtained with two rotational constraints in series; one rotating in pitch, and the other in roll, and both at the same location. 


Multiple Condition Runs (MCR)
---------------------------------
WEC-Sim allows users to perform batch runs by typing ``wecSimMCR`` into the MATLAB Command Window. This command executes the Multiple Condition Run (MCR) option, which can be initiated three different ways:

	**Option 1.** Specify a range of sea states and PTO damping coefficients in the WEC-Sim input file, example: 
	``waves.H = 1:0.5:5; waves.T = 5:1:15;``
	``pto(1).k=1000:1000:10000; pto(1).c=1200000:1200000:3600000;``        

	**Option 2.**  Specify the excel filename that contains a set of wave statistic data in the WEC-Sim input file. This option is generally useful for power matrix generation, example:
	``statisticsDataLoad = "<Excel file name>.xls"``

	**Option 3.**  Provide a MCR case *.mat* file, and specify the filename in the WEC-Sim input file, example:
	``simu.mcrCaseFile = "<File name>.mat"``

For more information about MCR, refer to the webinar `available here <http://wec-sim.github.io/WEC-Sim/webinars.html#wec-sim-webinar-1-bemio-mcr>`_

.. Note::

	For Multiple Condition Runs, the *.h5* hydrodynamic data is only loaded once. To override this default (and reload the *.h5* hydrodynamic data between runs),  set ``simu.reloadH5Data =1`` in the WEC-Sim input file. 


Decay Tests
---------------------------------
When performing simulations of decay tests, you must use one of the no-wave cases and setup the initial (time = 0) location of each body, constraint, PTO, and mooring block.
The initial location of a body or mooring block is set by specifying the CG or location at the stability position (as with any WEC-Sim simulation) and then specifying an initial displacement.
To specify an initial displacement, the body and mooring blocks have a :code:`.initDisp` property with which you can specify a translation and angular rotation about an arbitrary axis.
For the constraint and PTO blocks, the :code:`.loc` property must be set to the location at time = 0.

There are methods available to help setup this initial displacement for all bodies, constraints, PTOs, and moorings.
To do this, you would use the :code:`body(i).setInitDisp(...);`, :code:`constraint(i).setInitDisp(...)`, :code:`pto(i).setInitDisp(...)`, and :code:`mooring(i).setInitDisp(...)` method in the WEC-Sim input file.
A description of the required input can be found in the method's header comments.
Note that :code:`body(i).cg`, :code:`constraint(i).loc`, :code:`pto(i).loc`, and :code:`mooring.ref` must be defined prior to using the object's :code:`.setInitDisp` method.


.. MoorDyn

.. include:: moordyn.rst


.. PTO-Sim

.. include:: ptosim.rst


.. ParaView

.. include:: viz.rst

