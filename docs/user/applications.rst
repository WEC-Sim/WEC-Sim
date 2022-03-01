.. _user-applications:

WEC-Sim Applications
========================

The `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository contains many more applications of the WEC-Sim code that demonstrate 
WEC-Sim :ref:`Advanced Features <user-advanced-features>`. This includes 
tutorials by the WEC-Sim team as well as user-shared examples and covers topics 
such as body interactions, numerical set-up, batch runs, visualization, control 
examples, mooring and more. These applications highlight the 
versatility of WEC-Sim and can be used as a starting point for users interested 
in a given application. 
It is highly recommended that users go through an application case along with the 
relevant advanced feature section when learning to implement a new WEC-Sim feature.
The WEC-Sim Applications repository is included as a 
`submodule <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_ of the 
WEC-Sim repository. The applications are summarized below.

.. TODO currently these descriptions are copy/pasted from the application READMEs.
   Expand on descriptions and link directly to the READMEs later on.
   

Body-to-Body Interactions
^^^^^^^^^^^^^^^^^^^^^^^^^

Example using :ref:`Body-to-Body (B2B) <user-advanced-features-b2b>` to run WEC-Sim for the :ref:`RM3 <user-tutorials-rm3>` 
geometry. The scripts run and plot the RM3 model with B2B on/off and with 
Regular/RegularCIC. Execute the `runB2B.m` script to run this case. 

Desalination
^^^^^^^^^^^^

Example using WEC-Sim for desalination based on the :ref:`OSWEC <user-tutorials-oswec>` 
geometry. Note the dependency on SimScape Fluids to run this desalination case. 

Free Decay
^^^^^^^^^^

Example using WEC-Sim to simulate :ref:`free decay <user-advanced-features-decay>` 
of a sphere in heave, using :ref:`Multiple Condition Runs <user-advanced-features-mcr>`. 
Execute the `runFreeDecay.m` script to run this case.

Generalized Body Modes
^^^^^^^^^^^^^^^^^^^^^^

Example using :ref:`Generalized Body Modes <user-advanced-features-generalized-body-modes>` 
in WEC-Sim. In this application a barge is allowed four additional flexible 
degrees of freedom. Note that this requires the BEM solver also account for 
these general degrees of freedom and output the appropriate quantities required 
by BEMIO.

Mooring
^^^^^^^

One example using the :ref:`RM3 <user-tutorials-rm3>` 
geometry coupled with :ref:`MoorDyn <mooring-moordyn>` 
to simulate a more realistic mooring system. And another example modeling the 
RM3 with a Mooring Matrix. The MoorDyn application consists of 3 catenary 
mooring lines attached to floating buoys and then to different points on the 
spar and anchored at the sea floor.

Multiple Condition Run
^^^^^^^^^^^^^^^^^^^^^^

Example using :ref:`Multiple Condition Runs <user-advanced-features-mcr>`
to run the :ref:`RM3 <user-tutorials-rm3>`.
These examples demonstrate each of the 3 different ways to run WEC-Sim with MCR
and generates a power matrix for each PTO damping value. The last example
demonstrates how to use MCR to vary the imported sea state test file and
specify corresponding phase. Execute `wecSimMCR.m` from the case directory to
run an example. 

* MCROPT1: Cases defined using arrays of values for period and height.
* MCROPT2: Cases defined with wave statistics in an Excel spreadsheet
* MCROPT3: Cases defined in a MATLAB data file (``.mat``)
* MCROPT4: Cases defined using several MATLAB data files (``*.mat``) of the 
  wave spectrum

Nonhydrodynamic Body
^^^^^^^^^^^^^^^^^^^^

Example using :ref:`Non-Hydro Body <user-advanced-features-non-hydro-body>`
to run WEC-Sim for the :ref:`OSWEC <user-tutorials-oswec>`.
This example models the base as a nonhydro body, and the flap as a hydrodynamic
body.

Nonlinear Hydrodynamic Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Example using :ref:`Nonlinear Hydro <user-advanced-features-nonlinear>`
to run WEC-Sim for a :ref:`heaving ellipsoid <user-advanced-features-nonlinear-tutorial-heaving-ellipsoid>`.
Includes examples of running nonlinear hydrodynamics with different :ref:`fixed and
variable time-step solvers <user-advanced-features-time-step>`
(ode4/ode45), and different regular wave formulations (with/without CIC). 
Execute the `runNL.m` script to run this case. 

Paraview Visualization
^^^^^^^^^^^^^^^^^^^^^^

Example using ParaView data visualization for WEC-Sim coupled with :ref:`MoorDyn <mooring-moordyn>` 
to simulate a more realistic mooring system for the :ref:`RM3 <user-tutorials-rm3>` 
geometry. Example consists of 3 catenary mooring lines attached to different 
points on the spar and anchored at the sea floor.

Example using ParaView data visualization for WEC-Sim with :ref:`Nonlinear Hydro <user-advanced-features-nonlinear>` 
for the Flap and a :ref:`Non-Hydro Body <user-advanced-features-non-hydro-body>` 
for the Base to run WEC-Sim for the :ref:`OSWEC <user-tutorials-oswec>` 
geometry.

Passive Yaw
^^^^^^^^^^^

Example on using :ref:`Passive Yaw <user-advanced-features-passive-yaw>`
to run WEC-Sim for the :ref:`OSWEC <user-tutorials-oswec>` geometry.
Execute the `runYawCases.m` script to run this case. 

PTO-Sim
^^^^^^^

Examples using :ref:`PTO-Sim <pto-pto-sim>`.
Examples of WEC-Sim models using PTO-Sim are included for the :ref:`RM3 <user-tutorials-rm3>` 
geometry and :ref:`OSWEC <user-tutorials-oswec>`
geometry.

Visualization Markers
^^^^^^^^^^^^^^^^^^^^^^

Examples of WEC-Sim with Wave Elevation visualization at User-Defined Locations.
The setup for the visualization can be found at `Advanced Features <https://github.com/WEC-Sim/advanced_features>`

WECCCOMP
^^^^^^^^

Numerical model for the WEC Control Competition (WECCCOMP) using WEC-Sim to 
model the WaveStar with various fault implementations can be found in the `WECCCOMP <https://github.com/WEC-Sim/WECCCOMP>`_ repository. 
See the project report written by Erica Lindbeck in the "report" folder. 

Write HDF5
^^^^^^^^^^

This is an example of how to write your own h5 file using MATLAB. Can be useful 
if you want to modify your coefficients, use experimental coefficients, or 
coefficients from another BEM code other than WAMIT, NEMOH, AQWA, or CAPYTAINE. For more 
details see :ref:`BEMIO <user-advanced-features-bemio-h5>` 
documentation. 