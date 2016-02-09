.. _getting_started:

Getting Started
===============
This section provides instructions on how to download and install the `WEC-Sim <https://github.com/WEC-Sim/WEC-Sim>`_ code, the `BEMIO <https://github.com/WEC-Sim/bemio>`_ preprocessing code, and how to run WEC-Sim simulations.

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

.. literalinclude:: wecSimStartup.m
   :language: matlab

Copy the code in the ``wecSimStartup.m`` shown above and paste it into the ``startup.m`` file located in the `MATLAB Startup Folder <http://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html>`_. Set the ``wecSimPath`` variable to the ``$WEC-SIM-SOURCE`` folder, and open the ``startup.m`` file by executing ``open startup.m`` from the MATLAB Command Window. 

.. code-block:: matlabsession

	>> open startup.m

To verify the path was set up correctly, close and reopen MATLAB, and type the ``path`` command in the MATLAB Command Window to ensure that the WEC-Sim directory, ``$WEC-SIM-SOURCE``, is listed in the MATLAB Search Path:

.. code-block:: matlabsession

	>> path

		MATLABPATH

	/Users/username/Github/WEC-Sim/source
	/Users/username/Github/WEC-Sim/source/functions
	/Users/username/Github/WEC-Sim/source/lib
	/Users/username/Github/WEC-Sim/source/lib/WEC-Sim
	/Users/username/Github/WEC-Sim/source/objects
	/Users/username/Github/WEC-Sim
	/Users/username/Documents/MATLAB
	...


Step 2: Add WEC-Sim Library to Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the Simulink Library Browser by typing ``simulink`` in the MATLAB Command Window. 

.. code-block:: matlabsession

	>> simulink
	
Once the Simulink Library Browser opens, `Refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. The WEC-Sim Library of Body Elements, Constraints, Frames and PTOs should now be visible, as shown in the figure below. The WEC-Sim library should now be accessible every time Simulink is opened. For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

.. figure:: _static/WEC-Sim_Library.jpg
   :align: center
    
   ..
    
   *WEC-Sim Library*
   

