
.. warning::
    This rst source is written in a really unusual way, with each sentence on
    it's own line. All the docs would be much easier to read if it was enforced 
    by a linter such as `doc8 <https://github.com/pycqa/doc8>`_.

.. note::
    Overall, I think this section tries to be too many things and is let down 
    by the assumption that the structure of the code is informative to the 
    user. IMO, the structure of the code is informative to developers, the use 
    of the code is informative to the user. It's made somewhat worse by the 
    fact that the user is unnecessarily burdened with setting up two (three if 
    you count moordyn) different models using different techniques, so a lot of 
    time is spent explaining the mechanics of a MATLAB class and how to 
    interact with them, rather than giving useful information about the data 
    that is required to run the model and, more importantly, the results that 
    it generates. 
    
    Assuming that class+simulink user interface continues, this would be much
    easier to understand if the blocks and classes were explained in the same 
    section, describing what they do and, precisely, how to use each type. 
    Here it's too fractured to get a feeling for how to develop a model.
    
    The lack of detail regarding the outputs is also disappointing, especially
    since there is hardly any detail on what information WEC-Sim provides up
    to this part of the docs. I almost think I would show the outputs first,
    to wet the appetite of new users (I'm noting that idea for DTOcean should I 
    ever work on it again!). 
    
    Also, the cursory mention of the supporting functions seems like a missed
    opportunity, considering how important at least BEMIO is to the process
    of using WEC-Sim. From a users perspective, the page is a big tease, telling
    me some of things I need to know, but not enough.

    Also, it seems like the :ref:`advanced_features` section carries some pretty 
    critical setup information that isn't provided in this page, again, probably
    forced by the need to structure the page in the way it is.

.. _code_structure:

Code Structure
==============
This section provides a description of the WEC-Sim source code and its structure. 
For more information about WEC-Sim's code structure, refer to the :ref:`webinars:WEC-Sim Code Structure` webinar.

.. note::
    Well, the webinar explains the relationship between the simulink file and
    the input file, which wasn't specified in the docs up to now, so that's
    good. The fact that you're having to train folk how to use OOP seems like
    the choice to use OOP to collect user input was perhaps the wrong design.
    Also, It seems like there is "a way" that the Simulink file should be put 
    together, but I'm yet to encounter any description of that "way" and I'm
    kind of going through the developer focussed parts (yes?) of the docs now.
    
    OOP could have been used more effectively, also, particularly polymorphism,
    such that specific subclasses could have been provided that only have the
    properties they require, rather than having general classes where some of
    the properties should be set depending on how it's configured.

WEC-Sim Source Code
--------------------------------
The directory where the WEC-Sim code is contained is referred to as ``$WECSIM`` (e.g. ``C:/User/Documents/GitHub/WEC-Sim``).
The WEC-Sim source code files are contained within a source directory referred to as ``$WECSIM/source``.
The WEC-Sim source code consists of a series of MATLAB ``*.m`` objects (defined in WEC-Sim as classes) and Simulink ``*.slx`` library blocks which are executed by the ``wecSim.m`` script. 
Executing ``wecSim.m`` parses the user input data, performs preprocessing calculations in each of the classes, selects and initializes variant subsystems in the Simulink model, and runs the time-domain simulations in WEC-Sim. 

.. note::
    The "source code consists of a series of MATLAB ``*.m`` objects". Well, 
    strictly it contains .m files that define both classes and functions.
    
    The use of the term "object" here is a bit strange, e.g. "objects defined 
    in WEC-Sim as classes" is an odd way to put it, and I think you 
    should just say classes when you are referring to what is in the objects 
    folder of the source code, because that's what they are (every file is 
    named somethingClass, after all.). I think I would have called them 
    "blocks" if I were to group them, because they are analogous to the 
    simulink blocks. 
    
    I would also remove the term Class in all the classes. You don't put the 
    word Function after all your functions. The first-letter-is-capital naming 
    convention for MATLAB classes can distinguish between classes and functions 
    (and objects). 

