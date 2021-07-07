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


.. _user-troubleshooting:

Troubleshooting WEC-Sim
-----------------------
.. Topics to cover:
    - Github Issues, templates and PRs
    - Steps before opening issue:
        - Personal debugging expectations
        - Identify if matlab/simulink error vs WEC-Sim error (paths!)
        - Identify relevant documentation section for answers
        - search previous issues for solutions


The WEC-Sim development team actively maintains a `WEC-Sim Issues page <https://github.com/WEC-Sim/WEC-Sim/issues>`_ on GitHub. 
This issue page is upkept to assist users with immediate needs and to document all past issues.
In this way, it serves as a significant resource for users in solving WEC-Sim problems or clarifying its implementation.

If you have problems downloading, installing or using WEC-Sim please follow the troubleshooting guidelines on this page. 
Completing these steps will help users address their own questions and aid the development team in maintaining the issue board effectively.
Maintanence of an overwhelmed issue board takes time and effort away from WEC-Sim developments.
Please take the time to follow these steps before opening an issue on GitHub:

.. We also encourage users to address the issues of other users if they are confident in their knowledge of WEC-Sim. 


1. Personal Debugging
^^^^^^^^^^^^^^^^^^^^^

Before opening an issue on GitHub, it is expected that users do a fair share of debugging.
WEC-Sim is intentionally easy to use and utilizes convenient MATLAB/Simulink interfaces. 
However, this ease of use does not detract from the difficulty and time required to create an accurate and robust simulation.
Users should spend time carefully setting up and debugging their WEC-Sim cases. For example:

- Follow all error codes to the root cause of the error 
- Confirm that all user-defined inputs are set correctly
- Confirm that WEC-Sim is called in the intended way (wecSim, wecSimMCR, wecSimPCT, from Simulink, etc)
- Check BEM input data for expected results
- If creating your own WEC-Sim case, go through the 


2. Identify Root Cause
^^^^^^^^^^^^^^^^^^^^^^
Identify if MATLAB and Simulink, or WEC-Sim is the root cause of the problem.
Does the problem occur in a WEC-Sim class, function or Simulink model? If so, it may be a WEC-Sim error. 
Carefully check input file paths, especially when copying previously working WEC-Sim examples. 
Please do not submit issues for errors related to using MATLAB. 
The development team cannot provide support for MATLAB errors outside of WEC-Sim.


3. Review  Relevant Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Find the appropriate documentation section for solutions or clarification on a particular issue. 
The documentation is thorough and requires careful reading on sections relevant to your project.
If documentation in an area is lacking, please identify this in your GitHub issue so that we may improve WEC-Sim.


4. Search Closed WEC-Sim Issues
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In many cases, another user has had a similar issue before. 
Search the issues page and the below FAQ for topics that relate to your current problem.
If these are related but not sufficient, tag them in your GitHub issue for easy reference of the development team and future users.


5. Open an Issue
^^^^^^^^^^^^^^^^

If the above steps do not solve your problem, please open an issue using one of the provided templates: bug report, feature request, theory or implementation, or WEC-Sim application.
Issue templates serve to layout the information required to solve an issue in a consistent, upfront manner. 
Templates are new to the WEC-Sim workflow, and input on their use is welcome. 
The development team hopes this will help address questions as quickly and thoroughly as possible for users.

Users may remove all italic descriptive text in a template, but must keep the bold headers that organize the issue.
Users who do not use a template will be asked to reopen their issue with the appropriate layout.
If the provided templates do not fit an issue, users may open a blank issue with an initial statement explaining why there is no template and providing sufficient information.

When opening an issue, please provide all relevant information. 
Link to the relevant documentation section and past issues, and upload a case file whenever possible.


Notes on the Issue Board
^^^^^^^^^^^^^^^^^^^^^^^^
Unfortunately, the WEC-Sim development team does not have the time and funding to address issues outside of WEC-Sim.
The following topics cannot be addressed when there is not a direct relation to WEC-Sim code, theory or implementation: 

- MATLAB/Simulink/Simscape-based issues
- general hydrodynamics questions
- performing tasks for a user's case, i.e. supplying nonlinear meshes or \*.h5 files
- running BEM codes
- use or development of BEM codes

The issue board is provided as a convenience to users and the development team makes every effort to respond to issues each week. 
Issues are not addressed over weekends nor U.S. holidays.
Users should not expect nor request an immediate response from the developers.


Frequently Asked Questions
^^^^^^^^^^^^^^^^^^^^^^^^^^
This section highlights some of the frequently encountered issues when using WEC-Sim.
All FAQ information is available when searching closed GitHub issues but is repeated here for convenience.

Solution Singularity
~~~~~~~~~~~~~~~~~~~~

**Problem**

The simulation is numerically unstable. Bodies may rise or fall indefinitely and have unphysical responses.
This occurs because there is an imbalance between the gravity and hydrostatic forces.
If the gravity force is much larger than the hydrostatic force, bodies may fall indefinitely. The result is opposite when gravity is too small.
An extremely large or small stiffness can also cause this problem. 
A small stiffness will not restore a body to an equilibrium position. 
A large stiffness may require a very small time step to be effective.

**Possible error messages**

.. code-block:: none

	Derivative of state ... in block ... at time ... is not finite. 
	The simulation will be stopped. There may be a singularity in the solution

**Solution**

Reevaluate the hydrostatic stability of the device.
Compare the mass and displaced volume of the device to evaluate if it will float properly.
Calculate an approximate stiffness that will restore the body to equilibrium in still water. 
Compare the mass, volume, and stiffness to those results in the BEM data.


Degenerate Mass Distribution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Problem**

When two PTOs or Constraints are connected in series with no mass between them, Simulink attempts to connect two joints directly together.
Simulink cannot reconcile the forcing and motion between those joints without a mass between series joints.

**Possible error messages**

.. code-block:: none

	... Joint has a degenerate mass distribution on its base/follower side.

**Solution**

Add an insignificantly small mass (e.g. ``Simulink Library/Simscape/Multibody/Body Elements/Inertia``) between the two joints.
Alternatively, if special degrees of freedom are required create a new PTO or constraint using one of the many joints 
available in the Simscape Multibody Joints library.


Hydrodynamic Data File
~~~~~~~~~~~~~~~~~~~~~~

**Problem**

The path to the ``*.h5`` file does not exist or it is incomplete (size < 1kB).

**Possible error messages**

.. code-block:: none

	The hdf5 file hydroData/*.h5 does not exist

.. code-block:: none

	This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file, or run \hydroData\bemio.m to generate a new *.h5 file

**Solution**

Check the path to the \*.h5 file in the wecSimInputFile.m or run BEMIO for the source examples.


.. format
	problem name
	~~~~~~~~~

	**Problem**

	Description

	**Possible error messages**

	.. code-block:: none

		Message

	**Solution**

	Description