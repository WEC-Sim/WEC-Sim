.. _overview:

Overview
=============
This section provides an overview of the WEC-Sim work flow. 
First, the WEC-Sim file structure is described; then, steps for setting up and running the WEC-Sim code are described. 
The WEC-Sim workflow diagram is shown below. 
A description of this workflow is provided in the following sections. 
For information about the implementation and structure of the WEC-Sim source code, refer to the `Code Structure <http://wec-sim.github.io/WEC-Sim/code_structure.html>`_ section.

.. _workFlow:

.. figure:: _static/WEC-Sim_flowChart.png
   :width: 500pt
   :align: center   
    
   ..

   *WEC-Sim Workflow Diagram*



WEC-Sim Model Files
---------------------
All files required for a WEC-Sim simulation must be contained within a case directory referred to as ``$CASE``. 
This directory can be located anywhere on your computer. The table below list the WEC-Sim case directory structure and required files. 

==================   ====================== ====================
**File Type**        **File Name**     	    **Directory**
Input File           ``wecSimInputFile.m``  ``$CASE``
Simulink Model       ``*.slx``              ``$CASE``
Hydrodynamic Data    ``*.h5``   	    ``$CASE/hydroData``
Geometry File        ``*.stl`` 		    ``$CASE/geometry``
==================   ====================== ====================


Input File 
~~~~~~~~~~~
A WEC-Sim input file (``wecSimInputFile.m``) is required for each run. 
The input file must be named ``wecSimInputFile.m`` and placed within the case directory. 
The main structure of the input file consists of initializing all the objects necessary to run WEC-Sim simulations, and defining any user specified properties for each object.
The input file for each WEC-Sim simulation requires initialization and definition of the simulation and wave classes, at least one instance of the body class, and at least one instance of the constraint or PTO classes.
For details about WEC-Sim's objects and available properties for each object, refer to the `WEC-Sim Objects <http://wec-sim.github.io/WEC-Sim/code_structure.html#wec-sim-objects>`_ section.

An example WEC-Sim input file is shown below for the OSWEC Tutorial. 
Additional examples are provided in the `Tutorials <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_  section.
WEC-Sim is an object oriented code and the input file reflects this.
The WEC-Sim input file (``wecSimInputFile.m``) for the OSWEC initializes and specifies properties for simulation, body, constraint and pto classes.
 
    
.. literalinclude:: OSWECwecSimInputFile.m
   :language: matlab
       
 
Simulink Model 
~~~~~~~~~~~~~~
In addition to an input file, all WEC-Sim runs require a Simulink model file (``*.slx``). 
An example Simulink model file for the OSWEC is shown below. 
For more information about the OSWEC, and how to build WEC-Sim Simulink models, refer to the `Tutorials <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_ section.

.. figure:: _static/OSWEC_Model.png
   :width: 400pt
   :align: center   
    
   ..

   *OSWEC Simulink Model*   


Hydrodynamic Data
~~~~~~~~~~~~~~~~~~~~
The WEC-Sim code also requires a hydrodynamic data from a BEM solution in the form of a ``*.h5`` file.
This ``*.h5`` hydrodynamic data file can be generated using the BEMIO pre-processor.
BEMIO (Boundary Element Method Input/Output) is a code developed by the WEC-Sim team to process BEM output files from WAMIT, NEMOH, and AQWA into a data structure than can be read by WEC-Sim. For more information about the BEMIO pre-processor, refer to the `BEMIO <http://wec-sim.github.io/WEC-Sim/advanced_features.html#bemio>`_ section.

Geometry File
~~~~~~~~~~~~~~
The WEC-Sim code also requires a geometry file in the form of a ``*.stl`` file. 
This ``*.stl`` file is used by the WEC-Sim code to generate the Simscape Explorer visualization, and by non-linear hydrodynamics to determine the instantaneous wetted surface at each time step. 
When running WEC-Sim with linear hydrodynamics, the ``*.stl`` is only used for visualization. 
However, when running WEC-Sim with non-linear hydrodynamics, the quality of the ``*.stl`` mesh is critical, refer to the `Non-Linear Hydrodynamics <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-linear-hydrodynamics>`_ section for more information. 


Running WEC-Sim
-----------------
This section provides a description of the steps to run the WEC-Sim code, refer to the :ref:`WEC-Sim workflow diagram <workFlow>` while following the steps to run WEC-Sim.


Step 1: WEC-Sim Pre-Processing 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In the pre-processing step, users need to create the WEC geometry, run a BEM code to calculate the hydrodynamic coefficients, and convert the hydrodynamic coefficients into the ``*.h5`` format for WEC-Sim to read:

* **WEC Geometry**: Create 3D models of the WEC geometry and generate a meshes for each body. Export the WEC geometry file to a ``*.stl`` format. ``*.stl`` files are used to visualize the WEC response in Simscape Explorer, and they are used for `Non-Linear Hydrodynamics <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-linear-hydrodynamics>`_.
* **Hydrodynamic Data**: WEC-Sim requires frequency-domain hydrodynamic coefficients (e.g. added mass, radiation damping, and wave excitation) in the form of a ``*.h5`` file. The hydrodynamic coefficients for each body may be generated using a boundary element method (BEM) code and parsed into a ``*.h5`` data structure using `BEMIO <http://wec-sim.github.io/WEC-Sim/advanced_features.html#bemio>`_. BEMIO was developed by the WEC-Sim team to parse BEM solutions from WAMIT, NEMOH and AQWA into the format required by WEC-Sim. 

.. Note::
	* WEC-Sim requires that all hydrodynamic coefficients must be given at the center of gravity for each body. 
	* If WAMIT is used, the center of gravity for each body must be at the origin of the body coordinate system (XBODY). More details on WAMIT setup are given in the `WAMIT User Manual <http://www.wamit.com/manual.htm>`_.
	* Users are able to specify their own hydrodynamic coefficients by creating their own ``*.h5`` file with customized hydrodynamic coefficients following ``*.h5`` format created by BEMIO.

Step 2: Build WEC-Sim Simulink Model
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this step, users build their WEC-Sim Simulink model (``*.slx``) using the `WEC-Sim Library <http://wec-sim.github.io/WEC-Sim/code_structure.html#wec-sim-library>`_ developed in Simulink/Simscape. 
The ``*.slx`` Simulink model file must be located in the ``$CASE`` directory. 
The figure below shows an example WEC-Sim Simulink model for the OSWEC tutorial.


.. figure:: _static/OSWEC_Model.png
   :width: 400pt
   :align: center   
    
   ..

   *OSWEC Simulink Model*   
   

Step 3: Write WEC-Sim Input File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The WEC-Sim input file must be located in the ``$CASE`` directory, and named ``wecSimInputFile.m``. The figure below shows an example of a WEC-Sim input file. The input file specifies the simulation settings, body mass properties, wave conditions, joints, and mooring. Additionally, the WEC-Sim input file must specify the location of the WEC-Sim Simulink model (``*.slx``) file, the geometry file(s) ``*.stl``, and the hydrodynamic data file (``*.stl``) .

.. figure:: _static/runWECSim_mod.png
   :width: 600pt

Step 4: Execute WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Lastly, execute the WEC-Sim code by typing ``wecSim`` into the MATLAB Command Window. 
The WEC-Sim source code is located in the ``$Source`` directory, but ``wecSim`` must be executed from the ``$CASE`` directory.

.. Note::

	WEC-Sim simulations should always be executed from the MATLAB Command Window, not from the Simulink/SimMechanics model.

