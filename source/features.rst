.. _features:


Advanced Features
===================

Nonlinear Hydrodynamic Forces
-----------------------
As described previously, WEC-Sim in based on linear hydrodynamic wave theory, which is reasonable if, the motion of the WEC device is small with respect to the device dimensions, and the submerged surface area remains approximately constant. 
If the system hydrodynamics are *slightly* nonlinear, WEC-Sim’s nonlinear hydrodynamics option, **simu.nlHydro = 2**, may be used to improve the simulation accuracy. 
That being said, WEC-Sim cannot, and is not intended to, model highly nonlinear hydrodynamic events such as wave slamming, overtopping, etc. 

Specifying the nonlinear hydrodynamics option in WEC-Sim prompts the calculation of the buoyancy force and Froude-Krylov portion of the excitation force based on the instantaneous position of the body and wave elevation, rather than the BEM calculated linear hydrodynamic force coefficients. 
The nonlinear buoyancy and the Froude-Krylov force components are obtained by integrating the static and dynamic pressures, respectively, over the instantaneous submerged surface area, as determined by the position of the body and wave elevation at each time step. 
Where, the static pressure is simply, :math:`P_{S} = \rho gz`, and the dynamic pressure is calculated based on the wave type specified; for example,  :math:`P_{D} = \frac{1}{2}\rho gHe^{kz} \sin{(\omega t - kx)}`, for an infinite depth regular wave. 
Currently, WEC-Sim’s nonlinear hydrodynamic option may be invoked with regular and irregular waves, finite and infinite depth waves, but not with user-defined irregular waves. 

When the nonlinear hydrodynamics option is specified, the .stl geometry file, which is only used for visualization purposes in linear simulations, is also used as the discretized body surface on which the nonlinear pressure forces are integrated. 
As such, when the nonlinear hydrodynamics option is used, additional care must be taken in creating the .stl file. 
The simulation accuracy will increase with increased surface resolution (i.e. the number of discretized surface panels specified in the .stl file), but the computation time will also significantly increase. 
An option available to reduce the nonlinear simulation time is to specify a nonlinear time step, **simu.dtFeNonlin**. 
The nonlinear time step specifies the interval at which the nonlinear hydrodynamic forces are calculated, separately, and presumably at a larger interval than the system level simulation time step (**simu.dt**). 
As the ratio of the nonlinear to system time step increases, the computation time is reduced, but again, at the expense of the simulation accuracy.

.. Note::
	'simu.nlHydro = 1;' option.

State-Space Representation
-----------------------
.. Note::

	Coming soon!

Body-To-Body Interaction
-----------------------
WEC-Sim allows for body-to-body interactions in the radiation force calculation.
That is, the motion of a body causes a force on all other bodies.
The radiation matrices for each body (radiation damping and added mass) required by WEC-Sim and contained in the *h5* file are of size *[(6\*N), 6]*, where *N* is the total number of hydrodynamic bodies.
By default, there is no body-to-body interactions and only the *[1+6\*(i-1):6\*i, 1:6]* sub-matrices are used for each body, where *i* is the body number.
When body-to-body interactions are used, the augmented *[(6\*N), 6]* matrices are multiplied by concatenated velocity and acceleration vectors of all hydrodynamic bodies.
For example, the radiation damping force for *body 2* in a 3-body system with body-to-body interactions would be calculated as the product of a [1,18] velocity vector, and a [18,6] radiation damping coefficients matrix.

To use body-to-body interactions in your WEC-Sim simulation simply set :code:`simu.b2b = 1` in your input file.


Morison Element
-----------------------
.. Note::

	Coming soon!

Multiple Condition Runs
-----------------------
.. Note::

	Coming soon!

Different Simulation Time Step Size
-----------------------------------
.. Note::

	Coming soon!


Writing Your Own h5 File
------------------------
The most common way of creating an h5 file is using BEMIO to post-process the outputs of a BEM code.
This requires a single BEM solution that contains all hydrodynamic bodies and accounts for body interactions.
Some cases in which you might want to create your own h5 file are:

* Use experimentally determined coefficients, or a mix of BEM and experimental coefficients.
* Combine results from different BEM files and have the coefficient matrices be the correct size for the new total number of bodies.
* Modify the BEM results for any other reason.

Matlab and Python have functions to read and write *h5* files easily.
WEC-Sim includes three functions to help you create your own h5 file. 
These are found under **/source/functions/writeH5/**.
The header comments of each function explain the inputs and outputs, and an example of how to use it is shown in **/tutorials/write_hdf5/create_h5file.m**.
The first step is to have all the required coefficients and properties in Matlab in the correct format.
Then the functions provided are used to create and populate the *h5* file. 

.. Note::

	The new *h5* file will not have the impulse response function coefficients required for the convolution integral.
	BEMIO is currently being modified to allow for reading an existing *h5* file.
	This would allow you to read in the *h5* file you created, calculate the required impulse response functions and state space coefficients and re-write the *h5* file.

