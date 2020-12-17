.. _tutorials:

Tutorials
=========
This section provides step-by-step instructions on how to run the WEC-Sim code using the provided Tutorials (located in the WEC-Sim ``$WECSIM/tutorials`` directory). 
Two WEC-Sim tutorials are provided: the Two-Body Point Absorber (RM3), and the Oscillating Surge WEC (OSWEC). 
For information about the implementation of the WEC-Sim code refer to the refer to the :ref:`code_structure` section. 
For information about additional WEC-Sim features, refer to :ref:`advanced_features`. 


Two-Body Point Absorber (RM3)
----------------------------------
This section describes the application of the WEC-Sim code to model the Reference Model 3 (RM3) two-body point absorber WEC. 
This tutorial is provided in the WEC-Sim code release in the ``$WECSIM/tutorials`` directory.

Device Geometry
^^^^^^^^^^^^^^^^^^^^^^^
The RM3 two-body point absorber WEC has been characterized both numerically and experimentally as a result of the DOE-funded `Reference Model Project <http://energy.sandia.gov/rmp>`_. 
The RM3 is a two-body point absorber consisting of a float and a reaction  plate. Full-scale dimensions and mass properties of the RM3 are shown below. 


.. figure:: /_static/images/RM3_Geom.png
   :width: 300pt
   :align: center

+-------+---------------+
| Body  | Mass (tonne)  |
+=======+===============+
| Float | 727.01        |
+-------+---------------+
| Plate | 878.30        |
+-------+---------------+

+-------+-----------+------------------------+--------------------------------------+
| Body  | Direction | Center of Gravity* (m) | Moment of Inertia Tensor (kg m^2)    |
+=======+===========+========================+============+============+============+
|       |    x      |  0                     | 20,907,301 | 0          | 0          |
|       +-----------+------------------------+------------+------------+------------+
| Float |    y      |  0                     | 21,306,091 | 0          | 0          |
|       +-----------+------------------------+------------+------------+------------+
|       |    z      | -0.72                  | 0          | 0          | 37,085,481 |
+-------+-----------+------------------------+------------+------------+------------+
|       |    x      |  0                     | 94,419,615 | 0          | 0          |
|       +-----------+------------------------+------------+------------+------------+
| Plate |    y      |  0                     | 0          | 94,407,091 | 0          |
|       +-----------+------------------------+------------+------------+------------+
|       |    z      | -21.29                 | 0          | 0          | 28,542,225 |
+-------+-----------+------------------------+------------+------------+------------+

**\* The origin lies at the undisturbed free surface (SWL)**

Model Files
^^^^^^^^^^^^^^^^^^^^^^^
Below is an overview of the files required to run the RM3 simulation in WEC-Sim. For the RM3 WEC, there are two corresponding geometry files: ``float.stl`` and ``plate.stl``. In addition to the required files listed below, users may supply a ``userDefinedFunctions.m`` file for post-processing results once the WEC-Sim run is complete. 

==================   =============================  =============================
**File Type**        **File Name**                  **Directory**
Input File           ``wecSimInputFile.m``          ``$WECSIM/tutorials/rm3/``
Simulink Model       ``rm3.slx``   		    ``$WECSIM/tutorials/rm3/``
Hydrodynamic Data    ``rm3.h5``    	            ``$WECSIM/tutorials/rm3/hydroData/``
Geometry Files       ``float.stl`` & ``plate.stl``  ``$WECSIM/tutorials/rm3/geometry/`` 
==================   =============================  =============================

RM3 Tutorial
^^^^^^^^^^^^^^^^^^^^^^^

Step 1: Run BEMIO
""""""""""""""""""""""""
Hydrodynamic data for each RM3 body must be parsed into a HDF5 file using :ref:`bemio`. 
BEMIO converts hydrodynamic data from WAMIT, NEMOH or AQWA into a HDF5 file, ``*.h5`` that is then read by WEC-Sim.
The RM3 tutorial includes data from a WAMIT run, ``rm3.out``, of the RM3 geometry in the ``$WECSIM/tutorials/rm3/hydroData/`` directory.
The RM3 WAMIT ``rm3.out`` file and the BEMIO ``bemio.m`` script are then used to generate the ``rm3.h5`` file. 

