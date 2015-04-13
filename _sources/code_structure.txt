Code Structure
==============
This section provides a description of the WEC-Sim source code and its structure. The WEC-Sim source code is a series of MATLAB m-files that read the user input data, perform preprocessing calculations, and run the Simulink/SimMechanics time-domain simulations.

Code Conventions
----------------
All units within WEC-Sim are in the MKS (meters-kilograms-seconds system) and angular measurements are specified in radians unless otherwise specified.

The WEC-Sim coordinate system assumes that the X axis is in the direction of wave propagation if the wave heading angle is equal to zero, the Z axis is in the vertical upwards direction, and the Y axis direction
is defned by the right-hand rule (as shown below).

.. figure:: _static/coordinateSystem.png
   :width: 400pt

Input File Structure
--------------------

The WEC-Sim input file (``wecSimInputFile.m``) is required for each run. The input file MUST be placed inside the case directory for the run and MUST be named ``wecSimInputFile.m``. The input file contains information needed to run WEC-Sim simulations. Descriptions of the four primary functions the WEC-Sim input file serves will be given in the following sections. Example WEC-Sim input files are provided in the `Applications Section <https://github.com/WEC-Sim/WEC-Sim/wiki/3.-Applications>`_, and are also provided in the WEC-Sim source code in the applications folder.

Simulation Class
~~~~~~~~~~~~~~~~~~~~~~~~
Within the input file, users specify simulation class (``simulationClass``) parameters using the ``simu`` object. Simulation class parameters include simulation start time (``simu.startTime``), end time (``simu.endTime``), and time step (``simu.dt``). Users also specify the name of the Simulink/SimMechanics WEC model within the `` simu.simMechanicsFile`` variable. All simulation class parameters are specified as variables within the ``simu`` object (as members of the ``simulationClass``).The simulation parameters that are available for the user to set within the simulation class are described in more detail in Section 2.3.1.

Wave Class
~~~~~~~~~~
Within the input file, users MUST specify wave class (``waveClass``) parameters defining wave conditions for the simulation using the ``waves`` object. The user MUST specify the wave condition within the waves variable. The options that are available for the user to set within the wave class are discussed in more detail in Section 2.3.2.

