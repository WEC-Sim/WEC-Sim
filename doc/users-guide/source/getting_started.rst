.. _getting_started:

Getting Started
===============
This section provides instructions on how to install `WEC-Sim` and the `bemio` preprocessing code and how to run `WEC-Sim` simulations.

MATLAB Requirements
---------------------
`WEC-Sim` was developed in MATLAB and running `WEC-Sim` requires MATLAB R2014b and the following toolboxes:

==================  ===================		
**Matlab Toolbox**  **Recommended Version**
Simulink            R2014b Version 8.4
SimMechanics        R2014b Version 4.5
Simscape            R2014b Version 3.12
==================  ===================	

Ensure that the correct version of MATLAB and the required toolboxes are installed by using MATLAB's ``ver`` command:

.. code-block:: matlabsession

	>> ver
	----------------------------------------------------------------------------------------------------
	MATLAB Version: 8.4.0.150421 (R2014b)
	MATLAB License Number: 844783
	Operating System: Mac OS X  Version: 10.9.5 Build: 13F34 
	Java Version: Java 1.7.0_55-b13 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
	----------------------------------------------------------------------------------------------------
	MATLAB                                                Version 8.4        (R2014b)
	Simulink                                              Version 8.4        (R2014b)
	SimMechanics                                          Version 4.5        (R2014b)
	Simscape                                              Version 3.12       (R2014b)

.. Note::

	`WEC-Sim` may work in earlier or later versions of MATLAB, but MATLAB 2014b is highly recommended for the best user experience.

Downloading and Installing `bemio`
-----------------------------------
`bemio` is the hydrodynamic data preprocessor and is required to run WEC-Sim. Instructions for how to download and install `bemio` can be found on the `bemio GitHub web site <http://wec-sim.github.io/bemio/>`_

Downloading `WEC-Sim`
------------------------
`WEC-Sim` is distributed through the `WEC-Sim` GitHub web page <https://github.com/WEC-Sim/wec-sim>`_. The three ways of obtaining the `WEC-Sim` are described in this section.
 
Clone with Git (Recommended for Users)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
``WEC-Sim`` can be obtained by cloning the repository with Git::

	git clone https://github.com/WEC-Sim/wec-sim.git

This method is recommended for most users because it makes it easy to update your local version of ``WEC-Sim`` to the latest version using Git's pull command::

	git pull

Fork with Git (Recommended for Developers)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you are planning to contribute to the ``WEC-Sim`` code base, please follow the `forking instructions provided by GitHub <https://help.github.com/articles/fork-a-repo/>`_. If you implement an improvement you would like included in the ``WEC-Sim`` code base please make a `pull request <https://help.github.com/articles/using-pull-requests/>`_ so that your improvement can be merged into the code base.

Download code archive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The easiest way to obtain a copy of ``WEC-Sim`` is to download the code archive:

* `WEC-Sim`-1.0 <>`_. FIX THIS LINK.

If you chose this method you will have to re-download the code in order to receive code updates.

Installing WEC-Sim
---------------------
Once you have obtained the WEC-Sim source code follow the steps described in this section to install WEC-Sim.

.. Note::
	
	The folder where the WEC-Sim code is located will be refereed to as the ``$WEC-SIM-SOURCE``.

Step 1: Add `WEC-Sim` Source Code to MATLAB Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the ``$WEC-SIM-SOURCE/wecSimStartup.m`` file

.. literalinclude:: ../../../source/wecSimStartup.m
   :language: matlab

Copy the code in the ``wecSimStartup.m`` shown above and paste it into the ``startup.m`` file within the `MATLAB Startup Folder <http://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html>`_. You can open the ``startup.m`` file by executing ``open startup.m`` from the MATLAB command line. Set the ``wecSimPath`` variable to the ``$WEC-SIM-SOURCE`` folder. 

To verify you have performed this process correctly, close and reopen MATLAB, and type the ``path`` command in the command window to ensure that the `WEC-Sim` directory is listed in the MATLAB Search Path:

.. code-block:: matlabsession

	>> path

		MATLABPATH

	/Users/mlawson/Applications/WEC-Sim/source
	/Users/mlawson/Applications/WEC-Sim/source/functions
	/Users/mlawson/Applications/WEC-Sim/source/lib
	/Users/mlawson/Applications/WEC-Sim/source/lib/WEC-Sim
	/Users/mlawson/Applications/WEC-Sim/source/objects
	/Users/mlawson/Applications/WEC-Sim
	/Users/mlawson/Documents/MATLAB
	...


Step 2: Add `WEC-Sim` Library to Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Open the Simulink Library Browser by typing ``simulink`` from the MATLAB Command Window. Once the Simulink Library Browser opens, `Refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html?searchHighlight=simulink%20Refresh%20the%20Library%20Browser>`_. The `WEC-Sim` Library of Body Elements, Constraints, Frames and PTOs should now be visible (as shown below). The `WEC-Sim` library should now be accessible every time Simulink is opened. For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.