This is done by navigating to the ``$WECSIM/tutorials/rm3/hydroData/`` directory, and typing``bemio`` in the MATLAB Command Window::

	>> bemio
	

Step 2: Build Simulink Model
""""""""""""""""""""""""""""""""""""""""""""""""
The WEC-Sim Simulink model is created by dragging and dropping blocks from the *WEC-Sim Library* into the ``rm3.slx`` file. When setting up a WEC-Sim model, it is very important to note the base and follower frames. The base port should always connect 'towards' the Global Reference Frame, while the follower port connects 'away' from the reference frame. Also, a base port should always connect to a follower port. The same port type should not be connected (i.e. no base-base or follower-follower connections).

* Place two **Rigid Body** blocks from *Body Elements* in *WEC-Sim Library* in the Simulink model file, one for each RM3 rigid body.

* Double click on the **Rigid Body** block, and rename each instance of the body. The first body must be called ``body(1)``, and the second body should be called ``body(2)``. 

.. figure:: /_static/images/RM3_WECSim_Body.jpg
   :width: 400pt
   :align: center

*  Place the **Global Reference Frame** from *Frames* in the *WEC-Sim Library* in the Simulink model file. The global reference frame acts as the seabed.

.. figure:: /_static/images/RM3_WECSim_GlobalRef.jpg
   :width: 400pt
   :align: center
   

* Place the **Floating (3DOF)** block from *Constrains* to connect the plate to the seabed. This constrains the plate to move in 3DOF relative to the **Global Reference Frame**.  

* Place the **Translational PTO** block  from *PTOs* to connect the float to the spar. This constrains the float to move in heave relative to the spar, and allows definition of PTO damping. 

.. figure:: /_static/images/RM3_WECSim.JPG
   :width: 400pt
   :align: center


Step 3: Write wecSimInputFile.m
""""""""""""""""""""""""""""""""""""""""""""""""
The WEC-Sim input file defines simulation parameters, body properties, joints, and mooring for the RM3 model. The ``wecSimInputFile.m`` for the RM3 is provided in the RM3 case directory, and shown below.

New users should manually write the wecSimInputFile.m to become familiar with the set-up parameters and the files being called in a basic WEC-Sim run. First, define the simulation parameters. Initialize an instance of the simulationClass. Define the simulink file to use, the start, ramp and end times, and the time step required. The simulation class also controls all relevant numerical options and simulation-wide parameters in a single convenient class.

Next set-up the type of incoming wave by instantiating the waveClass. 'Regular' is a sinusoidal wave and the easiest to start with. Define an appropriate wave height and period. Waves can also be an irregular spectrum, imported by elevation or spectrum, or multidirectional.

Third, define all bodies, PTOs and contraints present in the simulink file. There are distinct classes for bodies, PTOs and contraints that contain different properties and function differently. Bodies are hydrodynamic and contain mass and geometry properties. Initialize bodies by calling the bodyClass and the path to the relevant h5 file. Set the path to the geometry file, and define the body's mass properties. PTOs and constraints are more simple and contain forces and power dissipation (in the constraint) that limit the WEC's motion. PTOs and constraints can be set by calling the appropriate class with the Simulink block name. Set the location and any PTO damping or stiffness desired.

.. literalinclude:: ../../tutorials/RM3/RM3_wecSimInputFile.m
   :language: matlab
      

Step 4: Run WEC-Sim
""""""""""""""""""""""""
To execute the WEC-Sim code for the RM3 tutorial, type ``wecSim`` into the MATLAB Command Window. Below is a figure showing the final RM3 Simulink model and the WEC-Sim GUI during the simulation. For more information on using WEC-Sim to model the RM3 device, refer to :cite:`ruehl_preliminary_2014`.

.. figure:: /_static/images/RM3_WECSim_GUI.JPG
   :width: 400pt
   :align: center

Step 5: Post-processing
""""""""""""""""""""""""""""""""""""""""""""""""
The RM3 tutorial includes a ``userDefinedFunctions.m`` which plots RM3 forces and responses. This file can be modified by users for post-processing. Additionally, once the WEC-Sim run is complete, the WEC-Sim results are saved to the **output** variable in the MATLAB workspace.

  
Oscillating Surge WEC (OSWEC)
----------------------------------
This section describes the application of the WEC-Sim code to model the Oscillating Surge WEC (OSWEC). 
This tutorial is provided in the WEC-Sim code release in the ``$WECSIM/tutorials`` directory.


