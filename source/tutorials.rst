.. _tutorials:


Tutorials
==================
This section provides an overview of the WEC-Sim work flow. First the WEC-Sim file structure is described, then steps for setting up and running the WEC-Sim code are described. Additionally, two example applications of using WEC-Sim to model WECs are given. For more information about the implementation and additional features, refer to the `Code Structure <http://wec-sim.github.io/WEC-Sim/code_structure.html>`_ section, and to `Advanced Features <http://wec-sim.github.io/WEC-Sim/features.html>`_ section respectively. 

Running WEC-Sim
---------------------
The section provides an overview of the WEC-Sim file structure, and outlines the steps to run WEC-Sim.


File Structure Overview
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All files required for a WEC-Sim simulation must be contained within a case directory. This directory can be located anywhere on your computer. The table below list the WEC-Sim case directory structure and required files.

==================   ==========================  ====================
**Information**      **File name**               **Directory**
Input File           wecSimInputFile.m           ``$CASE``
Simulink Model       <Simulink_model_name>.slx   ``$CASE``
Hydrodynamic Data    <hydrodata_file_name>.h5    ``$CASE``/hydroData
Geometry File        <STL_file_name>.stl         ``$CASE``/geometry
==================   ==========================  ====================

.. Note::

	The WEC-Sim case directory will be referred to as **$CASE**

Step 1: WEC-Sim Pre-Processing 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In the pre-processing step, users need to create the model geometry, calculate the hydrodynamic coefficients and convert the hydrodynamic coefficients into HDF5 format for WEC-Sim read:

* **3D WEC Model**: Create 3D models of the WEC, and generate a meshes for each body. Export the 3D CAD model in STL format. STL files are used to visualize the WEC bodies in the WEC-Sim/MATLAB GUI, and used for `WEC-Sim non-linear hydro <http://wec-sim.github.io/WEC-Sim/features.html#nonlinear-hydrodynamic-forces>`_.
* **Generate hydrodynamic coefficients**: WEC-Sim requires frequency-domain hydrodynamic coefficients (added mass, radiation damping, and wave excitation). Typically, these hydrodynamic coefficients for each body of the WEC device are generated using a boundary element method (BEM) code (e.g., WAMIT, NEMOH or AQWA).
* **Create HDF5 file**: WEC-Sim reads the hydrodynamic data in HDF5 format from the (``<hydrodata_file_name>.h5``) file. `BEMIO <http://wec-sim.github.io/bemio/>`_ was developed to parse BEM solutions (from WAMIT, NEMOH and AQWA) into the required HDF5 data structure. 

.. Note::
	* WEC-Sim requires that all hydrodynamic coefficients must be given at the center of gravity for each body. 
	* If WAMIT is used, the center of gravity for each body must be at the origin of the body coordinate system (XBODY). More details on WAMIT setup are given in the `WAMIT User Manual <http://www.wamit.com/manual.htm>`_.
	* Users are able to specify their own hydrodynamic coefficients by creating their own HDF5 file with customized hydrodynamic coefficients following HDF5 format created in BEMIO.

Step 2: Build WEC-Sim model in Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this step, users build their WEC model using the WEC-Sim Library developed in Simulink/SimMechanics. The figure below shows an example of a a two-body point absorber modeled using WEC-Sim Library.

.. figure:: _static/exampleWecModel.png
   :width: 400pt

Step 3: Write WEC-Sim input file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The WEC-Sim input file must be created in the ``$CASE`` directory, and must be named ``wecSimInputFile.m``. The figure below shows an example of a WEC-Sim input file. The input file specifies the simulation settings, body mass properties, wave conditions, joints, and mooring. Additionally, the WEC-Sim input file must specify the filename of the WEC-Sim Simulink model, ``<Simulink_model_name>.slx``.

.. figure:: _static/runWECSim_mod.png
   :width: 400pt

Step 4: Execute WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Execute the WEC-Sim code by typing ``wecSim`` into the MATLAB Command Window. The WEC-Sim code must be executed in the ``$CASE`` directory.

