.. _getting_started:

Getting Started
===============
This section provides instructions on how to download, install, and test the WEC-Sim code.


MATLAB Requirements
------------------------------
WEC-Sim is developed in MATLAB/Simulink, and requires the toolboxes listed below. 
WEC-Sim's Simulink Library is saved in MATLAB version R2015b, so any newer MATLAB release should be compatible with WEC-Sim.
Certain advanced features relying on external functions, such as :ref:`man/advanced_features:moordyn`, may not be compatible with older versions of MATLAB. 
Full functionality has been verified on 2018a through 2019b. 
 
==========================  ============================		
**Required Toolbox**        **Oldest Compatible Version**
MATLAB		            Version 8.6  (R2015b)
Simulink                    Version 8.6  (R2015b)
Simscape                    Version 3.14 (R2015b)
Simscape Multibody   	    Version 4.7  (R2015b)
==========================  ============================	
	

Ensure that the correct version of MATLAB and the required toolboxes are installed by typing ``ver`` in the MATLAB Command Window:

.. code-block:: matlabsession

	>> ver
	--------------------------------------------------------------------------------------
	MATLAB Version: 9.5.0.944444 (R2018b)
	--------------------------------------------------------------------------------------
	MATLAB                                                Version 9.5         (R2018b)
	Simulink                                              Version 9.2         (R2018b)
	Simscape                                              Version 4.5         (R2018b)
	Simscape Multibody                                    Version 6.0         (R2018b)		



Download WEC-Sim
------------------------------
The WEC-Sim source code is hosted on the `WEC-Sim GitHub repository <https://github.com/WEC-Sim/wec-sim>`_. 
The best way to install the code depends on if one is a user or wants to contribute to WEC-Sim development. These options are detailed below.

 
User Instructions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim users are recommended to clone the Github repository. This allows users to easily pull the latest updates to the WEC-Sim source code. These updates may improve the code's speed, accuracy and add additional functionality or advanced features.
The WEC-Sim source code can be cloned by installing `Git Large File Storage <https://git-lfs.github.com/>`_ (git lfs) to access large files (e.g. ``*.h5`` files), and `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the WEC-Sim GitHub repository. 
To install WEC-Sim using `git <https://git-scm.com/>`_:, in a git interface type:

	>> git lfs install
	>> git clone https://github.com/WEC-Sim/WEC-Sim

The local copy of WEC-Sim can easily be updated to the latest version of the code hosted on the GitHub repository by using the pull command::

	>> git pull

For new users who are new to git, it is recommended to go through examples on `GitHub <https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github>`_ or other sources while getting started. If you have problems downloading, installing or using WEC-Sim please submit a question to the `WEC-Sim Issues page <https://github.com/WEC-Sim/WEC-Sim/issues>`_.

.. Note:
	Users may also download a static version of WEC-Sim from the latest tagged `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.  This is the easiest way to obtain the WEC-Sim code, however it is more difficult to manually download future updates.


Developer Instructions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
WEC-Sim developers are recommended to fork the GitHub repository. If you plan to contribute to the WEC-Sim code, please fork the official `WEC-Sim repository <https://github.com/WEC-Sim/WEC-Sim>`_. 
This method allows you to create a personal copy of the WEC-Sim repository, which can be freely edited without changing the official repository.
It is easily compared to the main repository when pushing changes or pulling updates.

Once you have forked the code on GitHub, navigate in the git command line to the desired directory. Clone the fork:

	>> git clone https://github.com/YOUR-USERNAME/WEC-Sim/

Push local commits to GitHub:

	>> git push origin BRANCH

To sync your fork with the official repository, add a remote:

	>> git remote add upstream https://github.com/WEC-Sim/WEC-Sim.git

Once the upstream repository is set, pull updates to WEC-Sim:

	>> git pull upstream master


For details on creating and using a fork, see the `forking instructions <https://help.github.com/articles/fork-a-repo/>`_  provided by GitHub.

If you make improvements to the code that you would like included in the WEC-Sim master code, please submit a `pull request <https://help.github.com/articles/using-pull-requests/>`_. This pull request will then be reviewed, merged into the `WEC-Sim development branch <https://github.com/WEC-Sim/WEC-Sim>`_, and included in future WEC-Sim releases. For more details see :ref:`man/overview:WEC-Sim Development`.


Install WEC-Sim
---------------------
Once you have downloaded the WEC-Sim source code, take the following steps to install the WEC-Sim code.
The directory where the WEC-Sim code is contained is referred to as ``$WECSIM`` (e.g. ``C:/User/Documents/GitHub/WEC-Sim``).

Step 1. Add WEC-Sim to MATLAB Path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Open the ``$WECSIM/source/wecSimStartup.m`` file.


.. literalinclude:: ../../source/wecSimStartup.m
   :language: matlab

Rename the ``wecSimStartup.m`` file ``startup.m`` and paste it into the `MATLAB Startup Folder <https://www.mathworks.com/help/matlab/ref/startup.html>`_. 
Set ``<wecSim>`` to the ``$WECSIM/source`` directory, save the revised ``startup.m`` file, and restart MATLAB. 
Verify the path was set up correctly by checking that the WEC-Sim source directory, ``$WECSIM/source``, is listed in the MATLAB search path. 
This is done by typing ``path`` in the MATLAB Command Window::

	>> path
	
			MATLABPATH
	
	C:/User/Documents/GitHub/WEC-Sim/source


The WEC-Sim source directory, ``$WECSIM/source``, and its subfolders should appear in this list. 
	
	
Step 2. Add WEC-Sim Library to Simulink
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Open the Simulink Library Browser by typing ``slLibraryBrowser`` in the MATLAB Command Window::

	>> slLibraryBrowser

Once the Simulink Library Browser opens, `refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. 
The WEC-Sim Library (Body Elements, Constraints, Frames, Moorings, and PTOs) should now be visible, as shown in the figure below. 
The WEC-Sim Library will now be accessible every time Simulink is opened. 
For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

.. figure:: /_static/images/WEC-Sim_Lib.PNG
   :align: center

   ..


Step 3. Test the Installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Both users and contributors can test the installation using the following steps. 
In the MATLAB Command Window type::
			
	>> cd $WECSIM/examples/RM3
	>> wecSim
	
	
This should run an example case using the Reference Model 3 (RM3) point absorber. 
A SimMechanics Explorer window will open within the MATLAB window, and figures will be generated displaying simulation outputs. 

.. Note:: 
	
	If a git lfs error is produced, there was a problem with git-lfs installation. You may need to manually install `Git Large File Storage <https://git-lfs.github.com/>`_ , or run ``$WECSIM/examples/RM3/hydroData/bemio.m`` to generate the correct ``rm3.h5`` file.
.. 
	``This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file,`` ``or run ./hydroData/bemio.m to generate a new *.h5 file.``
	
	
