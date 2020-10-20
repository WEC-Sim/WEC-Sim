.. _advanced_features:

Advanced Features
=================
.. Note:: 
	Adam:
	My summary: Some sections feel like a strange mix of theoretical information and code details. I think it is better to break up each 'feature' into an initial theory subsection (what it is, why it is necessary/useful, what its pros/cons are) and a following implementation subsection (variable names, related functions, classes, etc, example of how to implement if more complex).
	Also, the advanced features are essentially the same cases as the WEC-Sim Applications repo. However, this not made very clear at the beginning. I think that the Adv. Features section can better mesh with the applications by acting as a walkthrough for a user interested in that topic. As in other parts of the documentation, the 'what is happening' is well covered but the why is not addressed as well. The applications themselves can better compare the effects of what they are trying to show. Make it easy for users to see the advantages of the code and the pros/cons of each feature. Use each application’s user defined function file to highlight the advantages of that application and compare to a standard case.
	These two areas are closely tied, so I will also write my notes on the WEC-Sim app repo below. Not all advanced features are covered by an application, and not all applications have an adv. feature section. These should have clear connections with minimal mixing of cases so that it is easy to follow.
	
	Applications:
	B2B - error with b2b + CIC calculation block in Simulink?
	Desal - needs an advanced feature section. Requires Simscape Fluids...
	Free decay - change plotting of cases so that Morison Element is included in the comparison of the results
	GBM - needs comparison to a similar non-flex body simulation
	Mooring - add script to run mooring matrix, Moordyn and no-mooring simulations and compare
	MCR - dot divide error in waveClass for MCR waves.H, waves.T (opt2, opt2). Uncomment waves.spectrumDatafile =" by default so that it runs
	Nonhydro body - N/A
	Nonlinear hydro - error with plotForces call in userDefinedFunctions.m
	Paraview - N/A
	Passive Yaw - Divide runYawCases.m into run and plot scripts for consistency with other applications
	PTO-Sim - N/A
	WECCCOMP Fault Implementation - needs adv. feature page or move to other repo?
	Write HDF5 - No explanation on how to use other than to ‘fill in parameters’
..

The advanced features documentation provides an overview of WEC-Sim features that were not covered in the WEC-Sim :ref:`tutorials`. The diagram below highlights some of WEC-Sim's advanced features, details of which will be described in the following sections. 

.. codeFeatures:

.. figure:: _images/codeFeatures.png
   :width: 400pt
   :align: center   
    
   ..



.. _bemio:

BEMIO
-----

.. include:: bemio.rst


Simulation Features
---------------------------------
This section provides an overview of WEC-Sim's simulation class features; for more information about the simulation class code structure, refer to :ref:`code_structure:Simulation Class`. 

