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

.. _user-advanced-features-mcr:

Multiple Condition Runs (MCR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows users to easily perform batch runs by typing ``wecSimMCR`` into 
the MATLAB Command Window. This command executes the Multiple Condition Run 
(MCR) option, which can be initiated three different ways: 


    **Option 1.** Specify a range of sea states and PTO damping coefficients in 
    the WEC-Sim input file, example: 
    ``waves.H = 1:0.5:5; waves.T = 5:1:15;``
    ``pto(1).k=1000:1000:10000; pto(1).c=1200000:1200000:3600000;``

    **Option 2.**  Specify the excel filename that contains a set of wave 
    statistic data in the WEC-Sim input file. This option is generally useful 
    for power matrix generation, example:
    ``waves.statisticsDataLoad = "<Excel file name>.xls"``

    **Option 3.**  Provide a MCR case *.mat* file, and specify the filename in 
    the WEC-Sim input file, example:
    ``simu.mcrCaseFile = "<File name>.mat"``

For Multiple Condition Runs, the ``*.h5`` hydrodynamic data is only loaded 
once. To reload the ``*.h5`` data between runs, set ``simu.reloadH5Data =1`` in 
the WEC-Sim input file. 

If the Simulink model relies upon ``From Workspace`` input blocks other than those utilized by the WEC-Sim library blocks (e.g. ``Wave.etaDataFile``), these can be iterated through using Option 3. The MCR file header MUST be a cell containing the exact string ``'LoadFile'``. The pathways of the files to be loaded to the workspace must be given in the ``cases`` field of the MCR *.mat* file. WEC-Sim MCR will then run WEC-Sim in sequence, once for each file to be loaded. The variable name of each loaded file shoud be consistent, and specified by the ``From Workspace`` block.  

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

For PCT runs, the ``*.h5`` hydrodynamic data must be reload, regardless the 
setting for ``simu.reloadH5Data`` in the WEC-Sim input file. 


.. Note::
    The ``userDefinedFunctionsMCR.m`` is not compatible with ``wecSimPCT``. 
    Please use ``userDefinedFunctions.m`` instead.


.. _user-advanced-features-fcn:

Running as Function 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows users to execute WEC-Sim as a funection by using ``wecSimFcn``.



.. _user-advanced-features-simulink:

Running from Simulink
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beginning in version 4.3, WEC-Sim can also be run from Simulink. 
The WEC-Sim library now allows for an input file or custom parameters to be used inside the block masks.
This mode is useful when using WEC-Sim in conjunction with hardware-in-the-loop or other Simulink models with their own initialization.
To run WEC-Sim from Simulink, open the Simulink ``.slx`` file and choose whether to use an input file or custom parameters in the Global Reference Frame.
Next type ``wecSimInitialize`` in the MATLAB Command Window. 
Lastly, run the model from the Simulink interface.

* Run from Simulink with a wecSimInputFile.m
	* Set the Global Reference Frame to use an input file
	* Choose the correct input file
	* Type ``wecSimInitialize`` in the Command Window
	* Run the model from Simulink
* Run from Simulink with custom parameters
	* Set the Global  Reference Frame to use custom parameters
	* (Optional) prefill parameters by loading an input file.
	* Edit custom parameters as desired
	* Type ``wecSimInitialize`` in the Command Window
	* Run the model from Simulink
	
Upon completion of a WEC-Sim simulation run from Simulink a ``wecSimInputFile_simulinkCustomParameters.m`` file is written to the ``$CASE`` directory including the WEC-Sim parameters used for the WEC-Sim simulation.

Refer to :ref:`user-tutorials-examples` for more details on how to run the examples 


State-Space Representation
^^^^^^^^^^^^^^^^^^^^^^^^^^

The convolution integral term in the equation of motion can be linearized using 
the state-space representation as described in the :ref:`theory` section. To 
use a state-space representation, the ``simu.ssCalc`` simulationClass variable 
must be defined in the WEC-Sim input file, for example: 

    :code:`simu.ssCalc = 1` 


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
* Nonlinear Buoyancy and Froude-Krylov Excitation time-step: :code:`simu.dtNL=N*simu.dt` 
* Convolution integral time-step: :code:`simu.dtCITime=N*simu.dt`   
* Morison force time-step: :code:`simu.dtME = N*simu.dt` 

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

    :code:`waves.freqDisc = 'EqualEnergy';`

By comparison, the traditional method divides the wave spectrum into a 
sufficiently large number of equally spaced bins to define the wave spectrum. 
WEC-Sim's traditional formulation uses 999 bins, defined by 1000 wave 
frequencies of equal frequency distribution. To override WEC-Sim's default 
equal energy method, and instead use the traditional binning method, the 
following wave class variable must be defined in the WEC-Sim input file: 

    :code:`waves.freqDisc = 'Traditional';`

Users may override the default number of wave frequencies by defining 
``waves.numFreq``. However, it is on the user to ensure that the wave spectrum 
is adequately defined by the number of wave frequencies, and that the wave 
forces are not impacted by this change. 

Wave Directionality
^^^^^^^^^^^^^^^^^^^

WEC-Sim has the ability to model waves with various angles of incidence, 
:math:`\theta`. To define wave directionality in WEC-Sim, the following wave 
class variable must be defined in the WEC-Sim input file: 

    :code:`waves.waveDir = <user defined wave direction(s)>; %[deg]`    

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

    :code:`waves.waveSpread = <user defined directional spreading>;`

The wave directional spreading has a default value of 1 (Default = 1), and 
should be defined as a column vector of directional spreading for each one wave 
direction. For more information about the spectral formulation, refer to 
:ref:`theory-wave-spectra`. 

.. Note::

    Users must define appropriate spreading parameters to ensure energy is 
    conserved. Recommended directional spreading functions include 
    Cosine-Squared and Cosine-2s.

.. _user-advanced-features-seeded-phase:

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

By default, the wave surface elevation is calculated at the origin. Users are 
allowed up to 3 other x-locations to calculate the wave surface elevation 
offset from the origin in the global x-direction by defining the wave class 
variable, ``waves.wavegauge<i>loc``, in the WEC-Sim input file: 

    :code:`waves.wavegauge<i>loc = <user defined wave gauge i x-location>; %(y-position assumed to be 0 m)`

where i = 1, 2, or 3

The WEC-Sim numerical wave gauges output the undisturbed linear incident wave 
elevation at the wave gauge locations defined above. The numerical wave gauges 
do not handle the incident wave interaction with the radiated or diffracted 
waves that are generated because of the presence and motion of the WEC 
hydrodynamic bodies. This option provides the following wave elevation time 
series: 

    :code:`waves.waveAmpTime<i> = incident wave elevation time series at wave gauge i`

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
  density. If :code:`simu.nlhydro = 0`, then the mass is calculated using the 
  displaced volume contained in the ``*.h5`` file. If :code:`simu.nlhydro = 1` 
  or :code:`simu.nlhydro = 2`, then the mass is calculated using the displaced 
  volume of the provided STL geometry file.

* **Fixed Body** - if the mass is unknown (or not important to the dynamics), 
  the user may specify :code:`body(i).mass = 'fixed'` which will set the mass 
  to 999 kg and moment of inertia to [999 999 999] kg-m^2.

* **Import STL** - to read in the geometry (``*.stl``) into Matlab use the 
  :code:`body(i).bodyGeo` method in the bodyClass. This method will import the 
  mesh details (vertices, faces, normals, areas, centroids) into the 
  :code:`body(i).bodyGeometry` property. This method is also used for nonlinear 
  buoyancy and Froude-Krylov excitation and ParaView visualization files. Users 
  can then visualize the geometry using the :code:`body(i).plotStl` method.

.. _user-advanced-features-nonlinear:

Nonlinear Buoyancy and Froude-Krylov Excitation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim has the option to include the nonlinear hydrostatic restoring and 
Froude-Krylov forces when solving the system dynamics of WECs, accounting for 
the weakly nonlinear effect on the body hydrodynamics. To use nonlinear 
buoyancy and Froude-Krylov excitation, the **simu.nlHydro** simulationClass 
variable must be defined in the WEC-Sim input file, for example: 

    :code:`simu.nlHydro = 2`  

For more information, refer to the :ref:`webinar2`, and the **NonlinearHydro** 
example on the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository. 

Nonlinear Settings
""""""""""""""""""

**simu.nlHydro**  - 
The nonlinear hydrodynamics option can be used with the parameter: 
:code:`simu.nlHydro` in your WEC-Sim input file. When any of the three 
nonlinear options (below) are used, WEC-Sim integrates the wave pressure over 
the surface of the body, resulting in more accurate buoyancy and Froude-Krylov 
force calculations. 

    **Option 1.** :code:`simu.nlHydro = 1` This option integrates the pressure 
    due to the mean wave elevation and the instantaneous body position.

    **Option 2.** :code:`simu.nlHydro = 2` This option integrates the pressure 
    due to the instantaneous wave elevation and the instantaneous body position. 
    This option is recommended if nonlinear effects need to be considered.

    **Option 3.** :code:`simu.nlHydro = 3` This option calculates the nonlinear 
    Froude-Krylov force directly from a BEM result. This requires additional 
    output files from the BEM code (.3fk and .3sc files for WAMIT, and 
    DiffractionForce.tec and FKForce.tec files for NEMOH).

**simu.dtNL** - 
An option available to reduce the nonlinear simulation time is to specify a 
nonlinear time step, :code:`simu.dtNL=N*simu.dt`, where N is number of 
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
integrated. A good STL mesh resolution is required for the WEC body geometry 
file(s) when using the nonlinear buoyancy and Froude-Krylov wave excitation in 
WEC-Sim. The simulation accuracy will increase with increased surface 
resolution (i.e. the number of discretized surface panels specified in the 
``*.stl`` file), but the computation time will also increase. 

There are many ways to generate an STL file; however, it is important to verify 
the quality of the mesh before running WEC-Sim simulations with the nonlinear 
hydro flag turned on. An STL file can be exported from most CAD programs, but 
few allow adequate mesh refinement. A good program to perform STL mesh 
refinement is `Rhino <https://www.rhino3d.com/>`_. Some helpful resources 
explaining how to generate and refine an STL mesh in Rhino can be found `on 
Rhino's website <https://wiki.mcneel.com/rhino/meshfaqdetails>`_ and `on 
Youtube <https://www.youtube.com/watch?v=CrlXAMPfHWI>`_. 

.. Note::
    
    All STL files must be saved as ASCII (not binary)
 
**Refining STL File** -
The script ``refine_stl`` in the BEMIO directory performs a simple mesh 
refinement on an ``*.stl`` file by subdividing each panel with an area above 
the specified threshold into four smaller panels with new vertices at the 
mid-points of the original panel edges. This procedure is iterated for each 
panel until all panels have an area below the specified threshold, as in the 
example rectangle. 

.. figure:: /_static/images/rectangles.png 
   :width: 300pt 
   :align: center

In this way, the each new panel retains the aspect ratio of the original panel. 
Note that the linear discretization of curved edges is not refined via this 
algorithm. The header comments of the function explain the inputs and outputs. 
This function calls ``import_stl_fast``, included with the WEC-Sim 
distribution, to import the ``.*stl`` file. 

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

.. rli:: https://raw.githubusercontent.com/WEC-Sim/WEC-Sim_Applications/master/Nonlinear_Hydro/ode4/Regular/wecSimInputFile.m
   :language: matlab

Simulation and post-processing is the same process as described in the 
:ref:`user-tutorials` section. 

Viscous Damping and Morison Elements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim allows for the definition of additional damping and added-mass terms; 
for more information about the numerical formulation of viscous damping and 
Morison Elements, refer to :ref:`theory-viscous-damping-morison`. 

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

    body(i).viscDrag.cd
    body(i).viscDrag.characteristicArea

Alternatively, one can define :math:`C_{D}` directly::

    body(i).viscDrag.Drag

.. _user-advanced-features-morison:

Morison Elements 
""""""""""""""""

To use Morison Elements, the following simulation class variable must be 
defined in the WEC-Sim input file with :code:`simu.morisonElement = 1` or 
:code:`simu.morisonElement = 2` 

Implementation Option 1 allows for the Morison Element properties to be defined 
independently for the x-, y-, and z-axis while implementation option 2 uses a 
normal and tangential representation of the Morison Element properties. Note 
that the two options allow the user flexibility to implement hydrodynamic 
forcing that best suits their modeling needs; however, the two options have 
slightly different calculation methods and therefore the outputs will not 
necessarily provide the same forcing values. The user is directed to look at 
the Simulink Morison Element block within the WEC-Sim library to better 
determine which approach better suits their modeling requirements. 

Morison Elements must be defined for each body using the 
:code:`body(#).morisonElement` property of the body class. This property 
requires definition of the following body class parameters in the WEC-Sim input 
file (each of which have a default value of zero(s)). 

For :code:`simu.morisonElement  = 1` ::
    
    body(i).morisonElement.cd = [c_{dx} c_{dy} c_{dz}]
    body(i).morisonElement.ca = [c_{ax} c_{ay} c_{az}]
    body(i).morisonElement.characteristicArea = [A_{x} A_{y} A_{z}]
    body(i).morisonElement.VME = [V_{me}]
    body(i).morisonElement.rgME = [r_{gx} r_{gy} r_{gz}]
    body(i).morisonElement.z = [0 0 0]
    
.. Note::

    For Option 1, the unit normal :code:`body(#).morisonElement.z` must be 
    initialized as a [1x3] vector although it will not be used in the 
    hydrodynamic calculation. 
    
For :code:`simu.morisonElement  = 2` ::
    
    body(i).morisonElement.cd = [c_{dn} c_{dt} 0]
    body(i).morisonElement.ca = [c_{an} c_{at} 0]
    body(i).morisonElement.characteristicArea = [A_{n} A_{t} 0]
    body(i).morisonElement.VME = [V_{me}]
    body(i).morisonElement.rgME = [r_{gx} r_{gy} r_{gz}]
    body(i).morisonElement.z = [z_{x} z_{y} z_{z}]
    
.. Note::

    For Option 2, the :code:`body(#).morisonElement.cd`, 
    :code:`body(#).morisonElement.ca`, and 
    :code:`body(#).morisonElement.characteristicArea` variables need to be 
    initialized as [1x3] vectors with the last index set to zero. While 
    :code:`body(#).morisonElement.z` is a unit normal vector that defines the 
    orientation of the Morison Element. 

The Morison Element time-step may also be defined as
:code:`simu.dtME = N*simu.dt`, where N is number of increment steps. For an 
example application of using Morison Elements in WEC-Sim, refer to the `WEC-Sim 
Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository 
**Free_Decay/1m-ME** example. 

.. Note::

    Morison Elements cannot be used with :code:`etaImport`.

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
an empty string. Specify :code:`body(i).nhBody = 1;` and specify body name, 
mass, moments of inertia, center of gravity, center of buoyancy, geometry file, 
location, and displaced volume. You can also specify visualization options and 
initial displacement. 

To use non-hydrodynamic bodies, the following body class variable must be 
defined in the WEC-Sim input file, for example: 

    body(i).nhBody = 1

For more information, refer to :ref:`webinar2`, and the **OSWEC_nhBody** 
example on the `WEC-Sim Applications 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

Drag Bodies
^^^^^^^^^^^

A body may be subjected to viscous drag or Morison forces, but does not 
experience significant wave excitation or radiation. And example may be a 
deeply-submerged heave plate of large surface area tethered to a float. In 
these instances, the drag body implementation can be utilized by defining the 
following body class variable:: 

    body(i).nhBody = 2

Drag bodies have zero wave excitation or radiation forces, but viscous forces 
can be applied in the same manner as a hydrodynamic body via the parameters:: 

    body(i).viscDrag.Drag
    body(i).viscDrag.cd
    body(i).viscDrag.characteristicArea
    body(i).linearDamping

or if using Morison Elements::  

    body(i).morisonElement.cd
    body(i).morisonElement.ca
    body(i).morisonElement.characteristicArea
    body(i).morisonElement.VME
    body(i).morisonElement.rgME
    
which are described in more detail in the forthcoming section. At a minimum, it 
is necessary to define:: 

    body(i).mass
    body(i).momOfInertia
    body(i).cg
    body(i).cb
    body(i).dispVol
    
to resolve drag body dynamics. One can additionally describe initial body 
displacement in the manner of a hydrodynamic body. 

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

Generalized Body Modes
^^^^^^^^^^^^^^^^^^^^^^

To use this, select a Flex Body Block from the WEC-Sim Library (under Body 
Elements) and initialize it in the WEC-Sim input file as any other body. 
Calculating dynamic response of WECs considering structural flexibilities using 
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
    may need to be modified for NEMOH, AQWA and CAPYTAINE.

Passive Yaw Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^

For non-axisymmetric bodies with yaw orientation that changes substantially 
with time, WEC-Sim allows a correction to excitation forces for large yaw 
displacements. To enable this correction, add the following to your 
``wecSimInputFile``:: 

    simu.yawNonLin = 1

Under the default implementation (:code:`simu.yawNonLin = 0`), WEC-Sim uses the 
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
every time-step, ``simu.yawThresh`` (default 1 degree) can be specified in the 
``wecSimInputFile`` to specify the minimum yaw displacement (in degrees) that 
must occur before another interpolation of excitation coefficients will be 
calculated. The minimum threshold for good simulation accuracy will be device 
specific: if it is too large, no interpolation will occur and the simulation 
will behave as :code:`simu.yawNonLin = 0`, but overly small values may not 
significantly enhance simulation accuracy while increasing simulation time. 

When :code:`simu.yawNonLin = 1`, hydrostatic and radiation forces are 
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

.. _user-advanced-features-pto:

Constraint and PTO Features
----------------------------

.. include:: /_include/pto.rst


.. _user-advanced-features-mooring:

Mooring Features
----------------

.. include:: /_include/mooring.rst


Visualization/Paraview
----------------------

.. include:: /_include/viz.rst


Decay Tests
-----------

When performing simulations of decay tests, you must use one of the no-wave 
cases and setup the initial (time = 0) location of each body, constraint, PTO, 
and mooring block. The initial location of a body or mooring block is set by 
specifying the CG or location at the stability position (as with any WEC-Sim 
simulation) and then specifying an initial displacement. To specify an initial 
displacement, the body and mooring blocks have a :code:`.initDisp` property 
with which you can specify a translation and angular rotation about an 
arbitrary axis. For the constraint and PTO blocks, the :code:`.loc` property 
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

* :code:`body(i).cg`
* :code:`constraint(i).loc`
* :code:`pto(i).loc`
* :code:`mooring.ref` 

For more information, refer to the **Free Decay** example on the `WEC-Sim 
Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

Other Applications
------------------

The WEC-Sim Applications repository also includes examples of using WEC-Sim to 
model a Desalination plant and a numerical model of the WaveStar device for 
control implementation. The WaveStar device was used in the WECCCOMP wave 
energy control competition. 