.. Note::

	WEC-Sim simulations should always be executed from the MATLAB Command Window, not from the Simulink/SimMechanics model.


Two-Body Point Absorber (RM3)
-----------------------------
The sections describes application of the WEC-Sim code to model the Reference Model 3 (RM3) two-body point absorber WEC. This example application is provided in the WEC-Sim code release in the `tutorials <https://github.com/WEC-Sim/WEC-Sim/tree/master/tutorials>`_ directory.

The RM3 two-body point absorber WEC has been characterized both numerically and experimentally as a result of the DOE-funded `Reference Model Project <http://energy.sandia.gov/rmp>`_. The RM3 is a two-body point absorber, consisting of a float and a reaction plate. Full-scale dimensions of the RM3 and its mass properties are shown below.

.. figure:: _static/RM3_Geom.jpg
   :width: 400pt

+-------------------------------------------------+
|Float Full Scale Properties                      |
+======+=========+================================+
|      |Mass     |Moment of                       |
+CG (m)+(tonne)  +Inertia (kg-m^2)                +
+------+---------+----------+----------+----------+
|  0   |         |20,907,301|0         |0         |
+------+         +----------+----------+----------+
|  0   |727.01   |0         |21,306,091|4305      |
+------+         +----------+----------+----------+
|-0.72 |         |          |4305      |37,085,481|
+------+---------+----------+----------+----------+   

+-------------------------------------------------+
|Plate Full Scale Properties                      |
+======+=========+================================+
|      |Mass     |Moment of                       |
+CG (m)+(tonne)  +Inertia (kg-m^2)                +
+------+---------+----------+----------+----------+
|  0   |         |94,419,615|0         |0         |
+------+         +----------+----------+----------+
|  0   |878.30   |0         |94,407,091|217,593   |
+------+         +----------+----------+----------+
|-21.29|         |          |217,593   |28,542,225|
+------+---------+----------+----------+----------+ 

File Structure Overview
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Below is an overview of the files required to run the RM3 simulation in WEC-Sim. For the RM3 WEC, consisting of a buoy and a plate, there are two corresponding geometry files: ``float.stl`` and ``plate.stl``. In addition to the required files listed below, users may supply a ``userDefinedFunctions.m`` file for post-processing results once the WEC-Sim run is complete. 

==================   =====================  =========================
**Information**      **File name**          **Directory**
Input File           wecSimInputFile.m      /tutorials/rm3/
Simulink Model       rm3.slx   		    /tutorials/rm3/
Hydrodynamic Data    rm3.h5    		    /tutorials/rm3/hydroData/
Geometry File        float.stl & plate.stl  /tutorials/rm3/geometry/
==================   =====================  =========================

Step 1: WEC-Sim Pre-Processing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Hydrodynamic data for each RM3 body must be parsed into a HDF5 file using the `BEMIO <http://wec-sim.github.io/bemio/>`_ hydrodynamic data format. The RM3 HDF5 file (``rm3.h5``) was created based on a WAMIT run of the RM3 geometry. The RM3 WAMIT ``rm3.out`` file and the BEMIO ``readWAMIT.py`` script used to generate the HDF5 are included in the ``/hydroData`` directory.

Step 2: Build WEC-Sim model in Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The WEC-Sim Simulink model is created by dragging and dropping blocks from the WEC-Sim library into the ``rm3.slx`` file. 

* Place two **Rigid Body** blocks from the WEC-Sim Library in the Simulink model file, one for each RM3 rigid body.

.. figure:: _static/RM3_WECSim_Body.jpg
   :width: 400pt


* Double click on the **Rigid Body** block, and rename each instance of the body. The first body must be called **body(1)**, and the second body should be called **body(2)**. 


* Place the **Global Reference Frame** from the WEC-Sim Library in the Simulink model file. The global reference frame acts as the seabed.

.. figure:: _static/RM3_WECSim_GlobalRef.jpg
   :width: 400pt


* Place the **Floating (3DOF)** block to connect the plate to the seabed. This constrains the plate to move in 3DOF relative to the **Global Reference Frame**. 


