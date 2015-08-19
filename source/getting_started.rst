.. _getting_started:

Getting Started
===============
This section provides instructions on how to download and install the WEC-Sim code, the BEMIO preprocessing code, and how to run WEC-Sim simulations.

MATLAB Toolbox Requirements
------------------------------
WEC-Sim was developed in **MATLAB R2014b**, and requires the following toolboxes:

====================  ===================		
**Required Toolbox**  **Supported Version**
MATLAB		      Version 8.4 (R2014b)
Simulink              Version 8.4 (R2014b)
SimMechanics          Version 4.5 (R2014b)
Simscape              Version 3.12 (R2014b)
====================  ===================	

Ensure that the correct version of MATLAB and the required toolboxes are installed by typing ``ver`` in the MATLAB Command Window:

.. code-block:: matlabsession

	>> ver
	--------------------------------------------------------------------------------------
	MATLAB Version: 8.4.0.150421 (R2014b)
	MATLAB License Number: 844783
	Operating System: Mac OS X  Version: 10.9.5 Build: 13F34 
	Java Version: Java 1.7.0_55-b13 with Oracle Corporation Java HotSpot(TM) 
	64-Bit Server VM mixed mode
	--------------------------------------------------------------------------------------
	MATLAB                                                Version 8.4        (R2014b)
	Simulink                                              Version 8.4        (R2014b)
	SimMechanics                                          Version 4.5        (R2014b)
	Simscape                                              Version 3.12       (R2014b)

.. Note::

	WEC-Sim may work with other versions of MATLAB, but **MATLAB 2014b** is the only version that is currently supported.

Downloading and Installing BEMIO
-----------------------------------
BEMIO is the hydrodynamic data preprocessor that is required to run WEC-Sim. Instructions on how to download and install BEMIO are on the `BEMIO website <http://wec-sim.github.io/bemio/installing.html>`_

Downloading WEC-Sim
------------------------
WEC-Sim is distributed through the `WEC-Sim GitHub site <https://github.com/WEC-Sim/wec-sim>`_. There are three ways of obtaining the WEC-Sim code, each of which are described in this section.
 
Option 1: Clone with GitHub (Recommended for Users)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WEC-Sim can be obtained by cloning the repository with Git::

	git clone https://github.com/WEC-Sim/WEC-Sim

This method is recommended for most users because it makes it easy to update your local version of WEC-Sim to the latest version using Git's pull command::

	git pull

Option 2: Fork with Git (Recommended for Developers)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you are planning to contribute to the WEC-Sim code, please follow the `forking instructions <https://help.github.com/articles/fork-a-repo/>`_  provided by GitHub. Should you make improvements to the code that you would like included in the WEC-Sim master code, please make a `pull request <https://help.github.com/articles/using-pull-requests/>`_ so that your improvement can be merged into `WEC-Sim master <https://github.com/WEC-Sim/WEC-Sim>`_, and included in future releases.

Option 3: Static Code Download 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The easiest way to obtain a copy of WEC-Sim is to download the latest tagged release of the WEC-Sim code available on Github, `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.

.. Note::
	This is a static download of the WEC-Sim code. If you chose this method, you will have to re-download the code in order to receive code updates.


Installing WEC-Sim
---------------------
Once you have downloaded the WEC-Sim source code, follow the steps described in this section to install WEC-Sim.

.. Note::
	
	The folder where the WEC-Sim code is located will be refereed to as ``$WEC-SIM-SOURCE``.

Step 1: Add WEC-Sim Source Code to MATLAB Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the ``$WEC-SIM-SOURCE/wecSimStartup.m`` file

.. literalinclude:: _scripts/wecSimStartup.m
   :language: matlab

Copy the code in the ``wecSimStartup.m`` shown above and paste it into the ``startup.m`` file located in the `MATLAB Startup Folder <http://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html>`_. Set the ``wecSimPath`` variable to the ``$WEC-SIM-SOURCE`` folder, and open the ``startup.m`` file by executing ``open startup.m`` from the MATLAB Command Window. 

To verify the path was set up correctly, close and reopen MATLAB, and type the ``path`` command in the MATLAB Command Window to ensure that the WEC-Sim directory, ``$WEC-SIM-SOURCE``, is listed in the MATLAB Search Path:

.. code-block:: matlabsession

	>> path

		MATLABPATH

	/Users/username/Applications/WEC-Sim/source
	/Users/username/Applications/WEC-Sim/source/functions
	/Users/username/Applications/WEC-Sim/source/lib
	/Users/username/Applications/WEC-Sim/source/lib/WEC-Sim
	/Users/username/Applications/WEC-Sim/source/objects
	/Users/username/Applications/WEC-Sim
	/Users/username/Documents/MATLAB
	...