.. Note::

	BEMIO is currently being modified to allow for the combination of different *h5* files into a single file.
	This would allow for the BEM of different bodies to be done separately, and BEMIO would take care of making the coefficient matrices the correct size.


Non-Hydrodynamic Bodies
-----------------------
For some cases, in order to obtain the correct dynamics, it might be important to model bodies that do not have hydrodynamic forces acting on them.
This could be bodies that are completely outside of the water, but are still connected through a joint to the WEC bodies, or it could be bodies deeply submerged to the point where the hydrodynamics can be neglected.
WEC-Sim allows for bodies which have no hydrodynamic forces acting on them, and for which no BEM data is provided.

To do this, use a regular *body block* and define it in the *input file* as any other body, leaving the name of the *h5* file as an empty string.
Specify :code:`body(i).nhBody = 1;` and specify body name, mass, moments of inertia, cg, geometry file, location, and displaced volume. 
You can also specify visualization options and initial displacement.

Advanced Constraints and PTOs
-----------------------------
The default linear and rotational constraints and PTOs are allow for heave and pitch motions of the follower relative to the base.
To obtain a linear or rotational constraint in a different direction you must modify the constraint's or PTO's coordinate orientation.
The important thing to remember is that a linear constraint or PTO will always allow motion along the joint's Z-axis, and a rotational constraint or PTO will allow rotation about the joint's Y-axis.
To obtain translation along or rotation about a different direction relative to the global frame, you must modify the orientation of the joint's coordinate frame.
This is done by setting the constraint's or PTO's :code:`orientation.z` and :code:`orientation.y` properties, which specify the new direction of the Z- and Y- joint coordinates.
The Z- and Y- directions must be perpendicular to each other.

As an example, if you want to constrain body 2 to surge motion relative to body 1 using a linear constraint, you would need the constraint's Z-axis to point in the direction of the global surge (X) direction.
This would be done by setting :code:`constraint(i).orientation.z=[1,0,0]` and the Y-direction to any perpendicular direction (can be left as the default y=[0 1 0]).
In this example the Y-direction would only have an effect on the coordinate on which the constraint forces are reported, but not on the dynamics of the system.
Similarly if you want to obtain a yaw constraint you would use a rotational constraint and align the constraint's Y-axis with the global Z-axis.
This would be done by setting :code:`constraint(i).orientation.y=[0,0,1]` and the  z-direction to a perpendicular direction (say [0,-1,0]).


Additionally, by combining constraints and PTOs in series you can obtain different motion constraints. 
For example, a massless rigid rod between two bodies, hinged at each body, can be obtained by using a two rotational constraints in series, both rotating in pitch, but with different locations.
A roll-pitch constraint can also be obtained with two rotational constraints in series; one rotating in pitch, and the other in roll, and both at the same location. 

Decay Tests
-----------
When performing simulations of decay tests you must use one of the no-wave cases, and setup the initial (time = 0) location of each body, constraint, PTO, and mooring block.
The initial location of a body or mooring block is set by specifying the CG or location at the stability position (as with any WEC-Sim simulation) and then specifying an initial displacement.
To specify an initial displacement, the body, and mooring blocks have a :code:`.initDisp` property with which you can specify a translation and angular rotation about an arbitrary axis.
For the constraint and PTO blocks, the :code:`.loc` property must be set to the location at time = 0.

There are methods available to help setup this initial displacement for all bodies, constraints, PTOs, and moorings.
To do this you would use the :code:`body(i).setInitDisp(...);`, :code:`constraint(i).setInitDisp(...)`, :code:`pto(i).setInitDisp(...)`, and :code:`mooring(i).setInitDisp(...)` method in the *input file*.
A description of the rquired input can be found in the method's header comments.
Note that :code:`body(i).cg`, :code:`constraint(i).loc`, :code:`pto(i).loc`, and :code:`mooring.ref` must be defined prior to using the object's :code:`.setInitDisp` method.



Advanced Body Mass and Geometry
-------------------------------
The mass of each body must be specified in the *input file*.
For the case of a floating body, the user has the option of setting :code:`body(i) = 'equilibrium'` in which case WEC-Sim will calculate the correct mass based on displaced volume and water density.
For the case of a fixed body, for which the mass is unknown and not important to the dynamics, you can specify :code:`body(i) = 'fixed'` which will set the mass to 999 kg and moment of inertia to [999 999 999].

To read in the geometry (stl) into Matlab use the :code:`body(i).bodyGeo` method, and the mesh details (vertices, faces, normals, areas, centroids) will be read into the :code:`body(i).bodyGeometry` property.
This is done automatically when using non-linear hydrodynamics or outputting ParaView visualization files.
You can then visualize the geometry using the :code:`body(i).plotStl` method.

.. include:: ptosim.rst

.. include:: moordyn.rst

.. include:: viz.rst
