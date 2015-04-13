Running WEC-Sim
==========================
This section gives an overview of the `WEC-Sim` work flow. First we describe the `WEC-Sim` file structure describe the steps for setting up and running a `WEC-Sim` simulation. Detailed descriptions and options for input parameters for the input file are described in the Code Structure section. Specific examples of using `WEC-Sim` to simulate WEC devices are presented in the Application Section.

File Structure Overview
-----------------------------
All the information for a WEC-Sim run is contained within a case directory. Provided you have installed WEC-Sim correctly, this folder can be anywhere on your computer. The table below shows the structure for a case directory.

=================   ==========================  ==============
**Information**     **File name**               **Location**
Input file          wecSimInputFile.m           Case directory
WEC Model           ``<WEC Model Name>.slx``    Case directory
Hydrodynamic Data   ``<hydro-data name>.hd5``   hydroData
Geometry            ``<STL File Name>.stl``     geometry
=================   ==========================  ==============

.. Note::

	The location of the `WEC-Sim` case directory will be referred to as the ``$CASE`` directory in this document.

Steps To Run `WEC-Sim`
-----------------------------

The `WEC-Sim` work flow is shown in the figure below. We describe the steps for setting up and running a `WEC-Sim` simulations in the following:

.. figure:: _static/WECSimWorkflow.png
   :width: 400pt

Step 1: Pre-Processing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the pre-processing step, users need to create the model geometry, calculate the hydrodynamic coefficients and convert the hydrodynamic coefficients into HDF5 format for `WEC-Sim` read:

* Creating the device geometry using a CAD model: Users need to create representations of the WEC bodies to generate mesh for their hydrodynamic model and also need to export a their CAD model in STL format, which are used to visualize the WEC bodies in the `WEC-Sim`/MATLAB graphical user interface.
* Run the hydrodynamic model: `WEC-Sim` require pre-determined hydrodynamic coefficients. Typically, these hydrodynamic coefficients for each body of the WEC device are generated using a hydrodynamic model (e.g., WAMIT, NEMOH or AQWA).
* Run ``bemio`` to create `WEC-Sim` input hydrodynamic data file in HDF5 format: `WEC-Sim` will read the hydrodynamic data generated using a hydrodynamic model in HDF5 format (``<hydro-data name>.hd5``). The boundary-element method input/output (``bemio``) was developed for this purpose. Currently, bemio accepts the hydrodynamic coefficients from WAMIT, NEMOH and AQWA. 

Note: 
* To ensure that `WEC-Sim` uses the correct hydrodynamic coefficients to model the WEC system, the hydrodynamic coefficients MUST be given at the center of gravity for each body. If WAMIT is used, the center of gravity for each body MUST be at the origin of the body coordinate system (XBODY) in WAMIT simulations. More details on WAMIT setup are given in the WAMIT User Manual<ref>wamit</ref>.
* Current version of `WEC-Sim` does not account for the multidirectional wave heading and `WEC-Sim` will use whatever (single) wave heading was modeled in the hydrodynamic model.
* Users are also allowed to specify their own hydrodynamic coefficients by modifying an existing HDF5 file or create their own HDF5 file with customized hydrodynamic coefficients following HDF5 format used in ``bemio``.

Step 2: Build Device Simulink/SimMechanics Model
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Next, the user must build the device model using the Simulink/SimMechanics toolboxes and the `WEC-Sim` Library. Figure below shows an example of a a two-body point absorber modeled in Simulink/SimMechanics.

.. figure:: _static/exampleWecModel.png
   :width: 400pt

Step 3: Create `WEC-Sim` Input File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A `WEC-Sim` input file needs to be created in the case directory, and it MUST be named ``wecSimInputFile.m``. An example of the input file for a two-body point absorber is shown in the following figure. In the input file, the simulation settings, sea state, body mass properties, PTO, and constraints are specified. In addition, users MUST specify the Simulink/SimMechanics model file name in the ``wecSimInputFile.m``, which is::

	   simu.simMechanicsFile=’<WEC Model Name>.slx’.

.. figure:: _static/runWECSim_mod.png
   :width: 400pt

Step 4: Execute `WEC-Sim`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Finally, execute the simulation by running the wecSim command from the MATLAB Command Window. The wecSim command must be executed in the `WEC-Sim` case directory where the ``wecSimInputFile.m`` is located.

.. Note::

	`WEC-Sim` simulations should always be executed from the MATLAB Command Window and no from the Simulink/SimMechanics model. This ensures that the correct variables are in the MATLAB workspace during simulation.