Multiple Condition Runs (MCR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim allows users to perform batch runs by typing ``wecSimMCR`` into the MATLAB Command Window. This command executes the Multiple Condition Run (MCR) option, which can be initiated three different ways:

	**Option 1.** Specify a range of sea states and PTO damping coefficients in the WEC-Sim input file, example: 
	``waves.H = 1:0.5:5; waves.T = 5:1:15;``
	``pto(1).k=1000:1000:10000; pto(1).c=1200000:1200000:3600000;``        

	**Option 2.**  Specify the excel filename that contains a set of wave statistic data in the WEC-Sim input file. This option is generally useful for power matrix generation, example:
	``waves.statisticsDataLoad = "<Excel file name>.xls"``

	**Option 3.**  Provide a MCR case *.mat* file, and specify the filename in the WEC-Sim input file, example:
	``simu.mcrCaseFile = "<File name>.mat"``

For Multiple Condition Runs, the ``*.h5`` hydrodynamic data is only loaded once. To reload the ``*.h5`` data between runs,  set ``simu.reloadH5Data =1`` in the WEC-Sim input file. 

For more information, refer to :ref:`webinar1`, and the **RM3_MCR** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 


State-Space Representation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The convolution integral term in the equation of motion can be linearized using the state-space representation as described in the :ref:`theory` section. To use a state-space representation, the ``simu.ssCalc`` simulationClass variable must be defined in the WEC-Sim input file, for example:

	:code:`simu.ssCalc = 1` 


Time-Step Features
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The default WEC-Sim solver is 'ode4'. Refer to the **NonlinearHydro** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository for a comparisons between 'ode4' to 'ode45'. The following variables may be changed in the simulationClass (where N is number of increment steps, default: N=1):

* Fixed time-step: :code:`simu.dt` 
* Output time-step: :code:`simu.dtOut=N*simu.dt` 
* Nonlinear Buoyancy and Froude-Krylov Excitation time-step: :code:`simu.dtNL=N*simu.dt` 
* Convolution integral time-step: :code:`simu.dtCITime=N*simu.dt` 	
* Morison force time-step: :code:`simu.dtME = N*simu.dt` 


Fixed Time-Step (ode4)
""""""""""""""""""""""""""""""
When running WEC-Sim with a fixed time-step, 100-200 time-steps per wave period is recommended to provide accurate hydrodynamic force calculations (ex: simu.dt = T/100, where T is wave period). However, a smaller time-step may be required (such as when coupling WEC-Sim with MoorDyn or PTO-Sim). To reduce the required WEC-Sim simulation time, a different time-step  may be specified for nonlinear buoyancy and Froude-Krylov excitation and for convolution integral calculations. For all simulations, the time-step should be chosen based on numerical stability and a convergence study should be performed.


Variable Time-Step (ode45)
""""""""""""""""""""""""""""""
.. Note:: 
	Adam:
	What is the benefit to doing this? The maximum set, but how is the instantaneous dt value determined?

To run WEC-Sim with a variable time-step, the following variables must be defined in the simulationClass:

* Numerical solver: :code:`simu.solver='ode45'` 
* Max time-step: :code:`simu.dt` 


Wave Features
-------------------------
This section provides an overview of WEC-Sim's wave class features. For more information about the wave class code structure, refer to :ref:`code_structure:Wave Class`. 


Irregular Wave Binning
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim's default spectral binning method divides the wave spectrum into 499 bins with equal energy content, defined by 500 wave frequencies. As a result, the wave forces on the WEC using the equal energy method are only computed at each of the 500 wave frequencies. The equal energy formulation speeds up the irregular wave simulation time by reducing the number of frequencies the wave train is defined by, and thus the number of frequencies for which the wave forces are calculated. The equal energy method is specified by defining the following wave class variable in the WEC-Sim input file:

	:code:`waves.freqDisc = 'EqualEnergy';`

By comparison, the traditional method divides the wave spectrum into a sufficiently large number of equally spaced bins to define the wave spectrum. WEC-Sim's traditional formulation uses 999 bins, defined by 1000 wave frequencies of equal frequency distribution. To override WEC-Sim's default equal energy method, and instead use the traditional binning method, the following wave class variable must be defined in the WEC-Sim input file:

	:code:`waves.freqDisc = 'Traditional';`

Users may override the default number of wave frequencies by defining ``waves.numFreq``.  However, it is on the user to ensure that the wave spectrum is adequately defined by the number of wave frequencies, and that the wave forces are not impacted by this change.

.. Note:: 
	Adam:
	Why would a user use an equal energy vs traditional equal frequency spectrum? Pros/cons?

Wave Directionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. Note:: 
	Adam:
	It looks like beta is used in this advanced features section, but theta is in the theory sections

WEC-Sim has the ability to model waves with various angles of incidence, :math:`\beta`. To define wave directionality in WEC-Sim, the following wave class variable must be defined in the WEC-Sim input file:

	:code:`waves.waveDir = <user defined wave direction(s)>; %[deg]`  	
	
The incident wave direction has a default heading of 0 Degrees (Default = 0), and should be defined as a column vector for more than one wave direction. For more information about the wave formulation, refer to :ref:`theory:Wave Spectra`.

Wave Directional Spreading
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim has the ability to model waves with directional spreading, :math:`D\left( \beta \right)`. To define wave directional spreading in WEC-Sim, the following wave class variable must be defined in the WEC-Sim input file:

	:code:`waves.waveSpread = <user defined directional spreading>;`  	
	
The wave directional spreading has a default value of 1 (Default = 1), and should be defined as a column vector of directional spreading for each one wave direction. For more information about the spectral formulation, refer to :ref:`theory:Wave Spectra`.

.. Note::

	Users must define appropriate spreading parameters to ensure energy is conserved. Recommended directional spreading functions include Cosine-Squared and Cosine-2s.

.. _seeded_phase:

Irregular Waves with Seeded Phase
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
By default, the phase for all irregular wave cases are generated randomly. In order to reproduce the same time-series every time an irregular wave simulation is run, the following wave class variable may be defined in the WEC-Sim input file:

	:code:`waves.phaseSeed = <user defined seed>;`
	
By setting ``waves.phaseSeed``  equal to 1,2,3,...,etc, the random wave phase generated by WEC-Sim is seeded, thus producing the same random phase for each simulation. 


Wave Gauge Placement 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
By default, the wave surface elevation is calculated at the origin. Users are allowed up to 3 other x-locations to calculate the wave surface elevation offset from the origin in the global x-direction by defining the wave class variable, ``waves.wavegauge<i>loc``, in the WEC-Sim input file:

	:code:`waves.wavegauge<i>loc = <user defined wave gauge i x-location>; %(y-position assumed to be 0 m)`

where i = 1, 2, or 3

The WEC-Sim numerical wave gauges output the undisturbed linear incident wave elevation at the wave gauge locations defined above. The numerical wave gauges do not handle the incident wave interaction with the radiated or diffracted waves that are generated because of the presence and motion of the WEC hydrodynamic bodies. This option provides the following wave elevation time series:

	:code:`waves.waveAmpTime<i> = incident wave elevation time series at wave gauge i`


Body Features
--------------
This section provides an overview of WEC-Sim's body class features; for more information about the body class code structure, refer to :ref:`code_structure:Body Class`. 

Body Mass and Geometry Features
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The mass of each body must be specified in the  WEC-Sim input file. The following features are available:

* **Floating Body** - the user may set :code:`body(i).mass = 'equilibrium'` which will calculate the body mass based on displaced volume and water density. If :code:`simu.nlhydro = 0`, then the mass is calculated using the displaced volume contained in the ``*.h5`` file. If :code:`simu.nlhydro = 1` or :code:`simu.nlhydro = 2`, then the mass is calculated using the displaced volume of the provided STL geometry file.

* **Fixed Body** - if the mass is unknown (or not important to the dynamics), the user may specify :code:`body(i).mass = 'fixed'` which will set the mass to 999 kg and moment of inertia to [999 999 999] kg-m^2.

* **Import STL** - to read in the geometry (``*.stl``) into Matlab use the :code:`body(i).bodyGeo` method in the bodyClass. This method will import the mesh details (vertices, faces, normals, areas, centroids) into the :code:`body(i).bodyGeometry` property. This method is also used for nonlinear buoyancy and Froude-Krylov excitation and ParaView visualization files. Users can then visualize the geometry using the :code:`body(i).plotStl` method.


.. _nonlinear:

Nonlinear Buoyancy and Froude-Krylov Excitation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. Note:: 
	Adam:
	simu.nlHydro options 1 vs 2 not stated clearly. Doesn’t need much info, but should state clearly

WEC-Sim has the option to include the nonlinear hydrostatic restoring and Froude-Krylov forces when solving the system dynamics of WECs, accounting for the weakly nonlinear effect on the body hydrodynamics. To use nonlinear buoyancy and Froude-Krylov excitation, the **simu.nlHydro** simulationClass variable must be defined in the WEC-Sim input file, for example: 

	:code:`simu.nlHydro = 2`  
	
For more information, refer to the :ref:`webinar2`, and the **NonlinearHydro** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 


Nonlinear Settings
""""""""""""""""""""""""""""""
**simu.nlHydro**  - 
The nonlinear hydrodynamics option can be used by setting :code:`simu.nlHydro = 2` or :code:`simu.nlHydro = 1` in your WEC-Sim input file. Typically, :code:`simu.nlHydro = 2` is recommended if nonlinear buoyancy and Froude-Krylov effects need to be used. Note that :code:`simu.nlHydro = 1` only considers the nonlinear hydrostatic and Froude-Krylov wave excitations based on the body position and mean wave elevation. 

**simu.dtNL** - 
An option available to reduce the nonlinear simulation time is to specify a nonlinear time step, :code:`simu.dtNL=N*simu.dt`, where N is number of increment steps. The nonlinear time step specifies the interval at which the nonlinear hydrodynamic forces are calculated. As the ratio of the nonlinear to system time step increases, the computation time is reduced, again, at the expense of the simulation accuracy.


.. Note::
	WEC-Sim's nonlinear buoyancy and Froude-Krylov wave excitation option may be used for regular or irregular waves but not with user-defined irregular waves. 
.. Note:: 
	Adam:
	Why can’t nonlinear buoyancy and nonlinear FK be used with user-defined wave? Doesn’t it just use the mean/instantaneous wave elevation?


STL File Generation
""""""""""""""""""""""""""""""
When the nonlinear option is turned on, the geometry file (``*.stl``) (previously only used for visualization purposes in linear simulations) is used as the discretized body surface on which the nonlinear pressure forces are integrated. A good STL mesh resolution is required for the WEC body geometry file(s) when using the nonlinear buoyancy and Froude-Krylov wave excitation in WEC-Sim. The simulation accuracy will increase with increased surface resolution (i.e. the number of discretized surface panels specified in the ``*.stl`` file), but the computation time will also increase. 

There are many ways to generate an STL file; however, it is important to verify the quality of the mesh before running WEC-Sim simulations with the nonlinear hydro flag turned on. An STL file can be exported from most CAD programs, but few allow adequate mesh refinement. A good program to perform STL mesh refinement is `Rhino <https://www.rhino3d.com/>`_. Some helpful resources explaining how to generate and refine an STL mesh in Rhino can be found `on Rhino's website <https://wiki.mcneel.com/rhino/meshfaqdetails>`_ and `on Youtube <https://www.youtube.com/watch?v=CrlXAMPfHWI>`_.	
	
.. Note::
	
	All STL files must be saved as ASCII (not binary)
 
**Refining STL File** - The script ``refine_stl`` in the BEMIO directory performs a simple mesh refinement on an ``*.stl`` file by subdividing each panel with an area above the specified threshold into four smaller panels with new vertices at the mid-points of the original panel edges. This procedure is iterated for each panel until all panels have an area below the specified threshold, as in the example rectangle. 


.. figure:: _images/rectangles.png 
   :width: 300pt 
   :align: center

In this way, the each new panel retains the aspect ratio of the original panel. Note that the linear discretization of curved edges is not refined via this algorithm. The header comments of the function explain the inputs and outputs. This function calls ``import_stl_fast``, included with the WEC-Sim distribution, to import the ``.*stl`` file.


Nonlinear Buoyancy and Froude-Krylov Wave Excitation Tutorial - Heaving Ellipsoid
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
The body tested in the study is an ellipsoid with a cross- section characterized by semi-major and -minor axes of 5.0 m and 2.5 m in the wave propagation and normal directions, respectively . The ellipsoid is at its equilibrium position with its origin located at the mean water surface. The mass of the body is then set to 1.342×105 kg, and the center of gravity is located 2 m below the origin.

.. _nonlinearEllipsoid:

.. figure:: _images/nonlinearEllipsoid.png
    :width: 350pt
    :align: center

STL file with the discretized body surface is shown below (``ellipsoid.stl``)

.. _nonlinearMesh:

.. figure:: _images/nonlinearMesh.png
    :width: 250pt
    :align: center
    
The single-body heave only WEC model is shown below (``nonLinearHydro.slx``)

.. _nonlinearWEC:

.. figure:: _images/nonlinearWEC.png
    :width: 450pt
    :align: center

The WEC-Sim input file used to run the nonlinear hydro WEC-Sim simulation:

.. _nonLinearwecSimInputFile:

.. literalinclude:: ../../WEC-Sim_Applications/Nonlinear_Hydro/ode4/Regular/wecSimInputFile.m
   :language: matlab

Simulation and post-processing is the same process as described in :ref:`tutorials` section.

Passive Yaw Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. Note:: 
	Adam:
	Isn't this the same as using BEM data with different wave directionality?
	Interpolation method vs wave directionality?

For non-axisymmetric bodies with yaw orientation that changes substantially with time, WEC-Sim allows a correction to excitation forces for large yaw displacements. To enable this correction, add the following to your ``wecSimInputFile``: 

 	:code:`simu.yawNonLin = 1`

Under the default implementation (:code:`simu.yawNonLin = 0`), WEC-Sim uses the initial yaw orientation of the device relative to the incident waves to calculate the wave excitation coefficients that will be used for the duration of the simulation. When the correction is enabled, excitation coefficients are interpolated from BEM data based upon the instantaneous relative yaw position. For this to enhance simulation accuracy, BEM data must be available over the range of observed yaw positions at a sufficiently dense discretization to capture the significant variations of excitation coefficients with yaw position. For robust simulation, BEM data should be available from -180 to 170 degrees of yaw (or equivalent).    

This can increase simulation time, especially for irregular waves, due to the large number of interpolations that must occur. To prevent interpolation at every time-step, ``simu.yawThresh`` (default 1 degree) can be specified in the ``wecSimInputFile`` to specify the minimum yaw displacement (in degrees) that must occur before another interpolation of excitation coefficients will be calculated. The minimum threshold for good simulation accuracy will be device specific: if it is too large, no interpolation will occur and the simulation will behave as :code:`simu.yawNonLin = 0`, but overly small values may not significantly enhance simulation accuracy while increasing simulation time. 

When :code:`simu.yawNonLin = 1`, hydrostatic and radiation forces are determined from the local body-fixed coordinate system based upon the instantaneous relative yaw position of the body, as this may differ substantially from the global coordinate system for large relative yaw values. 

A demonstration case of this feature is included in the **PassiveYaw** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.  	

.. Note::

	Caution must be exercised when simultaneously using passive yaw and body-to-body interactions. Passive yaw relies on interpolated BEM solutions to determine the cross-coupling coefficients used in body-to-body calculations. Because these BEM solutions are based upon the assumption of small displacements, they are unlikely to be accurate if a large relative yaw displacement occurs between the bodies. 

Non-Hydrodynamic Bodies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
For some simulations, it might be important to model bodies that do not have hydrodynamic forces acting on them. This could be bodies that are completely outside of the water but are still connected through a joint to the WEC bodies, or it could be bodies deeply submerged to the point where the hydrodynamics may be neglected. WEC-Sim allows for bodies which have no hydrodynamic forces acting on them and for which no BEM data is provided.

To do this, use a Body Block from the WEC-Sim  Library and initialize it in the WEC-Sim input file as any other body but leave the name of the ``h5`` file as an empty string. Specify :code:`body(i).nhBody = 1;` and specify body name, mass, moments of inertia, cg, geometry file, location, and displaced volume. You can also specify visualization options and initial displacement.

To use non-hydrodynamic bodies, the following body class variable must be defined in the WEC-Sim input file, for example:

	:code:`body(i).nhBody = 1` 

For more information, refer to :ref:`webinar2`, and the **OSWEC_nhBody** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 


Body-To-Body Interactions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim allows for body-to-body interactions in the radiation force calculation, thus allowing the motion of one body to impart a force on all other bodies. The radiation matrices for each body (radiation wave damping and added mass) required by WEC-Sim and contained in the ``*.h5`` file. **For body-to-body interactions with N total hydrodynamic bodies, the** ``*h5`` **data structure is [(6\*N), 6]**.

When body-to-body interactions are used, the augmented [(6\*N), 6] matrices are multiplied by concatenated velocity and acceleration vectors of all hydrodynamic bodies. For example, the radiation damping force for body(2) in a 3-body system with body-to-body interactions would be calculated as the product of a [1,18] velocity vector and a [18,6] radiation damping coefficients matrix.

To use body-to-body interactions, the following simulation class variable must be defined in the WEC-Sim input file:

	:code:`simu.b2b = 1`
	
For more information, refer to :ref:`webinar2`, and the **RM3_B2B** example in the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.  	

.. Note::

	By default, body-to-body interactions  are off (:code:`simu.b2b = 0`), and only the :math:`[1+6(i-1):6i, 1+6(i-1):6i]` sub-matrices are used for each body (where :math:`i` is the body number).


Generalized Body Modes 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To use this, select a Flex Body Block from the WEC-Sim Library (under Body Elements) and initialize it in the WEC-Sim input file as any other body. Calculating dynamic response of WECs considering structural flexibilities using WEC-Sim should consist of multiple steps, including:

* Modal analysis of the studied WEC to identify a set of system natural frequencies and corresponding mode shapes
* Construct discretized mass and impedance matrices using these structural modes
* Include these additional flexible degrees of freedom in the BEM code to calculate hydrodynamic coefficients for the WEC device
* Import the hydrodynamic coefficients to WEC-Sim and conduct dynamic analysis of the hybrid rigid and flexible body system

.. Note::

	Generalized body modes module has only been tested with WAMIT, where BEMIO may need to be modified for NEMOH. 


Viscous Damping and Morison Elements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim allows for the definition of additional damping and added-mass terms; for more information about the numerical formulation of viscous damping and Morison Elements, refer to :ref:`theory:Viscous Damping and Morison Elements`.


Viscous Damping
""""""""""""""""""""""""""""""
A viscous damping force in the form of a linear damping coefficient :math:`C_{v}` can be applied to each body by defining the following body class parameter in the WEC-Sim input file (which has a default value of zero)::

	body(i).linearDamping

A quadratic drag force, proportional to the square of the body's velocity, can be applied to each body by defining the quadratic drag coefficient :math:`C_{d}`, and the characteristic area :math:`A_{d}` for drag calculation. This is achieved by defining the following body class parameters in the WEC-Sim input file (each of which have a default value of zero)::

	body(i).viscDrag.cd
	body(i).viscDrag.characteristicArea

Alternatively, one can define :math:`C_{D}` directly::

	body(i).viscDrag.Drag

.. _morison:

Morison Elements 
""""""""""""""""""""""""""""""
To use Morison Elements, the following simulation class variable must be defined in the WEC-Sim input file:

	:code:`simu.morisonElement  = 1`


Morison Elements must then be defined for each body using the :code:`body(#).morisonElement` property of the body class. This property requires definition of the following body class parameters in the WEC-Sim input file (each of which have a default value of zero)::
	
	body(i).morisonElement.cd
	body(i).morisonElement.ca
	body(i).morisonElement.characteristicArea
	body(i).morisonElement.VME
	body(i).morisonElement.rgME

The Morison Element time-step may also be defined as :code:`simu.dtME = N*simu.dt`, where N is number of increment steps. For an example application of using Morison Elements in WEC-Sim, refer to the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository **Free_Decay/1m-ME** example. 

.. Note::

	Morison Elements cannot but used with :code:`etaImport`.



.. _pto:

Constraint and PTO Features
----------------------------

.. include:: pto.rst



.. _mooring1:

Mooring Features
----------------

.. include:: mooring.rst



.. ParaView

Visualization/Paraview
----------------------

.. include:: viz.rst


Decay Tests
---------------------------------
When performing simulations of decay tests, you must use one of the no-wave cases and setup the initial (time = 0) location of each body, constraint, PTO, and mooring block.
The initial location of a body or mooring block is set by specifying the CG or location at the stability position (as with any WEC-Sim simulation) and then specifying an initial displacement.
To specify an initial displacement, the body and mooring blocks have a :code:`.initDisp` property with which you can specify a translation and angular rotation about an arbitrary axis.
For the constraint and PTO blocks, the :code:`.loc` property must be set to the location at time = 0.

There are methods available to help setup this initial displacement for all bodies, constraints, PTOs, and moorings.
To do this, you would use the:

* :code:`body(i).setInitDisp()`
* :code:`constraint(i).setInitDisp()`
* :code:`pto(i).setInitDisp()`
* :code:`mooring(i).setInitDisp()` 

methods in the WEC-Sim input file.
A description of the required input can be found in the method's header comments.
The following propoerties must be defined prior to using the object's :code:`setInitDisp()` method: 

* :code:`body(i).cg`
* :code:`constraint(i).loc`
* :code:`pto(i).loc`
* :code:`mooring.ref` 

For more information, refer to the **IEA_OES_Task10_freeDecay** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.