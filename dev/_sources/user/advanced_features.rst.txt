.. _user-advanced-features:

Advanced Features
=================

The advanced features documentation provides an overview of WEC-Sim features 
and applications that were not covered in the WEC-Sim :ref:`user-tutorials`. 
The diagram below highlights some of WEC-Sim's advanced features, details of 
which will be described in the following sections. Most advanced features have 
a corresponding example case within the `WEC-Sim_Applications repository 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ or the ``WEC-Sim/Examples`` 
directory in the WEC-Sim source code. For those topics of interest, it is 
recommended that users run and understand the output of an application while 
reading the documentation on the feature. 

.. codeFeatures:

.. figure:: /_static/images/codeFeatures.png
   :width: 400pt
   :align: center   
    
   ..

.. _user-advanced-features-bemio:

BEMIO
-----

.. include:: /_include/bemio.rst

.. _user-advanced-features-simulation:

Simulation Features
-------------------

This section provides an overview of WEC-Sim's simulation class features; for 
more information about the simulation class code structure, refer to 
:ref:`user-code-structure-simulation-class`. 

Running WEC-Sim
^^^^^^^^^^^^^^^

The subsection describes the various ways to run WEC-Sim. The standard method is 
to type the command ``wecSim`` in the MATLAB command window when in a ``$CASE`` 
directory. This is the same method described in the :ref:`user-workflow` and 
:ref:`user-tutorials` sections.


.. _user-advanced-features-fcn:

Running as Function 
"""""""""""""""""""

WEC-Sim allows users to execute WEC-Sim as a function by using ``wecSimFcn``. 
This option may be useful for users who wish to devise their own batch runs, 
isolate the WEC-Sim workspace, create a special set-up before running WEC-Sim, 
or link to another software.


.. _user-advanced-features-simulink:

Running from Simulink
"""""""""""""""""""""

WEC-Sim can also be run directly from Simulink. 
The Run From Simulink advanced feature allows users to initialize WEC-Sim from the command window and then begin the simulation from Simulink. 
This allows greater compatibility with other models or hardware-in-the-loop simulations that must start in Simulink. 
The WEC-Sim library contains mask options that allow users to either:

   1. Define an standard input file to use in WEC-Sim or 
   2. Define custom parameters inside the block masks.

The Global Reference Frame mask controls whether an input file or custom 
parameters are used for WEC-Sim. Note that when the Custom Parameters options is 
selected, WEC-Sim will only use those variable in the block masks. Certain options 
become visible when the correct flag is set. For example, ``body.morisonElement.cd`` 
will not be visible unless ``body.morisonElement.on > 0``. This method of running 
WEC-Sim may help some users visualize the interplay between the blocks and classes.
For more information on how the blocks and classes are related, see the 
:ref:`user-code-structure` section.

To run WEC-Sim from Simulink, open the Simulink ``.slx`` file and choose whether to 
use an input file or custom parameters in the Global Reference Frame. Next type 
``initializeWecSim`` in the MATLAB Command Window. Then, run the model from the 
Simulink interface. Lastly, after the simulation has completed, type ``stopWecSim`` 
in the MATLAB Command Window to run post-processing.

* Run from Simulink with a wecSimInputFile.m
	* Open the WEC-Sim Simulink file (``.slx``).
	* Set the Global Reference Frame to use an input file
	* Type ``initializeWecSim`` in the Command Window
	* Run the model from Simulink
	* Wait for the simulation to complete, then type ``stopWecSim`` in the Command Window
* Run from Simulink with custom parameters
	* Open the Simulink file (``.slx``).
	* Set the Global  Reference Frame to use custom parameters
	* (Optional) prefill parameters by loading an input file.
	* Edit custom parameters as desired
	* Type ``initializeWecSim`` in the Command Window
	* Run the model from Simulink
	* Wait for the simulation to complete, then type ``stopWecSim`` in the Command Window
	
After running WEC-Sim from Simulink with custom parameters, a 
``wecSimInputFile_simulinkCustomParameters.m`` file is written to the ``$CASE`` 
directory. This file specifies all non-default WEC-Sim parameters used for the 
WEC-Sim simulation. This file serves as a record of how the case was run for 
future reference. It may be used in the same manner as other input files when 
renamed to ``wecSimInputFile.m``


.. _user-advanced-features-mcr:

Multiple Condition Runs (MCR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows users to easily perform batch runs by typing ``wecSimMCR`` into 
the MATLAB Command Window. This command executes the Multiple Condition Run 
(MCR) option, which can be initiated three different ways: 


    **Option 1.** Specify a range of sea states and PTO damping coefficients in 
    the WEC-Sim input file, example: 
    ``waves.height = 1:0.5:5; waves.period = 5:1:15;``
    ``pto(1).stiffness=1000:1000:10000; pto(1).damping=1200000:1200000:3600000;``

    **Option 2.**  Specify the excel filename that contains a set of wave 
    statistic data in the WEC-Sim input file. This option is generally useful 
    for power matrix generation, example:
    ``simu.mcrExcelFile = "<Excel file name>.xls"``

    **Option 3.**  Provide a MCR case *.mat* file, and specify the filename in 
    the WEC-Sim input file, example:
    ``simu.mcrMatFile = "<File name>.mat"``

For Multiple Condition Runs, the ``*.h5`` hydrodynamic data is only loaded 
once. To reload the ``*.h5`` data between runs, set ``simu.reloadH5Data =1`` in 
the WEC-Sim input file. 

If the Simulink model relies upon ``From Workspace`` input blocks other than those utilized by the WEC-Sim library blocks (e.g. ``waves.elevationFile``), these can be iterated through using Option 3. The MCR file header MUST be a cell containing the exact string ``'LoadFile'``. The pathways of the files to be loaded to the workspace must be given in the ``cases`` field of the MCR *.mat* file. WEC-Sim MCR will then run WEC-Sim in sequence, once for each file to be loaded. The variable name of each loaded file should be consistent, and specified by the ``From Workspace`` block.  

For more information, refer to :ref:`webinar1`, and the **RM3_MCR** example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

The **RM3_MCR** examples on the `WEC-Sim Applications 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository demonstrate the 
use of WEC-Sim MCR for each option above (arrays, .xls, .mat). The fourth case 
demonstrates how to vary the wave spectrum input file in each case run by 
WEC-Sim MCR. 

The directory of an MCR case can contain a :code:`userDefinedFunctionsMCR.m` 
file that will function as the standard :code:`userDefinedFunctions.m` file. 
Within the MCR application, the :code:`userDefinedFunctionsMCR.m` script 
creates a power matrix from the PTO damping coefficient after all cases have 
been run. 

For more information, refer to :ref:`webinar1`. 

.. _user-advanced-features-pct:

Parallel Computing Toolbox (PCT)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows users to execute batch runs by typing ``wecSimPCT`` into the 
MATLAB Command Window. This command executes the MATLAB `Parallel Computing 
Toolbox <https://www.mathworks.com/products/parallel-computing.html>`_ (PCT), 
which allows parallel capability for :ref:`user-advanced-features-mcr` but adds 
an additional MATLAB dependency to use this feature. Similar to MCR, this 
feature can be executed in three ways (Options 1~3). 

For PCT runs, the ``*.h5`` hydrodynamic data must be reloaded, regardless the 
setting for ``simu.reloadH5Data`` in the WEC-Sim input file. 

The option ``simu.keepPool=1`` will retain the parallel pool after simulations have finished to facilitate
parallel post-processing. If the pool is no longer needed or needs reinitialization, ``simu.keepPool=0`` will close the parallel pool after simulations have completed.     

.. Note::
    The ``userDefinedFunctionsMCR.m`` is not compatible with ``wecSimPCT``. 
    Please use ``userDefinedFunctions.m`` instead.


Radiation Force calculation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The radiation forces are calculated at each time-step by the convolution of the body velocity and the 
radiation Impulse Response Function -- which is calculated using the cosine transform of the radiation-damping.
Speed-gains to the simulation can be made by using alternatives to the convolution operation, namely, 

1. The State-Space Representation,
2. The Finite Impulse Response (FIR) Filters.

Simulation run-times were benchmarked using the RM3 example simulated for 1000 s. Here is a summary of normalized
run-times when the radiation forces are calculated using different routes. The run-times are normalized by the 
run-time for a simulation where the radiation forces are calculated using "Constant Coefficients" ( :math:`T_0` ):

	+------------------------------------------------+-------------------------------------------+
	|   *Radiation Force Calculation Approach*       | *Normalized Run Time*  	             |
	+------------------------------------------------+-------------------------------------------+
	|   Constant Coefficients                        | :math:`T_0`    	                     |
	+------------------------------------------------+-------------------------------------------+
	|   Convolution                                  | :math:`1.57 \times T_0`                   |
	+------------------------------------------------+-------------------------------------------+
	|   State-Space	                                 | :math:`1.14 \times T_0`                   |   
	+------------------------------------------------+-------------------------------------------+
	|   FIR Filter 	                                 | :math:`1.35 \times T_0`                   |     
	+------------------------------------------------+-------------------------------------------+  

