.. _user-applications:

Applications
============

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

Example using `Body-to-Body (B2B) <http://wec-sim.github.io/WEC-Sim/advanced_features.html#body-to-body-interacti 
ons>`_ to run WEC-Sim for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ 
geometry. The scripts run and plot the RM3 model with B2B on/off and with 
Regular/RegularCIC. Execute the `runB2B.m` script to run this case. 

Desalination
^^^^^^^^^^^^

Example using WEC-Sim for desalination based on the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ 
geometry. Note the dependency on SimScape Fluids to run this desalination case. 

Free Decay
^^^^^^^^^^

Example using WEC-Sim to simulate `free decay <http://wec-sim.github.io/WEC-Sim/advanced_features.html#decay-tests>`_ 
of a sphere in heave, using `Multiple Condition Runs <http://wec-sim.github.io/WEC-Sim/advanced_features.html#multiple-condition-runs-mcr>`_. 
Execute the `runFreeDecay.m` script to run this case.

Generalized Body Modes
^^^^^^^^^^^^^^^^^^^^^^

Example using `Generalized Body Modes <http://wec-sim.github.io/WEC-Sim/advanced_features.html#generalized-body-modes>`_ 
in WEC-Sim. In this application a barge is allowed four additional flexible 
degrees of freedom. Note that this requires the BEM solver also account for 
these general degrees of freedom and output the appropriate quantities required 
by BEMIO.

Mooring
^^^^^^^

One example using the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ 
geometry coupled with `MoorDyn <http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn>`_ 
to simulate a more realistic mooring system. And another example modeling the 
RM3 with a Mooring Matrix. The MoorDyn application consists of 3 catenary 
mooring lines attached to floating buoys and then to different points on the 
spar and anchored at the sea floor.

Multiple Condition Run
^^^^^^^^^^^^^^^^^^^^^^

Example using `Multiple Condition Runs (MCR) <http://wec-sim.github.io/WEC-Sim/advanced_features.html#multiple-condition-runs-mcr>`_
to run WEC-Sim with Multiple Condition Runs for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_.
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

Example using `Non-Hydro Body <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-hydrodynamic-bodies>`_
to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_.
This example models the base as a nonhydro body, and the flap as a hydrodynamic
body.

Nonlinear Hydrodynamic Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Example using `Nonlinear Hydro <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation>`_
to run WEC-Sim for a `heaving ellipsoid <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-wave-excitation-tutorial-heaving-ellipsoid>`_.
Includes examples of running non-linear hydrodynamics with different `fixed and
variable time-step solvers <http://wec-sim.github.io/WEC-Sim/advanced_features.html#time-step-features>`_
(ode4/ode45), and different regular wave formulations (with/without CIC). 
Execute the `runNL.m` script to run this case. 

Paraview Visualization
^^^^^^^^^^^^^^^^^^^^^^

Example using ParaView data visualization for WEC-Sim coupled with `MoorDyn <http://wec-sim.github.io/WEC-Sim/advanced_features.html#moordyn>`_ 
to simulate a more realistic mooring system for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_ 
geometry. Example consists of 3 catenary mooring lines attached to different 
points on the spar and anchored at the sea floor.

Example using ParaView data visualization for WEC-Sim with `Non-linear Hydro <http://wec-sim.github.io/WEC-Sim/advanced_features.html#nonlinear-buoyancy-and-froude-krylov-excitation>`_ 
for the Flap and a `Non-Hydro Body <http://wec-sim.github.io/WEC-Sim/advanced_features.html#non-hydrodynamic-bodies>`_ 
for the Base to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ 
geometry.

Passive Yaw
^^^^^^^^^^^

Example on using `Passive Yaw <http://wec-sim.github.io/WEC-Sim/advanced_features.html#passive-yaw-implementation>`_
to run WEC-Sim for the `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ geometry.
Execute the `runYawCases.m` script to run this case. 

PTO-Sim
^^^^^^^

Examples using `PTO-Sim <http://wec-sim.github.io/WEC-Sim/advanced_features.html#pto-sim>`_.
Examples of WEC-Sim models using PTO-Sim are included for the `RM3 <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_
geometry and `OSWEC <http://wec-sim.github.io/WEC-Sim/tutorials.html#oscillating-surge-wec-oswec>`_ 
geometry.

WECCCOMP
^^^^^^^^

Numerical model for the WEC Control Competition (WECCCOMP) using WEC-Sim to 
model the WaveStar with various fault implementations. See the project report 
written by Erica Lindbeck in the "report" folder. 

Write HDF5
^^^^^^^^^^

This is an example of how to write your own h5 file using MATLAB. Can be useful 
if you want to modify your coefficients, use experimental coefficients, or 
coefficients from another BEM code other than WAMIT, NEMOH, AQWA, or CAPYTAINE. For more 
details see `BEMIO feature <http://wec-sim.github.io/WEC-Sim/features.html#bemio-writing-your-own-h5-file>`_ 
documentation. 
