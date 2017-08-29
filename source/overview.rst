.. _overview:

Overview
================
A visual representation of the WEC-Sim workflow is shown below. A description of this workflow is provided in the following sections. 

.. figure:: _static/WEC-Sim_flowChart.png
   :width: 500pt



WEC-Sim Model Files
---------------------

All files required for a WEC-Sim simulation must be contained within a case directory referred to as ``$CASE``. This directory can be located anywhere on your computer. The table below list the WEC-Sim case directory structure and required files. 

==================   ==========================  ====================
**File Type**        **File name**               **Directory**
Input File           wecSimInputFile.m           ``$CASE``
Simulink Model       <Simulink_model_name>.slx   ``$CASE``
Hydrodynamic Data    <hydrodata_file_name>.h5    ``$CASE/hydroData``
Geometry File        <STL_file_name>.stl         ``$CASE/geometry``
==================   ==========================  ====================


Input File 
~~~~~~~~~~~
A WEC-Sim input file (``wecSimInputFile.m``) is required for each run. 
The input file must be named ``wecSimInputFile.m`` and must be placed within the case directory. 
The main structure of the input file consists of initializing all the objects necessary to run WEC-Sim simulations, and defining any user specified properties for each object.
The input file for each WEC-Sim simulation requires initialization and definition of the simulation and wave classes, at least one instance of the body class, and at least one instance of the constraint or PTO classes.
For details about WEC-Sim's objects and available properties for each object, refer to the `WEC-Sim Objects Section <http://wec-sim.github.io/WEC-Sim/code_structure.html#wec-sim-objects>`_.

An example WEC-Sim input file is shown below for the OSWEC Tutorial - additional examples are provided in the `Tutorials Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_, and are also provided in the WEC-Sim source code tutorials folder.
WEC-Sim is an object oriented code and the input file reflects this.
The WEC-Sim input file (``wecSimInputFile.m``) for the OSWEC intializes and specifies properties for simulation, body, constraint and pto classes.
 
    
.. literalinclude:: OSWECwecSimInputFile.m
   :language: matlab


Simulink Model 
~~~~~~~~~~~~~~
In addition to an input file, all WEC-Sim runs require a Simulink model file (``<Simulink_model_name>.slx``). An example Simulink model file for the OSWEC is shown below. For more information about the OSWEC, refer to the `Tutorials Section <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_.

.. figure:: _static/OSWEC_Model.png
   :width: 400pt


Running WEC-Sim
-----------------

Step 1: WEC-Sim Pre-Processing 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In the pre-processing step, users need to create the model geometry, calculate the hydrodynamic coefficients, and convert the hydrodynamic coefficients into HDF5 format for WEC-Sim read:

* **3D WEC Model**: Create 3D models of the WEC and generate a meshes for each body. Export the 3D CAD model in STL format. STL files are used to visualize the WEC bodies in the WEC-Sim/MATLAB GUI, and they are used for `WEC-Sim non-linear hydro <http://wec-sim.github.io/WEC-Sim/features.html#nonlinear-hydrodynamic-forces>`_.
* **Generate hydrodynamic coefficients**: WEC-Sim requires frequency-domain hydrodynamic coefficients (added mass, radiation damping, and wave excitation). Typically, these hydrodynamic coefficients for each body of the WEC device are generated using a boundary element method (BEM) code (e.g., WAMIT, NEMOH or AQWA).
* **Create HDF5 file**: WEC-Sim reads the hydrodynamic data in HDF5 format from the (``<hydrodata_file_name>.h5``) file. `BEMIO <http://wec-sim.github.io/bemio/>`_ was developed to parse BEM solutions (from WAMIT, NEMOH and AQWA) into the required HDF5 data structure. 

.. Note::
	* WEC-Sim requires that all hydrodynamic coefficients must be given at the center of gravity for each body. 
	* If WAMIT is used, the center of gravity for each body must be at the origin of the body coordinate system (XBODY). More details on WAMIT setup are given in the `WAMIT User Manual <http://www.wamit.com/manual.htm>`_.
	* Users are able to specify their own hydrodynamic coefficients by creating their own HDF5 file with customized hydrodynamic coefficients following HDF5 format created in BEMIO.

Step 2: Build WEC-Sim model in Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this step, users build their WEC model using the *WEC-Sim Library* developed in Simulink/SimMechanics. The figure below shows an example of a a two-body point absorber modeled using *WEC-Sim Library*.

.. figure:: _static/exampleWecModel.png
   :width: 400pt

Step 3: Write WEC-Sim input file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The WEC-Sim input file must be created in the ``$CASE`` directory, and must be named ``wecSimInputFile.m``. The figure below shows an example of a WEC-Sim input file. The input file specifies the simulation settings, body mass properties, wave conditions, joints, and mooring. Additionally, the WEC-Sim input file must specify the filename of the WEC-Sim Simulink model, ``<Simulink_model_name>.slx``.

.. figure:: _static/runWECSim_mod.png
   :width: 600pt

Step 4: Execute WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Execute the WEC-Sim code by typing ``wecSim`` into the MATLAB Command Window. The WEC-Sim code must be executed in the ``$CASE`` directory.

.. Note::

	WEC-Sim simulations should always be executed from the MATLAB Command Window, not from the Simulink/SimMechanics model.