Device Geometry
^^^^^^^^^^^^^^^^^^^^^^^
The OSWEC was selected because its design is fundamentally different from the RM3. This is critical because WECs span an extensive design space, and it is important to model devices in WEC-Sim that operate under different principles.  The OSWEC is fixed to the ground and has a flap that is connected through a hinge to the base that restricts the flap in order to pitch about the hinge.
The full-scale dimensions and mass properties of the OSWEC are shown below.

.. figure:: /_static/images/OSWEC_Geom.png
   :width: 300pt
   :align: center

+-------------------+----------------------------------+
| Mass |nbsp| (kg)  | Pitch Moment of Inertia (kg m^2) |
+===================+==================================+
| 727.01            | 1,850,000                        |
+-------------------+----------------------------------+

+-----------+------------------------+
| Direction | Center of Gravity* (m) |
+===========+========================+
|    x      |  0                     |
+-----------+------------------------+
|    y      |  0                     |
+-----------+------------------------+
|    z      | -3.9                   |
+-----------+------------------------+

**\* The origin lies at the undisturbed free surface**

Model Files
^^^^^^^^^^^^^^^^^^^^^^^
Below is an overview of the files required to run the OSWEC simulation in WEC-Sim. 
For the OSWEC, there are two corresponding geometry files: ``flap.stl`` and ``base.stl``. 
In addition to the required files listed below, users may supply a ``userDefinedFunctions.m`` file for post-processing results once the WEC-Sim run is complete. 

==================   ============================  ===============================
**File Type**        **File Name**                 **Directory**
Input File           ``wecSimInputFile.m``         ``$WECSIM/tutorials/oswec/``
Simulink Model       ``oswec.slx``   	           ``$WECSIM/tutorials/oswec/``
Hydrodynamic Data    ``oswec.h5``    	           ``$WECSIM/tutorials/oswec/hydroData/``
Geometry Files       ``flap.stl`` & ``base.stl``   ``$WECSIM/tutorials/oswec/geometry/``
==================   ============================  ===============================


OSWEC Tutorial
^^^^^^^^^^^^^^^^^^^^^^^

Step 1: Run BEMIO
""""""""""""""""""""""""
Hydrodynamic data for each OSWEC body must be parsed into a HDF5 file using :ref:`bemio`. 
BEMIO converts hydrodynamic data from WAMIT, NEMOH or AQWA into a HDF5 file, ``*.h5`` that is then read by WEC-Sim.
The OSWEC tutorial includes data from a WAMIT run, ``oswec.out``, of the OSWEC geometry in the ``$WECSIM/tutorials/rm3/hydroData/`` directory.
The OSWEC WAMIT ``oswec.out`` file and the BEMIO ``bemio.m`` script are then used to generate the ``oswec.h5`` file. 

This is done by navigating to the ``$WECSIM/tutorials/oswec/hydroData/`` directory, and typing``bemio`` in the MATLAB Command Window::

	>> bemio


Step 2: Build Simulink Model
""""""""""""""""""""""""""""""""""""""""""""""""
The WEC-Sim Simulink model is created by dragging and dropping blocks from the *WEC-Sim Library* into the ``oswec.slx`` file. 

* Place two **Rigid Body** blocks from the *WEC-Sim Library* in the Simulink model file, one for each OSWEC rigid body. 

* Double click on the **Rigid Body** block, and rename each instance of the body. The first body must be called ``body(1)``, and the second body should be called ``body(2)``. 
   
.. figure:: /_static/images/OSWEC_WECSim_Body.jpg
   :width: 400pt  
   :align: center


* Place the **Global Reference Frame**  from *Frames* in the *WEC-Sim Library* in the Simulink model file. The global reference frame acts as the seabed.

.. figure:: /_static/images/OSWEC_WECSim_GlobalRef.jpg
   :width: 400pt
   :align: center

* Place the **Fixed** block from *Constraints* to connect the base to the seabed. This constrains the base to be fixed relative to the **Global Reference Frame**. 