* Place the **Translational PTO** block to connect the float to the spar. This constrains the float to move in heave relative to the spar, and allows definition of PTO damping. 

.. figure:: _static/RM3_WECSim.JPG
   :width: 400pt

.. Note::

	When setting up a WEC-Sim model, it is very important to note the base and follower frames.


Step 3: Write WEC-Sim input file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The WEC-Sim input file defines simulation parameters, body properties, joints, and mooring for the RM3 model. The ``wecSimInputFile.m`` for the RM3 is provided in the RM3 case directory, and shown below.

.. figure:: _static/RM3wecSimInputFile.png
   :width: 400pt


.. _`RM3 with WEC-Sim`:
.. _Simulation:

Step 4: Execute WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To execute the WEC-Sim code for the RM3 tutorial, type ``wecSim`` into the MATLAB Command Window. Below is a figure showing the final RM3 Simulink model and the WEC-Sim GUI during the simulation. For more information on using WEC-Sim to model the RM3 device, refer to :cite:`ruehl_preliminary_2014`.

.. figure:: _static/RM3_WECSim_GUI.JPG
   :width: 400pt

Output and Post-processing
++++++++++++++++++++++++++++
The RM3 example includes a ``userDefinedFunctions.m`` which plots RM3 forces and responses. This file can be modified by users for post-processing. Additionally, once the WEC-Sim run is complete, the WEC-Sim results are saved to the **output** variable in the MATLAB workspace.

Running Different Wave Cases
++++++++++++++++++++++++++++
The input file in the RM3 example has four different wave examples: 
* Regular waves
* Irregular waves with using Pierson–Moskowitz spectrum with convolution integral calculation
* Irregular waves with using Bretschneider Spectrum with state space calculation
* Irregular waves with defined spectrum, and irregular waves with a user defined spectrum

By default the regular waves case is used. To run either of the other three cases the user needs to comment out the regular wave case and uncomment the desired case. Additionally, the user can create any other desired wave. 

Note: If ``simu.ssCalc=1`` is uncommented, the user needs to make sure the state space hydrodynamic coefficients are included in the ``<hydro-data name>.hd5`` file. User can generate the state space hydrodynamic coefficients and export the values in the ``<hydro-data name>.hd5`` file using the bemio code. More details are described in the `Calculating Impulse Response Functions and Sate Space Coefficients <http://wec-sim.github.io/bemio/api.html#calculating-impulse-response-functions-and-sate-space-coefficients>`_ section in the `bemio` Documentation and Users Guide

  
Oscillating Surge WEC (OSWEC)
-----------------------------
Geometry Definition
~~~~~~~~~~~~~~~~~~~

As the second application of the WEC-Sim code, the oscillating surge WEC (OSWEC) device. We selected the OSWEC because its design is fundamentally different from the RM3. This is critical because WECs span an extensive design space, and it is important to model devices in WEC-Sim that operate under different principles.  The OSWEC is fixed to the ground and has a flap that is connected through a hinge to the base that restricts the flap to pitch about the hinge. The full-scale dimensions of the OSWEC and the mass properties are shown in the figure and table below.

.. figure:: _static/OSWEC_Geom.png
   :width: 400pt

+-----------------------------+
|Flap Full Scale Properties   |
+======+=========+============+
|      |         |Pitch Moment|
+CG (m)+Mass (kg)+of Inertia  +
|      |         |(kg-m^2)    |
+------+---------+------------+
|  0   |         |            |
+------+         +            +
|  0   |127,000  |1,850,000   |
+------+         +            +
| -3.9 |         |            |
+------+---------+------------+


Hydrodynamic Data Pre-Processing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The hydrodynamic data for each body must be supplied in `bemio` hydrodynamic data format generated using the `bemio`_ code.  More information on how to use `bemio` can be found here - http://wec-sim.github.io/bemio/. The hydrodynamic data for each body can be supplied in one single ''hdf5'' file, or several (ie. one per body). In this application case, a single file is provided. This file was created based on a WAIMT run of the RM3 geometry, using the WAMIT output file and the WAMIT reader from the  `bemio open source BEM parser <https://github.com/WEC-Sim/bemio/releases>`_ . The WAMIT ``*.out`` file and the python bemio script used to create the ''hdf5'' are included as well. All these files are located in the ''/hydroData'' directory of the RM3 application case.

