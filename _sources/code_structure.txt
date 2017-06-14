.. _code_structure:

Code Structure
==============
This section provides a description of the WEC-Sim source code and its structure. 
The WEC-Sim source code is a series of MATLAB m-files that read the user input data, perform preprocessing calculations, and run the Simulink/Simscape Multibody time-domain simulations.
The code consists of object class definitions, a Simulink library, the main ``wecSim.m`` function, and other supporting functions.


Code Conventions
----------------
All units within WEC-Sim are in the MKS (meters-kilograms-seconds system) and angular measurements are specified in radians (except for wave directionality which is defined in degrees).

The WEC-Sim coordinate system assumes that the X axis is in the direction of wave propagation if the wave heading angle is equal to zero, the Z axis is in the vertical upwards direction, and the Y axis direction is defined by the right-hand rule (as shown below). 

.. figure:: _static/coordinateSystem.png
   :width: 400pt

Input File Structure
--------------------
The WEC-Sim input file (``wecSimInputFile.m``) is required for each run. 
The input file must be placed inside the case directory for the run and must be named ``wecSimInputFile.m``. 
The input file contains information needed to run WEC-Sim simulations. 
This section describes the structure, requirements, and options for the WEC-Sim input file.
Example WEC-Sim input files are provided in the `Tutorials Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_, and are also provided in the WEC-Sim source code in the tutorials folder.
WEC-Sim is an object oriented code, and input file reflects this.
The main structure of the input file consists of initializing all the required objects and then specifying any additional properties for each.
For details on the available additional properties for each class refer to the WEC-Sim Classes Section.
Each WEC-Sim simulation (and input file) requires one instance of the simulation class and wave class, at least one instance of the body class, and at least one instance of the constraint or PTO classes.

Simulation Class
~~~~~~~~~~~~~~~~~~~~~~~~
Within the input file, users specify simulation class (``simulationClass``) parameters using the ``simu`` object. 
To initialize the ``simu`` object include the following line: ``simu=simulationClass();``.
Simulation class parameters include simulation start time (``simu.startTime``), end time (``simu.endTime``), and time step (``simu.dt``). 
Users also specify the name of the Simulink/SimMechanics WEC model within the `` simu.simMechanicsFile`` variable. 
All simulation class parameters are specified as variables within the ``simu`` object (as members of the ``simulationClass``).


Wave Class
~~~~~~~~~~
Within the input file, users must specify wave class (``waveClass``) parameters defining wave conditions for the simulation using the ``waves`` object. 
The user must specify the wave condition within the waves variable. 
The options that are available for the user to set within the wave class are discussed in more detail in Section 2.3.2.
The wave class is initialized with ``waves = waveClass('type');``, where `type` is one of the wave type options.

Body Class
~~~~~~~~~~
Within in the input file, users must specify body class (``bodyClass``) parameters using the ``body`` object for each body. 
WEC-Sim assumes that every WEC is composed of rigid bodies exposed to wave forcing. 
For each body, users must specify body properties within the body class in the input file. 
Body class parameters include mass (``body(#).mass``), and moment of inertia (``body(#).momOfInertia``).
Each instance of the body class is initialized with the line ``body(#) = bodyClass('bem_data.h5');``, where # is the body number, and 'bem_data.h5' is the name of the h5 file containing the BEM results.

Constraint Class
~~~~~~~~~~~~~~~~
WEC-Sim constraint blocks connect WEC bodies to on one another (and possibly to the seabed) by constraining DOFs. 
The properties of the constraint class (``constraintClass``) are defined in the ``constraint`` object. 
An instance of the constraint class is initialized with the line ``constraint(#)= constraintClass('name');``, where # is the constraint number and `name` is a unique, Matlab variable naming compliant, name assigned to that constraint.
See the `Advanced Constraints and PTOS Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_ for more detail on the constraint options.