State-Space Representation
""""""""""""""""""""""""""

The convolution integral term in the equation of motion can be linearized using 
the state-space representation as described in the :ref:`theory` section. To 
use a state-space representation, the ``simu.stateSpace`` simulationClass variable 
must be defined in the WEC-Sim input file, for example: 

    :code:`simu.stateSpace = 1` 

.. _user-advanced-features-time-step:


Finite Impulse Response (FIR) Filters
"""""""""""""""""""""""""""""""""""""
By default, WEC-Sim uses numerical integration to calculate the convolution integral, while 
FIR filters implement the same using a `discretized convolution`, by using FIR filters -- digital filters 
that are inherently stable. Convolution of Impulse Response Functions of `Finite` length, i.e., those 
that dissipate and converge to `zero` can be accomplished using FIR filters.
The convolution integral can also be calculated using FIR filters by setting:

 :code:`simu.FIR=1`. 

.. Note::
    By default :code:`simu.FIR=0`, unless specified otherwise.

Time-Step Features
^^^^^^^^^^^^^^^^^^

The default WEC-Sim solver is 'ode4'. Refer to the **NonlinearHydro** example 
on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository for a comparisons between 'ode4' to 
`'ode45' <https://www.mathworks.com/help/matlab/ref/ode45.html>`_. The following 
variables may be changed in the simulationClass (where N is number of increment 
steps, default: N=1): 

* Fixed time-step: :code:`simu.dt` 
* Output time-step: :code:`simu.dtOut=N*simu.dt` 
* Nonlinear Buoyancy and Froude-Krylov Excitation time-step: :code:`simu.nonlinearDt=N*simu.dt` 
* Convolution integral time-step: :code:`simu.cicDt=N*simu.dt`   
* Morison force time-step: :code:`simu.morisonDt = N*simu.dt` 