=========================   ====================  ==========================
**File Type**               **File name**         **Directory**
WEC-Sim Executable          ``wecSim.m``          ``$WECSIM/source``
WEC-Sim MATLAB Objects      ``<object>Class.m``   ``$WECSIM/source/objects``
WEC-Sim Simulink Library    ``<block>_Lib.slx``   ``$WECSIM/source/lib``
=========================   ====================  ==========================

.. warning::
    Your table here seems like it is out of date. There are no slx files on
    the ``$WECSIM/source/lib`` path, just two folders. Also the meaning of
    <block> and <object> are not explained.

.. _wsim_objects:

WEC-Sim Objects
----------------

.. note::
    I would say you were fairly explicit about what you had to do in the
    input file in the webinar, but here I think you need to be more precise
    about what is required. The objects are created from classes and should
    have specific names (I guess). It is sort of implicitly written below but 
    not clearly enough, IMO.

All information required to run WEC-Sim simulations is contained within the ``simu``, ``waves``, ``body(i)``, ``pto(i)``, ``constraint(i)``, and ``mooring(i)`` objects (instances of the simulationClass, waveClass, bodyClass, constraintClass, ptoClass, and mooringClass).  
The user can interact with these classes within the WEC-Sim input file (``wecSimInputFile.m``). 
The remainder of this section describes the role of the WEC-Sim objects, and how to interact with the WEC-Sim objects to define input properties. 

There are two ways to look at the available properties and methods within a class.
The first is to type ``doc <className>`` in Matlab Command Window, and the second is to open the class definitions located in the ``$WECSIM/source/objects`` directory by typing ``open <className>`` in MATLAB Command Window.
The latter provides more information since it also defines the different fields in a structure.

.. note::
    You've probably avoided telling people to use the help command because 
    all you get is your copyright statement. We encountered this in WecOptTool,
    and MATLAB has a particular method for positioning the copyright statement
    so it doesn't interfere with the help. You can find the issue we have open
    for this `here <https://github.com/SNL-WaterPower/WecOptTool/issues/142>`_.

Simulation Class
^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    This first line, that appears in every class is redundant given you've 
    already said this above. And the second line is much more useful to be
    the first line, if you get my drift.
    
The simulation class file, ``simulationClass.m``, is located in the ``$WECSIM/source/objects`` directory. 
The simulation class contains the simulation parameters and solver settings necessary to execute the WEC-Sim code. 
Within the ``wecSimInputFile.m``, users must initialize the simulation class (``simulationClass``) and specify the name of the  WEC-Sim (``*.slx``) model file by including the following lines::

	simu=simulationClass();
	simu.simMechanicsFile='<WEC Model Name>.slx'
	
	

.. note::
    "the  WEC-Sim (``*.slx``) model file" - the fact that these are simulink
    model files is sort of avoided in this documentation, but, given the
    ambiguity of what a model can be (WEC-Sim is a model), it would avoid 
    confusion if the word simulink were added, I think.

Users may specify other simulation class properties using the ``simu`` object in the ``wecSimInputFile.m``, such as: simulation start time (``simu.startTime``), end time (``simu.endTime``), ramp time (``simu.rampTime``) and time step (``simu.dt``). 
All simulation class properties are specified as variables within the ``simu`` object as members of the ``simulationClass``.

.. note::
    "All [type] class properties are specified as variables within the 
    [object] as members of the [class]" isn't particularly informative.


The WEC-Sim code has default values defined for the simulation class properties. 
These default values can be overwritten by the user, for example, the end time of a simulation can be set by entering the following command: ``simu.endTime = <user specified end time>``.

.. note::
    The sentence below is also made redundant by the text in the 
    :ref:`wsim_objects` section.

Available simulation properties, default values, and functions can be found by typing ``doc simulationClass`` in the MATLAB command window, or by opening the ``simulationClass.m`` file in ``$WECSIM//objects`` directory by typing ``open simulationClass`` in MATLAB Command Window.

For more information about application of WEC-Sim's simulation class, refer to :ref:`advanced_features:Simulation Features`.

