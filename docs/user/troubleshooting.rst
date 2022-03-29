.. _user-troubleshooting:

Troubleshooting
===============

WEC-Sim Issues
---------------
The WEC-Sim development team actively maintains the `WEC-Sim Issues page <https://github.com/WEC-Sim/WEC-Sim/issues>`_ on GitHub. 
This issue page is maintained to assist users and past issues.
In this way, it serves as a significant resource for users in solving WEC-Sim problems or clarifying its implementation.

If you have problems downloading, installing, or using WEC-Sim please follow the debugging steps on this page. 
Completing these steps will help users address their own questions and aid the development team in maintaining the issue board effectively.
Please take the time to follow these steps before opening an issue on GitHub.


Note on the Issue Board
^^^^^^^^^^^^^^^^^^^^^^^^

Unfortunately, the WEC-Sim development team does not have the time and funding to address issues outside of WEC-Sim.
The following topics cannot be addressed when there is not a direct relation to WEC-Sim code, theory, or implementation: 

- MATLAB/Simulink/Simscape-based issues
- general hydrodynamics questions
- performing tasks for a user's case, i.e. supplying nonlinear meshes, \*.h5 files, BEM results
- running BEM software
- use or development of BEM software

The issue board is provided as a convenience to users and the development team makes every effort to respond to issues in a timely manner. 
However, users should not expect nor request an immediate response from the developers.



Debugging
---------------------

Before opening an issue on GitHub, it is expected that users do a fair share of debugging.
WEC-Sim is intentionally easy to use and utilizes convenient MATLAB/Simulink interfaces. 
However, this ease of use does not detract from the difficulty and time required to create an accurate and robust simulation.
Users should spend time carefully setting up and debugging their WEC-Sim cases. For example:

- Follow all error codes to the root cause of the error 
- Confirm that all user-defined inputs are set correctly
- Confirm that WEC-Sim is called in the intended way (wecSim, wecSimMCR, wecSimPCT, from Simulink, etc)
- When running a WEC-Sim example (e.g. OSWEC, RM3) carefully compare to the working examples before opening an issue
- Check BEM input data for expected results, referring to the notes in the BEMIO figures
- If creating your own WEC-Sim case, go through the wave test cases below. Check the common issues and solutions for each test.


Identify Root Cause
^^^^^^^^^^^^^^^^^^^^^
Identify if MATLAB and Simulink, or WEC-Sim is the root cause of the problem.
Does the problem occur in a WEC-Sim class, function, or Simulink model? If so, it may be a WEC-Sim error. 
Carefully check input file paths, especially when copying previously working WEC-Sim examples. 
Please do not submit issues for errors related to using MATLAB. 
The development team cannot provide support for MATLAB errors outside of WEC-Sim.


Review Relevant Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Read the appropriate documentation section for solutions or clarification on use of a particular feature. 
The documentation is thorough but requires careful reading of relevant sections.
If documentation in an area is lacking, please identify this in a GitHub issue so that we may improve WEC-Sim.


Search WEC-Sim Issues
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In many cases, another user has had a similar issue before. 
Search the issues page (both open and closed) and the below FAQ for topics that relate to your current problem.
If these are related but insufficient, tag them in your GitHub issue for as references for the development team and future users.


Open an Issue
^^^^^^^^^^^^^^^^^^^^^

If the above steps do not solve your problem, please open an issue using one of the provided templates: bug report, feature request, theory or implementation, or WEC-Sim application.
Issue templates serve to layout the information required to solve an issue in a consistent, up front manner. 
Templates are new to the WEC-Sim workflow, and input on their use is welcome. 
The development team hopes this will help address questions as quickly and thoroughly as possible for users.

Users may remove all italic descriptive text in a template, but must keep the bold headers that organize the issue.
Users who do not use a template will be asked to reopen their issue with the appropriate layout.
If the provided templates do not fit an issue, users may open a blank issue with an initial statement explaining why there is no template and providing sufficient information.

When opening an issue, please provide all relevant information. 
Link to the relevant documentation section and past issues, and upload a case file whenever possible.



Numerical Test Cases
--------------------
This section describe a series of numerical test cases that should be performed when creating a novel WEC-Sim case.
These various wave cases are necessary to ensure a robust, accurate solution and speed the debugging process for users.
When opening a support question for case development, users will be asked to supply information on which test cases are functioning or not.
Note that this workflow is not foolproof, but can be used as a guide to create a more robust WEC-Sim case.

======  =================================  =========================
Number  Purpose                            Input parameters utilized
======  =================================  =========================
1A      Hydrostatic stability              noWave
1B      Hydrostatic stability              noWaveCIC
2A      Free Decay, hydrostatic stiffness  noWave, initial
2B      Free Decay, hydrostatic stiffness  noWaveCIC, initial
3A      Viscous drag                       regular
3B      Viscous drag                       regularCIC
4A      Full functionality                 irregular, initial
======  =================================  =========================

Various problems may occur while progressing through these test cases.
Users should not advance to the next test unless the previous tests run without error and result in a physical response.

