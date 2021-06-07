.. _user-workflow:

Workflow
========

The WEC-Sim workflow diagram below shows a high level view of WEC-Sim's 
function. As a precursor, a functional WEC design with several forms of data 
must be included. The WEC is defined in an input file. This input file is read 
by WEC-Sim which instantiates objects based on the device requirements. The 
objects are used in conjunction with WEC-Sim's Simulink library during the 
time-domain simulation. User defined functions serve for easy post-processing 
and visualization of WEC-Sim's output. A detailed description of this workflow 
is provided in the following sections. For information about the implementation 
and structure of the WEC-Sim source code, refer to the 
:ref:`user-code-structure` section. 

.. _user-workflow-chart:

.. figure:: /_static/images/WEC-Sim_flowChart.png
   :width: 500pt
   :align: center   
    
   ..

   *WEC-Sim Workflow Diagram*

.. _user-workflow-input-files:

WEC-Sim Input Files
-------------------

Before WEC-Sim can be used, a wave energy converter design must exist. This 
design must include a surface mesh, frequency-based hydrodynamic data from a 
boundary element method solver, and a Simulink/Simscape model of the WEC. The 
WEC's geometry and other parameters must be detailed in the wecSimInputFile. 
All files required for a WEC-Sim simulation must be contained within a case 
directory referred to as ``$CASE``. This directory can be located anywhere on 
your computer. The table below lists the WEC-Sim case directory structure and 
required files. 

==================== ====================== ====================
**File Type**        **File Name**          **Directory**
Hydrodynamic Data    ``*.h5``               ``$CASE/hydroData``
Geometry File        ``*.stl``              ``$CASE/geometry``
Simulink Model       ``*.slx``              ``$CASE``
Input File           ``wecSimInputFile.m``  ``$CASE``
==================== ====================== ====================

.. Note:: 
    Where ``*`` denotes a user-specified file name. 

Hydrodynamic Data
^^^^^^^^^^^^^^^^^

The Hydrodynamic coefficients for each body may be generated using a boundary 
element method (BEM) code (e.g., **WAMIT**, **NEMOH**, **AQWA**, or **CAPYTAINE**). The WEC-Sim 
code requires hydrodynamic data from the BEM solution in the form of HDF5 
format (``*.h5`` file). This ``*.h5`` hydrodynamic data file can be generated 
using the BEMIO pre-processor. BEMIO (Boundary Element Method Input/Output) is 
a code developed by the WEC-Sim team to process BEM output files from 
**WAMIT**, **NEMOH**, **AQWA**, and **CAPYTAINE** into a data structure than can be read by 
WEC-Sim. For more information about the BEMIO pre-processor, refer to the 
:ref:`user-advanced-features-bemio` section. 

Geometry File
^^^^^^^^^^^^^

The WEC-Sim code also requires a geometry file (``*.stl``) that defines the 
outer surface of the device. Most CAD programs can export a geometry as a 
``*.stl`` file. When running WEC-Sim with linear hydrodynamics, the ``*.stl`` 
is only used for the Simscape Mechanics Explorer visualization. However, when 
running WEC-Sim with nonlinear buoyancy and Froude-Krylov forces the mesh 
determines the instantaneous wetted surface at each time step. In this 
nonlinear case, the quality of the ``*.stl`` mesh is critical, refer to the 
:ref:`user-advanced-features-nonlinear` section for more information. 

Simulink Model 
^^^^^^^^^^^^^^

In addition to an input file, all WEC-Sim runs require a Simulink/Simscape 
model file (``*.slx``). This Simulink/Simscape model is defined using the 
WEC-Sim library blocks. Additional components or power take-off systems can be 
created in this file and coupled with the WEC geometry. 

An example Simulink model file for the OSWEC is shown below. For more 
information about the OSWEC, and how to build WEC-Sim Simulink models, refer to 
the :ref:`user-tutorials` section. 

.. figure:: /_static/images/OSWEC_Model.png
   :width: 200pt
   :align: center   

Input File
^^^^^^^^^^