PTO Class
~~~~~~~~~
WEC-Sim Power Take-Off (PTO) blocks connect WEC bodies to one other (and possibly to the seabed) by constraining DOFs and applying linear damping and stiffness. 
The properties of the PTO class (``ptoClass``) are defined in the ``pto`` object. 
An instance of the PTO class is initialized with the line ``pto(#)= ptoClass('name');``, where # is the pto number and `name` is a unique, Matlab variable naming compliant, name assigned to that PTO.
See the `Advanced Constraints and PTOS Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_ for more detail on the pto options.

Mooring Class
~~~~~~~~~~~~~
The WEC-Sim mooring block allows for simulating mooring in two different ways: as linear stiffness, pre-tension, and damping matrices, or using MoorDyn.
The properties of the mooring class (``mooringClass``) are defined in the ``mooring`` object. 
An instance of the mooring class is initialized with the line ``mooring(#)= mooringClass('name');``, where # is the pto number and `name` is a unique, Matlab variable naming compliant, name assigned to that mooring.
See the `Mooring Modeling Section <http://wec-sim.github.io/WEC-Sim/features.html#mooring-modeling>`_ for more detail on the mooring options.


WEC-Sim Classes
----------------
All information required to run WEC-Sim simulations is contained within the simu, waves, body(i), pto(i), constraint(i), and mooring(i) objects (instances of the simulationClass, waveClass, bodyClass, constraintClass, ptoClass, and mooringClass).  
The user can interact with these variables within the WEC-Sim input file (``wecSimInputFile.m``). 
The remainder of this section describes the parameters defined within the WEC-Sim objects, and how to interact with the WEC-Sim objects to define input parameters. 
There are two ways to look at all the available properties and methods a class has.
The first is to type ``doc className`` in Matlab, and the second is to open the class definition script under ``source/objects``.
The later provides more information since it also defines the different fields in a structure.

simulationClass
~~~~~~~~~~~~~~~
The simulation class (``simulationClass``) contains the simulation parameters and solver settings needed to execute the WEC-Sim code. 
Users can set relevant simulation properties in the ``wecSimInputFile.m``. 
Users must specify the name of the Simulink/SimMechanics WEC model, which can be set by entering the following command in the input file::

	simu.simMechanicsFile=<WEC Model Name>.slx

The WEC-Sim code has default values defined for all the other simulation parameters. Available simulation parameters and the default values can be found by typing ``doc simulationClass`` in the MATLAB command window or opening the `.m` file in `/source/objects/.

.. figure:: _static/simuClass.png

These default values can be overwritten by the user, as demonstrated in the Applications Section. 
For example, the end time of a simulation can be set by entering the following command::

	simu.endTime = <user specified end time>


waveClass
~~~~~~~~~
The wave class (``waveClass``) contains all the information that defines the wave conditions for the time-domain simulation. 
Typing ``doc waveClass`` in the MATLAB command window  or opening the `.m` file in `/source/objects/ provides more information on the wave class functionality, available wave parameters, and default values.

.. figure:: _static/waveClass.png

The table below lists the types of wave environments that are currently supported by WEC-Sim. 

================= =====================================  =============================================================
waves.type        Additional required inputs             Description
noWave            waves.noWaveHydrodynamicCoeffT         Free decay test with constant hydrodynamic coefficients
noWaveCIC         None                                   Free decay test with convolution integral
regular           waves.H waves.T                        Sinusoidal steady-state Response Scenario
regularCIC        waves.H waves.T                        Regular waves with convolution integral
irregular         waves.H waves.T, waves.spectrumType    Irregular waves with typical wave spectrum
irregularImport   waves.spectrumDataFile                 Irregular waves with user-defined wave spectrum
userDefined       waves.etaDataFile                 	 Irregular waves with user-defined wave elevation time-history                                                                            
================= =====================================  =============================================================

The **noWave** case (``waves.type=noWave``) is for running WEC-Sim simulations without waves, using constant added mass and radiation damping coefficients. 
This "wave" case is typically used to run decay tests for comparisons. 
Users must still provide hydro coefficients from a BEM solve before executing WEC-Sim. 
In addition, users must specify the period from which the hydrodynamic coefficients are selected by defining the following in the input file::
 
	waves.noWaveHydrodynamicCoeffT = <user specified wave period>

The **noWaveCIC** case (``waves.type=noWaveCIC``) is the same as the noWave case described above, with the addition of the convolution integral calculation. 
The wave type is the same as noWave, except the radiation forces are calculated using the convolution integral and the infinite frequency added mass.

The **regular** wave case (``waves.type=regular``) is for running simulations using regular waves with constant added mass and radiation damping coefficients. 
Wave period (``wave.T``) and wave height (``wave.H``) need to be specified in the input file. 
Using this option, WEC-Sim assumes that the system dynamic response is in sinusoidal steady-state form, where constant added mass and damping coefficients are used (instead of the convolution integral) to calculate wave radiation forces.

The **regularCIC**, regular wave with convolution integral case (``waves.type=regularCIC``), is the same as regular wave case, except the radiation forces are calculated using the convolution integral and the infinite frequency added mass.

The **irregular** wave case (``waves.type=irregular``)is the wave type for irregular wave simulations using a given wave spectrum. 
Significant wave height (``wave.H``), peak period (``wave.T``) and wave spectrum type (``waves.spectrumtype``) need to be specified in the input file. 
The available spectral formulations are listed below:

======================  ==========================
**Wave Spectrum Type**  **Input File Parameter**
Pierson Moskowitz   	waves.spectrumType=PM
Bretschneider	    	waves.spectrumType=BS
JONSWAP             	waves.spectrumType=JS
======================  ==========================

The irregular waves with user-defined spectrum case (``waves.type=irregularImport``) is the wave case for irregular wave simulations using user-defined wave spectrum (ex: from buoy data). 
Users need to specify the wave spectrum file name in WEC-Sim input file as follows::

	waves.spectrumDataFile=<wave spectrum file>.txt

The user-defined wave spectrum must be defined with the wave frequency (Hz) in the first row, and the spectral energy density (m^2/Hz) in the second row. 
An example of this is given in the ``ndbcBuoyData.txt`` file in the applications folder of the WEC-Sim source code. 
This format can be copied directly from NDBC buoy data. 
For more information on NDBC buoy data measurement descriptions, refer to the [http://www.ndbc.noaa.gov/measdes.shtml NDBC website].

Note: By default, the phase for irregular waves (irregular and irregularImport) is generated randomly. Users have the ability to seed the random phase by specifying the following in the WEC-Sim input file::

	waves.randPreDefined=1

This gives the user an option to generate the same "random" wave time-series as needed (the default for random phase is ``waves.randPreDefined=0``). 


bodyClass
~~~~~~~~~~~~~~~
The body class (``bodyClass``) contains the mass and hydrodynamic properties of each body that comprises the WEC being simulated. 
Each body must have an iteration of the body class initiated in the input file. 
Each body object must be initiated by entering the following command in the WEC-Sim input file::

	body(<#>)=bodyClass('h5filename')

The available body parameters, and default values defined in the body class can be found by typing ``doc bodyClass`` in the MATLAB command window or opening the `.m` file in `/source/objects/.

.. figure:: _static/bodyClass.png 

For example, the viscous drag can be specified by entering the viscous drag coefficient and the characteristic area in vector format the WEC-Sim input file as follows::

	body(<#>).viscDrag.cd= [0 0 1.3 0 0 0]
	body(<#>).viscDrag.characteristicArea= [0 0 100 0 0 0]


constraintClass
~~~~~~~~~~~~~~~
The constraint class (``constraintClass``) is used to define the motion of bodies relative to the reference fram and each other. 
The constraint variable should be initiated by entering the following command in the WEC-Sim input file::

	constraint(<#>)=constraintClass('<constraint name>')

For rotational constraint (ex: pitch), the user also needs to specify the location of the rotational joint with respect to the global reference frame in the ``constraint(<#>).loc`` variable.

The available constraint parameters, and default values defined in the constraint class can be found by typing ``doc constraintClass`` in the MATLAB command window  or opening the `.m` file in `/source/objects/.

.. figure:: _static/constraintClass.png


ptoClass
~~~~~~~~
The pto class (``ptoClass``) extracts power from relative body motion with respect to a fixed reference frame or another body. 
The pto objects can also constrain motion to certain degrees of freedom. 
The pto variable should be initiated by entering the following command in the WEC-Sim input file::

	pto(<#>) = ptoClass('<pto name>')

For rotational ptos, users also needs to specify the pto location. 
In the PTO class, users can also specify linear damping (``pto(<#>).c``) and stiffness (``pto(<#>).k``) values to represent the PTO system (both have a default value of 0). 
Users can overwrite the default values in the input file, for example to specify a damping value by entering the following in the WEC-Sim input file::

	pto(<#>).c = <pto damping value>

The available pto parameters, and default values defined in the pto class can be found by typing `` doc ptoClass`` in the MATLAB command window  or opening the `.m` file in `/source/objects/.

.. figure:: _static/ptoClass.png
   :width: 400pt


mooringClass
~~~~~~~~~~~~
The mooring class (``mooringClass``) allows for different fidelity simulation of mooring systems.
The mooring variable should be initiated by entering the following command in the WEC-Sim input file::

	mooring(<#>) = mooringClass('<mooring name>')

The available mooring parameters, and default values defined in the mooring class can be found by typing `` doc mooringClass`` in the MATLAB command window  or opening the `.m` file in `/source/objects/.

.. figure:: _static/mooringClass.png
   :width: 400pt

responseClass
~~~~~~~~~~~~~
The response class is not initialized by the user.
Instead it is created at the end of a WEC-Sim simulation.
It contains all the output time-series and methods to plot and interact with the results.
The available parameters are explained in the Output Structure Section.

.. figure:: _static/responseClass.png
   :width: 400pt



WEC-Sim Library & Input Simulink Model
--------------------------------------
In addition to the `wecSimInputFile.m` a WEC-Sim simulation requires a simulink model that represents the WEC system components and connectivities.
Similar to how the input file uses the WEC-Sim classes, the Simulink model uses the WEC-Sim blocks from the WEC-Sim library.
There should be a one-to-one between the objects defined in the input file and the blocks used in the Simulink model.

The WEC-Sim library is divided into 5 sub-libraries. 
The user should be able to model their WEC device using the available WEC-Sim blocks, and possibly some SimMechanics blocks. 
The table below lists the WEC-Sim blocks and their organization into sub-libraries.

+-----------------+----------------------------------+
|           WEC-Sim Library                          |
+================+===================================+
|Sub-library     |Blocks                             |
+----------------+-----------------------------------+
|Body Elements   |Rigid Body                         | 
+----------------+-----------------------------------+
|Frames          |Global Reference Frame             |
+----------------+-----------------------------------+
|Constraints     |Fixed                              |
|                |Translational                      |
|                |Rotational                         |
|                |Floating (3DOF)                    |
|                |Floating (6DOF)                    |
+----------------+-----------------------------------+
|                |Translational PTO                  | 
|                |Rotational PTO                     |
|                |Translational PTO Actuation Force  |
|PTOs            |Rotational PTO Actuation Torque    |
|                |Translational PTO Actuation Motion |
|                |Rotational PTO Actuation Motion    | 
+----------------+-----------------------------------+
|Mooring         |MooringMatrix                      |
|                |MoorDyn                            |
+----------------+-----------------------------------+

.. figure:: _static/subLibs.PNG
   :width: 400pt	

This section describes the five sub-libraries and their general purpose. 
The Body Elements sub-library contains the Rigid Body block used to simulate the different bodies. 
The Frames sub-library contains the Global Reference Frame block necessary for every simulation. 
The Constraints sub-library contains blocks that are used to constrain the DOF of the bodies, without including any additional forcing or resistance. 
The PTOs sub-library contains blocks used to both simulate a PTO system and restrict the body motion. 
Both constraints and PTOs can be used to restrict the relative motion between multi-body systems. 
The Mooring sub-library contains blocks used to simulate mooring systems.

Body Elements Sub-library
~~~~~~~~~~~~~~~~~~~~~~~~~~
The Body Elements sub-library (Figure~\ref{fig:bLib) contains one block, the Rigid Body block. 
It is used to represent rigid bodies. 
At least one instance of this block is required in each model.

.. figure:: _static/bodiesLib.PNG
   :width: 400pt

The Rigid Body block is used to represent a rigid body in the simulation. The user has to name the blocks 'body(i)' where i=1,2,... 
The mass properties, hydrodynamic data, geometry file, mooring, and other properties are then specified in the input file. 
Within the body block the wave radiation, wave excitation, hydrostatic restoring, viscous damping and mooring forces are calculated.

Frames Sub-library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The Frames sub-library contains one block that is necessary in every model. 
The Global Reference Frame block defines the global coordinates, solver configuration, seabed and free surface description, simulation time, and other global settings. 
It can be useful to think of the Global Reference Frame as being the seabed when creating a model. 
Every model requires one instance of the Global Reference Frame block. 
The Global Reference Frame block uses the simulation class variable simu and the wave class variable waves, which must be defined in the input file.

.. figure:: _static/framesLib.PNG
   :width: 400pt

Constraints Sub-library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The blocks within the Constraints sub-library are used to define the DOF of a specific body. 
Constraints blocks define only the DOF, but do not otherwise apply any forcing or resistance to the body motion. 
Each Constraints block has two connections, a base (B) and a follower (F). 
The Constraints block restricts the motion of the block that is connected to the follower relative to the block that is connected to the base. 
For a single body system the base would be the Global Reference Frame (which can be thought of as the seabed) and the follower is a Rigid Body.


.. figure:: _static/constraintsLib.PNG
   :width: 400pt


+----------------+-----+-----------------------------------------+
|           Constraint Sub-Library                               |
+================+=====+=========================================+
|Block           |DOFs |Description                              |
+----------------+-----+-----------------------------------------+
|Fixed           |0    |Rigid connection. Constrains all motion  |
|                |     |between the base and follower            |
+----------------+-----+-----------------------------------------+
|Translational   |1    |Constrains the motion of the follower    |
|                |     |relative to the base to be translation   |
|                |     |along the constraint's Z-axis            |
+----------------+-----+-----------------------------------------+
|Rotational      |1    |Constrains the motion of the follower    |
|                |     |relative to the base to be rotation      |
|                |     |about the constraint's Y-axis            |
+----------------+-----+-----------------------------------------+
|Floating (3DOF) |3    |Constrains the motion of the follower    |
|                |     |relative to the base to planar motion    |
|                |     |with translation along the constraint's  |
|                |     |X- and Z- and rotation about the Y- axis |
+----------------+-----+-----------------------------------------+
|Floating (6DOF) |6    |Allows for unconstrained motion of the   |
|                |     |follower relative to the base            |
+----------------+-----+-----------------------------------------+


PTOs Sub-library
~~~~~~~~~~~~~~~~~~~~~~~~~~
The PTOs sub-library is used to simulate simple PTO systems and to restrict relative motion between multiple bodies or between one body and the seabed. 
The PTO blocks can simulate simple PTO systems by applying a linear stiffness and damping to the connection. 
Similar to the Constraints blocks, the PTO blocks have a base (B) and a follower (F). 
Users must name each PTO block 'pto(i)' where i=1,2,..., and then define their properties in the input file.

.. figure:: _static/ptosLib.PNG
   :width: 400 pt

The Translational and Rotational PTOs are identical to the Translational and Rotational constraints, but allow for the application of linear damping and stiffness forces.
Additionally there are two other variations of the Translational and Rotational PTOs.
The Actuation Force/Torque PTOs allow the user to define the PTO force/torque at each time-step and provide the position, velocity and acceleration of the PTO at each time-step.
The user can use the response information to calculate the PTO force/torque.
The Actuation Motion PTOs allow the user to define the motion of the PTO. 
These can be usefull to simulate forced-oscillation tests.

Mooring Sub-library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The mooring sub-library is used to simulate mooring systems.
The MooringMatrix block applies linear damping and stiffness based on the motion of the follower relative to the base.
The MoorDyn block uses the compiled MoorDyn executables and a MoorDyn input file to simulate a realistic mooring system. 
There can be at most one MoorDyn block per Simulink model.
There is no restrictions on the number of MooringMatrix blocks.

.. figure:: _static/mooringLib.PNG
   :width: 400 pt

Other Simulink and SimMechanics Blocks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In some situations, users may have to use SimMechanics and Simulink blocks not included in the WEC-Sim Library to build their WEC model. 





Output Structure
----------------
After WEC-Sim is done running there will be a new variable, called ``output``, in your Matlab workspace.
The ``output`` variable is an instance of the ``responseClass`` class. 
It contains all the relevant time-series results of the simulation. 
The structure of the ``output`` variable is shown in the table below. 
Time series are given as [(# of time-steps) x 6] arrays, where 6 are the degrees of freedom.
In addition to these time-series, the output for each object contains the object's name or type and the time vector.

In addition to the responseClass ``output`` variable, the outputs can be written to ASCII files by using ``simu.outputtxt = 1;`` in the input file.

+------------------------------------------------------------------------------+
|output                                                                        |
+================+=============================+===============================+
|wave            | elevation                   | array: (# of time-steps) x 1  |
+----------------+-----------------------------+-------------------------------+
|bodies(i)       | position                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | velocity                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | acceleration                | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceTotal                  | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceExcitation             | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceRadiationDamping       | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceAddedMass              | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceRestoring              | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceMorrisonAndViscous     | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceLinearDamping          | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | cellPressures_time          | array: (# nlHydro time-steps) |
|                |                             |        x (# cells)            |
|                |                             |                               |
|                | cellPressures_hydrostatic   | array: (# nlHydro time-steps) |
|                |                             |        x (# cells)            |
|                |                             |                               |
|                | cellPressures_waveLinear    | array: (# nlHydro time-steps) |
|                |                             |        x (# cells)            |
|                |                             |                               |
|                | cellPressures_waveNonLinear | array: (# nlHydro time-steps) |
|                |                             |        x (# cells)            |
+----------------+-----------------------------+-------------------------------+
|ptos(i)         | position                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | velocity                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | acceleration                | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceTotal                  | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceActuation              | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceConstraint             | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceInternalMechanics      | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | powerInternalMechanics      | array: (# of time-steps) x 6  |
+----------------+-----------------------------+-------------------------------+
|constraints(i)  | position                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | velocity                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | acceleration                | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceConstraint             | array: (# of time-steps) x 6  |
+----------------+-----------------------------+-------------------------------+
|mooring(i)      | position                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | velocity                    | array: (# of time-steps) x 6  |
|                |                             |                               |
|                | forceMooring                | array: (# of time-steps) x 6  |
+----------------+-----------------------------+-------------------------------+
|moorDyn         | Lines                       | struct: outputs in the        |
|                |                             |         Lines.out file        |
|                |                             |                               | 
|                | Line# (for each line)       | struct: outputs in the        |
|                |                             |         Line#.out file        |
+----------------+-----------------------------+-------------------------------+
|ptosim          | See PTO-Sim section for     |                               |
|                | details                     |                               |
+----------------+-----------------------------+-------------------------------+



WEC-Sim Functions & External Codes
----------------------------------
While the bulk of the WEC-Sim code consists of the WEC-Sim classes and the WEC-Sim library, the source code also includes supporting functions and external codes.
These include third party Matlab functions to read `hdf5` and `stl` files, WEC-Sim Matlab functions to write `hdf5` files and run WEC-Sim in batch mode, MoorDyn compiled executables, python macros for ParaView vizualisation, and the PTO-Sim class and library.
Additionally, BEMIO can be used to create the hydrodynamic `h5` file required by WEC-Sim.
WEC-Sim only includes the compiled executables of MoorDyn.
Since MoorDyn is also an open source code anyone can obtain the code, modify and recompile it, and replace the executable within WEC-Sim's source directory.