Body Class
~~~~~~~~~~
Within in the input file, users MUST specify body class (``bodyClass``) parameters using the ``body`` object for each body. WEC-Sim assumes that every WEC is composed of rigid bodies exposed to wave forcing. For each body, users MUST specify body properties within the body class in the input file. Body class parameters include mass (``body(#).mass``), moment of inertia (``body(#).momOfInertia``), center of gravity (``body(#).cg``), and the WAMIT files that describe the hydrodynamic properties (refer to sample input file in the Applications Section. The body parameters that are available for the user to set within the body class are described in more detail in Section 2.3.3.

Constraint Class
~~~~~~~~~~~~~~~~
WEC-Sim constraint blocks connect WEC bodies to on another other (and possibly to the seabed) by constraining DOFs. The properties of the constraint class (``constraintClass``) are defined in the ``constraint`` object. The parameters available for user specification are described in in Section 2.3.4.


PTO Class
~~~~~~~~~
WEC-Sim Power Take-Off (PTO) blocks connect WEC bodies to one other (and possibly to the seabed) by constraining DOFs and applying linear damping and stiffness. The properties of the PTO class (``ptoClass``) are defined in the ``pto`` object. The parameters available for user specification are described in Section 2.3.5.

Input Parameters
----------------
All information required to run WEC-Sim simulations is contained within the simu, waves, body, pto, and constraint objects (instances of the simulationClass, waveClass, bodyClass, constraintClass and ptoClass).  The user can interact with these variables within the WEC-Sim input file (``wecSimInputFile.m``). The remainder of this section describes the parameters defined within the WEC-Sim objects, and how to interact with the WEC-Sim objects to define input parameters. 

simulationClass
~~~~~~~~~~~~~~~

The simulation class (``simulationClass``) contains the simulation parameters and solver settings needed to execute the WEC-Sim code. Users can set relevant simulation properties in the ``wecSimInputFile.m``. Users MUST specify the name of the Simulink/SimMechanics WEC model, which can be set by entering the following command in the input file::

	simu.simMechanicsFile=’<WEC Model Name>.slx’

The WEC-Sim code has default values defined for all the other simulation parameters. Available simulation parameters and the default values can be found by typing ``doc simulationClass`` in the MATLAB Command Window.

.. figure:: _static/simuClass.png

These default values can be overwritten by the user, as demonstrated in the Applications Section. For example, the end time of a simulation can be set by entering the following command::

	simu.endTime = <user specified end time>

Note: By default, running the irregular wave (irregular and irregularImport), regular wave with convolution integral (regularCIC) or no wave with convolution integral (noWaveCIC), WEC-Sim calculates the fluid memory term using the convolution integral formulation. Users have the option to use the state space model by specifying the following in the WEC-Sim input file::

	simu.ssCalc=1

waveClass
~~~~~~~~~
The wave class (``waveClass``) contains all the information that defines the wave conditions for the time-domain simulation. Typing ``doc waveClass`` in the MATLAB Command Window provides more information on the wave class functionality, available wave parameters, and default values.

.. figure:: _static/waveClass.png

The table below lists the types of wave environments that are currently supported by WEC-Sim. 

===============================  =====================================   ========================================================
Option                           Additional required inputs              Description
waves.type =’noWave’             waves.noWaveHydrodynamicCoeffT          Free decay test with constant hydrodynamic coefficients
waves.type =’noWaveCIC’          None                                    Free decay test with convolution integral
waves.type =’regular’            waves.H waves.T                         Sinusoidal steady-state Reponse Scenario
waves.type =’regularCIC’         waves.H waves.T                         Regular waves with convolution integral
waves.type =’irregular’          waves.H waves.T waves.spectrumType      Irregular waves with typical wave spectrum
waves.type =’irregularImport’    waves.spectrumDataFile                  Irregular waves with user-defined wave spectrum
===============================  =====================================   ========================================================

noWave
.........
The noWave case (``waves.type=’noWave’``) is for running WEC-Sim simulations without waves, using constant added mass and radiation damping coefficients. This "wave" case is typically used to run decay tests for comparisons. Users must still provide hydro coefficients from a BEM solve before executing WEC-Sim. In addition, users MUST specify the period from which the hydrodynamic coefficients are selected by defining the following in the input file::
 
	waves.noWaveHydrodynamicCoeffT = <user specified wave period>

noWaveCIC
.........
The noWaveCIC case (``waves.type=’noWaveCIC’``) is the same as the noWave case described above, 
with the addition of the convolution integral calculation. The wave type is the same as noWave, except the radiation forces are calculated using the convolution integral and the infinite frequency added mass.

regular
.........
The regular wave case (``waves.type=’regular’``) is for running simulations using regular waves with constant added mass and radiation damping coefficients. Wave period (``wave.T``) and wave height (``wave.H``) need to be specified in the input file. Using this option, WEC-Sim assumes that the system dynamic response is in sinusoidal steady-state form, where constant added mass and damping coefficients are used (instead of the convolution integral) to calculate wave radiation forces.

regularCIC
...........
The regular wave with convolution integral case (``waves.type=’regularCIC’``) is the same as regular wave case (described above), except the radiation forces are calculated using the convolution integral and the infinite frequency added mass.

irregular
.........
The irregular wave case (``waves.type=’irregular’``)is the wave type for irregular wave simulations using a given wave spectrum. Significant wave height (``wave.H``), peak period (``wave.T``) and wave spectrum type (``waves.spectrumtype``) need to be specified in the input file. The available spectral formulations are listed below.


WEC-Sim wave spectrum options (with `waves.type=irregular`)

==================  ========================
Wave Spectrum Type  Input File Parameter
Pierson–Moskowitz   waves.spectrumType=’PM’
Bretschneider	    waves.spectrumType=’BS’
JONSWAP             waves.spectrumType=’JS’
==================  ========================

irregularImport
................
The irregular waves with user-defined spectrum case (``waves.type=’irregularImport’``) is the wave case for irregular wave simulations using user-defined wave spectrum (ex: from buoy data). Users need to specify the wave spectrum file name in WEC-Sim input file as follows::

	waves.spectrumDataFile=’<wave spectrum file>.txt’

The user-defined wave spectrum must be defined with the wave frequency (Hz) in the first row, and the spectral energy density (m^2/Hz) in the second row. An example of which is given in the ``ndbcBuoyData.txt`` file in the applications folder of the WEC-Sim source code. This format can be copied directly from NDBC buoy data. For more information on NDBC buoy data measurement descriptions, refer to the [http://www.ndbc.noaa.gov/measdes.shtml NDBC website].

Note: By default, the phase for irregular waves (irregular and irregularImport) is generated randomly. Users have the ability to seed the random phase by specifying the following in the WEC-Sim input file::

	waves.randPreDefined=1

This gives the user an option to generate the same "random" wave time-series as needed (the default for random phase is ``waves.randPreDefined=0``). 

bodyClass
~~~~~~~~~~~~~~~
The body class (``bodyClass``) contains the mass and hydrodynamic properties of each body that comprises the WEC being simulated. Each body must have an iteration of the body class initiated in the input file. It is recommended that body objects are named body(<#>). Each body object MUST be initiated by entering the following command in the WEC-Sim input file::

	body(<#>)=bodyClass('body name')

Users can specify the mass and hydrodynamic properties for each after the body object is initiated. Each body must have an iteration of the body class initiated, and have the following parameters defined::

	body(<#>).hydroDataType
	body(<#>).hydroDataLocation
	body(<#>).mass
	body(<#>).cg
	body(<#>).momOfInertia

Users have the option of accepting the default values for the remaining body parameters, or specify their own values. The available wave parameters, and default values defined in the body class can be found by typing ``doc bodyClass`` in the MATLAB Command Window.

.. ::figure _static/bodyClass.png 

For example, the viscous drag can be specified by entering the (nondimensional) viscous drag coefficient and the characteristic area (in m^2) in vector format the WEC-Sim input file as follows::

	body(<#>).cd= [0 0 1.3 0 0 0]
	body(<#>).characteristicArea= [0 0 100 0 0 0]

constraintClass
~~~~~~~~~~~~~~~
The constraint class (``constraintClass``) is used to connect bodies to the Global Reference Frame. The constraint variable should be initiated by entering the following command in the WEC-Sim input file::

	constraint(<#>)=constraintClass('<constraint name>')

For rotational constraint (ex: pitch), the user also needs to specify its location of the rotational
joint with respect to the global reference frame in the ``constraint(<#>).loc`` variable

The available constraint parameters, and default values defined in the constraint class can be found by typing ``doc constraintClass`` in the MATLAB Command Window.

.. figure:: _static/constraintClass.png

ptoClass
~~~~~~~~

The pto class (``ptoClass``) extracts power from relative body motion with respect to a fixed reference frame or another body. The pto objects can also constrain motion to certain degrees of freedom (for example relative heave motion between the float and spar of a point absorber). The pto variable should be initiated by entering the following command in the WEC-Sim input file::

	pto(<#>) = ptoClass('<pto name>')

For rotational ptos (Local RY), users also needs to specify the pto location. In the PTO class, users can also
specify linear damping (``pto(<#>).c``) and stiffness (``pto(<#>).k``) values to represent the PTO system (both have a default value of 0). Users can overwrite the default values in the input file, for example to specify a damping value by entering the following in the WEC-Sim input file::

	pto(<#>).c = <pto damping value>

The available pto parameters, and default values defined in the pto class can be found by typing `` doc ptoClass`` in the MATLAB Command Window.

.. figure:: _static/ptoClass.png
   :width: 400pt

Library Structure
------------------

The WEC-Sim library is divided into 4 sublibraries. The user should be able to model their WEC device using the available WEC-Sim blocks, and possibly some SimMechanics blocks. The table below lists the WEC-Sim  blocks and their organization into sublibraries.

+-----------------+--------------------------+
|           WEC-Sim Library                  |
+================+===========================+
|Sublibrary      |Blocks                     |
+----------------+---------------------------+
|Body Elements   |Rigid Body                 | 
+----------------+---------------------------+
|Frames          |Global Reference Frame     |
+----------------+---------------------------+
|Constraints     |Heave                      |
|                |Surge                      |
|                |Surge                      |
|                |Fixed                      |
|                |Floating                   |
+----------------+---------------------------+
|                |Rotational PTO (Local RY)  | 
|PTOs            |Translational PTO (Local X)|
|                |Translational PTO (Local Z)| 
+----------------+---------------------------+

		
In the following sections, we will describe the four sublibraries and their general purpose. The Body Elements sublibrary contains the Rigid Body block used to simulate the different bodies. The Frames sublibrary contains the Global Reference Frame block necessary for every simulation. The Constraints sublibrary contains blocks that are used to constrain the DOF of the bodies, without including any additional forcing or resistance. The PTOs sublibrary contains blocks used to both simulate a PTO system and restrict the body motion. Both constraints and PTOs can be used to restrict the relative motion between multibody systems. %\end{section{Library Structure Overview

Body Elements Sublibrary
~~~~~~~~~~~~~~~~~~~~~~~~~

The Body Elements sublibrary (Figure~\ref{fig:bLib) contains one block, Rigid Body block. It is used to represent rigid bodies. At least one instance of this block is required in each model.

.. figure:: _static/bodiesLib.PNG
   :width: 400pt

Rigid Body Block
............................
The Rigid Body block is used to represent a rigid body in the simulation. The user has to name the blocks 'body(i)' where i=1,2,... The mass properties, hydrodynamic data, geometry file, mooring, and other properties are then specified in the input file. Within the body block the wave radiation, wave excitation, hydrostatic restoring, viscous damping and mooring forces are calculated.

Frames Sublibrary
~~~~~~~~~~~~~~~~~~~~~~~~~
The Frames sublibrary, shown in above, contains one block that is necessary in every model. The Global Reference Frame block defines global references and can be thought of as the seabed.

Global Reference Frame Block
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The Global Reference Frame block defines the solver configuration, seabed and free surface description, simulation time, and other global settings. It can be useful to think of the Global Reference Frame as being the seabed when creating a model. Every model requires one instance of the Global Reference Frame block. The Global Reference Frame block uses the simulation class variable simu and the wave class variable waves, which must be defined in the input file.

.. figure:: _static/framesLib.PNG
   :width: 400pt

Constraints Sublibrary
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The blocks within the Constraints sublibrary, shown above, are used to define the DOF of a specific body. Constraints blocks define only the DOF, but do not otherwise apply any forcing or resistance to the body motion. Each Constraints block has two connections, a base (B) and a follower (F). The Constraints block restricts the motion of the block that is connected to the follower relative to the block that is connected to the base. The base of these blocks is typically the Global Reference Frame (which can be thought of as the seabed) and the follower is a Rigid Body.

There are five Constraints blocks, including three that restrict motion to one DOF (Heave, Surge, Pitch), a free-floating (Floating) block, and a rigid connection (Fixed) block. The rest of this section will describe each Constraints block in more detail.

.. figure:: _static/constraintsLib.PNG
   :width: 400pt

Floating Block
.....................
The Floating block is used to simulate a free-floating body. It constrains the motion of the follower to be along the XZ plane of the base. That is, it allows translation in the X- and Z-axis, and rotation about the Y-axis. It  is usually used with the base connected to the Global Reference Frame (seabed), in which case the motion of the follower is along the global XZ plane.

Heave Block
.....................
The Heave block constrains the motion of the follower relative to the base to be along the Z-axis. In the case of the base connected to the Global Reference Frame (seabed), the body is allowed to move only in the vertical (Z) direction. In the case of the Heave block connecting two bodies, the relative motion of the two bodies is constrained to be only along their Z-axes. The Z-axis of the follower and base will always be parallel and their perpendicular distance will be constant. The actual direction of movement of the follower depends on the orientation of the base.

Surge Block
.....................
The Surge block constrains the motion of the follower relative to the base to be along the X-axis. If the base is connected to the Global Reference Frame (seabed), the body is allowed to move only in the horizontal (X) direction. If Surge block is connects two bodies, the relative motion of the two bodies is constrained to be only along their X-axes. The X-axis of the follower and base will always be parallel and their perpendicular distance will be constant. The actual direction of movement of the follower depends on the orientation of the base.

Pitch Block
.....................
The Pitch block constrains the relative motion between the follower and the base to be pitch rotation only (about the Y-axis). The distance from both body-fixed coordinate systems to the point of rotation stays constant. The orientation of both body-fixed Y-axes also stays constant. The user MUST enter the point about which the rotation occurs as the constraint's location in the input file.

Fixed Block
.....................
The Fixed block is a rigid connection that constrains all motion between the base and follower. It restricts translation in the X- and Z-axis, and rotation about the Y-axis.  Its most common use is for a rigid body fixed to the seabed.

PTOs Sublibrary
~~~~~~~~~~~~~~~~~~~~~~~
The PTOs sublibrary, shown below, is used to simulate simple PTO systems and to restrict relative motion between multiple bodies or between one body and the seabed. The PTO blocks can simulate simple PTO systems by applying a linear stiffness and damping to the connection. Similar to the Constraints blocks, the PTO blocks have a base (B) and a follower (F). Users MUST name each PTO block 'pto(i)' where i=1,2,..., and then define their properties in the input file.

Translation PTO (Local Z) Block
......................................
The Translation PTO (Local Z) is identical to the Heave constraint, but applies a linear stiffness and damping coefficient to the connection. The user has to name the PTOs as described earlier. The user then specifies the stiffness coefficient (in N/m), and damping coefficient (in Ns/m) in the input file.

.. figure:: _static/ptosLib.PNG
   :width: 400 pt

Translation PTO (Local X) Block
......................................
The Translation PTO (Local X) is identical to the Surge constraint, but additionally applies a linear stiffness and damping coefficient to the connection. The user has to name the PTOs as described earlier. The user then specifies the stiffness coefficient (in N/m), and damping coefficient (in Ns/m) in the input file.
	        
Rotational PTO (Local RY) Block
......................................
The Rotational PTO (Local RY) is identical to the Pitch constraint, but adds a linear rotational stiffness and damping coefficient to the connection. The user has to name the PTOs as described earlier. The user then specifies the stiffness coefficient (in Nm/rad) and damping coefficient (in Nms/rad) in the input file.

		
Other SimMechanics Blocks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In some situations, users may have to use SimMechanics blocks not included in the WEC-Sim Library to build their WEC model. One commonly used block is the Rigid Transform, which can be used to rotate the frames on PTOs, constraints, and bodies. This is also explained in the SimMechanics {User's Guide.