A WEC-Sim input file (``wecSimInputFile.m``) is required for each run. The 
input file **MUST** be named ``wecSimInputFile.m`` and placed within the case 
directory. WEC-Sim uses `object orientated programming 
<https://uk.mathworks.com/discovery/object-oriented-programming.html>`__ to 
describe components of the WEC model; the main structure of the input file 
consists of initializing all the objects necessary to run WEC-Sim simulations 
and defining any user specified properties for each object. Specifically, the 
input file requires initialization and definition of the simulation and wave 
classes, at least one instance of the body class, and at least one instance of 
the constraint or PTO classes. For details about WEC-Sim's classes and 
available properties for each, refer to the 
:ref:`user-code-structure-classes` section. 

An example WEC-Sim input file is shown below for the OSWEC. Additional examples 
are provided in the :ref:`user-tutorials` section. WEC-Sim is an object 
oriented code and the input file reflects this by instantiating the WEC-Sim 
classes to create objects that are tied to the Simulink library. 

The WEC-Sim input file (``wecSimInputFile.m``) for the OSWEC example 
(``WEC-Sim/examples/OSWEC/``) initializes and 
specifies properties for the simulation, body, constraint and pto classes. 

.. literalinclude:: ../../tutorials/OSWEC/OSWEC_wecSimInputFile.m
   :language: matlab

.. _user-workflow-running-wec-sim:

Running WEC-Sim
---------------

This section provides a description of the steps to run the WEC-Sim code. Refer 
to the :ref:`WEC-Sim Workflow Diagram <user-workflow-chart>` while following 
the steps to run WEC-Sim. 

Step 1: Pre-Processing 
^^^^^^^^^^^^^^^^^^^^^^

In the pre-processing step, users need to create the WEC geometry, and run a 
BEM code to calculate the hydrodynamic coefficients. 

* **Create WEC Geometry**: 

   * Create CAD models of the WEC geometry and export it to a ``*.stl`` format. 
   * The ``*.stl`` files are used to visualize the WEC response in Simscape 
     Explorer
   * They are also used for :ref:`user-advanced-features-nonlinear` forces if 
     the option is enabled.

* **Compute Hydrodynamic Coefficients**: WEC-Sim requires frequency-domain 
  hydrodynamic coefficients (e.g. added mass, radiation damping, and wave 
  excitation). 

   * The coefficients for each body may be generated using a boundary element 
     method (BEM) code (e.g., **WAMIT**, **NEMOH**, **AQWA**, or **CAPYTAINE**). 
   * WEC-Sim requires that all hydrodynamic coefficients must be specified at 
     **the center of gravity** for each body.

Step 2: Generate Hydrodata File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this step, users run :ref:`BEMIO<user-advanced-features-bemio>` to convert 
the hydrodynamic coefficients from their BEM solution into the ``*.h5`` format 
for WEC-Sim to read: 

* **Run BEMIO**: to generate ``*.h5`` Hydrodynamic Coefficients for WEC-Sim

   * The hydrodynamic coefficients for each body generated from the BEM code 
     can be parsed into a ``*.h5`` data structure using 
     :ref:`BEMIO<user-advanced-features-bemio>`, which was developed by the 
     WEC-Sim team.
   * BEMIO currently supports WAMIT, NEMOH, AQWA, and CAPYTAINE. 