.. note::
    This section and others could be made clearer using tables like this:
    
    +-----------------------+-----------+---------+------+
    | Option                | Parameter | Default | unit |
    +=======================+===========+=========+======+
    | simulation start time | startTime | 0       | s    |
    +-----------------------+-----------+---------+------+
    | simulation end time   | endTime   | 1000    | s    |
    +-----------------------+-----------+---------+------+
    | ramp time             | rampTime  | 60      | s    |
    +-----------------------+-----------+---------+------+
    | time step             | dt        | 1       | s    |
    +-----------------------+-----------+---------+------+
    
    with some explanation above about how to set a parameter, and the difference
    between required and optional parameters, in the introduction text, to 
    avoid repeating yourself.

Wave Class
^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    From a naming perspective, I noticed in the webinar you spent some time
    explaining that this is just for describing the incident wave, why then
    not call the class 'IncidentWave' or something else to help enforce
    what is an important distinction?

The wave class file, ``waveClass.m``, is located in the ``$WECSIM/source/objects`` directory. 
The wave class contains all wave information necessary to define the incident wave condition for the WEC-Sim time-domain simulation. 
Within the ``wecSimInputFile.m``, users must initialize the wave class (``waveClass``) and specify the wave ``type`` by including the following lines::

	waves = waveClass('type');
	
Users must specify additional wave class properties using the ``waves`` object depending on which wave type is selected, as shown in the table below. A more detailed description of the available wave types is given in the following sections.

================== ===================================
**Wave Type**      **Required Properties**         	       
``noWave``          ``waves.T``         		       
``noWaveCIC``                                          
``regular``         ``waves.H``, ``waves.T``                       
``regularCIC``      ``waves.H``, ``waves.T``                      
``irregular``       ``waves.H``, ``waves.T``, ``waves.spectrumType``  
``spectrumImport``  ``waves.spectrumDataFile``                 
``etaImport``       ``waves.etaDataFile``                      
================== =================================== 

.. note::
    There was a missed opportunity for using polymorphism here to create 
    subclasses that simply required these inputs on initialisation, rather than
    relying on configuring a single class correctly.

Available wave class properties, default values, and functions can be found by typing ``doc waveClass`` in the MATLAB command window, or by opening the ``waveClass.m`` file in ``$WECSIM/source/objects`` directory by typing ``open waveClass`` in the Matlab Command Window.

noWave
""""""""""""""""""""""""""""""

.. note::
    Waves don't have added mass, so I think the choice to use the 
    convolution integral, or not, has made the meaning of this class rather
    muddy. Surely the use of the convolution integral is more of a simulation
    thing, than a property of the incident wave itself?


The ``noWave`` case is for running WEC-Sim simulations with no waves and constant radiation added mass and wave damping coefficients. 
The ``noWave`` case is typically used to run decay tests. 
Users must still provide hydro coefficients from a BEM solver before executing WEC-Sim and specify the period (``wave.T``) from which the hydrodynamic coefficients are selected. 

The ``noWave`` case is defined by including the following in the input file::

	waves = waveClass('noWave');
	waves.T = <user defined wave period>; %[s]

noWaveCIC
""""""""""""""""""""""""""""""
The ``noWaveCIC`` case is the same as the noWave case described above, but with the addition of the convolution integral calculation. 
The only difference is that the radiation forces are calculated using the convolution integral and the infinite frequency added mass. 

The ``noWaveCIC`` case is defined by including the following in the input file::

	waves = waveClass('noWaveCIC');

.. note::
    "The ``noWaveCIC`` case is the same as the noWave case described above"
    except that you don't have to set T?

regular
""""""""""""""""""""""""""""""
The ``regular`` wave case  is used for running simulations in regular waves with constant radiation added mass and wave damping coefficients. 
Using this option, WEC-Sim assumes that the system dynamic response is in sinusoidal steady-state form, where constant added mass and damping coefficients are used (instead of the convolution integral) to calculate wave radiation forces.
Wave period (``wave.T``) and wave height (``wave.H``) must be specified in the input file. 

The ``regular`` case is defined by including the following in the input file::

	waves = waveClass('regular');
	waves.T = <user defined wave period>; %[s]
	waves.H = <user defined wave height>; %[m]