Fixed Time-Step (ode4)
""""""""""""""""""""""

When running WEC-Sim with a fixed time-step, 100-200 time-steps per wave period 
is recommended to provide accurate hydrodynamic force calculations (ex: simu.dt 
= T/100, where T is wave period). However, a smaller time-step may be required 
(such as when coupling WEC-Sim with MoorDyn or PTO-Sim). To reduce the required 
WEC-Sim simulation time, a different time-step may be specified for nonlinear 
buoyancy and Froude-Krylov excitation and for convolution integral 
calculations. For all simulations, the time-step should be chosen based on 
numerical stability and a convergence study should be performed. 

Variable Time-Step (ode45)
""""""""""""""""""""""""""

To run WEC-Sim with a variable time-step, the following variables must be 
defined in the simulationClass: 

* Numerical solver: :code:`simu.solver='ode45'` 
* Max time-step: :code:`simu.dt` 

This option sets the maximum time step of the simulation (:code:`simu.dt`) and 
automatically adjusts the instantaneous time step to that required by MATLAB's 
differential equation solver. 

.. _user-advanced-features-wave:

Wave Features
--------------

This section provides an overview of WEC-Sim's wave class features. For more 
information about the wave class code structure, refer to 
:ref:`user-code-structure-wave-class`. The various wave features can be 
compared by running the cases within ``the WEC-Sim/Examples/RM3`` and ``the 
WEC-Sim/Examples/OSWEC`` directories. 

.. _user-advanced-features-irregular-wave-binning:

Irregular Wave Binning
^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim's default spectral binning method divides the wave spectrum into 499 
bins with equal energy content, defined by 500 wave frequencies. As a result, 
the wave forces on the WEC using the equal energy method are only computed at 
each of the 500 wave frequencies. The equal energy formulation speeds up the 
irregular wave simulation time by reducing the number of frequencies the wave 
train is defined by, and thus the number of frequencies for which the wave 
forces are calculated. It prevents bins with very little energy from being 
created and unnecessarily adding to the computational cost. The equal energy 
method is specified by defining the following wave class variable in the 
WEC-Sim input file: 

    :code:`waves.bem.option = 'EqualEnergy';`

By comparison, the traditional method divides the wave spectrum into a 
sufficiently large number of equally spaced bins to define the wave spectrum. 
WEC-Sim's traditional formulation uses 999 bins, defined by 1000 wave 
frequencies of equal frequency distribution. To override WEC-Sim's default 
equal energy method, and instead use the traditional binning method, the 
following wave class variable must be defined in the WEC-Sim input file: 

    :code:`waves.bem.option = 'Traditional';`

Users may override the default number of wave frequencies by defining 
``waves.bem.count``. However, it is on the user to ensure that the wave spectrum 
is adequately defined by the number of wave frequencies, and that the wave 
forces are not impacted by this change. 

Wave Directionality
^^^^^^^^^^^^^^^^^^^

WEC-Sim has the ability to model waves with various angles of incidence, 
:math:`\theta`. To define wave directionality in WEC-Sim, the following wave 
class variable must be defined in the WEC-Sim input file: 

    :code:`waves.direction = <user defined wave direction(s)>; %[deg]`    

The incident wave direction has a default heading of 0 Degrees (Default = 0), 
and should be defined as a column vector for more than one wave direction. For 
more information about the wave formulation, refer to 
:ref:`theory-wave-spectra`. 

Wave Directional Spreading
^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim has the ability to model waves with directional spreading, 
:math:`D\left( \theta \right)`. To define wave directional spreading in 
WEC-Sim, the following wave class variable must be defined in the WEC-Sim input 
file: 

    :code:`waves.spread = <user defined directional spreading>;`

The wave directional spreading has a default value of 1 (Default = 1), and 
should be defined as a column vector of directional spreading for each one wave 
direction. For more information about the spectral formulation, refer to 
:ref:`theory-wave-spectra`. 

.. Note::

    Users must define appropriate spreading parameters to ensure energy is 
    conserved. Recommended directional spreading functions include 
    Cosine-Squared and Cosine-2s.

.. _user-advanced-features-seeded-phase:

Multiple Wave-Spectra
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Wave Directional Spreading feature only allows splitting the same wave-front. 
However, quite often mixed-seas are composed of disparate Wave-Spectra with unique
periods, heights, and directions. An example would be a sea-state composed of 
swell-waves and chop-waves.  

Assuming that the linear potential flow theory holds, the wave inputs to the system can be
super-imposed. This implies, the effects of multiple Wave-Spectra can be simulated, if the 
excitation-forces for each Wave-Spectra is calculated, and added to the pertinent 
Degree-of-Freedom.

WEC-Sim can simulate the dynamics of a body experiencing multiple Wave-Spectra each with 
their unique directions, periods, and heights. In order to calculate the excitation-forces 
for multiple Wave-Spectra, WEC-Sim automatically generates multiple instances of 
excitation-force sub-systems. The user only needs to create multiple instances of 
the ``waves`` class.


Here is an example for setting up multiple Wave-Spectra in the WEC-Sim input file::

            waves(1)           = waveClass('regularCIC');   % Initialize Wave Class and Specify Type                                 
            waves(1).height    = 2.5;                       % Wave Height [m]
            waves(1).period    = 8;                         % Wave Period [s]
            waves(1).direction = 0;                         % Wave Direction (deg.)
            waves(2)           = waveClass('regularCIC');   % Initialize Wave Class and Specify Type                                 
            waves(2).height    = 2.5;                       % Wave Height [m]
            waves(2).period    = 8;                         % Wave Period [s]
            waves(2).direction = 90;                        % Wave Direction (deg.)



.. Note::

    1. If using a wave-spectra with different wave-heading directions, ensure that the BEM data has
    the hydrodynamic coefficients corresponding to the desired wave-heading direction,

    2. All wave-spectra should be of the same type, i.e., if :code:`waves(1)` is initialized 
    as :code:`waves(1) = waveClass('regularCIC')`, the following :code:`waves(#)` object should 
    initialized the same way.
    
Addtionally, the multiple Wave-Spectra can be visualized as elaborated in :ref:`user-advanced-features-wave-markers`.
The user needs to define the marker parameters for each Wave-Spectra, as one would for a single Wave-Spectra.

Here is an example of 2 Wave-Spectra being visualized using the wave wave-markers feature:

.. figure:: /_static/images/Nwave.png 
   :width: 600pt 
   :align: center

Here is a visualization of two Wave-Spectra, represented by red markers and blue markers respectively.

Irregular Waves with Seeded Phase
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the phase for all irregular wave cases are generated randomly. In 
order to reproduce the same time-series every time an irregular wave simulation 
is run, the following wave class variable may be defined in the WEC-Sim input 
file: 

    :code:`waves.phaseSeed = <user defined seed>;`

By setting ``waves.phaseSeed`` equal to 1,2,3,...,etc, the random wave phase 
generated by WEC-Sim is seeded, thus producing the same random phase for each 
simulation. 

Wave Gauge Placement
^^^^^^^^^^^^^^^^^^^^
Wave gauges can be included through the wave class parameters::

    waves.marker.location
    waves.marker.size
    waves.marker.style

By default, the wave surface elevation at the origin is calculated by WEC-Sim. 
In past releases, there was the option to define up to three numerical wave gauge 
locations where WEC-Sim would also calculate the undisturbed linear incident wave 
elevation. WEC-Sim now has the feature to define wave markers that oscillate 
vertically with the undistrubed linear wave elevation (see :ref:`user-advanced-features-wave-markers`).
This feature does not limit the number of point measurements of the undisturbed 
free surface elevation and the time history calculation at the marker location 
is identical to the previous wave gauge implementation. Users who desire to 
continuing using the previous wave gauge feature will only need to update the 
variable called within WEC-Sim and an example can be found in the 
`WECCCOMP Repository <https://github.com/WEC-Sim/WECCCOMP>`_. 

.. Note::
    The numerical wave markers (wave gauges) do not handle the incident wave interaction with the radiated or diffracted 
    waves that are generated because of the presence and motion of any hydrodynamic bodies.


.. _user-advanced-features-current:

Ocean Current
^^^^^^^^^^^^^
The speed of an ocean current can be included through the wave class parameters::

    waves.current.option
    waves.current.speed
    waves.current.direction
    waves.current.depth

The current option determines the method used to propagate the surface current across the 
specified depth. Option 0 is depth independent, option 1 uses a 1/7 power law, option 2
uses linear variation with depth and option 3 specifies no ocean current.
The ``current.speed`` parameter represents the surface current speed, and ``current.depth`` 
the depth at which the current speed decays to zero (given as a positive number).
See :ref:`theory-current` for more details on each method.
These parameters are used to calculate the fluid velocity in the Morison Element calculation.

.. _user-advanced-features-body:

Body Features
-------------

This section provides an overview of WEC-Sim's body class features; for more 
information about the body class code structure, refer to 
:ref:`user-code-structure-body-class`. 

Body Mass and Geometry Features
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The mass of each body must be specified in the WEC-Sim input file. The 
following features are available: 

* **Floating Body** - the user may set :code:`body(i).mass = 'equilibrium'` 
  which will calculate the body mass based on displaced volume and water 
  density. If :code:`simu.nonlinearHydro = 0`, then the mass is calculated using the 
  displaced volume contained in the ``*.h5`` file. If :code:`simu.nonlinearHydro = 1` 
  or :code:`simu.nonlinearHydro = 2`, then the mass is calculated using the displaced 
  volume of the provided STL geometry file.
  
* **Fixed Body** - if a body is fixed to the seabed using a fixed constraint, the mass 
  and moment of inertia may be set to arbitrary values such as 999 kg and [999 999 999] 
  kg-m^2. If the constraint forces on the fixed body are important, the mass and inertia 
  should be set to their real values.

* **Import STL** - to read in the geometry (``*.stl``) into Matlab use the 
  :code:`body(i).importBodyGeometry()` method in the bodyClass. This method will import the 
  mesh details (vertices, faces, normals, areas, centroids) into the 
  :code:`body(i).geometry` property. This method is also used for nonlinear 
  buoyancy and Froude-Krylov excitation and ParaView visualization files. Users 
  can then visualize the geometry using the :code:`body(i).plotStl` method.

.. _user-advanced-features-nonlinear:

Nonlinear Buoyancy and Froude-Krylov Excitation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim has the option to include the nonlinear hydrostatic restoring and 
Froude-Krylov forces when solving the system dynamics of WECs, accounting for 
the weakly nonlinear effect on the body hydrodynamics. To use nonlinear 
buoyancy and Froude-Krylov excitation, the **body(ii).nonlinearHydro** bodyClass 
variable must be defined in the WEC-Sim input file, for example: 

    :code:`body(ii).nonlinearHydro = 2`  

For more information, refer to the :ref:`webinar2`, and the **NonlinearHydro** 
example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository. 

Nonlinear Settings
""""""""""""""""""

**body(ii).nonlinearHydro**  - 
The nonlinear hydrodynamics option can be used with the parameter: 
:code:`body(ii).nonlinearHydro` in your WEC-Sim input file. When any of the three 
nonlinear options (below) are used, WEC-Sim integrates the wave pressure over 
the surface of the body, resulting in more accurate buoyancy and Froude-Krylov 
force calculations. 

    **Option 1.** :code:`body(ii).nonlinearHydro = 1` This option integrates the pressure 
    due to the mean wave elevation and the instantaneous body position.

    **Option 2.** :code:`body(ii).nonlinearHydro = 2` This option integrates the pressure 
    due to the instantaneous wave elevation and the instantaneous body position. 
    This option is recommended if nonlinear effects need to be considered.

**simu.nonlinearDt** - 
An option available to reduce the nonlinear simulation time is to specify a 
nonlinear time step, :code:`simu.nonlinearDt=N*simu.dt`, where N is number of 
increment steps. The nonlinear time step specifies the interval at which the 
nonlinear hydrodynamic forces are calculated. As the ratio of the nonlinear to 
system time step increases, the computation time is reduced, again, at the 
expense of the simulation accuracy. 

.. Note::
    WEC-Sim's nonlinear buoyancy and Froude-Krylov wave excitation option may 
    be used for regular or irregular waves but not with user-defined irregular 
    waves.

STL File Generation
"""""""""""""""""""

When the nonlinear option is turned on, the geometry file (``*.stl``) 
(previously only used for visualization purposes in linear simulations) is used 
as the discretized body surface on which the nonlinear pressure forces are 
integrated. As in the linear case, the STL mesh origin must be at a body's center of gravity.

A good STL mesh resolution is required when using the nonlinear buoyancy and Froude-Krylov wave excitation in 
WEC-Sim. The simulation accuracy will increase with increased surface 
resolution (i.e. the number of discretized surface panels specified in the 
``*.stl`` file), but the computation time will also increase. 
There are many ways to generate an STL file; however, it is important to verify 
the quality of the mesh before running WEC-Sim simulations with the nonlinear 
hydro flag turned on. An STL file can be exported from most CAD programs, but 
few allow adequate mesh refinement. By default, most CAD programs write an STL
file similar to the left figure, with the minimum panels possible. 
To accurately model nonlinear hydrodynamics in WEC-Sim, STL files should be refined to 
have an aspect ratio close to one, and contain a high resolution in the vertical direction 
so that an accurate instantaneous displaced volume can be calculated.

.. figure:: /_static/images/rectangles.png 
   :width: 300pt 
   :align: center

Many commercial and free software exist to convert between mesh formats and 
refine STL files, including:

* `Free CAD <https://www.freecadweb.org/>`_
* `BEM Rosetta <https://github.com/BEMRosetta/BEMRosetta>`_
* `Meshmagick <https://lheea.github.io/meshmagick/index.html>`_
* `Coreform CUBIT <https://coreform.com/products/coreform-cubit/>`_ (commercial)
* `Rhino <https://www.rhino3d.com/>`_ (commercial)


.. _user-advanced-features-nonlinear-tutorial-heaving-ellipsoid:

Nonlinear Buoyancy and Froude-Krylov Wave Excitation Tutorial - Heaving Ellipsoid
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The body tested in the study is an ellipsoid with a cross- section 
characterized by semi-major and -minor axes of 5.0 m and 2.5 m in the wave 
propagation and normal directions, respectively . The ellipsoid is at its 
equilibrium position with its origin located at the mean water surface. The 
mass of the body is then set to 1.342×105 kg, and the center of gravity is 
located 2 m below the origin. 

.. _user-advanced-features-nonlinearEllipsoid:

.. figure:: /_static/images/nonlinearEllipsoid.png
    :width: 350pt
    :align: center

STL file with the discretized body surface is shown below (``ellipsoid.stl``)

.. _user-advanced-features-nonlinearMesh:

.. figure:: /_static/images/nonlinearMesh.png
    :width: 250pt
    :align: center
    
The single-body heave only WEC model is shown below (``nonLinearHydro.slx``)

.. _user-advanced-features-nonlinearWEC:

.. figure:: /_static/images/nonlinearWEC.png
    :width: 450pt
    :align: center

The WEC-Sim input file used to run the nonlinear hydro WEC-Sim simulation:

.. _user-advanced-features-nonLinearwecSimInputFile:

.. rli:: https://raw.githubusercontent.com/WEC-Sim/WEC-Sim_Applications/main/Nonlinear_Hydro/ode4/Regular/wecSimInputFile.m
   :language: matlab

Simulation and post-processing is the same process as described in the 
:ref:`user-tutorials` section. 

Viscous Damping and Morison Elements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows for the definition of additional damping and added-mass terms 
to allow users to tune their models precisely. Viscous damping and Morison Element
may be defined for hydrodynamic, drag, or flexible bodies. It is highly recommended
that users add viscous or Morison drag to create a realistic model.

When the Morison Element
option is used in combination with a hydrodynamic or flexible body, it serves as a 
tuning method. The equation of motion for hydrodynamic and flexible bodies with a 
Morison Element is more complex than the traditional Morison Element formulation.
A traditional Morison Element may be created by using a drag body 
(``body(#).nonHydro=2``) with ``body(#).morisonElement.option = 1 or 2``.
For more information about the numerical formulation of viscous damping and 
Morison Elements, refer to the theory section :ref:`theory-viscous-damping-morison`. 

Viscous Damping
"""""""""""""""

