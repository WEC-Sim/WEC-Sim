.. _user-getting-started:

Getting Started
===============

This section provides instructions on how to download and install WEC-Sim. 

MATLAB Requirements
-------------------

WEC-Sim is developed in MATLAB/Simulink, and requires the following toolboxes:
 
==========================  =============================
**Required Toolbox**        **Oldest Compatible Version**
MATLAB                      Version 9.9  (R2020b)
Simulink                    Version 10.2 (R2020b)
Simscape                    Version 5.0  (R2020b)
Simscape Multibody          Version 7.2  (R2020b)
==========================  =============================

WEC-Sim's Simulink Library is saved in MATLAB R2020b, and WEC-Sim tests are run on MATLAB R2020b and newer. 
Any version of MATLAB newer than R2020b should be compatible with WEC-Sim. 
The stability of each MATLAB release is available via `WEC-Sim's GitHub Actions <https://github.com/WEC-Sim/WEC-Sim/actions>`_. 
Certain advanced features rely on external functions (such as :ref:`mooring-moordyn`), and additional MATLAB Toolboxes (such as :ref:`user-advanced-features-pct`). 

Verify that the MATLAB required toolboxes are installed by typing ``ver`` in the MATLAB Command Window: 

.. code-block:: matlabsession

    >> ver
    -----------------------------------------------------------------------------------------------------
    MATLAB Version: 9.9.0.1592791 (R2020b) 
    -----------------------------------------------------------------------------------------------------
    MATLAB                                                Version 9.9         (R2020b)
    Simulink                                              Version 10.2        (R2020b)
    Simscape                                              Version 5.0         (R2020b)
    Simscape Multibody                                    Version 7.2         (R2020b)


Download WEC-Sim
----------------

The WEC-Sim source code is hosted on `WEC-Sim's GitHub repository <https://github.com/WEC-Sim/wec-sim>`_. 
WEC-Sim users should clone WEC-Sim's Github repository.
Cloning the repository allows users to easily pull the latest updates to the WEC-Sim source code.
The WEC-Sim source code can be cloned by installing `Git Large File Storage <https://git-lfs.github.com/>`_ (git lfs) to access large files (e.g. ``*.h5`` files), and `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the WEC-Sim GitHub repository. 

To install WEC-Sim using `git <https://git-scm.com/>`_:: 

    >> git lfs install
    >> git clone https://github.com/WEC-Sim/WEC-Sim

The local copy of WEC-Sim can easily be updated to include updates from the master version of the WEC-Sim source code hosted on the GitHub by using the git pull command:: 

    >> git pull origin master

For users who are new to git, it is recommended to go through examples on `GitHub <https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github>`_ or other sources while getting started. 
If you have problems downloading or installing please see the :ref:`user-troubleshooting` page.

For developers who wish to contribute to WEC-Sim, refer to the Developer :ref:`dev-getting-started` section.


.. Note::
    Users may also download a static version of WEC-Sim from the latest tagged 
    `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.  This is 
    the easiest way to obtain the WEC-Sim code, however users must manually 
    download new releases for updates.


.. _user-install:

Install WEC-Sim
---------------

Once you have downloaded the WEC-Sim source code, take the following steps to install WEC-Sim. 
The directory where the WEC-Sim source code is saved is referred to as ``$WECSIM`` (e.g. ``C:/User/Documents/GitHub/WEC-Sim``). 


Step 1. Add WEC-Sim to the MATLAB Path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To run WEC-Sim, the source directory must be on the MATLAB path. 
Users have two options to do this:

**Option 1. Automatically add the WEC-Sim source on MATLAB startup.**

Open ``$WECSIM/source/addWecSimSource.m`` and copy contents to a new file called ``startup.m``. 
Set the WEC-Sim  path to the local ``$WECSIM/source`` directory, e.g. ``wecSimSource = 'C:/User/Documents/GitHub/WEC-Sim/source``.
Save ``startup.m`` to the `MATLAB Startup Folder <https://www.mathworks.com/help/matlab/ref/startup.html>`_. 
Restart MATLAB, and the ``$WECSIM/source`` directory will automatically be added to the MATLAB path.


.. literalinclude:: ../../addWecSimSource.m
   :language: matlab


**Option 2. Manually add and remove the WEC-Sim source from the MATLAB path.**

This option requires users to run a script each time MATLAB is opened to add the WEC-Sim source directory to the path.
Navigate to the ``$WECSIM`` directory and run ``addWecSimSource``.
The ``$WECSIM/source`` directory will then be added to the MATLAB path for this instance of MATLAB.
To remove WEC-Sim from the path, run ``removeWecSimSource``. 


Step 2. Verify the Path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Verify the path was set up correctly by checking that the WEC-Sim source directory is listed in the MATLAB search path. 
The WEC-Sim source directory, ``$WECSIM/source``, and its subfolders should be listed. 
To view the MATLAB path, type ``path`` in the MATLAB Command Window:: 

    >> path
    
            MATLABPATH
    
    C:/User/Documents/GitHub/WEC-Sim/source



Step 3. Add WEC-Sim Library to Simulink
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open the Simulink Library Browser by typing ``slLibraryBrowser`` in the MATLAB 
Command Window::

    >> slLibraryBrowser

Once the Simulink Library Browser opens, `refresh the Simulink Library <http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. 
The WEC-Sim Library should now be visible, as shown in the figure below. 
The WEC-Sim Library will now be accessible every time Simulink is opened. 
For more information on using and modifying library blocks refer to the `Simulink Documentation <http://www.mathworks.com/help/simulink/>`_. 

.. figure:: /_static/images/WEC-Sim_Lib.PNG
   :align: center

   ..

Step 4. Test the Installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both users and contributors can test the installation using the following steps.
In the MATLAB Command Window type::
            
    >> cd $WECSIM/examples/RM3
    >> wecSim

This should run an example case using the Reference Model 3 (RM3) point absorber. 
A Mechanics Explorer window will open within the MATLAB window, and figures will be generated displaying simulation outputs. 
Both the RM3 and the OSWEC examples (``$WECSIM/examples/OSWEC``) come ready-to-run and can be used once WEC-Sim is installed.

.. Note:: 
    
    If a git lfs error is produced, there was a problem with git-lfs 
    installation. You may need to manually install `Git Large File 
    Storage <https://git-lfs.github.com/>`_ , or run 
    ``$WECSIM/examples/RM3/hydroData/bemio.m`` to generate the correct 
    ``rm3.h5`` file.

