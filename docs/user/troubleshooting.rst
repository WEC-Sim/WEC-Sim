.. _user-troubleshooting:

Troubleshooting
===============
.. Topics to cover:
    - common download / installation issues
	- numerical workflow


The WEC-Sim development team actively maintains a `WEC-Sim Issues page <https://github.com/WEC-Sim/WEC-Sim/issues>`_ on GitHub. 
This issue page is upkept to assist users with immediate needs and to document all past issues.
In this way, it serves as a significant resource for users in solving WEC-Sim problems or clarifying its implementation.

If you have problems downloading, installing or using WEC-Sim please follow the troubleshooting guidelines on this page. 
Completing these steps will help users address their own questions and aid the development team in maintaining the issue board effectively.
Maintanence of an overwhelmed issue board takes time and effort away from WEC-Sim developments.
Please take the time to follow these steps before opening an issue on GitHub:

.. We also encourage users to address the issues of other users if they are confident in their knowledge of WEC-Sim. 


1. Personal Debugging
---------------------

Before opening an issue on GitHub, it is expected that users do a fair share of debugging.
WEC-Sim is intentionally easy to use and utilizes convenient MATLAB/Simulink interfaces. 
However, this ease of use does not detract from the difficulty and time required to create an accurate and robust simulation.
Users should spend time carefully setting up and debugging their WEC-Sim cases. For example:

- Follow all error codes to the root cause of the error 
- Confirm that all user-defined inputs are set correctly
- Confirm that WEC-Sim is called in the intended way (wecSim, wecSimMCR, wecSimPCT, from Simulink, etc)
- Check BEM input data for expected results
- If creating your own WEC-Sim case, go through the wave test cases below and check the common issues and solutions for each test.


2. Identify Root Cause
----------------------
Identify if MATLAB and Simulink, or WEC-Sim is the root cause of the problem.
Does the problem occur in a WEC-Sim class, function or Simulink model? If so, it may be a WEC-Sim error. 
Carefully check input file paths, especially when copying previously working WEC-Sim examples. 
Please do not submit issues for errors related to using MATLAB. 
The development team cannot provide support for MATLAB errors outside of WEC-Sim.


3. Review  Relevant Documentation
---------------------------------

Find the appropriate documentation section for solutions or clarification on a particular issue. 
The documentation is thorough and requires careful reading on sections relevant to your project.
If documentation in an area is lacking, please identify this in your GitHub issue so that we may improve WEC-Sim.


4. Search Closed WEC-Sim Issues
-------------------------------

In many cases, another user has had a similar issue before. 
Search the issues page and the below FAQ for topics that relate to your current problem.
If these are related but not sufficient, tag them in your GitHub issue for easy reference of the development team and future users.


5. Open an Issue
----------------

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
------------------------

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
--------------------------
This section highlights some of the frequently encountered issues when using WEC-Sim.
All FAQ information is available in closed GitHub issues, but is repeated here for convenience.

Solution Singularity
^^^^^^^^^^^^^^^^^^^^

Problem
~~~~~~~

The simulation is numerically unstable. Bodies may rise or fall indefinitely and have unphysical responses.
This occurs because there is an imbalance between the gravity and hydrostatic forces.
If the gravity force is much larger than the hydrostatic force, bodies may fall indefinitely. The result is opposite when gravity is too small.
An extremely large or small stiffness can also cause this problem. 
A small stiffness will not restore a body to an equilibrium position. 
A large stiffness may require a very small time step to be effective.

Possible error messages
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: none

	Derivative of state ... in block ... at time ... is not finite. 
	The simulation will be stopped. There may be a singularity in the solution

Solution
~~~~~~~~

Reevaluate the hydrostatic stability of the device.
Compare the mass and displaced volume of the device to evaluate if it will float properly.
Calculate an approximate stiffness that will restore the body to equilibrium in still water. 
Compare the mass, volume, and stiffness to those results in the BEM data.


Degenerate Mass Distribution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Problem
~~~~~~~

When two PTOs or Constraints are connected in series with no mass between them, Simulink attempts to connect two joints directly together.
Simulink cannot reconcile the forcing and motion between those joints without a mass between series joints.

Possible error messages
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: none

	... Joint has a degenerate mass distribution on its base/follower side.

Solution
~~~~~~~~

Add an insignificantly small mass (e.g. ``Simulink Library/Simscape/Multibody/Body Elements/Inertia``) between the two joints.
Alternatively, if special degrees of freedom are required create a new PTO or constraint using one of the many joints 
available in the Simscape Multibody Joints library.


Hydrodynamic Data File
^^^^^^^^^^^^^^^^^^^^^^

Problem
~~~~~~~

The path to the ``*.h5`` file does not exist or it is incomplete (size < 1kB).

Possible error messages
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: none

	The hdf5 file hydroData/*.h5 does not exist

.. code-block:: none

	This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file, or run \hydroData\bemio.m to generate a new *.h5 file

Solution
~~~~~~~~

Check the path to the \*.h5 file in the wecSimInputFile.m or run BEMIO for the source examples.


.. format
	problem name
	^^^^^^^^^^^^
	
	Problem
	~~~~~~~
	
	Description
	
	Possible error messages
	~~~~~~~~~~~~~~~~~~~~~~~
	
	.. code-block:: none
	
		Message
		
	Solution
	~~~~~~~~
	
	Description