A viscous damping force in the form of a linear damping coefficient 
:math:`C_{v}` can be applied to each body by defining the following body class 
parameter in the WEC-Sim input file (which has a default value of zero):: 

    body(i).linearDamping

A quadratic drag force, proportional to the square of the body's velocity, can 
be applied to each body by defining the quadratic drag coefficient 
:math:`C_{d}`, and the characteristic area :math:`A_{d}` for drag calculation. 
This is achieved by defining the following body class parameters in the WEC-Sim 
input file (each of which have a default value of zero):: 

    body(i).quadDrag.cd
    body(i).quadDrag.area

Alternatively, one can define :math:`C_{D}` directly::

    body(i).quadDrag.drag

.. _user-advanced-features-morison:

Morison Elements 
""""""""""""""""

To use Morison Elements, the following body class variable must be 
defined in the WEC-Sim input file with :code:`body(ii).morisonElement.option`.

Implementation Option 0 Morison Elements are not included in the body force and moment calculations. 

Implementation Option 1 allows for the Morison Element properties to be defined 
independently for the x-, y-, and z-axis while Implementation Option 2 uses a 
normal and tangential representation of the Morison Element properties. Note 
that the two options allow the user flexibility to implement hydrodynamic 
forcing that best suits their modeling needs; however, the two options have 
slightly different calculation methods and therefore the outputs will not 
necessarily provide the same forcing values. The user is directed to look at 
the Simulink Morison Element block within the WEC-Sim library to better 
determine which approach better suits their modeling requirements. 

Morison Elements must be defined for each body using the 
:code:`body(i).morisonElement` property of the body class. This property 
requires definition of the following body class parameters in the WEC-Sim input 
file (each of which have a default value of zero(s)). 

For :code:`body(ii).morisonElement.option  = 1` ::
    
    body(i).morisonElement.cd = [c_{dx} c_{dy} c_{dz}]
    body(i).morisonElement.ca = [c_{ax} c_{ay} c_{az}]
    body(i).morisonElement.area = [A_{x} A_{y} A_{z}]
    body(i).morisonElement.VME = [V_{me}]
    body(i).morisonElement.rgME = [r_{gx} r_{gy} r_{gz}]
    body(i).morisonElement.z = [0 0 0]
    
.. Note::

    For Option 1, the unit normal :code:`body(#).morisonElement.z` must be 
    initialized as a [:code:`n` x3] vector, where :code:`n` is the number of Morison Elements, although it will not be used in the 
    hydrodynamic calculation. 
    
For :code:`body(ii).morisonElement.option  = 2` ::
    
    body(i).morisonElement.cd = [c_{dn} c_{dt} 0]
    body(i).morisonElement.ca = [c_{an} c_{at} 0]
    body(i).morisonElement.area = [A_{n} A_{t} 0]
    body(i).morisonElement.VME = [V_{me}]
    body(i).morisonElement.rgME = [r_{gx} r_{gy} r_{gz}]
    body(i).morisonElement.z = [z_{x} z_{y} z_{z}]
    
.. Note::

    For Option 2, the :code:`body(i).morisonElement.cd`, 
    :code:`body(i).morisonElement.ca`, and 
    :code:`body(i).morisonElement.area` variables need to be 
    initialized as [:code:`n` x3] vector, where :code:`n` is the number of Morison Elements, with the third column index set to zero. While 
    :code:`body(i).morisonElement.z` is a unit normal vector that defines the 
    orientation of the Morison Element. 

To better represent certain scenarios, an ocean current speed can be defined to 
calculate a more accurate fluid velocity and acceleration on the Morison 
Element. These can be defined through the wave class parameters 
``waves.current.option``, ``waves.current.speed``, ``waves.current.direction``, 
and ``waves.current.depth``. See :ref:`user-advanced-features-current` for more 
detail on using these options.

The Morison Element time-step may also be defined as
:code:`simu.morisonDt = N*simu.dt`, where N is number of increment steps. For an 
example application of using Morison Elements in WEC-Sim, refer to the `WEC-Sim 
Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository 
**Free_Decay/1m-ME** example.  

.. Note::

    Morison Elements cannot be used with :code:`elevationImport`.

.. _user-advanced-features-non-hydro-body:

Non-Hydrodynamic Bodies
^^^^^^^^^^^^^^^^^^^^^^^

For some simulations, it might be important to model bodies that do not have 
hydrodynamic forces acting on them. This could be bodies that are completely 
outside of the water but are still connected through a joint to the WEC bodies, 
or it could be bodies deeply submerged to the point where the hydrodynamics may 
be neglected. WEC-Sim allows for bodies which have no hydrodynamic forces 
acting on them and for which no BEM data is provided. 

To do this, use a Body Block from the WEC-Sim Library and initialize it in the 
WEC-Sim input file as any other body but leave the name of the ``h5`` file as 
an empty string. Specify :code:`body(i).nonHydro = 1;` and specify body name, 
mass, moments of inertia, center of gravity, center of buoyancy, geometry file, 
location, and displaced volume. You can also specify visualization options and 
initial displacement. 

To use non-hydrodynamic bodies, the following body class variable must be 
defined in the WEC-Sim input file, for example:: 

    body(i).nonHydro = 1

Non-hydrodynamic bodies require the following properties to be defined::

    body(i).mass
    body(i).inertia
    body(i).centerGravity
    body(i).volume
    
In the case where only non-hydrodynamic and drag bodies are used, WEC-Sim does
not read an ``*.h5`` file. Users must define these additional parameters to 
account for certain wave settings as there is no hydrodynamic body present in
the simulation to define them::

    waves.bem.range
    waves.waterDepth


For more information, refer to :ref:`webinar2`, and the **Nonhydro_Body** 
example on the `WEC-Sim Applications 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

Drag Bodies
^^^^^^^^^^^

A body may be subjected to viscous drag or Morison forces, but does not 
experience significant wave excitation or radiation. And example may be a 
deeply-submerged heave plate of large surface area tethered to a float. In 
these instances, the drag body implementation can be utilized by defining the 
following body class variable:: 

    body(i).nonHydro = 2


Drag bodies have zero wave excitation or radiation forces, but viscous forces 
can be applied in the same manner as a hydrodynamic body via the parameters:: 

    body(i).quadDrag.drag
    body(i).quadDrag.cd
    body(i).quadDrag.area
    body(i).linearDamping

or if using Morison Elements::  

    body(i).morisonElement.cd
    body(i).morisonElement.ca
    body(i).morisonElement.area
    body(i).morisonElement.VME
    body(i).morisonElement.rgME
    
which are described in more detail in the forthcoming section. At a minimum, it 
is necessary to define:: 

    body(i).mass
    body(i).inertia
    body(i).centerGravity
    body(i).volume
    
to resolve drag body dynamics. One can additionally describe initial body 
displacement in the manner of a hydrodynamic body. 

.. _user-advanced-features-b2b:

Body-To-Body Interactions
^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows for body-to-body interactions in the radiation force 
calculation, thus allowing the motion of one body to impart a force on all 
other bodies. The radiation matrices for each body (radiation wave damping and 
added mass) required by WEC-Sim and contained in the ``*.h5`` file. **For 
body-to-body interactions with N total hydrodynamic bodies, the** ``*h5`` 
**data structure is [(6\*N), 6]**. 

When body-to-body interactions are used, the augmented [(6\*N), 6] matrices are 
multiplied by concatenated velocity and acceleration vectors of all 
hydrodynamic bodies. For example, the radiation damping force for body(2) in a 
3-body system with body-to-body interactions would be calculated as the product 
of a [1,18] velocity vector and a [18,6] radiation damping coefficients matrix. 

To use body-to-body interactions, the following simulation class variable must 
be defined in the WEC-Sim input file:: 

    simu.b2b = 1

For more information, refer to :ref:`webinar2`, and the **RM3_B2B** example in 
the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository. 

.. Note::

    By default, body-to-body interactions  are off (:code:`simu.b2b = 0`), and 
    only the :math:`[1+6(i-1):6i, 1+6(i-1):6i]` sub-matrices are used for each 
    body (where :math:`i` is the body number).

.. _user-advanced-features-generalized-body-modes:

Generalized Body Modes
^^^^^^^^^^^^^^^^^^^^^^

To use this, select a Flex Body Block from the WEC-Sim Library (under Body 
Elements) and initialize it in the WEC-Sim input file as any other body. 
Calculating dynamic response of WECs considering structural flexibility using 
WEC-Sim should consist of multiple steps, including: 

* Modal analysis of the studied WEC to identify a set of system natural 
  frequencies and corresponding mode shapes
* Construct discretized mass and impedance matrices using these structural 
  modes
* Include these additional flexible degrees of freedom in the BEM code to 
  calculate hydrodynamic coefficients for the WEC device
* Import the hydrodynamic coefficients to WEC-Sim and conduct dynamic analysis 
  of the hybrid rigid and flexible body system

The `WEC-Sim Applications repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
contains a working sample of a barge with four additional degrees of freedom to 
account for bending and shearing of the body. See this example for details on 
how to implement and use generalized body modes in WEC-Sim. 

.. Note::

    Generalized body modes module has only been tested with WAMIT, where BEMIO 
    may need to be modified for NEMOH, Aqwa and Capytaine.

.. _user-advanced-features-passive-yaw:

Passive Yaw Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^

For non-axisymmetric bodies with yaw orientation that changes substantially 
with time, WEC-Sim allows a correction to excitation forces for large yaw 
displacements. To enable this correction, add the following to your 
``wecSimInputFile``:: 

    body(ii).yaw.option = 1

Under the default implementation (:code:`body(ii).yaw.option = 0`), WEC-Sim uses the 
initial yaw orientation of the device relative to the incident waves to 
calculate the wave excitation coefficients that will be used for the duration 
of the simulation. When the correction is enabled, excitation coefficients are 
interpolated from BEM data based upon the instantaneous relative yaw position. 
For this to enhance simulation accuracy, BEM data must be available over the 
range of observed yaw positions at a sufficiently dense discretization to 
capture the significant variations of excitation coefficients with yaw 
position. For robust simulation, BEM data should be available from -180 to 170 
degrees of yaw (or equivalent). 

This can increase simulation time, especially for irregular waves, due to the 
large number of interpolations that must occur. To prevent interpolation at 
every time-step, ``body(ii).yaw.threshold`` (default 1 degree) can be specified in the 
``wecSimInputFile`` to specify the minimum yaw displacement (in degrees) that 
must occur before another interpolation of excitation coefficients will be 
calculated. The minimum threshold for good simulation accuracy will be device 
specific: if it is too large, no interpolation will occur and the simulation 
will behave as :code:`body(ii).yaw.option = 0`, but overly small values may not 
significantly enhance simulation accuracy while increasing simulation time. 

When :code:`body(ii).yaw.option = 1`, hydrostatic and radiation forces are 
determined from the local body-fixed coordinate system based upon the 
instantaneous relative yaw position of the body, as this may differ 
substantially from the global coordinate system for large relative yaw values. 

A demonstration case of this feature is included in the **PassiveYaw** example 
on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository. 

.. Note::

    Caution must be exercised when simultaneously using passive yaw and 
    body-to-body interactions. Passive yaw relies on interpolated BEM solutions 
    to determine the cross-coupling coefficients used in body-to-body 
    calculations. Because these BEM solutions are based upon the assumption of 
    small displacements, they are unlikely to be accurate if a large relative 
    yaw displacement occurs between the bodies. 

.. _user-advanced-features-large-XY-disp:

Large X-Y Displacements
^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the excitation force applied to the modeled body is calculated at the body's CG position as defined in BEM. 
If large lateral displacements (i.e., in the x or y direction by the default WEC-Sim coordinate system) are expected for the modeled device, it may be desirable to adjust the excitation force to account for this displacment. 

When :code:`body(i).largeXYDisplacement.option = 1`, the phase of the excitation force exerted on the body is adjusted based upon its displacement as

:math:`\phi_{displacement} = k \omega x(1)*cos(\frac{\theta \pi}{180}) + x(2).*sin(\frac{\theta \pi}{180})`

where k is waves.wavenumber, x(1,2) is displacement in the (x,y) direction, :math:`\omega` is waves.omega, and :math:`\theta` is waves.direction (in degrees). 
This phase is thus the same size as waves.phase, and is then summed with waves.phase to determine excitation force.

Note that this adjustment only affects the incident exciting waves, not the total wave field that is the superposition of exciting and radiating waves. 
This implies that this adjustment is only valid for cases where the lateral velocity of the body is significantly less than the celerity of its radiated waves, and is thus not appropriate for sudden, rapid displacements. 

.. Note::

	This feature has not been implemented for a user-defined wave elevation.

Variable Hydrodynamics
^^^^^^^^^^^^^^^^^^^^^^

.. include:: /_include/variable_hydro.rst

Body Initialization
^^^^^^^^^^^^^^^^^^^
The bodyClass is typically defined by inputting one or more paths to H5 files in the body constructor. 
Alternatively, users may input a ``hydroData`` structure directly to the body constructor to bypass the 
pre-processing steps that require writing the H5 file with BEMIO and then reloading it in the bodyClass.
This workflow may save users time in computationally expensive scenarios.

This alternate workflow is used by defining a body as: :code:`body(i) = bodyClass(hydroData)`. 
Users should take care to ensure that the ``hydroData`` structure passed is identical in form to that 
which ``initializeWecSim`` obtains by calling:

:code:`hydroData = readBEMIOH5('pathToH5File', body.number, body.meanDrift);`

The function :code:`rebuildHydroStruct()` may be used to convert the BEMIO :code:`hydro` structure
into the bodyClass :code:`hydroData` format.


.. _user-advanced-features-pto:

Constraint and PTO Features
----------------------------

.. include:: /_include/pto.rst



.. _user-advanced-features-control:

Controller Features
-------------------

The power generation performance of a WEC is highly dependent on the control 
algorithm used in the system. There are different control strategies that 
have been studied for marine energy applications. These control algorithms 
can be applied directly to the PTO components to achieve a desired output, or 
they can be high-level controllers which are focused on the total PTO force 
applied to the WEC. The examples presented in this section are based on high-
level controller applications. WEC-Sim’s controller features support the modeling 
of both simple passive and reactive controllers as well as more complex methods 
such as model predictive control.

The files for the controller tutorials described in this section can be found in 
the **Controls** examples on the `WEC-Sim Applications repository 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ . The controller examples 
are not comprehensive, but provide a reference for user to implement their 
own controls.

	+--------------------------------+-------------------------------------------+
	|   **Controller Application**   |               **Description**             |                
	+--------------------------------+-------------------------------------------+
	|   Passive (P)  	         | Sphere with proportional control    	     |
	+--------------------------------+-------------------------------------------+
	|   Reactive (PI)                | Sphere with proportional-integral control |
	+--------------------------------+-------------------------------------------+
	|   Latching		         | Sphere with latching control		     |
	+--------------------------------+-------------------------------------------+
	|   Declutching   		 | Sphere with declutching control           |
	+--------------------------------+-------------------------------------------+
	|   Model Predictive Control   	 | Sphere with model predictive control      |
	+--------------------------------+-------------------------------------------+
	|   Reactive with PTO   	 | Sphere with reactive control and DD PTO   |
	+--------------------------------+-------------------------------------------+


Examples: Sphere Float with Various Controllers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First, it is important to understand the concept of complex conjugate control.
Complex conjugate control, as applied to wave energy conversion, 
can be used to understand optimal control. For a complex conjugate controller, 
the impedance of the controller is designed to match the admittance of the 
device (equal to the complex conjugate of device impedance). Hence, it is 
also known as impedance matching and is a common practice within electrical 
engineering. Complex conjugate control is not a completely realizable control 
method due to its acausality, which means it requires exact knowledge of 
future wave conditions. Still, a causal transfer function can be used to approximate 
complex conjugate control across a limited frequency range :cite:`bacelli2020comments`. 
Thus, complex conjugate control presents a reference for the implementation of 
optimal causal controls. The WEC impedance can be modeled by the following equation
:cite:`bacelli2019feedback` and can be used to formulate the optimal control implementation:

.. math::

    Z_i(\omega) = j\omega (m + A(\omega)) + B(\omega) + \frac{K_{hs}}{j\omega}

By characterizing the impedance of the WEC, a greater understanding of the 
dynamics can be reached. The figure below is a bode plot of the impedance of 
the RM3 float body. The natural frequency is defined by the point at which the 
phase of impedance is zero. By also plotting the frequency of the incoming 
wave, it is simple to see the difference between the natural frequency of 
the device and the wave frequency. Complex conjugate control (and some other
control methods) seeks to adjust the natural frequency of the device to match 
the wave frequency. Matching the natural frequency to the wave frequency leads 
to resonance, which allows for theoretically optimal mechanical power. 

.. figure:: /_static/images/impedance.png
   :width: 300pt 
   :align: center

It is important to note here that although impedance matching can lead to maximum mechanical 
power, it does not always lead to maximum electrical power. Resonance due to 
impedance matching often creates high peaks of torque and power, which are usually 
far from the most efficient operating points of PTO systems used to extract power
and require those systems to be more robust and expensive.
Thus, the added factor of PTO dynamics and efficiency may lead to 
complex conjugate control being suboptimal. Furthermore, any constraints or other 
nonlinear dynamics may make complex conjugate control unachievable or suboptimal. 
Theoretical optimal control using complex conjugates presented here should be 
taken as a way to understand WEC controls rather than a method to achieve 
optimal electrical power for a realistic system.

.. _control-passive:

Passive Control (Proportional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Passive control is the simplest of WEC controllers and acts as a damping force. 
Hence, the damping value (also referred to as a proportional gain) is 
multiplied by the WEC velocity to determine the power take-off force:

.. math::

    F_{PTO} = K_p \dot{X}

Although unable to reach optimal power for a regular wave due to its passive 
nature, a passive controller can still be tuned to reach its maximum power.
According to complex conjugate control, a passive controller can be 
optimized for regular wave conditions using the following formula :cite:`gomes2015dynamics`:

.. math::

    K_{p,opt} = \sqrt{B(\omega)^2 + (\frac{K_{hs}}{\omega} - \omega (m + A(\omega)))^2}

The optimal proportional gain has been calculated for the float using the optimalGainCalc.m file 
and implemented in WEC-Sim to achieve optimal power. The mcrBuildGains.m file sets 
up a sweep of the proportional gains which can be used to show that the results 
confirm the theoretical optimal gain in the figure below (negative power corresponding to 
power extracted from the system). This MCR run can be 
recreated by running the mcrBuildGains.m file then typing wecSimMCR in the command
window.

.. figure:: /_static/images/pGainSweep.png
   :width: 300pt 
   :align: center

This example only shows the optimal proportional gain in regular wave conditions. 
For irregular wave spectrums and nonlinear responses (such as with constraints), 
an optimization algorithm can be used to determine optimal control gains.

.. _control-reactive:

Reactive Control (Proportional-Integral)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Reactive control is also a very simple form of WEC control and combines the 
damping force of a passive controller with a spring stiffness force. The standard PTO 
block can also be used to implement PI control using the damping and stiffness
values but doesn't allow for negative inputs which is often necessary for 
optimal stiffness. This controller is also known as a proportional integral 
controller with the proportional gain corresponding to the damping value and 
the integral gain corresponding to a spring stiffness value:

.. math::

    F_{PTO} = K_p \dot{X} + K_i X

The addition of the reactive component means the controller can achieve optimal 
complex conjugate control by cancelling out the imaginary portion of the device 
impedance. Thus, the proportional and integral control gains can be defined by the 
following formulas :cite:`coe2021practical`:

.. math::

    K_{p,opt} = B(\omega)

.. math::

    K_{i,opt} = (m + A(\omega)) \omega^2 - K_hs

The optimal proportional and integral gains have been calculated using the optimalGainCalc.m file 
and implemented in WEC-Sim to achieve optimal power. The mcrBuildGains.m file again sets 
up a sweep of the gains which can be used to show that the results 
confirm the theoretical optimal gains in the figure below. This MCR run can be 
recreated by running the mcrBuildGains.m file then typing wecSimMCR in the command
window.

.. figure:: /_static/images/piGainSweep.png
   :width: 300pt 
   :align: center

This example only shows the optimal gains in regular wave conditions. 
For irregular wave spectrums and nonlinear responses (such as with constraints), 
an optimization algorithm can be used to determine optimal control gains.

.. _control-latching:

Latching Control
^^^^^^^^^^^^^^^^

Latching control combines a traditional passive controller with a latching mechanism which applies 
a large braking force during a portion of the oscillation. By locking the device for 
part of the oscillation, latching control attempts to adjust the phase of the motion to 
match the phase of incoming waves. Latching control can slow the device motion to match 
wave motion and is therefore most often used when the wave period is longer than the natural 
period. Latching control is still considered passive as no energy input is required (assuming velocity 
is zero while latched).

The braking/latching force is implemented as a very large damping force (:math:`G`), which can be 
adjusted based on the device's properties :cite:`babarit2006optimal`:

.. math::

    G = 80 (m + A(\omega))

Because latching achieves phase matching between the waves and device, the optimal 
damping can be assumed the same as for reactive control. Lastly, the main control 
variable, latching time, needs to be determined. For regular waves, it is 
desired for the device to move for a time equal to its natural frequency, meaning 
the optimal latching time is likely close to half the difference between the wave 
period and the natural period :cite:`babarit2006optimal` (accounting for 2 latching periods per wave period).

.. math::

    t_{latch} = \frac{1}{2} (T_{wave} - T_{nat})

The optimal latching time has been calculated using the optimalGainCalc.m file 
and implemented in WEC-Sim. The mcrBuildTimes.m file sets 
up a sweep of the latching times, the results for which are shown in the figure below. 
This MCR run can be recreated by running the mcrBuildGains.m file then typing wecSimMCR 
in the command window. Based on the results, the optimal latching time is slightly 
lower than expected which may be due to imperfect latching or complex dynamics which 
aren't taken into account in the theoretical optimal calculation. Regardless, latching results in 
much larger power when compared to traditional passive control.

.. figure:: /_static/images/latchTimeSweep.png
   :width: 300pt 
   :align: center

Further, the figure below shows the excitation force and velocity, which are close to 
in phase when a latching time of 2.4 seconds is implemented.

.. figure:: /_static/images/latching.png
   :width: 300pt 
   :align: center

Although not shown with this example, latching can also be implemented in irregular waves 
but often requires different methods including excitation prediction.

.. _control-declutching:

Declutching Control
^^^^^^^^^^^^^^^^^^^

Declutching control is essentially the opposite of latching. Instead of locking the device, 
it is allowed to move freely (no PTO force) for a portion of the oscillation. Often, 
declutching is used when the wave period is smaller than the natural period, allowing the 
device motion to "catch up" to the wave motion. Declutching is also considered 
a passive control method.

The optimal declutching time and damping values are slightly harder to estimate than for 
latching. The device's motion still depends on its impedance during the declutching period, 
meaning the device does not really move "freely" during this time. Hence, in opposition to 
optimal latching the declutching time was assumed to be near half the difference between 
the natural period and the wave period, but is further examined through tests.

.. math::

    t_{declutch} = \frac{1}{2} (T_{wave} - T_{nat})

This optimal declutching time has been calculated using the optimalGainCalc.m file 
and implemented in WEC-Sim. Because energy is not harvested during the declutching 
period, it is likely that a larger damping is required. Thus, the optimal passive 
damping value was used for the following simulations, although a more 
optimal damping value likely exists for delclutching.

Since declutching is most desired when the wave period is smaller than the natural period, 
a wave period of 3.5 seconds was tested with a height of 1 m. For comparison to traditional 
passive control, the optimal passive damping value was tested for these conditions, leading
to a power of 5.75 kW. The mcrBuildTimes.m file sets up a sweep of the declutching times, 
the results for which are shown in the figure below. It is clear that delcuthing control 
can offer an improvement over traditional passive control.

.. figure:: /_static/images/declutchTimeSweep.png
   :width: 300pt
   :align: center 

Further, the figure below shows the excitation force and velocity with a declutch time
of 0.8 seconds. The excitation and response are not quite in phase, but the device 
can be seen "catching up" to the wave motion during the declutching time. 

.. figure:: /_static/images/declutching.png
   :width: 300pt 
   :align: center

Although not shown with this example, declutching can also be implemented in irregular waves 
but often requires different methods including excitation prediction.

.. _control-MPC:

Model Predictive Control (MPC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Model predictive control is a WEC control method which uses a plant model to predict and 
optimize the dynamics. MPC is a complex controller that can be applied in both regular 
and irregular waves while also taking into account time-domain constraints such as position, 
velocity, and PTO force. For the model predictive controller implemented here, 
the plant model is a frequency dependent state-space model :cite:`so2017development`. 
The state space model is then converted to a quadratic programming problem to be 
solved by quadprog(), MATLAB's quadratic programming function. Solving this system 
leads to a set of PTO forces to optimize the future dynamics for maximum harvested 
power, the first of which is applied at the current timestep. The relevant files for 
the MPC example in the Controls folder of WEC-Sim Applications are detailed in the 
table below (excluding wecSimInputFile.m and userDefinedFunctions.m which are not 
unique to MPC). Note: This controller is similar to the NMPC example within the 
WECCCOMP Application, but this example includes a method for calculating frequency 
dependence and setting up the state space matrices based on boundary element method 
data, allows for position, velocity, and force constraints, and is applied to a 
single body heaving system. 

	+--------------------------------+------------------------------------------------------+
	|   	     *File*	         |                    *Description*              	|                
	+--------------------------------+------------------------------------------------------+
	|   coeff.mat	  	         | Coefficients for frequency dependence     		|
	+--------------------------------+------------------------------------------------------+
	|   fexcPrediction.m             | Predicts future excitation forces         		|
	+--------------------------------+------------------------------------------------------+
	|   sphereMPC.slx                | Simulink model including model predictive controller |
	+--------------------------------+------------------------------------------------------+
	|   mpcFcn.m		         | Creates and solves quadratic programming problem     |
	+--------------------------------+------------------------------------------------------+
	|   plotFreqDep.m   		 | Solves for and plots frequency dependence coeffs     |
	+--------------------------------+------------------------------------------------------+

The Simulink diagram is shown in the figure below. The figure shows an overview of 
the controller, which primarily consists of the plant model and the optimizer. The plant 
model uses the excitation force, applied PTO force, and current states to calculate the 
states at the next timestep. Then, the optimizer predicts the future excitation, which 
is input into the mpcFcn.m file along with the states to solve for the optimal change in 
PTO force (integrated to solve for instantaneous PTO force). 

.. figure:: /_static/images/mpcSimulink.png
   :width: 500pt 
   :align: center

The results of the model predictive controller simulation in irregular waves are shown 
below with the dashed lines indicating the applied 
constraints. MPC successfully restricts the system to within the constraints (except for 
a few, isolated timesteps where the solver couldn't converge) while also optimizing for maximum 
average mechanical power (300 kW). The constraints can be changed to account for 
specific WEC and PTO physical limitations, but will limit the average power. 
There are also other parameters which can be defined or changed by the user in the 
wecSimInputFile.m such as the MPC timestep, prediction horizon, r-scale, etc. to 
customize and tune the controller as desired.

.. figure:: /_static/images/mpcPos.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/mpcVel.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/mpcForce.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/mpcForceChange.png
   :width: 300pt 
   :align: center

The model predictive controller is particularly beneficial because of its ability to
predict future waves and maximize power accordingly as well as the ability to handle constraints. A 
comparison to a reactive controller is shown in the table below. The reactive controller 
can be tuned to stay within constraint bounds only when future wave conditions are known 
and, in doing so, would sacrifice significant power. On the other hand, without knowledge 
of future wave, the results from the untuned reactive controller are shown below using 
optimal theoretical gains from the complex conjugate method at the peak wave period. 
With no ability to recognize constraints, the reactive controller leads to much larger 
amplitude and velocity and exhibits large peaks in PTO force and power, both of which 
would likely lead to very expensive components and inefficient operation. 
It is clear that the model predictive controller significantly outperforms the reactive 
controller in terms of mechanical power harvested, constraint inclusions, and peak conditions. 
Because of the increased complexity of model predictive control, limitations include longer 
computation time and complex setup. 

	+----------------------------+--------------+-------------+------------+
	|         *Parameter*        | *Constraint* |    *MPC*    | *Reactive* |
	+----------------------------+--------------+-------------+------------+
	| Max Heave Position (m)     |      4       |    4.02     |    8.06    |
	+----------------------------+--------------+-------------+------------+
	| Max Heave Velocity (m/s)   |      3       |    2.95     |    5.63    |
	+----------------------------+--------------+-------------+------------+
	| Max PTO Force (kN)         |     2,000    |    2,180    |    4,630   |
	+----------------------------+--------------+-------------+------------+
	| Max PTO Force Change (kN/s)|     1,500    |    1,500    |    3,230   |
	+----------------------------+--------------+-------------+------------+
	| Peak Mechanical Power (kW) |      N/A     |    4,870    |   13,700   |
	+----------------------------+--------------+-------------+------------+
	| Avg Mechanical Power (kW)  |      N/A     |    300      |    241     |
	+----------------------------+--------------+-------------+------------+

.. _control-reactive-with-PTO:

Reactive Control with Direct Drive Power Take-Off
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The previous controllers only considered the mechanical power output. Although maximization
of mechanical power allows for the maximum energy transfer from waves to body, it often does 
not lead to maximum electrical power. The previous controller examples demonstrate the 
controller types and energy transfer from waves to body, but the important consideration of 
electrical power requires a PTO model. This example applies a reactive controller to the 
sphere body with a simplified direct drive PTO model to maximize electrical power. Within 
the Simulink subsystem for determining the PTO force, the controller prescribes the ideal or 
desired force which is fed into the direct drive PTO. The current in the generator is then 
used to control the applied force. 

.. figure:: /_static/images/piPTOSimulink.png
   :width: 500pt 
   :align: center

The PTO parameters used for this example are defined in the ``wecSimInputFile.m`` and correspond to 
the Allied Motion Megaflux Frameless Brushless Torque Motors–MF0310 :cite:`allied`. The 
results in terms of capture width (ratio of absorbed power (W) to wave power (W/m)) and resultant power for the 
applied gains from Section :ref:`control-reactive` are shown in the figures 
below for a regular wave with a period of 9.6664 s and a height of 2.5 m. The "Controller (Ideal)" 
power is the ideal power absorbed according to the applied controller gains. 
The "Mechanical (Drivetrain)" power is the actual mechanical power absorbed by 
the PTO system including the inertial, damping, and shaft torque power. Lastly, the 
"Electrical (Generator)" power is the electrical power absorbed by the 
generator including the product of induced current and voltage (based on shaft torque and velocity, 
respectively) and the resultant generator losses (product of current squared and winding resistance).
Mechanical power maximization requires significant net input electrical power 
(signified by red bar) which leads to an extremely negative capture width. Thus, 
instead of harvesting electrical power, power would need to be taken from the grid or energy 
storage component to achieve mechanical power maximization. 

.. figure:: /_static/images/reactiveWithPTOCCPower.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/reactiveWithPTOCC.png
   :width: 300pt 
   :align: center

On the other hand, by testing different controller gains in the same wave conditions 
(regular wave: period = 9.6664 s, height = 2.5 m), the gains which optimize for 
maximum electrical power can be found as shown below. Increasing the proportional gain 
and decreasing the integral gain magnitude leads to a maximum power of about 84 kW and capture width of about 
1.5 m. The resultant motion is almost ten times smaller than for the mechanical power 
maximization which leads to a lower current and much lower generator power losses 
(product of current squared and winding resistance).

.. figure:: /_static/images/reactiveWithPTOSweep.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/reactiveWithPTOOptPower.png
   :width: 300pt 
   :align: center

.. figure:: /_static/images/reactiveWithPTOOpt.png
   :width: 300pt 
   :align: center


.. _user-advanced-features-cable:

Cable Features
----------------------------

Cables or tethers between two bodies apply a force only in tension (when taut or stretched), but not in compression,
can be modeled using the :code:`cableClass` implementation. A cable block must be added to the
model between the two PTOs or constraints that are to be connected by a cable. Users must initialize the cable
class in the ``wecSimInputFile.m`` along with the base and follower connections in that order, by including the following lines:: 

	cable(i) = cableClass('cableName','baseConnection','followerConnection');

where ``baseConnection`` is a PTO or constraint block that defines the cable connection on the base side, and ``followerConnection``
is a PTO or constraint block that defineds the connection on the follower side.  


It is necessary to define, at a minimum: ::

    cable(i).stiffness = <cableStiffness>;
    cable(i).damping = <cableDamping>;

where :code:`cable(i).stiffness` is the cable stiffness (N/m), and :code:`cable(i).damping` is the cable damping (N/(m*s)). Force from the cable stiffness or 
damping is applied between the connection points if the current length of the cable exceeds the equilibrium length of the cable. 
By default, the cable equilibrium length is defined to be the distance between the locations of the ``baseConnection`` and ``followerConnection``, so that initially there is no tension on the cable. 

If a distinct initial condition is desired, one can define either ``cable(i).length`` or ``cable(i).preTension``, where :code:`cable(i).length` is the equilibrium (i.e., unstretched) length of the cable (m), and :code:`cable(i).preTension` is the pre-tension applied to the cable at simulation start (N). The unspecified parameter is then calculated from the location of the ``baseConnection`` and 
``followerConnection``. 

To include dynamics applied at the cable-to-body coupling (e.g., a stiffness and damping), a PTO block 
can be used instead, and the parameters :code:`pto(i).damping` and :code:`pto(i).stiffness` can be used to describe these dynamics. 

By default, the cable is presumed neutrally buoyant and it is not subjected to fluid drag. To include fluid drag, the user can additionally define these parameters in a style similar to the :code:`bodyClass` ::

	cable(i).quadDrag.cd
	cable(i).quadDrag.area
	cable(i).quadDrag.drag
	cable(i).linearDamping
	
The cable mass and fluid drag is modeled with a low-order lumped-capacitance method with 2 nodes. 
The mass and fluid drag forces are exerted at nodes defined by the 2 drag bodies. 
By default, one is co-located with the ``baseConnection`` and the other with the ``followerConnection``. 
The position of these bodies can be manipulated by changing the locations of the base or follower connections points.

.. Note::

	This is not appropriate to resolve the actual kinematics of cable motions, but it is sufficient to model the aggregate forces among the connected bodies. 

.. _user-advanced-features-mooring:

Mooring Features
----------------

.. include:: /_include/mooring.rst


WEC-Sim Post-Processing
------------------------

WEC-Sim contains several built in methods inside the response class and wave 
class to assist users in processing WEC-Sim output: ``output.plotForces``, 
``output.plotResponse``, ``output.saveViz``, ``waves.plotElevation``, and
``waves.plotSpectrum``. This section will demonstrate the use of these methods. 
They are fully documented in the WEC-Sim :ref:`user-api`.

Plot Forces
^^^^^^^^^^^

The ``responseClass.plotForces()`` method can be used to plot the time series of 
each force component for a body. The first argument takes in a body number, the 
second a degree of freedom of the force. For example, ``output.plotForces(2,3)``
will plot the vertical forces that act on the 2nd body. The total force is split
into its :ref:`components <theory-time-domain>`: 

- total force
- excitation force
- radiation damping force
- added mass force
- restoring force (combination of buoyancy, gravity and hydrostatic stiffness), 
- Morison element and viscous drag force
- linear damping force

.. figure:: /_static/images/OSWEC_heaveForces.PNG
   :width: 250pt
   :figwidth: 250pt
   :align: center
   
   Demonstration of output.plotForces() method for the OSWEC example.


Plot Response
^^^^^^^^^^^^^

The ``responseClass.plotResponse()`` method is very similar to ``plotForces`` 
except that it will plot the time series of a body's motion in a given degree 
of freedom. For example, ``output.plotResponse(1,5)`` will plot the pitch motion
of the 1st body. The position, velocity and acceleration of that body is shown.

.. figure:: /_static/images/OSWEC_pitchResponse.PNG
   :width: 250pt
   :figwidth: 250pt
   :align: center
   
   Demonstration of output.plotResponse() method for the OSWEC example.



Plot Elevation
^^^^^^^^^^^^^^^

The ``waveClass.plotElevation()`` method can be used to plot the wave elevation time
series at the domain origin. The ramp time is also marked. The only required input
is ``simu.rampTime``. Users must manually plot or overlay the wave elevation at a 
wave gauge location.

.. figure:: /_static/images/OSWEC_plotEta.PNG
   :width: 250pt
   :figwidth: 250pt
   :align: center
   
   Demonstration of waves.plotElevation() method for the OSWEC example.


Plot Spectrum
^^^^^^^^^^^^^

The ``waveClass.plotSpectrum()`` method can be used to plot the frequency spectrum
of an irregular or spectrum import wave. No input parameters are required.

.. figure:: /_static/images/OSWEC_plotSpectrum.PNG
   :width: 250pt
   :figwidth: 250pt
   :align: center
   
   Demonstration of waves.plotSpectrum() method for the OSWEC example.


WEC-Sim Visualization
---------------------
WEC-Sim provides visualization in SimScape Mechanics Explorer by default. This section describes some additional options for WEC-Sim visualization


.. _user-advanced-features-wave-markers:

Wave Markers 
^^^^^^^^^^^^^^^^^^^

This section describes how to visualize the wave elevations at various locations using 
markers in SimScape Mechanics Explorer. 
Users must define an array of [X,Y] coordinates, the marker style (sphere, cube, frames), the marker size in pixels, marker color in RGB format.
The ``Global Reference Frame`` block programmatically initiates and adds/deletes the visualization blocks based on the number of markers *(0 to N)* defined by the user.
Here are the steps to define wave markers representing a wave-spectra, ``waves(1)``. Similar steps can be followed for subsequent ``waves(#)`` objects.


* Define an array of marker locations: ``waves(1).marker.location = [X,Y]``, where the first column defines the X coordinates, and the second column defines the corresponding Y coordinates, Default = ``[]``
* Define marker style : ``waves(1).marker.style = 1``, where 1: Sphere, 2: Cube, 3: Frame, Default = ``1``: Sphere
* Define marker size : ``waves(1).marker.size = 10``, to specify marker size in Pixels, Default = ``10``
* Define marker color: ``waves(1).marker.graphicColor = [1,0,0]``, to specifie marker color in RBG format.

.. Here is an example. In this example a mesh of points is described using the meshgrid command and then  making it an array of X and Y coordinates using reshape(). 

For more information about using ParaView for visualization, refer to the **Wave_Markers** examples on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository.


.. Note:: 

    This feature is not compatible with user-defined waves ``waves = waveClass('elevationImport')``
    
.. figure:: /_static/images/RM3_vizMarker.jpg
   :width: 250pt
   :figwidth: 250pt
   :align: center

   Demonstration of visualization markers in SimScape Mechanics Explorer.
   

Save Visualization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``responseClass.saveViz()`` method can be used to create a complete 
animation of the simulation. The animation shows the 3D response of all bodies
over time on top of a surface plot of the entire directional wave field. The 
default wave domain is defined by ``simu.domainSize``, ``waves.waterDepth``, and
the maximum height that the STL mesh of any body reaches. Users may optionally 
input the axis limits to restrict or widen the field of view, the time steps per 
animation frame, and the output file format. Users can choose to save the animation
as either a ``.gif`` or ``.avi`` file. This function can take significant time to 
run depending on simulation time and time step, however it may be faster and easier 
than Paraview. Users are still recommended to use the provided Paraview macros for 
more complex animations and analysis.

For example, in the OSWEC case the command 
``output.saveViz(simu,body,waves,'timesPerFrame',5,'axisLimits',[-50 50 -50 50 -12 20])``
results in the following figure:

.. figure:: /_static/images/OSWEC_plotWaves.PNG
   :width: 250pt
   :figwidth: 250pt
   :align: center
   
   Demonstration of output.saveViz() method for the OSWEC example.   


.. _user-advanced-features-paraview:
   
Paraview Visualization
----------------------

.. include:: /_include/viz.rst


.. _user-advanced-features-WSviz:



.. _user-advanced-features-decay:

Decay Tests
-----------

When performing simulations of decay tests, you must use one of the no-wave 
cases and setup the initial (time = 0) location of each body, constraint, PTO, 
and mooring block. The initial location of a body or mooring block is set by 
specifying the centerGravity or location at the stability position (as with any WEC-Sim 
simulation) and then specifying an initial displacement. To specify an initial 
displacement, the body and mooring blocks have a :code:`.initial` property 
with which you can specify a translation and angular rotation about an 
arbitrary axis. For the constraint and PTO blocks, the :code:`.location` property 
must be set to the location at time = 0. 

There are methods available to help setup this initial displacement for all 
bodies, constraints, PTOs, and moorings. To do this, you would use the: 

* :code:`body(i).setInitDisp()`
* :code:`constraint(i).setInitDisp()`
* :code:`pto(i).setInitDisp()`
* :code:`mooring(i).setInitDisp()` 

methods in the WEC-Sim input file. A description of the required input can be 
found in the method's header comments. The following properties must be 
defined prior to using the object's :code:`setInitDisp()` method: 

* :code:`body(i).centerGravity`
* :code:`constraint(i).location`
* :code:`pto(i).location`
* :code:`mooring.location` 

For more information, refer to the **Free Decay** example on the `WEC-Sim 
Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

Other Features
------------------

The WEC-Sim Applications repository also includes examples of using WEC-Sim to 
model a Desalination plant and a numerical model of the WaveStar device for 
control implementation. The WaveStar device was used in the WECCCOMP wave 
energy control competition. 

References
------------------------
.. bibliography:: ../refs/WEC-Sim_Adv_Features.bib
   :style: unsrt
   :labelprefix: C