regularCIC
""""""""""""""""""""""""""""""
The ``regularCIC`` is the same as regular wave case described above, but with the addition of the convolution integral calculation. 
The only difference is that the radiation forces are calculated using the convolution integral and the infinite frequency added mass. 
Wave period (``wave.T``) and wave height (``wave.H``) must be specified in the input file. 

The ``regularCIC`` case is defined by including the following in the input file::

	waves = waveClass('regularCIC');
	waves.T = <user defined wave period>; %[s]
	waves.H = <user defined wave height>; %[m]	

irregular
""""""""""""""""""""""""""""""
The ``irregular`` wave case is the wave type for irregular wave simulations using a Pierson Moskowitz (PM) or JONSWAP (JS) wave spectrum as defined by the IEC TS 62600-2:2019 standards. Significant wave height (``wave.H``), peak period (``wave.T``), and wave spectrum type (``waves.spectrumtype``) must be specified in the input file. 
The available wave spectra and their corresponding ``waves.spectrumType`` are listed below:

======================  ==================
**Wave Spectrum**       **spectrumType**
Pierson Moskowitz   	``PM``
JONSWAP             	``JS``
======================  ==================

The ``irregular`` case is defined by including the following in the input file::

	waves = waveClass('irregular');
	waves.T = <user defined wave period>; %[s]
	waves.H = <user defined wave height>; %[m]
	waves.spectrumType = '<user specified spectrum>';

.. note::
    <user specified spectrum> on quick glance, doesn't really make it clear 
    what should go in here. Perhaps with these examples, if they were put at 
    the top of the section, then you could explain the meanings in the angle 
    brackets in the following text. 

When using the JONSWAP spectrum, users have the option of defining gamma by specifying ``waves.gamma = <user specified gamma>;``. If gamma is not defined, then gamma is calculated based on a relationship between significant wave height and peak period defined by IEC TS 62600-2:2019.    

spectrumImport
""""""""""""""""""""""""""""""
The ``spectrumImport`` case is the wave type for irregular wave simulations using an imported wave spectrum (ex: from buoy data). 
The user-defined spectrum must be defined with the wave frequency (Hz) in the first column, and the spectral energy density (m^2/Hz) in the second column. 
Users have the option to specify a third column with phase (rad); if phase is not specified by the user it will be randomly defined.
An example of this is given in the ``spectrumData.mat`` file in the tutorials directory folder of the WEC-Sim source code. 
The ``spectrumImport`` case is defined by including the following in the input file::

	waves = waveClass('spectrumImport');
	waves.spectrumDataFile='<wave spectrum file>.mat';

.. Note::
	When using the ``spectrumImport`` option, users must specify a sufficient number of wave frequencies (typically ~1000) to adequately describe the wave spectra. These wave frequencies are the same that will be used to define the wave forces on the WEC, for more information refer to the :ref:`advanced_features:Irregular Wave Binning` section.
	
etaImport
""""""""""""""""""""""""""""""
The ``etaImport`` case is the wave type for wave simulations using user-defined time-series (ex: from experiments). 
The user-defined wave surface elevation must be defined with the time (s) in the first column, and the wave surface elevation (m) in the second column. 
An example of this is given in the ``etaData.mat`` file in the tutorials directory folder of the WEC-Sim source code. 
The ``etaImport`` case is defined by including the following in the input file::

	waves = waveClass('etaImport');
	waves.etaDataFile ='<eta file>.mat';
	
	
For more information about application of WEC-Sim's wave class, refer to :ref:`advanced_features:Wave Features`.

