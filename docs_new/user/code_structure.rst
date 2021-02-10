.. adam:
    I think that this section needs some additional overhaul. Now that it is in a distinct user manual it is more apparent that the 'what/how' of each class/block is missing. There is a lot of information on the location of the source files (this should move to dev manual, users don't need to know this) and how to initialize classes. But I feel that each class is missing an overview on what it does and how it does it (tie back to theory).
    
    e.g. The purpose of the simulation class is to set-up a WEC-Sim case and holds all of the numerical options and flags required for the simulation. Parameters A and B are passed to C and D classes for reasons X and Y, etc..
    
    Also, the classes and library blocks are intentionally tied together so they should be presented that way. I suggest further restructuring this section based on each class. In each class' section, specific types of blocks can be presented as needed. The Global Reference Frame can be included with the simulation or wave class
    
.. _user-code-structure:

Code Structure
==============

This section provides a description of the WEC-Sim source code and its 
structure. For more information about WEC-Sim's code structure, refer to the 
:ref:`welcome-webinars-code-structure` webinar. 

.. _user-code-structure-src:

WEC-Sim Source Code
-------------------

The directory where the WEC-Sim code is contained is referred to as ``$WECSIM`` 
(e.g. ``C:/User/Documents/GitHub/WEC-Sim``). The WEC-Sim source code files are 
contained within a source directory referred to as ``$WECSIM/source``. The 
WEC-Sim source code consists of a series of MATLAB ``*.m`` objects (defined in 
WEC-Sim as classes) and Simulink ``*.slx`` library blocks which are executed by 
the ``wecSim.m`` script. Executing ``wecSim.m`` parses the user input data, 
performs preprocessing calculations in each of the classes, selects and 
initializes variant subsystems in the Simulink model, and runs the time-domain 
simulations in WEC-Sim. 

=========================   ====================  ==========================
**File Type**               **File name**         **Directory**
WEC-Sim Executable          ``wecSim.m``          ``$WECSIM/source``
WEC-Sim MATLAB Objects      ``<object>Class.m``   ``$WECSIM/source/objects``
WEC-Sim Simulink Library    ``<block>_Lib.slx``   ``$WECSIM/source/lib``
=========================   ====================  ==========================

.. _user-code-structure-objects:

WEC-Sim Objects
---------------

All information required to run WEC-Sim simulations is contained within the 
``simu``, ``waves``, ``body(i)``, ``pto(i)``, ``constraint(i)``, and 
``mooring(i)`` objects (instances of the simulationClass, waveClass, bodyClass, 
constraintClass, ptoClass, and mooringClass). The user can interact with these 
classes within the WEC-Sim input file (``wecSimInputFile.m``). The remainder of 
this section describes the role of the WEC-Sim objects, and how to interact 
with the WEC-Sim objects to define input properties. 

There are two ways to look at the available properties and methods within a 
class. The first is to type ``doc <className>`` in Matlab Command Window, and 
the second is to open the class definitions located in the 
``$WECSIM/source/objects`` directory by typing ``open <className>`` in MATLAB 
Command Window. The latter provides more information since it also defines the 
different fields in a structure. 

.. _user-code-structure-simulation-class:

Simulation Class
^^^^^^^^^^^^^^^^

The simulation class contains the simulation parameters, flags and solver 
settings necessary to execute the WEC-Sim code. These simulation parameters 
include numerical settings such as the time step, start time, differential 
equation solver method, and flags for various output options and nonlinear 
hydrodynamics options. At a high level, the simulation class interacts with the 
rest of WEC-Sim as shown in the diagram below. The most common flags and 
attributes that are passed to the other classes are shown here. 

.. figure:: /_static/images/new_figs/simulation_diagram.png
   :width: 100%

The simulation class file, ``simulationClass.m``, is located in the 
``$WECSIM/source/objects`` directory. Within the ``wecSimInputFile.m``, users 
must initialize the simulation class (``simulationClass``) and specify the name 
of the WEC-Sim (``*.slx``) model file by including the following lines:: 

    simu=simulationClass();
    simu.simMechanicsFile='<WEC Model Name>.slx'

Users may specify other simulation class properties using the ``simu`` object 
in the ``wecSimInputFile.m``, such as: simulation start time 
(``simu.startTime``), end time (``simu.endTime``), ramp time 
(``simu.rampTime``) and time step (``simu.dt``). All simulation class 
properties are specified as variables within the ``simu`` object as members of 
the ``simulationClass``. 

The WEC-Sim code has default values defined for the simulation class 
properties. These default values can be overwritten by the user, for example, 
the end time of a simulation can be set by entering the following command: 
``simu.endTime = <user specified end time>``. 

Available simulation properties, default values, and functions can be found by 
typing ``doc simulationClass`` in the MATLAB command window, or by opening the 
``simulationClass.m`` file in ``$WECSIM//objects`` directory by typing ``open 
simulationClass`` in MATLAB Command Window. 

For more information about application of WEC-Sim's simulation class, refer to 
:ref:`user-advanced-features-simulation`. 

.. _user-code-structure-wave-class:

Wave Class
^^^^^^^^^^

The wave class contains all wave information necessary to define the incident 
wave condition for the WEC-Sim time-domain simulation. The wave class passes 
the incoming wave information to the body objects to determine the excitation 
force, added mass, radiation damping and other frequency based parameters that 
influence a body's motion. 

At a high level, the wave class interacts with the rest of WEC-Sim as shown in 
the diagram below. The most common flags and attributes that are passed to the 
other classes are shown here. The wave primarily interacts with the body class 
through Simulink as described in the sections below. 

.. figure:: /_static/images/new_figs/wave_diagram.PNG
   :width: 100%

The wave class file, ``waveClass.m``, is located in the 
``$WECSIM/source/objects`` directory. Within the ``wecSimInputFile.m``, users 
must initialize the wave class (``waveClass``) and specify the wave ``type`` by 
including the following lines:: 

    waves = waveClass('type');

Users must specify additional wave class properties using the ``waves`` object 
depending on which wave type is selected, as shown in the table below. A more 
detailed description of the available wave types is given in the following 
sections. 

================== ================================================
**Wave Type**      **Required Properties**                         
``noWave``         ``waves.T``                                     
``noWaveCIC``                                                      
``regular``        ``waves.H``, ``waves.T``                        
``regularCIC``     ``waves.H``, ``waves.T``                        
``irregular``      ``waves.H``, ``waves.T``, ``waves.spectrumType``
``spectrumImport`` ``waves.spectrumDataFile``                      
``etaImport``      ``waves.etaDataFile``                           
================== ================================================

noWave
""""""

The ``noWave`` case is for running WEC-Sim simulations with no waves and 
constant radiation added mass and wave damping coefficients. The ``noWave`` 
case is typically used to run decay tests. Users must still provide hydro 
coefficients from a BEM solver before executing WEC-Sim and specify the period 
(``wave.T``) from which the hydrodynamic coefficients are selected. 

The ``noWave`` case is defined by including the following in the input file::

    waves = waveClass('noWave');
    waves.T = <user defined wave period>; %[s]

noWaveCIC
"""""""""

The ``noWaveCIC`` case is the same as the noWave case described above, but with 
the addition of the convolution integral calculation. The only difference is 
that the radiation forces are calculated using the convolution integral and the 
infinite frequency added mass. 

The ``noWaveCIC`` case is defined by including the following in the input file::

    waves = waveClass('noWaveCIC');

regular
"""""""

The ``regular`` wave case is used for running simulations in regular waves with 
constant radiation added mass and wave damping coefficients. Using this option, 
WEC-Sim assumes that the system dynamic response is in sinusoidal steady-state 
form, where constant added mass and damping coefficients are used (instead of 
the convolution integral) to calculate wave radiation forces. Wave period 
(``wave.T``) and wave height (``wave.H``) must be specified in the input file. 

The ``regular`` case is defined by including the following in the input file::

    waves = waveClass('regular');
    waves.T = <user defined wave period>; %[s]
    waves.H = <user defined wave height>; %[m]

regularCIC
""""""""""

The ``regularCIC`` is the same as regular wave case described above, but with 
the addition of the convolution integral calculation. The only difference is 
that the radiation forces are calculated using the convolution integral and the 
infinite frequency added mass. Wave period (``wave.T``) and wave height 
(``wave.H``) must be specified in the input file. 

The ``regularCIC`` case is defined by including the following in the input file::

    waves = waveClass('regularCIC');
    waves.T = <user defined wave period>; %[s]
    waves.H = <user defined wave height>; %[m]

irregular
"""""""""

The ``irregular`` wave case is the wave type for irregular wave simulations 
using a Pierson Moskowitz (PM) or JONSWAP (JS) wave spectrum as defined by the 
IEC TS 62600-2:2019 standards. Significant wave height (``wave.H``), peak 
period (``wave.T``), and wave spectrum type (``waves.spectrumtype``) must be 
specified in the input file. The available wave spectra and their corresponding 
``waves.spectrumType`` are listed below: 

======================  ==================
**Wave Spectrum**       **spectrumType**
Pierson Moskowitz       ``PM``
JONSWAP                 ``JS``
======================  ==================

The ``irregular`` case is defined by including the following in the input file::

    waves = waveClass('irregular');
    waves.T = <user defined wave period>; %[s]
    waves.H = <user defined wave height>; %[m]
    waves.spectrumType = '<user specified spectrum>';

When using the JONSWAP spectrum, users have the option of defining gamma by 
specifying ``waves.gamma = <user specified gamma>;``. If gamma is not defined, 
then gamma is calculated based on a relationship between significant wave 
height and peak period defined by IEC TS 62600-2:2019. 

spectrumImport
""""""""""""""

The ``spectrumImport`` case is the wave type for irregular wave simulations 
using an imported wave spectrum (ex: from buoy data). The user-defined spectrum 
must be defined with the wave frequency (Hz) in the first column, and the 
spectral energy density (m^2/Hz) in the second column. Users have the option to 
specify a third column with phase (rad); if phase is not specified by the user 
it will be randomly defined. An example of this is given in the 
``spectrumData.mat`` file in the tutorials directory folder of the WEC-Sim 
source code. The ``spectrumImport`` case is defined by including the following 
in the input file:: 

    waves = waveClass('spectrumImport');
    waves.spectrumDataFile='<wave spectrum file>.mat';

.. Note::
    When using the ``spectrumImport`` option, users must specify a sufficient 
    number of wave frequencies (typically ~1000) to adequately describe the 
    wave spectra. These wave frequencies are the same that will be used to 
    define the wave forces on the WEC, for more information refer to the 
    :ref:`user-advanced-features-irregular-wave-binning` section.

etaImport
"""""""""

The ``etaImport`` case is the wave type for wave simulations using user-defined 
time-series (ex: from experiments). The user-defined wave surface elevation 
must be defined with the time (s) in the first column, and the wave surface 
elevation (m) in the second column. An example of this is given in the 
``etaData.mat`` file in the tutorials directory folder of the WEC-Sim source 
code. The ``etaImport`` case is defined by including the following in the input 
file:: 

    waves = waveClass('etaImport');
    waves.etaDataFile ='<eta file>.mat';

Available wave class properties, default values, and functions can be found by 
typing ``doc waveClass`` in the MATLAB command window, or by opening the 
``waveClass.m`` file in ``$WECSIM/source/objects`` directory by typing ``open 
waveClass`` in the Matlab Command Window. 

For more information about application of WEC-Sim's wave class, refer to 
:ref:`user-advanced-features-wave`. 

.. _user-code-structure-body-class:

Body Class
^^^^^^^^^^

The body class represents each rigid or flexible body that comprises the WEC 
being simulated. It contains the mass and hydrodynamic properties of each body, 
defined by hydrodynamic data from the \*.h5 file. The corresponding body block 
uses the hydrodynamic data and wave class to calculate all relevant forces on 
the body and solve for its resultant motion. At a high level, the body class 
interacts with the rest of WEC-Sim as shown in the diagram below. 

.. figure:: /_static/images/new_figs/body_diagram.PNG
   :width: 750pt

The body class file, ``bodyClass.m``, is located in the 
``$WECSIM/source/objects`` directory. Within the ``wecSimInputFile.m``, 
users must initialize each iteration of the body class (``bodyClass``), and 
specify the location of the hydrodynamic data file (``*.h5``) and geometry 
file (``*.stl``) for each body. The body class is defined by including the 
following lines in the WEC-Sim input file, where # is the body number 
'<bem_data>.h5' is the name of the h5 file containing the BEM results:: 

    body(<#>)=bodyClass('<bem_data>.h5')
    body(<#>).geometryFile = '<geom>.stl'; 

.. note:
    The *.h5 file defines the hydrodynamic data for all relevant bodies. It is 
    required that any drag body or nonhydrodyamic body be numbered after all 
    hydrodynamic bodies The body index must correspond with the index in the 
    *.h5 file and the number in the Simulink diagram. 

Users may specify other body class properties using the ``body`` object for 
each body in the ``wecSimInputFile.m``. WEC-Sim bodies may be one of four types:

* Hydrodynamic body (default)
* Flexible hydrodynamic body
* Drag body
* Nonhydrodynamic body

Each type of body requires various parameters and input BEM data. The 
:ref:`user-advanced-features-body` section contains more details on these 
important distinctions. Regardless of type, body class properties need to 
include the mass (``body(#).mass``) and moment of inertia 
(``body(#).momOfInertia``). Other parameters are specified as needed. For 
example, viscous drag can be specified by entering the viscous drag coefficient 
and the characteristic area in vector format the WEC-Sim input file as 
follows:: 

    body(<#>).viscDrag.cd = [0 0 1.3 0 0 0]
    body(<#>).viscDrag.characteristicArea = [0 0 100 0 0 0]

Available body properties, default values, and functions can be found by typing 
``doc bodyClass`` in the MATLAB command window, or opening the `bodyClass.m` 
file in ``$WECSIM/source/objects`` directory by typing ``open bodyClass`` in 
Matlab Command Window. 

For more information about application of WEC-Sim's body class, refer to 
:ref:`user-advanced-features-body`.


.. _user-code-structure-constraint-class:

Constraint Class
^^^^^^^^^^^^^^^^

The WEC-Sim constraint class and blocks connect WEC bodies to one another (and 
possibly to the seabed) by constraining DOFs. Constraint objects do not apply 
any force or resistance to body motion outside of the reactive force required 
to prevent motion in a given DOF. At a high level, the constraint class 
interacts with the rest of WEC-Sim as shown in the diagram below. Constraint 
objects largely interact with other blocks through Simscape connections that 
pass resistive forces to other bodies, constraints, ptos, etc. 

.. figure:: /_static/images/new_figs/constraint_diagram.PNG
   :width: 750pt


The constraint class file, ``constraintClass.m``, is located in the 
``$WECSIM/source/objects`` directory. The 
properties of the constraint class (``constraintClass``) are defined in the 
``constraint`` object. Within the ``wecSimInputFile.m``, users must initialize 
each iteration the constraint class (``constraintClass``) and specify the 
constraint ``name``, by including the following lines:: 

    constraint(<#>)=constraintClass('<constraint name>'); 

For rotational constraint (ex: pitch), the user also needs to specify the 
location of the rotational joint with respect to the global reference frame in 
the ``constraint(<#>).loc`` variable. 

Available constraint properties, default values, and functions can be found by 
typing ``doc constraintClass`` in the MATLAB command window, or opening the 
`constraintClass.m` file in ``$WECSIM/source/objects`` directory by typing 
``open constraintClass`` in MATLAB Command Window. 

For more information about application of WEC-Sim's constraint class, refer to 
:ref:`user-advanced-features-pto`. 

.. _user-code-structure-pto-class:

PTO Class
^^^^^^^^^

WEC-Sim Power Take-Off (PTO) blocks connect WEC bodies to one other (and 
possibly to the seabed) by constraining DOFs and applying linear damping and 
stiffness. The ability to apply damping, stiffness, or other external forcing 
differentiates a `PTO` from a `Constraint`. 

At a high level, the PTO class interacts with the rest of WEC-Sim as shown in 
the diagram below. PTO objects largely interact with other blocks through 
Simscape connections that pass resistive forces to other bodies, constraints, 
ptos, etc. 

.. figure:: /_static/images/new_figs/pto_diagram.PNG
   :width: 750pt

The pto class file, ``ptoClass.m``, is located in the 
``$WECSIM/source/objects`` directory.  The pto class (``ptoClass``) 
extracts power from relative body motion with respect to a fixed reference 
frame or another body. The properties of the PTO class (``ptoClass``) are 
defined in the ``pto`` object. Within the ``wecSimInputFile.m``, users must 
initialize each iteration the pto class (``ptoClass``) and specify the pto 
``name``, by including the following lines:: 

    pto(<#>) = ptoClass('<pto name>');

For rotational ptos, the user also needs to specify the location of the 
rotational joint with respect to the global reference frame in the 
``constraint(<#>).loc`` variable. In the PTO class, users can also specify 
linear damping (``pto(<#>).c``) and stiffness (``pto(<#>).k``) values to 
represent the PTO system (both have a default value of 0). Users can overwrite 
the default values in the input file. For example, users can specify a damping 
value by entering the following in the WEC-Sim input file:: 

    pto(<#>).c = <pto damping value>;
    pto(<#>).k = <pto stiffness value>;

Available pto properties, default values, and functions can be found by typing 
``doc ptoClass`` in the MATLAB command window, or opening the `ptoClass.m` file 
in ``$WECSIM/source/objects`` directory by typing ``open ptoClass`` in MATLAB 
Command Window. 

For more information about application of WEC-Sim's constraint class, refer to 
:ref:`user-advanced-features-pto`. 

.. _user-code-structure-mooring-class:

Mooring Class
^^^^^^^^^^^^^

The mooring class (``mooringClass``) allows for different fidelity simulations 
of mooring systems. Two possibilities are available, a lumped mooring matrix or 
MoorDyn. These differences are determined by the Simulink block chosen, and are 
described below. At a high level, the Mooring class interacts with the rest of 
WEC-Sim as shown in the diagram below. The interaction is similar to a 
constraint or PTO, where some resistive forcing is calculated and passed to a 
body block through a Simscape connection. 

.. figure:: /_static/images/new_figs/mooring_diagram.PNG
   :width: 750pt

The mooring class file, `mooringClass.m``, is located in the 
``$WECSIM/source/objects`` directory. The properties of the mooring class 
(``mooringClass``) are defined in the ``mooring`` object. Within the 
``wecSimInputFile.m``, users must initialize the mooring class and specify the 
mooring ``name``, by including the following lines:: 

    mooring(#)= mooringClass('name');

Available mooring properties, default values, and functions 
can be found by typing ``doc mooringClass`` in the MATLAB command window, or 
opening the `mooringClass.m` file in ``$WECSIM/source/objects`` directory by 
typing ``open mooringClass`` in MATLAB Command Window. 

For more information about application of WEC-Sim's mooring class, refer to 
:ref:`user-advanced-features-mooring`.


.. _user-code-structure-response-class:

Response Class
^^^^^^^^^^^^^^
The response class contains all the output time-series and methods to plot and 
interact with the results. It is not initialized by the user. Instead, it is 
created automatically at the end of a WEC-Sim simulation. The response class 
does not input any parameter back to WEC-Sim, only taking output data from the 
various objects and blocks. The available parameters are explained in the 
:ref:`user-code-structure-output` section. 

.. _user-code-structure-library:

WEC-Sim Library
---------------

In addition to the ``wecSimInputFile.m``, a WEC-Sim simulation requires a 
simulink model (``*.slx``) that represents the WEC system components and 
connectivities. Similar to how the input file uses the WEC-Sim classes, the 
Simulink model uses WEC-Sim library blocks. There should be a one-to-one 
relationship between the objects defined in the input file and the blocks used 
in the Simulink model. 

The WEC-Sim library is divided into 5 different types of library blocks. The 
user should be able to model their WEC device using the available WEC-Sim 
blocks (and possibly other Simulink/Simscape blocks). The image below shows the 
WEC-Sim block grouping by type. 

.. figure:: /_static/images/WEC-Sim_Lib.PNG
   :width: 400pt    
   :align: center

This section describes the five different library types and their general 
purpose. The Body Elements library contains the Rigid Body block used to 
simulate the different bodies. The Frames library contains the Global Reference 
Frame block necessary for every simulation. The Constraints library contains 
blocks that are used to constrain the DOF of the bodies without including any 
additional forcing or resistance. The PTOs library contains blocks used to both 
simulate a PTO system and restrict the body motion. Both constraints and PTOs 
can be used to restrict the relative motion between multi-body systems. The 
Mooring library contains blocks used to simulate mooring systems. 

Body Elements
^^^^^^^^^^^^^

The Body Elements library shown below contains four body types in two blocks: 
the ``Rigid Body`` block and the ``Flex Body`` block. The rigid body block is 
used to represent hydrodynamic, nonhydrodynamic, and drag bodies. Each type of 
rigid body is a `Variant Sub-system <https://www.mathworks.com/help/simulink/slref/variant-subsystems.html>`_. 
Before simulation, one variant is activated by a flag in the body object 
(body.nhBody=0,1,2). The flex body block is used to represent hydrodynamic 
bodies that contain additional flexible degrees of freedom ('generalized body 
modes'). The flex body is determined automatically by the degrees of freedom 
contained in the BEM input data. At least one instance of a hydrodynamic body 
block (rigid or flex) is required in each model. The 
:ref:`user-advanced-features-body` section describes the various types of 
WEC-Sim bodies in detail. 

Both in Simulink and the input file, the user has to name the blocks 
``body(i)`` (where i=1,2,...). The mass properties, hydrodynamic data, geometry 
file, mooring, and other properties are then specified in the input file. 
Within the body block, the wave radiation, wave excitation, hydrostatic 
restoring, viscous damping, and mooring forces are calculated. 

.. figure:: /_static/images/WEC-Sim_Lib_bodies.PNG
   :width: 400pt
   :align: center
   
Frames
^^^^^^

The Frames library contains one block that is necessary in every model. The 
``Global Reference Frame`` block defines the global coordinates, solver 
configuration, seabed and free surface description, simulation time, and other 
global settings. It can be useful to think of the Global Reference Frame as 
being the seabed when creating a model. Every model requires one instance of 
the Global Reference Frame block. The ``Global Reference Frame`` block uses the 
simulation class variable `simu` and the wave class variable `waves`, which 
must be defined in the input file. 

.. figure:: /_static/images/WEC-Sim_Lib_frames.PNG
   :width: 400pt
   :align: center

Constraints 
^^^^^^^^^^^

The blocks within the Constraints library are used to define the DOF of a 
specific body. Constraint blocks define only the DOF, but do not otherwise 
apply any forcing or resistance to the body motion. Each Constraint block has 
two connections: a base (B) and a follower (F). The Constraints block restricts 
the motion of the block that is connected to the follower relative to the block 
that is connected to the base. For a single body system, the base would be the 
``Global Reference Frame`` and the follower is a ``Rigid Body``. 

.. figure:: /_static/images/WEC-Sim_Lib_constraints.PNG
   :width: 400pt
   :align: center

A brief description of each constraint block is given below. More information 
can also be found by double clicking on the library block and viewing the Block 
Parameters box. 

+--------------------+-----+-----------------------------------------+
|                   Constraint Library                               |
+====================+=====+=========================================+
|Block               |DOFs |Description                              |
+--------------------+-----+-----------------------------------------+
|``Fixed``           |0    |Rigid connection. Constrains all motion  |
|                    |     |between the base and follower            |
+--------------------+-----+-----------------------------------------+
|``Translational``   |1    |Constrains the motion of the follower    |
|                    |     |relative to the base to be translation   |
|                    |     |along the constraint's Z-axis            |
+--------------------+-----+-----------------------------------------+
|``Rotational``      |1    |Constrains the motion of the follower    |
|                    |     |relative to the base to be rotation      |
|                    |     |about the constraint's Y-axis            |
+--------------------+-----+-----------------------------------------+
|``Floating (3DOF)`` |3    |Constrains the motion of the follower    |
|                    |     |relative to the base to planar motion    |
|                    |     |with translation along the constraint's  |
|                    |     |X- and Z- and rotation about the Y- axis |
+--------------------+-----+-----------------------------------------+
|``Floating (6DOF)`` |6    |Allows for unconstrained motion of the   |
|                    |     |follower relative to the base            |
+--------------------+-----+-----------------------------------------+


PTOs
^^^^

The PTOs library is used to simulate linear PTO systems and to restrict 
relative motion between multiple bodies or between one body and the seabed. The 
PTO blocks can simulate simple PTO systems by applying a linear stiffness and 
damping to the connection. Similar to the Constraint blocks, the PTO blocks 
have a base (B) and a follower (F). Users must name each PTO block ``pto(i)`` 
(where i=1,2,...) and then define their properties in the input file. 

The ``Translational PTO`` and ``Rotational PTO`` are identical to the 
``Translational`` and ``Rotational`` constraints, but they allow for the 
application of linear damping and stiffness forces. Additionally, there are two 
other variations of the Translational and Rotational PTOs. The Actuation 
Force/Torque PTOs allow the user to define the PTO force/torque at each 
time-step and provide the position, velocity and acceleration of the PTO at 
each time-step. The user can use the response information to calculate the PTO 
force/torque. The Actuation Motion PTOs allow the user to define the motion of 
the PTO. These can be useful to simulate forced-oscillation tests. 

.. figure:: /_static/images/WEC-Sim_Lib_pto.PNG
   :width: 400 pt
   :align: center

.. Note::
    When using the Actuation Force/Torque PTO or Actuation Motion PTO blocks, 
    the loads and displacements are specified in the local (not global) 
    coordinate system. This is true for both the sensed (measured) and actuated 
    (commanded) loads and displacements.

Mooring
^^^^^^^

The mooring library is used to simulate mooring systems. The ``MooringMatrix`` 
block applies linear damping and stiffness based on the motion of the follower 
relative to the base. The ``MoorDyn`` block uses the compiled MoorDyn 
executables and a MoorDyn input file to simulate a realistic mooring system. 
There can only be one MoorDyn block per Simulink model. There are no 
restrictions on the number of MooringMatrix blocks. 

.. figure:: /_static/images/WEC-Sim_Lib_mooring.PNG
   :width: 400 pt
   :align: center

Simulink/Simscape Blocks
^^^^^^^^^^^^^^^^^^^^^^^^

In some situations, users may want to use Simulink/Simscape blocks that are not 
included in the WEC-Sim Library to build their WEC model. 

.. _user-code-structure-output:

Output Structure
----------------

After WEC-Sim is done running, there will be a new variable called ``output`` 
saved to the MATLAB workspace. The ``output`` object is an instance of the 
``responseClass``. It contains all the relevant time-series results of the 
simulation. Refer to the WEC-Sim API documentation for the :ref:`response` for 
information about the structure of the ``output`` object, . Time-series are 
given as [# of time-steps x 6] arrays, where 6 is the degrees of freedom. 

WEC-Sim outputs can be written to ASCII files by specifying ``simu.outputtxt = 1;`` 
in ``wecSimInputFile.m``, in addition to the responseClass ``output`` variable. 

Functions & External Codes
--------------------------

While the bulk of the WEC-Sim code consists of the WEC-Sim classes and the 
WEC-Sim library, the source code also includes supporting functions and 
external codes. These include third party Matlab functions to read ``*.h5`` and 
``*.stl`` files, WEC-Sim Matlab functions to write ``*.h5`` files and run 
WEC-Sim in batch mode, MoorDyn compiled executables, python macros for ParaView 
visualization, and the PTO-Sim class and library. Additionally, BEMIO can be 
used to create the hydrodynamic ``*.h5`` file required by WEC-Sim. MoorDyn is 
an open source code that must be downloaded separately. Users may also obtain, 
modify, and recompile the code as desired.
