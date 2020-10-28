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
----------------
The WEC-Sim source code is hosted on the `WEC-Sim GitHub repository <https://github.com/WEC-Sim/wec-sim>`_. 
There are three ways of obtaining the WEC-Sim code, detailed below.
 
Option 1: Clone Repository from GitHub 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This option is recommended for WEC-Sim users. 
The WEC-Sim source code can be obtained by installing `Git Large File Storage <https://git-lfs.github.com/>`_ (git lfs) to access large files (e.g. ``*.h5`` files), and `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the WEC-Sim GitHub repository. 
To install WEC-Sim using `git <https://git-scm.com/>`_::

	>> git lfs install
	>> git clone https://github.com/WEC-Sim/WEC-Sim

This option is recommended for users because the local copy of WEC-Sim can easily be updated to the latest version of the code hosted on the GitHub repository by using the pull command::

	>> git pull

Option 2: Fork Repository on GitHub 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This option is recommended for WEC-Sim developers. If you plan to contribute to the WEC-Sim code, please follow the `forking instructions <https://help.github.com/articles/fork-a-repo/>`_  provided by GitHub. If you make improvements to the code that you would like included in the WEC-Sim master code, please submit a `pull request <https://help.github.com/articles/using-pull-requests/>`_. This pull request will then be reviewed, merged into `WEC-Sim master <https://github.com/WEC-Sim/WEC-Sim>`_, and included in future WEC-Sim releases.


Option 3: Static Code Download 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The easiest way to obtain a copy of WEC-Sim is to download the latest tagged `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_. 
This option is not recommended because is a static download of the WEC-Sim code. 
If you choose this option, you will have to manually download the WEC-Sim code in order to receive updates.


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
The WEC-Sim Library (Body Elements, Constraints, Frames Moorings, and PTOs) should now be visible, as shown in the figure below. 
The WEC-Sim Library will now be accessible every time Simulink is opened. 
For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_.

.. figure:: /_static/images/WEC-Sim_Lib.PNG
   :align: center

   ..


Step 3. Test the Installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In the MATLAB Command Window type::
			
	>> cd $WECSIM/examples/RM3
	>> wecSim
	
	
This should run an example case using the Reference Model 3 (RM3) point absorber. 
A SimMechanics Explorer window will open within the MATLAB window, and figures will be generated displaying simulation outputs. 


.. Note:: 
	
	If a git lfs error is produced, there was a problem with git-lfs installation. You may need to manually install `Git Large File Storage <https://git-lfs.github.com/>`_ , or run ``$WECSIM/examples/RM3/hydroData/bemio.m`` to generate the correct ``rm3.h5`` file.
.. 
	``This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file,`` ``or run ./hydroData/bemio.m to generate a new *.h5 file.``
	
	
