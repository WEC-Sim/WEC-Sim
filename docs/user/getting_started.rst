.. _user-getting-started:

Getting Started
===============

This section provides instructions on how to download, install, and test the 
installation of WEC-Sim. 

MATLAB Requirements
-------------------

WEC-Sim is developed in MATLAB/Simulink, and requires the following toolboxes:
 
==========================  =============================
**Required Toolbox**        **Oldest Compatible Version**
MATLAB                      Version 9.7  (R2019a)
Simulink                    Version 10.0 (R2019a)
Simscape                    Version 4.7  (R2019a)
Simscape Multibody          Version 7.0  (R2019a)
==========================  =============================

WEC-Sim's Simulink Library is saved in MATLAB R2019a, so any newer MATLAB 
release should be compatible with WEC-Sim. Certain advanced features rely on 
external functions, such as :ref:`mooring-moordyn`, and 
additional MATLAB Toolboxes, such as :ref:`user-advanced-features-pct`. WEC-Sim 
tests are currently run on MATLAB 2020a, refer to :ref:`dev-overview-tests`. 

Verify that the correct version of MATLAB and required toolboxes are installed 
by typing ``ver`` in the MATLAB Command Window: 

.. code-block:: matlabsession

    >> ver
    -----------------------------------------------------------------------------------------------------
    MATLAB Version: 9.7.0.1434023 (R2019b) 
    -----------------------------------------------------------------------------------------------------
    MATLAB                                                Version 9.7         (R2019b)
    Simulink                                              Version 10.0        (R2019b)
    Simscape                                              Version 4.7         (R2019b)
    Simscape Multibody                                    Version 7.0         (R2019b)
    Parallel Computing Toolbox                            Version 7.1         (R2019b)


Download WEC-Sim
----------------

The WEC-Sim source code is hosted on the `WEC-Sim GitHub repository <https://github.com/WEC-Sim/wec-sim>`_. 
WEC-Sim users are recommended to clone the Github repository.
Developers who wish to contribute to WEC-Sim should see the corresponding Developer :ref:`dev-getting-started` section.
Cloning the repository allows users to easily pull the latest updates to the WEC-Sim source code.
These updates may improve the code's speed, accuracy and add additional functionality or advanced features.
The WEC-Sim source code can be cloned by installing `Git Large File Storage <https://git-lfs.github.com/>`_ (git lfs) to access large files (e.g. ``*.h5`` files), and `cloning <https://help.github.com/articles/cloning-a-repository/>`_ the WEC-Sim GitHub repository. 
To install WEC-Sim using `git 
<https://git-scm.com/>`_, in a git interface type:: 

    >> git lfs install
    >> git clone https://github.com/WEC-Sim/WEC-Sim

The local copy of WEC-Sim can easily be updated to the latest version of the 
code hosted on the GitHub repository by using the pull command:: 

    >> git pull

For new users who are new to git, it is recommended to go through examples on 
`GitHub <https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github>`_ 
or other sources while getting started. 

.. Note::
    Users may also download a static version of WEC-Sim from the latest tagged 
    `WEC-Sim Release <https://github.com/WEC-Sim/WEC-Sim/releases>`_.  This is 
    the easiest way to obtain the WEC-Sim code, however it is more difficult to 
    manually download future updates.

If you have problems downloading, installing or using WEC-Sim please submit a question to the 
`WEC-Sim Issues page <https://github.com/WEC-Sim/WEC-Sim/issues>`_.
When opening an issue, use one of the provided issue templates: 
bug report, feature request, theory or implementation, or WEC-Sim application.
Issue templates help the development team to quickly and thoroughly address questions.
Users who do not use a template will be asked to reopen their issue with the appropriate layout.


.. _user-install:

Install WEC-Sim
---------------

Once you have downloaded the WEC-Sim source code, take the following steps to 
install the WEC-Sim code. The directory where the WEC-Sim code is contained is 
referred to as ``$WECSIM`` (e.g. ``C:/User/Documents/GitHub/WEC-Sim``). 

Step 1. Add WEC-Sim to MATLAB Path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open the ``$WECSIM/source/wecSimStartup.m`` file.

.. literalinclude:: ../../source/wecSimStartup.m
   :language: matlab

Rename the ``wecSimStartup.m`` file ``startup.m`` and paste it into the `MATLAB 
Startup Folder <https://www.mathworks.com/help/matlab/ref/startup.html>`_. Set 
``<wecSim>`` to the ``$WECSIM/source`` directory, save the revised 
``startup.m`` file, and restart MATLAB. Verify the path was set up correctly by 
checking that the WEC-Sim source directory, ``$WECSIM/source``, is listed in 
the MATLAB search path. This is done by typing ``path`` in the MATLAB Command 
Window:: 

    >> path
    
            MATLABPATH
    
    C:/User/Documents/GitHub/WEC-Sim/source

The WEC-Sim source directory, ``$WECSIM/source``, and its subfolders should 
appear in this list. 

Step 2. Add WEC-Sim Library to Simulink
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open the Simulink Library Browser by typing ``slLibraryBrowser`` in the MATLAB 
Command Window::

    >> slLibraryBrowser

Once the Simulink Library Browser opens, `refresh the Simulink Library 
<http://www.mathworks.com/help/simulink/gui/use-the-library-browser.html>`_. 
The WEC-Sim Library (Body Elements, Constraints, Frames, Moorings, and PTOs) 
should now be visible, as shown in the figure below. The WEC-Sim Library will 
now be accessible every time Simulink is opened. For more information on using 
and modifying library blocks refer to the `Simulink Documentation 
<http://www.mathworks.com/help/simulink/>`_. 

.. figure:: /_static/images/WEC-Sim_Lib.PNG
   :align: center

   ..

Step 3. Test the Installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both users and contributors can test the installation using the following steps.
In the MATLAB Command Window type::
            
    >> cd $WECSIM/examples/RM3
    >> wecSim

This should run an example case using the Reference Model 3 (RM3) point 
absorber. A SimMechanics Explorer window will open within the MATLAB window, 
and figures will be generated displaying simulation outputs. 
Both the RM3 and the OSWEC examples (``$WECSIM/examples/OSWEC``) come ready-to-run and can be used once WEC-Sim is installed.

.. Note:: 
    
    If a git lfs error is produced, there was a problem with git-lfs 
    installation. You may need to manually install `Git Large File 
    Storage <https://git-lfs.github.com/>`_ , or run 
    ``$WECSIM/examples/RM3/hydroData/bemio.m`` to generate the correct 
    ``rm3.h5`` file.