Hydrostatic Stability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Issues with Test 1A-B indicate there is an imbalance between the gravity and buoyant forces. 
This may cause the "solution singularity" as described in the FAQ, or result in a body rising or falling indefinitely.
To solve this problem, recalculate the mass that will balance the displaced volume from the BEM data.
Alternatively utilize the ``body(#).mass = equilibrium`` option.

Free Decay
^^^^^^^^^^^^^^

Failure in Test 2 but not Test 1 indicates an inaccurate hydrostatic stiffness.
The hydrostatic stiffness returns a device to equilibrium after some displacement.
If the stiffness is too large, the simulation may require a very small time step. 
If too small, an initial displacement may cause infinite motion.
Reevaluate the BEM input or tune the stiffness with ``body(#).hydroStiffness`` in the input file.

Viscous Drag
^^^^^^^^^^^^^^

A hydrostatically stable device that has an unphysical response to a regular wave requires improved drag and damping.
BEM codes inherently assume inviscid flow. Recreating the effects of viscous drag in WEC-Sim is essential to obtaining a physical response.
Tune the parameters ``body(#).quadDrag`` or ``body(#).linearDamping`` to create a realistic response to a regular wave.

Irregular Waves
^^^^^^^^^^^^^^^^^^^^^

If Test 4 fails, users should check that the IRF decays to zero in BEMIO as done for the other CIC waves. Users may also investigate
different body drag, or change the mooring and PTO stiffness or damping. The state space or other numerical options may be helpful to stabilize the irregular wave case.
Once a simulation is stable and realistic in Test 4 and all previous test cases, it can likely be used in additional cases as desired.
Passing these test cases does not necessarily indicate accuracy, but it should result in a simulation without numerical errors.
It is up to each user to tune body, PTO and mooring parameters appropriately to model a device accurately.

Other Tests
^^^^^^^^^^^

**Tests A vs B:**
CIC waves are one way to evaluate if "good" BEM data is being used. 
If a non-CIC wave has unphysical behavior at a specific frequency but not others, there are likely irregular frequency (IRR) spikes in the BEM data.
The CIC wave decreases the impact of these spikes in radiation damping.

If a CIC wave continues to oscillate without decaying to a steady state, the convolution integral time is not long enough.
Increase ``simu.cicEndTime`` to a greater value or use the state space option (``simu.stateSpace=1``).
In BEMIO, check that the convolution integral time is long enough for all oscillations to decay. 

**Nonlinear Hydrodynamics:**
If a user wishes to use the nonlinear hydro options, they should first follow this same workflow with ``simu.nonlinearHydro=0`` and again with ``simu.nonlinearHydro=1,2``
The nonlinear hydro options are difficult to set-up and must be used with care. 
A highly refined mesh is required to get an accurate displaced volume and wetted surface area at each time step.


FAQs
--------------------------
This section highlights some of the Frequently Asked Questions from WEC-Sim issues.
All FAQ information is available in closed GitHub issues, but is repeated here for convenience.

Solution Singularity
^^^^^^^^^^^^^^^^^^^^

**Problem:** 
The simulation is numerically unstable. Bodies may rise or fall indefinitely and have unphysical responses.
This occurs because there is an imbalance between the gravity and hydrostatic forces.
If the gravity force is much larger than the hydrostatic force, bodies may fall indefinitely. 
The opposite may occur when gravity is small compared to the hydrostatic force.
An extremely large or small stiffness can also cause this problem. 
A small stiffness may not restore a body to an equilibrium position. 
A large stiffness may require a very small time step to be effective.

**Possible error messages:**

.. code-block:: none

	Derivative of state ... in block ... at time ... is not finite. 
	The simulation will be stopped. There may be a singularity in the solution

**Solution:**
Re-evaluate the hydrostatic stability of the device.
Compare the mass and displaced volume of the device to evaluate if it will float properly.
Calculate an approximate stiffness that will restore the body to equilibrium in still water. 
Compare the mass, volume, and stiffness to those results in the BEM data.


Degenerate Mass Distribution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Problem:** 
When two PTOs or Constraints are connected in series with no mass between them, Simulink attempts to connect two joint blocks directly together.
Simulink cannot reconcile the forcing and motion between these series joints without a mass between them.

**Possible error messages:**

.. code-block:: none

	... Joint has a degenerate mass distribution on its base/follower side.

**Solution:**
Add an insignificantly small mass between the two joints (e.g. ``Simulink Library/Simscape/Multibody/Body Elements/Inertia``) .
Alternatively, create a new PTO or constraint with one of the many joints available in the 
Simscape Multibody Joints library if special degrees of freedom are required.


Hydrodynamic Data File
^^^^^^^^^^^^^^^^^^^^^^

**Problem:** 
The path to the ``*.h5`` file does not exist or it is incomplete (size < 1kB).

**Possible error messages:**


.. code-block:: none

	The hdf5 file hydroData/*.h5 does not exist

.. code-block:: none

	This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file, 
	or run \hydroData\bemio.m to generate a new *.h5 file

**Solution:**
Check the path to the ``*.h5`` file in the ``wecSimInputFile.m`` or run BEMIO to generate a new ``*.h5`` file.