Body Class
^^^^^^^^^^^^^^^^^^^^^^^
The body class file, ``bodyClass.m``, is located in the ``$WECSIM/source/objects`` directory. 
The body class contains the mass and hydrodynamic properties of each body that comprises the WEC being simulated. 
Within the ``wecSimInputFile.m``, users must initialize each iteration of the body class (``bodyClass``), and specify the location of the  hydrodynamic data file (``*.h5``) and geometry file (``*.stl``) for each body. The body class is defined by including the following lines in the WEC-Sim input file, where # is the body number '<bem_data>.h5' is the name of the h5 file containing the BEM results::

	body(<#>)=bodyClass('<bem_data>.h5')
	body(<#>).geometryFile = '<geom>.stl'; 
	

Users may specify other body class properties using the ``body`` object for each body in the ``wecSimInputFile.m``. 
WEC-Sim assumes that every WEC is composed of rigid bodies exposed to wave forcing.  
Body class properties include mass (``body(#).mass``) and moment of inertia (``body(#).momOfInertia``).
For example, viscous drag can be specified by entering the viscous drag coefficient and the characteristic area in vector format the WEC-Sim input file as follows::

	body(<#>).viscDrag.cd= [0 0 1.3 0 0 0]
	body(<#>).viscDrag.characteristicArea= [0 0 100 0 0 0]

.. note::
    "WEC-Sim assumes that every WEC is composed of rigid bodies exposed to wave 
    forcing." <- Why hide this in the second paragraph?

Available body properties, default values, and functions can be found by typing ``doc bodyClass`` in the MATLAB command window, or opening the `bodyClass.m` file in ``$WECSIM/source/objects`` directory by typing ``open bodyClass`` in Matlab Command Window.

For more information about application of WEC-Sim's body class, refer to :ref:`advanced_features:Body Features`.

Constraint Class
^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    This class is named after its implementation rather than its action. Is
    something like "link" or "joint" not more descriptive? 

The constraint class file, ``constraintClass.m``, is located in the ``$WECSIM/source/objects`` directory.  
WEC-Sim constraint blocks connect WEC bodies to one another (and possibly to the seabed) by constraining DOFs. 
The properties of the constraint class (``constraintClass``) are defined in the ``constraint`` object. 
Within the ``wecSimInputFile.m``, users must initialize each iteration the constraint class (``constraintClass``) and specify the constraint ``name``, by including the following lines::

	constraint(<#>)=constraintClass('<constraint name>'); 

.. note::
    I think there is some ambiguity in the return of the word block here. This
    is referring to the simulink model? If the block does that then this
    class does...? I think this enforces that there really shouldn't be a
    semantic difference between what is called objects and blocks.

For rotational constraint (ex: pitch), the user also needs to specify the location of the rotational joint with respect to the global reference frame in the ``constraint(<#>).loc`` variable. 

.. note:: 
    We are getting back to "the way" again here. I'm guessing that "the global 
    reference frame" is set in the simulink model? Are there any docs about 
    doing this?

Available constraint properties, default values, and functions can be found by typing ``doc constraintClass`` in the MATLAB command window, or opening the `constraintClass.m` file in ``$WECSIM/source/objects`` directory by typing ``open constraintClass`` in MATLAB Command Window.

For more information about application of WEC-Sim's constraint class, refer to :ref:`advanced_features:Constraint and PTO Features`.


PTO Class
^^^^^^^^^^^^^^^^^^^^^^^
The pto class file, ``ptoClass.m``, is located in the ``$WECSIM/source/objects`` directory.
WEC-Sim Power Take-Off (PTO) blocks connect WEC bodies to one other (and possibly to the seabed) by constraining DOFs and applying linear damping and stiffness. 
The pto class (``ptoClass``) extracts power from relative body motion with respect to a fixed reference frame or another body. 
The properties of the PTO class (``ptoClass``) are defined in the ``pto`` object. 
Within the ``wecSimInputFile.m``, users must initialize each iteration the pto class (``ptoClass``) and specify the pto ``name``, by including the following lines::

	pto(<#>) = ptoClass('<pto name>');
	

.. note::
    # isn't described here or for the constraints class.

For rotational ptos, the user also needs to specify the location of the rotational joint with respect to the global reference frame in the ``constraint(<#>).loc`` variable. 
In the PTO class, users can also specify linear damping (``pto(<#>).c``) and stiffness (``pto(<#>).k``) values to represent the PTO system (both have a default value of 0). 
Users can overwrite the default values in the input file. For example, users can specify a damping value by entering the following in the WEC-Sim input file::

	pto(<#>).c = <pto damping value>;
	pto(<#>).k = <pto stiffness value>;


Available pto properties, default values, and functions can be found by typing ``doc ptoClass`` in the MATLAB command window, or opening the `ptoClass.m` file in ``$WECSIM/source/objects`` directory by typing ``open ptoClass`` in MATLAB Command Window.

For more information about application of WEC-Sim's constraint class, refer to :ref:`advanced_features:Constraint and PTO Features`.

Mooring Class
^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    This section says nothing useful. Why does a mooring need a name? Why
    might I need more than one of them? 


The mooring class file, `mooringClass.m``, is located in the ``$WECSIM/source/objects`` directory.
The properties of the mooring class (``mooringClass``) are defined in the ``mooring`` object. 
Within the ``wecSimInputFile.m``, users must initialize the mooring class and specify the mooring ``name``, by including the following lines::

	mooring(#)= mooringClass('name');


The mooring class (``mooringClass``) allows for different fidelity simulations of mooring systems.
Available mooring properties, default values, and functions can be found by typing ``doc mooringClass`` in the MATLAB command window, or opening the `mooringClass.m` file in ``$WECSIM/source/objects`` directory by typing ``open mooringClass`` in MATLAB Command Window.

For more information about application of WEC-Sim's mooring class, refer to :ref:`advanced_features:Mooring Features`.

Response Class
^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    I think this section sort of encapsulates the problem with this page and 
    with mixing this tour of classes and some essential information about how 
    the user sets up the input file. The information here is only here because 
    it's talking about the classes, but because the user has no interaction 
    with the class in the setup stage, nothing is said. I would say this is 
    another strong indicator of the need to separate use from implementation in 
    these docs. 

The response class is not initialized by the user.
Instead, it is created at the end of a WEC-Sim simulation.
It contains all the output time-series and methods to plot and interact with the results.
The available parameters are explained in the :ref:`code_structure:Output Structure` section.


WEC-Sim Library
----------------
In addition to the ``wecSimInputFile.m``, a WEC-Sim simulation requires a simulink model (``*.slx``) that represents the WEC system components and connectivities.
Similar to how the input file uses the WEC-Sim classes, the Simulink model uses WEC-Sim library blocks.
There should be a one-to-one between the objects defined in the input file and the blocks used in the Simulink model.

The WEC-Sim library is divided into 5 different types of library blocks. 
The user should be able to model their WEC device using the available WEC-Sim blocks (and possibly other Simulink/Simscape blocks). 
The image below shows the WEC-Sim block grouping by type.

.. figure:: _images/WEC-Sim_Lib.PNG
   :width: 400pt	
   :align: center

This section describes the five different library types and their general purpose. 
The Body Elements library contains the Rigid Body block used to simulate the different bodies. 
The Frames library contains the Global Reference Frame block necessary for every simulation. 
The Constraints library contains blocks that are used to constrain the DOF of the bodies without including any additional forcing or resistance. 
The PTOs library contains blocks used to both simulate a PTO system and restrict the body motion. 
Both constraints and PTOs can be used to restrict the relative motion between multi-body systems. 
The Mooring library contains blocks used to simulate mooring systems.

.. note::
    Again, there is not really any description of how these blocks should be
    used together, which is as important as understanding what each block does.

Body Elements
^^^^^^^^^^^^^^^^^^^^^^^
The Body Elements library shown below contains one block: the ``Rigid Body`` block. 
It is used to represent rigid bodies. 
At least one instance of this block is required in each model.

The ``Rigid Body`` block is used to represent a rigid body in the simulation. The user has to name the blocks ``body(i)`` (where i=1,2,...). 
The mass properties, hydrodynamic data, geometry file, mooring, and other properties are then specified in the input file. 
Within the body block, the wave radiation, wave excitation, hydrostatic restoring, viscous damping, and mooring forces are calculated.

.. figure:: _images/WEC-Sim_Lib_bodies.PNG
   :width: 400pt
   :align: center
   
Frames
^^^^^^^^^^^^^^^^^^^^^^^
The Frames library contains one block that is necessary in every model. 
The ``Global Reference Frame`` block defines the global coordinates, solver configuration, seabed and free surface description, simulation time, and other global settings. 
It can be useful to think of the Global Reference Frame as being the seabed when creating a model. 
Every model requires one instance of the Global Reference Frame block. 
The ``Global Reference Frame`` block uses the simulation class variable `simu` and the wave class variable `waves`, which must be defined in the input file.

.. figure:: _images/WEC-Sim_Lib_frames.PNG
   :width: 400pt
   :align: center

.. note::
    There is a lot of stuff dedicated to one block here. Have you considered
    breaking it up?

Constraints 
^^^^^^^^^^^^^^^^^^^^^^^
.. note::
    This seems to differ somewhat from the description of the constraints
    class, i.e. "WEC-Sim constraint blocks connect WEC bodies to one another 
    (and possibly to the seabed) by constraining DOFs.". So the description
    here misses the fact that it's relative to another body, which is important
    because I guess you are in that other body's frame of reference(?).
    
    Again this definition refers to the implementation, than the physical
    entity, although some of blocks inside the library are clearer.

The blocks within the Constraints library are used to define the DOF of a specific body. 
Constraint blocks define only the DOF, but do not otherwise apply any forcing or resistance to the body motion. 
Each Constraint block has two connections: a base (B) and a follower (F). 
The Constraints block restricts the motion of the block that is connected to the follower relative to the block that is connected to the base. 
For a single body system, the base would be the ``Global Reference Frame`` and the follower is a ``Rigid Body``.

.. note::
    The terms "base" and "follower" need clearer explanation, I think.
    Perhaps there is some confusion in the way this is written as to whether
    base and follower are "ports" of the block ("the motion of the block that 
    is connected to the follower") or the bodies they connect to ("For a single 
    body system, the base would be the ``Global Reference Frame``").

.. figure:: _images/WEC-Sim_Lib_constraints.PNG
   :width: 400pt
   :align: center



A brief description of each constraint block is given below. More information can also be found by double clicking on the library block and viewing the Block Parameters box.

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

.. note::
    I think "along the constraint's ?-axis" doesn't make it clear that
    it's talking about the reference frame of the follower (which I assume it
    is).

.. warning::
    I find the term "Floating" to be a bit strange here. I understand that
    a 6DOF linkage is an odd thing also, but isn't this describing a mooring?
    Is this why this library was called constraints, because it needed to 
    include this abstract concept? I'm kind of more confused about what the
    mooring block does now, also.

PTOs
^^^^^^^^^^^^^^^^^^^^^^^
The PTOs library is used to simulate linear PTO systems and to restrict relative motion between multiple bodies or between one body and the seabed. 
The PTO blocks can simulate simple PTO systems by applying a linear stiffness and damping to the connection. 
Similar to the Constraint blocks, the PTO blocks have a base (B) and a follower (F). 
Users must name each PTO block ``pto(i)`` (where i=1,2,...) and then define their properties in the input file.

The ``Translational PTO`` and ``Rotational PTO`` are identical to the ``Translational`` and ``Rotational`` constraints, but they allow for the application of linear damping and stiffness forces.
Additionally, there are two other variations of the Translational and Rotational PTOs.
The Actuation Force/Torque PTOs allow the user to define the PTO force/torque at each time-step and provide the position, velocity and acceleration of the PTO at each time-step.
The user can use the response information to calculate the PTO force/torque.
The Actuation Motion PTOs allow the user to define the motion of the PTO. 
These can be useful to simulate forced-oscillation tests.

.. note::
    A link to how the user might "define the PTO force/torque at each 
    time-step" would be useful. Also, does this mean a formula or actual values?
    Do you know how many time steps there will be in advance? Is this a clue:
    "The user can use the response information to calculate the PTO 
    force/torque."? How might the user go about that? There is a lot left to
    the imagination in this section.

.. figure:: _images/WEC-Sim_Lib_pto.PNG
   :width: 400 pt
   :align: center
   
   
.. Note::
	When using the Actuation Force/Torque PTO or Actuation Motion PTO blocks, the loads and displacements are specified in the local (not global) coordinate system. This is true for both the sensed (measured) and actuated (commanded) loads and displacements.


Mooring 
^^^^^^^^^^^^^^^^^^^^^^^
The mooring library is used to simulate mooring systems.
The ``MooringMatrix`` block applies linear damping and stiffness based on the motion of the follower relative to the base.
The ``MoorDyn`` block uses the compiled MoorDyn executables and a MoorDyn input file to simulate a realistic mooring system. 
There can only be one MoorDyn block per Simulink model.
There are no restrictions on the number of MooringMatrix blocks.

.. figure:: _images/WEC-Sim_Lib_mooring.PNG
   :width: 400 pt
   :align: center   

.. note::
    I think this should be in the same "category" as the constaint and PTO 
    classes, in that it creates a linkage between bodies. I understand that 
    configuration is a bit tricky, perhaps, but from a physical perspective it 
    would make sense to treat them that way. One approach is to abstract the 
    use of MoorDyn and just call it "automatic" or something like that and then 
    build the moordyn inputs rather than ask the user for them. I think asking 
    the user to learn yet another another program which is used in yet another 
    way is a bit of a weakness. 

Simulink/Simscape Blocks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note::
    This isn't deserving of a section.

In some situations, users may want to use Simulink/Simscape blocks that are not included in the WEC-Sim Library to build their WEC model. 


Output Structure
----------------

.. note::
    I think the minimum this could have done is described the kind of outputs
    that are produced, but all it lets on is that there are some time series
    produced - of what? 
    
    This is probably one of the most important parts of your docs for a new 
    user to actually understand what is produced by the tool, but it's given 
    throw away treatment here. DTOcean suffer's this too, as it has a 
    significant input burden as well, so I understand how this kind of thing 
    comes about. 

After WEC-Sim is done running, there will be a new variable called ``output`` saved to the MATLAB workspace.
The ``output`` object is an instance of the ``responseClass``. 
It contains all the relevant time-series results of the simulation. 
Refer to the WEC-Sim API documentation for the :ref:`response` for information about the structure of the ``output`` object, . 
Time-series are given as [# of time-steps x 6] arrays, where 6 is the degrees of freedom.

WEC-Sim outputs can be written to ASCII files by specifying ``simu.outputtxt = 1;`` in ``wecSimInputFile.m``, in addition to the responseClass ``output`` variable.

.. note::
    And the ASCII files are saved to what location and are formatted how?

Functions & External Codes
--------------------------

.. note::
    The support functions surely deserve their own page? I think this is where
    the documentation as folder structure concept has let you down again -
    useful stuff has been relegated to a nothing section that describes stuff
    that isn't useful to a normal user and ignores describing stuff that is.

While the bulk of the WEC-Sim code consists of the WEC-Sim classes and the WEC-Sim library, the source code also includes supporting functions and external codes.
These include third party Matlab functions to read ``*.h5`` and ``*.stl`` files, WEC-Sim Matlab functions to write ``*.h5`` files and run WEC-Sim in batch mode, MoorDyn compiled executables, python macros for ParaView visualization, and the PTO-Sim class and library.
Additionally, BEMIO can be used to create the hydrodynamic ``*.h5`` file required by WEC-Sim.
MoorDyn is an open source code that must be downloaded separately. Users may obtain, modify, and recompile the code as well as desired.

.. warning::
    "that must be downloaded separately."
    
    Yet, you don't mention how to download it in any information up to now.
    And as I said in the :ref:`theory_mooring` theory section, the way you 
    offer to distribute it is probably not GPL compliant.
    
    I think having to download this manually and place it somewhere (for 
    Windows only) is a serious barrier to entry for a standard user. Did you 
    decide that it was just too hard to package? Why not dynamically select the 
    right libraries per OS to use from MATLAB and package the code yourselves? 
    Or even have separate releases per OS? 
    
    If it were easy to download and install as a standalone executable, I think
    this would be less of an issue, but it doesn't look like that is the case,
    and it seems like it is designed to be used as an embedded library.