Modeling OSWEC in WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this section, we provide a step by step tutorial on how to set up and run the OSWEC simulation in WEC-Sim. 

All WEC-Sim models consist of a input file (``wecSimInputFile.m``), and a Simulink model file (``OSWEC.slx``). The BEM hydrodynamic results were also pregenerated using WAMIT. The WAMIT output file corresponds to the ``oswec.out`` file, contained in the wamit subfolder. In addition, the user needs to specify the 3-D geometry file in the form of a ``<WEC model name>.stl`` file about the center of gravity for the WEC-Sim visualizations. For the OSWEC run consisting of a flap and a base, these files correspond to the ``flap.stl`` and ``base.stl`` files, respectively, which are located in the geometry subfolder.

OSWEC Simulink Model File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The first step to set up a WEC-Sim simulation is to populate the Simulink model file by dragging and dropping blocks from the WEC-Sim library into the ``<WEC model name>.slx`` file. 

* Step 1: Place two ``Rigid Body`` blocks from the WEC-Sim library in the Simulink model file, one for each OSWEC rigid body, as shown in the figure below. 

.. figure::: _static/OSWEC_WECSim_Body.jpg
   :width: 400pt

* Step 2: Double click on the body block, and rename the instances of the body. The first body should be titled body(1), and the second body should be titled body(2). Additional properties of these body blocks are defined in the OSWEC MATLAB input file.


* Step 3: Place the ``Global Reference`` block from the WEC-Sim library in the Simulink model file, as shown in the figure below. The global reference frame acts as the base to which all other bodies are linked through joints or constraints.

.. figure::: _static/OSWEC_WECSim_GlobalRef.jpg


* Step 4: Place a ``Fixed constraint`` block to connect the base to the seafloor. This is done because the OSWEC base is fixed relative to the global reference frame. Step 4 and 5 connections are shown in the figure below.


* Step 5: Place a ``Rotational PTO`` block to connect the base to the flap. This is done because the flap is restricted to pitch motion relative to the base.  For the OSWEC simulation, the ``Rotational PTO`` is used to model the WEC's PTO as a linear rotary damper. The input parameters are defined in the OSWEC MATLAB input file. 

.. figure::: _static/OSWEC_WECSim.JPG
   :width: 400pt


When setting up a WEC-Sim model, it is important to note the base and follower frames. For example, for the constraint between the base and the seabed, the seabed should be defined as the base because it is the Global Reference Frame.

OSWEC MATLAB Input File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this section, the WEC-Sim MATLAB input file, ``wecSimInputFile.m``, for the OSWEC model is defined. Each of the lines are commented to explain the purpose of the defined parameters. For the OSWEC model, the user must define the simulation parameters, body properties, PTO, and constraint definitions. Each of the specified parameters for OSWEC are defined below.

.. figure:: _static/OSWECwecSimInputFile.png
   :width: 400pt

OSWEC WEC-Sim Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the WEC-Sim Simulink model is set up and the OSWEC properties are defined in the MATLAB input file, the user can then run the OSWEC model in WEC-Sim by running the ``wecSim`` command from the MATLAB Command Window..  The figure below shows the final OSWEC Simulink model and the WEC-Sim GUI showing the OSWEC during the simulation. For more information on using WEC-Sim to model the OSWEC device, refer to :cite:`y._yu_development_2014,y._yu_design_2014`.

.. figure::: _static/OSWEC_WECSim_GUI.png
   :width: 400pt


Floating Oscillating Surge WEC (FOSWEC)
---------------------------------------
.. Note::

	Coming soon!



References
--------------
.. bibliography:: WEC-Sim_Tutorials.bib
   :style: unsrt