* Place a **Rotational PTO** block to connect the base to the flap. This constrains the flap to move in pitch relative to the base, and allows for the definition of PTO damping. 

.. figure:: /_static/images/OSWEC_WECSim.JPG
   :width: 400pt
   :align: center

.. Note::

	When setting up a WEC-Sim model, it is very important to note the base and follower frames.

Step 3: Write wecSimInputFile.m
""""""""""""""""""""""""""""""""""""""""""""""""
The WEC-Sim input file defines simulation parameters, body properties, and joints for the OSWEC model. Writing the OSWEC input file is similar to writing the RM3 input. Try writing it on your own. Define the simulation class, wave class, bodies, contraints and PTOs. The ``wecSimInputFile.m`` for the OSWEC is provided in the OSWEC case directory, and shown below.

.. literalinclude:: ../../tutorials/OSWEC/OSWEC_wecSimInputFile.m
   :language: matlab

Step 4: Run WEC-Sim
""""""""""""""""""""""""
To execute the WEC-Sim code for the OSWEC tutorial, type ``wecSim`` into the MATLAB Command Window. Below is a figure showing the final OSWEC Simulink model and the WEC-Sim GUI during the simulation. For more information on using WEC-Sim to model the OSWEC device, refer to :cite:`y._yu_development_2014,y._yu_design_2014`.

.. figure:: /_static/images/OSWEC_WECSim_GUI.jpg
   :width: 400pt
   :align: center

Step 5: Post-processing
""""""""""""""""""""""""""""""""""""""""""""""""
The OSWEC tutorial includes a ``userDefinedFunctions.m`` which plots OSWEC forces and responses. This file can be modified by users for post-processing. Additionally, once the WEC-Sim run is complete, the WEC-Sim results are saved to the **output** variable in the MATLAB workspace.



WEC-Sim Examples
------------------------
Working examples of using WEC-Sim to model the RM3 and OSWEC are provided in the ``$WECSIM/examples/`` directory. 
For each example the ``wecSimInputFile.m`` provided includes examples of how to run different wave cases: 

* ``noWaveCIC`` - no wave with convolution integral calculation
* ``regularCIC`` - regular waves with convolution integral calculation
* ``irregular`` - irregular waves using a Pierson-Moskowitz spectrum with convolution integral calculation
* ``irregular`` - irregular waves using a Bretschneider Spectrum with state space calculation
* ``spectrumImport`` - irregular waves using a user-defined spectrum
* ``etaImport`` - user-defined time-series


Other Applications
------------------------
The `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository contains many applications of the WEC-Sim code that demonstrate WEC-Sim :ref:`Advanced Features <advanced_features>`. This includes tutorials by the WEC-Sim team as well as user-shared examples and covers topics from body interactions, numerical set-up, batch runs, visualization, control examples, mooring and many more cases. These applications highlight the versatility of WEC-Sim and can be used as a starting point for users interested in a given application.
The WEC-Sim Applications repository is included as a `submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_ of the WEC-Sim repository. The applications are summarized below.

.. Adam: right now these descriptions are copy/pasted from the application READMEs. We can expand or link them later on depending on what will be done with the App repo


Body-to-Body Interactions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using `Body-to-Body (B2B) <http://wec-sim.github.io/WEC-Sim/advanced_features.html#body-to-body-interactions>`_ to run WEC-Sim for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ geometry. The scripts run and plot the RM3 model with B2B on/off and with Regular/RegularCIC. Execute the `runB2B.m` script to run this case. 


Desalination
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using WEC-Sim for desalination based on the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ geometry. Note the dependency on SimScape Fluids to run this desalination case. 


Free Decay
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using WEC-Sim to simulate `free decay <http://wec-sim.github.io/WEC-Sim/advanced_features.html#decay-tests>`_ of a sphere in heave, using `Multiple Condition Runs <http://wec-sim.github.io/WEC-Sim/advanced_features.html#multiple-condition-runs-mcr>`_.  Execute the `runFreeDecay.m` script to run this case.


Generalized Body Modes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using `Generalized Body Modes <http://wec-sim.github.io/WEC-Sim/advanced_features.html#generalized-body-modes>`_ in WEC-Sim. In this application a barge is allowed four additional flexible degrees of freedom. Note that this requires the BEM solver also account for these general degrees of freedom and output the appropriate quantities required by BEMIO.