Step 2: Add WEC-Sim Library to Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the Simulink Library Browser by typing ``simulink`` in the MATLAB Command Window. Once the Simulink Library Browser opens, `Refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. The WEC-Sim Library of Body Elements, Constraints, Frames and PTOs should now be visible, as shown in the figure below. The WEC-Sim library should now be accessible every time Simulink is opened. For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

.. figure:: _static/WEC-Sim_Library.jpg
   :align: center
    
   ..
    
   *WEC-Sim Library*
   

Running WEC-Sim
-----------------------------
This section provides an overview of the WEC-Sim work flow. First the WEC-Sim file structure is described, then steps for setting up and running a WEC-Sim simulation are described. Detailed descriptions and options for input files parameters are described in the `Code Structure <http://wec-sim.github.io/WEC-Sim/code_structure.html>`_ section. Specific examples of using WEC-Sim to simulate WEC devices are presented in the `Tutorials <http://wec-sim.github.io/WEC-Sim/tutorials.html>`_ section.

.. Note::

	The location of the WEC-Sim case directory will be referred to as the ``$CASE`` directory in this document.

File Structure Overview
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All the information for a WEC-Sim run is contained within a case directory. Provided you have installed WEC-Sim correctly, this folder can be anywhere on your computer. The table below shows the structure for a case directory.

=================   ==========================  ====================
**Information**     **File name**               **Location**
Input file          wecSimInputFile.m           ``$CASE``
WEC Model           <WEC Model Name>.slx        ``$CASE``
Hydrodynamic Data   <hydro-data name>.h5       ``$CASE``/bemio
Geometry            <STL File Name>.stl         ``$CASE``/geometry
=================   ==========================  ====================



Steps To Run WEC-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The WEC-Sim work flow is shown in the figure below. We describe the steps for setting up and running a WEC-Sim simulations in the following:

.. figure:: _static/wecSimWorkflow.png
   :width: 400pt
   :align: center
       
   ..
       
   *WEC-Sim Workflow*

Step 1: Pre-Processing
++++++++++++++++++++++

In the pre-processing step, users need to create the model geometry, calculate the hydrodynamic coefficients and convert the hydrodynamic coefficients into HDF5 format for WEC-Sim read:

* Creating the device geometry using a CAD model: Users need to create representations of the WEC bodies to generate mesh for their hydrodynamic model and also need to export a their CAD model in STL format, which are used to visualize the WEC bodies in the WEC-Sim/MATLAB graphical user interface.
* Run the hydrodynamic model: WEC-Sim require pre-determined hydrodynamic coefficients. Typically, these hydrodynamic coefficients for each body of the WEC device are generated using a hydrodynamic model (e.g., WAMIT, NEMOH or AQWA).
* Run `BEMIO` to create WEC-Sim input hydrodynamic data file in HDF5 format: WEC-Sim will read the hydrodynamic data generated using a hydrodynamic model in HDF5 format (``<hydro-data name>.h5``). The boundary-element method input/output (`BEMIO`) was developed for this purpose. Currently, bemio accepts the hydrodynamic coefficients from WAMIT, NEMOH and AQWA. 

.. Note::
	* To ensure that WEC-Sim uses the correct hydrodynamic coefficients to model the WEC system, the hydrodynamic coefficients **must** be given at the center of gravity for each body. If WAMIT is used, the center of gravity for each body **must** be at the origin of the body coordinate system (XBODY) in WAMIT simulations. More details on WAMIT setup are given in the `WAMIT User Manual <http://www.wamit.com/manual.htm>`_.
	* Users are also allowed to specify their own hydrodynamic coefficients by modifying an existing HDF5 file or create their own HDF5 file with customized hydrodynamic coefficients following HDF5 format used in `BEMIO`.

Step2: Build WEC-Sim Simulink Model
++++++++++++++++++++++++++++++++++++++++++++++++++++

Next, the user must build the device model using the Simulink/SimMechanics toolboxes and the WEC-Sim Library. Figure below shows an example of a a two-body point absorber modeled in Simulink/SimMechanics.

.. figure:: _static/exampleWecModel.png
   :width: 400pt

Step 3: Setip WEC-Sim Input File
+++++++++++++++++++++++++++++++++++++++

A WEC-Sim input file needs to be created in the case directory, and it MUST be named ``wecSimInputFile.m``. An example of the input file for a two-body point absorber is shown in the following figure. In the input file, the simulation settings, sea state, body mass properties, PTO, and constraints are specified. In addition, users MUST specify the Simulink/SimMechanics model file name in the ``wecSimInputFile.m``, which is::

	   simu.simMechanicsFile=<WEC Model Name>.slx.

.. figure:: _static/runWECSim_mod.png
   :width: 400pt

Step 4: Execute WEC-Sim
++++++++++++++++++++++++++
Finally, execute the simulation by running the ``wecSim`` command from the MATLAB Command Window. The wecSim command must be executed in the WEC-Sim case directory where the ``wecSimInputFile.m`` is located.

.. Note::

	WEC-Sim simulations should always be executed from the MATLAB Command Window and no from the Simulink/SimMechanics model. This ensures that the correct variables are in the MATLAB workspace during simulation.