.. Note:: 
   * **If WAMIT is used:**
   
      * The origin of the body coordinate system (XBODY, defined in ``*.pot``) 
        as well as the mesh for each body must be at the center of gravity.
      * The WAMIT mesh (``*.gdf``) can be generated using 
        `Rhino <https://www.rhino3d.com>`_ or 
        `MultiSurf <http://www.aerohydro.com/WAMIT.htm>`_.
      * More details on WAMIT setup are given in the 
        `WAMIT User Manual <http://www.wamit.com/manual.htm>`_.

   * **If NEMOH is used:** 
   
      * The origin of the mesh for each body (``*.dat``) is located at the mean 
         water surface, which follows the same coordinate used in WEC-Sim. 
      * The location to output the hydrodynamic coefficients for each degree of 
        freedom is defined in the ``Nemoh.cal`` file.
      * Please refer to `NEMOH-Mesh <https://lheea.ec-nantes.fr/logiciels-et-brevets/nemoh-mesh-192932.kjsp?RH=1489593406974>`_ 
        webpage for more mesh generation details.
      * The NEMOH Mesh.exe code creates the ``Hydrostatics.dat`` and ``KH.dat`` 
        files (among other files) for one input body at a time. For the 
        Read_NEMOH function to work correctly in the case of a multiple body 
        system, the user must manually rename ``Hydrostatics.dat`` and 
        ``KH.dat`` files to ``Hydrostatics_0.dat``, ``Hydrostatics_1.dat``, …, 
        and ``KH_0.dat``, ``KH_1.dat``,…, corresponding to the body order 
        specified in the ``Nemoh.cal`` file.
      * More details on NEMOH setup are given in the 
        `Nemoh Homepage <https://lheea.ec-nantes.fr/logiciels-et-brevets/nemoh-running-192930.kjsp?RH=1489593406974>`_.
      
   * **If AQWA is used:** 
   
      * The origin of the global coordinate system is at the mean water 
        surface, and the origin of the body coordinate system for each body 
        must be at the center of gravity (defined using the AQWA GUI or in 
        the ``*.dat`` input file).
      * In order to run BEMIO, AQWA users must output both the default 
        ``*.LIS`` file and output the ``*.AH1`` hydrodynamic database file. 
        Both of these files are reacquired to run BEMIO. 
      * More details on AQWA setup are given in the AQWA Reference Manual.
      
   * **If CAPYTAINE is used:** 
   
      * The origin of the mesh for each body (``*.dat``) is located at the mean water surface, which follows the same coordinate used in WEC-Sim. 
      * More details on CAPYTAINE setup are given in the `Capytaine webpage <https://ancell.in/capytaine/latest/>`_.

.. Note::
    
    Users are also able to specify their own hydrodynamic coefficients by 
    creating their own ``*.h5`` file with customized hydrodynamic coefficients 
    following the ``*.h5`` format created by BEMIO.

.. Note:: 
    
    We recommend installing HDFview https://www.hdfgroup.org/downloads/hdfview/ 
    to view the ``*.h5`` files generated by BEMIO.

Step 3: Build Simulink Model
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this step, users build their WEC-Sim Simulink model (``*.slx``) using the 
:ref:`user-code-structure-library` developed in Simulink/Simscape. The 
``*.slx`` Simulink model file must be located in the ``$CASE`` directory. The 
figure below shows an example WEC-Sim Simulink model for the OSWEC tutorial. 

.. figure:: /_static/images/OSWEC_Model.png
   :width: 200pt
   :align: center

Step 4: Write wecSimInputFile.m
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The WEC-Sim input file must be located in the ``$CASE`` directory, and named 
``wecSimInputFile.m``. The figure below shows an example of a WEC-Sim input 
file. The input file specifies the simulation settings, body mass properties, 
wave conditions, joints, and mooring. Additionally, the WEC-Sim input file must 
specify the location of the WEC-Sim Simulink model (``*.slx``) file, the 
geometry file(s) ``*.stl``, and the hydrodynamic data file (``*.h5``) . 


Step 5: Run WEC-Sim
^^^^^^^^^^^^^^^^^^^

Lastly, WEC-Sim can be executed from the ``$CASE`` directory using the following methods:


* Run from MATLAB Command Window (for RM3 and OSWEC examples)
	* Type ``wecSim`` in the Command Window
* Run from Simulink (for RM3FromSimulink example)
	* Open the relevant WEC-Sim Simulink file
	* Type ``wecSimInitialize`` in the Command Window
	* Hit Play in Simulink model to run 

Refer to :ref:`user-tutorials-examples` for more details on how to run the examples. To customize or develop a new WEC-Sim model that runs from Simlunk (e.g. for Hardware-in-the-Loop, HIL, applications) refer to :ref:`user-advanced-features-simulink` for more information.

Users may also use ``wecSimMCR``, ``wecSimPCT``, ``wecSimFcn`` and  as described in the advanced features 
sections :ref:`user-advanced-features-mcr`, :ref:`user-advanced-features-pct`, and :ref:`user-advanced-features-fcn`. 
These options are only available in through the MATLAB Command Window.

.. Note:: The WEC-Sim source code is located in the ``$WECSIM`` directory, but 
	WEC-Sim must be executed from the ``$CASE`` directory. 
	The MATLAB path must include the WEC-Sim source directory.