Mooring
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
One example using the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ geometry coupled with `MoorDyn <http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn>`_ to simulate a more realistic mooring system. And another example modeling the RM3 with a Mooring Matrix. The MoorDyn application consists of 3 catenary mooring lines attached to floating buoys and then to different points on the spar and anchored at the sea floor.


Multiple Condition Run
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using `Multiple Condition Runs (MCR) <http://wec-sim.github.io/WEC-Sim/advanced_features.html#multiple-condition-runs-mcr>`_ to run WEC-Sim with Multiple Condition Runs for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_. These examples demonstrate each of the 3 different ways to run WEC-Sim with MCR and generates a power matrix for each PTO damping value. The last example demonstrates how to use MCR to vary the imported sea state test file and specify corresponding phase. Execute `wecSimMCR.m` from the case directory to run an example. 

* MCROPT1: Cases defined using arrays of values for period and height.
* MCROPT2: Cases defined with wave statistics in an Excel spreadsheet
* MCROPT3: Cases defined in a MATLAB data file (``.mat``)
* MCROPT4: Cases defined using several MATLAB data files (``*.mat``) of the wave spectrum


Nonhydrodynamic Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using `Non-Hydro Body <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-hydrodynamic-bodies>`_ to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_. This example models the base as a nonhydro body, and the flap as a hydrodynamic body.


Nonlinear Hydrodynamic Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using `Nonlinear Hydro <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation>`_ to run WEC-Sim for a `heaving ellipsoid <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-wave-excitation-tutorial-heaving-ellipsoid>`_. Includes examples of running non-linear hydrodynamics with different `fixed and variable time-step solvers <http://wec-sim.github.io/WEC-Sim/advanced_features.html#time-step-features>`_ (ode4/ode45), and different regular wave formulations (with/without CIC). Execute the `runNL.m` script to run this case. 


Numerical Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example that compares various numerical options in WEC-Sim. This case compares the differential equation solver `time step settings <https://wec-sim.github.io/WEC-Sim/advanced_features.html#time-step-features>`_ (``ode4, ode45``), the `convolution integral <https://wec-sim.github.io/WEC-Sim/theory.html#convolution-integral-formulation>`_ and the `state-space <https://wec-sim.github.io/WEC-Sim/theory.html#state-space>`_ representations. Execute the `run_NumOpt.m` script to run this case. 


Paraview Visualization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example using ParaView data visualization for WEC-Sim coupled with `MoorDyn <http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn>`_ to simulate a more realistic mooring system for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ geometry. Example consists of 3 catenary mooring lines attached to different points on the spar and anchored at the sea floor.   

Example using ParaView data visualization for WEC-Sim with `Non-linear Hydro <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation>`_ for the Flap and a `Non-Hydro Body <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-hydrodynamic-bodies>`_ for the Base to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ geometry.


Passive Yaw
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Example on using `Passive Yaw <http://wec-sim.github.io/WEC-Sim/advanced_features.html#passive-yaw-implementation>`_ to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ geometry. Execute the `runYawCases.m` script to run this case. 


PTO-Sim
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Examples using `PTO-Sim <http://wec-sim.github.io/WEC-Sim/advanced_features.html#pto-sim>`_. Examples of WEC-Sim models using PTO-Sim are included for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ geometry and `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ geometry.


WECCCOMP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Numerical model for the WEC Control Competition (WECCCOMP) using WEC-Sim to model the WaveStar with various fault implementations. See the project report written by Erica Lindbeck in the "report" folder.


Write HDF5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is an example of how to write your own h5 file using MATLAB. 
Can be useful if you want to modify your coefficients, use experimental coefficients, or coefficients from another BEM code other than NEMOH, WAMIT, or AQWA.
For more details see `BEMIO feature <http://wec-sim.github.io/WEC-Sim/features.html#bemio-writing-your-own-h5-file>`_ documentation.


References
------------------------
.. bibliography:: ../refs/WEC-Sim_Tutorials.bib
   :style: unsrt
   :labelprefix: A

.. |nbsp| unicode:: 0xA0 
   :trim: