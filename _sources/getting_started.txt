.. _getting_started:

Getting Started
===============
This section provides instructions on how to download and install the WEC-Sim code.


MATLAB Toolbox Requirements
------------------------------
WEC-Sim was developed in **MATLAB R2015b**, and requires the following toolboxes:

	==========================  ====================		
	**Required Toolbox**        **Supported Version**
	MATLAB		            Version 8.6 (R2015b)
	Simulink                    Version 8.6 (R2015b)
	Simscape                    Version 3.14 (R2015b)
	SimMechanics   		    Version 4.7 (R2015b)
	==========================  ====================	

	Ensure that the correct version of MATLAB and the required toolboxes are installed by typing ``ver`` in the MATLAB Command Window:

	.. code-block:: matlabsession

		>> ver
		--------------------------------------------------------------------------------------
		MATLAB Version: 8.6.0.267246 (R2015b)
		--------------------------------------------------------------------------------------
		MATLAB                                                Version 8.6         (R2015b)
		Simulink                                              Version 8.6         (R2015b)
		SimMechanics                                          Version 4.7         (R2015b)
		Simscape                                              Version 3.14        (R2015b)

	.. Note::
		**SimMechanics** is now called **Simscape Multibody** in **R2016a**

Download WEC-Sim
------------------------
There are three ways of obtaining the WEC-Sim code which is distributed through the `WEC-Sim GitHub repository <https://github.com/WEC-Sim/wec-sim>`_: 
 
Option 1. Clone with GitHub (Recommended for Users)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	WEC-Sim can be obtained by locally `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the repository hosted on GitHub using the shell::

		>> git clone https://github.com/WEC-Sim/WEC-Sim

	This method is recommended for users because the local copy of WEC-Sim can easily be updated to the latest version of the code hosted on the GitHub repository by using the pull command::

		>> git pull

Option 2. Fork with Git (Recommended for Developers)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If you plan to contribute to the WEC-Sim code, please follow the `forking instructions <https://help.github.com/articles/fork-a-repo/>`_  provided by GitHub. Should you make improvements to the code that you would like included in the WEC-Sim master code, please submit a `pull request <https://help.github.com/articles/using-pull-requests/>`_. This pull request will then be reviewed, merged into `WEC-Sim master <https://github.com/WEC-Sim/WEC-Sim>`_, and included in future WEC-Sim releases.

Option 3. Static Code Download (Not Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	The easiest way to obtain a copy of WEC-Sim is to download the latest `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.

	.. Note::
		This is a static download of the WEC-Sim code. If you choose this method, you will have to re-download the code in order to receive code updates.


Install WEC-Sim
---------------------
Once you have downloaded the WEC-Sim source code, take the following steps to install the WEC-Sim code: 


Step 1. Add WEC-Sim Source Code to MATLAB Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Open the ``$wecSim/wecSimStartup.m`` file ($wecSim refers to WEC-Sim source code directory).

	.. literalinclude:: wecSimStartup.m
	   :language: matlab

	Copy the code in the ``wecSimStartup.m`` shown above and paste it into the ``startup.m`` file located in the `MATLAB Startup Folder <http://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html>`_. Set the ``wecSimPath`` variable to the ``$wecSim`` folder and open the ``startup.m`` file by typing ``open startup.m`` into the MATLAB Command Window: 

	.. code-block:: matlabsession

		>> open startup.m

	Verify the path was set up correctly by checking that the WEC-Sim source directory (``$wecSim``) is listed in the MATLAB. This is done by typing ``path`` into the MATLAB Command Window:

	.. code-block:: matlabsession

		>> path


Step 2. Add WEC-Sim Library to Simulink
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Open the Simulink Library Browser by typing ``slLibraryBrowser`` into the MATLAB Command Window:

	.. code-block:: matlabsession

		>> slLibraryBrowser

	Once the Simulink Library Browser opens, `refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. The WEC-Sim Library (Body Elements, Constraints, Frames Moorings, and PTOs) should now be visible, as shown in the figure below. The WEC-Sim Library should now be accessible every time Simulink is opened. For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

	.. figure:: _static/WEC-Sim_Library.jpg
	   :align: center

	   ..

	   *WEC-Sim Library*
	   
	   

.. Tutorials

.. include:: tutorials.rst
