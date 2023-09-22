.. _most-theory:

**********
Theory
**********

In this section, the features introduced with MOST will be explored, offering some theoretical background to understand their use. 
To do this, the workflow shown in the introduction (:ref:`most-introduction`) will be followed: Pre-processing, User Inputs, Simulation, and Post-processing.


Pre-processing
==============
In the pre-processing phase, it is possible to create all the data required for the simulation (except the hydrodynamic coefficients) by launching the ``mostIO.m`` script,
which will call up other codes, each dedicated to specific data (e.g. wind turbine, control, or mooring) and described in this section.


Mooring look-up table
---------------------
As mentioned above, MOST allows for simulation of a mooring look-up table to model a quasi-static, non-linear mooring system. 
Specifically, the mooring look-up table simulates a mooring system consisting of a certain number of lines suspended between two points (anchor and fairlead) and angularly 
equally spaced. This option is based on the catenary equations similarly to the open-source code MAP++ :cite:`MAP`. In the Simulink model, forces and torques due 
to moorings are determined through 6 different look-up tables having the 6 degrees of freedom surge, sway, heave, roll, pitch, and yaw as inputs. The breakpoints 
(related to the inputs) and the outputs (Fx, Fy, Fz, Mx, My and Mz, i.e., the mooring loads) are contained within a data structure called "moor_matrix" and created 
through the ``Create_Mooring_Matrix.m`` script.


Wind input
----------
This section describes how the input wind field is generated; there are two possible method: to have constant wind speed (in time and space) or to have a speed field 
in which turbulence and non-uniform spatial distribution are taken into account. It is possible to specify the choice in the script where the various settings for 
the simulation are made, ``wecSimInputFile.m``, by initializing the windClass with "constant" or "turbulent." In the first case there will be a constant wind speed at 
all times and at every point on the rotor area, while the second case considers the spatial and temporal turbulence of the wind. 
Regarding the second case, the scatter of the wind speed is obtained using an external code, TurbSim, developed by NREL, and integrated within the MOST code. 
The user can launch the ``run_turbsim.m`` script (in turbsim subfolder) to create the wind input data structure, specifying some properties such as mean velocity and 
turbulence intensity. For more information, it is recommended to read the documentation of TurbSim for the explanation of the theory :cite:`kelley2005overview`. 
The resulting data structure consists of the wind speed (in the surge direction) at each instant and for each node of a spatial grid covering the rotor area. 
During the simulation, the wind speed corresponding to the blade nodes will be obtained by interpolating between the grid points via look-up tables.


Wind turbine properties
-----------------------
All wind turbine components are modelled as rigid bodies; this includes the tower, the nacelle, the hub, and the blades. The inertial and geometrical properties of the
components must be defined in a MATLAB structure, the user can use the script ``WTproperties.m`` to write the parameters of the desired wind turbine. In particular, 
mass, moment of inertia, centre of mass relative to the reference, and centre of mass in the global reference frame (whose origin is at the still water level) are defined 
for each body. In addition, other parameters such as tilt and precone angles, tower height, electrical generator efficiency, and CAD file names are set. The CAD files 
to define the geometry can be imported from external software. They must be saved in the folder "geometry". The user must set the name of the CAD files in ``WTcomponents``
struct to allow MOST to upload the files.

.. image:: IMAGE_geometry.png
   :width: 80%

In addition to the general characteristics of the wind turbine, the user must set the specific properties for the blades by launching the ``BladeData.m`` script, 
which defines the needed data structure by taking the information from some text files in the "BladeData" folder. In these, lift, drag, and torque coefficients are 
specified for each type of airfoil used, as well as certain geometric characteristics of the blades such as twist angle and chord length as a function of radius, 
and geometric characteristics related to pre-bending.                          . 


Control properties
------------------

This section explains how the MOST controller characteristics to be used in simulations are calculated. As mentioned earlier, it is possible to choose between two control 
logics (Baseline :cite:`Hansen2005` and ROSCO :cite:`abbas2022reference`), and for the creation of the data required for the simulation, it is necessary to know the
steady states values, i.e. the stationary values of certain quantities of interest when varying, in this case, the wind speed, which is considered constant for this 
purpose. The first step in obtaining the data required for the simulation is therefore to run the script called ``Steady_States.m`` in the subfolder "Control", which performs
this calculation. Specifically, through this, the stationary values of power, rotor speed, thrust force, generator torque, and blade pitch angle are computed for both of 
the aforementioned control logics. 
The script calculates different stationary values according to the control logic because of their diversity. Specifically, only the ROSCO controller imposes an upper limit
for the thrust force, so when the wind speed is close to the nominal wind speed (where the force peak occurs), the blade pitch value will be slightly higher to reduce the
thrust and comply with the imposed limits. The second difference is that in the Baseline controller, no minimum rotor speed is imposed, which is the case for some turbine
types in the ROSCO controller. 

Below is a figure representing an example of steady state for Baseline and ROSCO controllers for the IEA 15 MW reference wind turbine :cite:`Gaertner2020`, which
follows a description of the operations performed by the script to obtain the desired results.

.. image:: IMAGE_Steady_States.png
   :width: 80%

Finally, the last step involves calculating the stationary values as the wind speed changes. It is performed by constrained optimization through which the rotor speed and
blade pitch values are sought such that the power produced is maximized while maintaining it at or below the rated power and respecting the maximum thrust limit. Once the
rotor speed and blade pitch values have been found for each wind speed analyzed, the steady-state values of the other quantities of interest (power, thrust, and generator
torque) are evaluated.

Once the steady-state values for the two control logics have been calculated, it is possible to build the data structures needed for controller simulation by running the
``Controller.m`` script in the "Control" subfolder. In this script a few settings have to be defined, which can refer to both logics or just the Baseline or ROSCO 
controller. In the following sections, the control logics that can be used and the methods for obtaining the data needed for their simulation will be briefly described, for more 
information on the controllers see :cite:`Hansen2005` for Baseline and :cite:`abbas2022reference`  for ROSCO.


Baseline 
^^^^^^^^

Baseline is a conventional, variable-speed, variable collective pitch controller, which is made up of two independent systems:

* A generator torque controller (consisting of a generator speed-torque law) designed to maximize power extraction below nominal wind speed
* A blades collective pitch controller designed to regulate rotor and generator speed above nominal wind speed

Generator torque controller
"""""""""""""""""""""""""""

The generator-torque control law is designed to have three main regions and two transition ones between them. Aerodynamic torque acts as an accelerating load, the generator torque, converting mechanical energy to electrical energy, acts as a braking load. The generator torque is computed as a tabulated function of the filtered generator speed, incorporating 4 control regions: 1, 1.5, 2, and 3.

* **Region 1**: control region before cut-in wind speed, where the generator is detached from the rotor to allow the wind to accelerate the rotor for start-up. In this region, the generator torque is zero and no power is extracted from the wind.


* **Region 1.5**: transition region called start-up region and permits a smooth transition between null and optimal torque.


* **Region 2**: control region where extracted power is maximized. Here, to maintain the tip speed ratio constant at its optimal value, the generator torque is proportional to the square of the filtered generator speed. Aerodynamic torque can be expressed as: 

  .. math::

      T_{aero}=\frac{1}{2} \rho \pi \frac{R^5}{λ^3} C_P(λ,\theta_{bl}) \Omega^2 = k_{opt}\Omega^2

  Where :math:`k_{opt}` is obtained with TSR (Tip Speed Ratio) and blade pitch values that lead to maximum power coefficient 
  (:math:`λ = λ_{opt}`, :math:`\theta_{bl} = 0^{\circ}`);

* **Region 3**: above rated condition region, where the generator torque is kept constant at its rated value. In this region pitch control is active to maintain rotor speed at its rated value.

The figure below shows an example of control law of the Baseline generator torque controller for the IEA 15 MW reference wind turbine :cite:`Gaertner2020`. 

.. image:: IMAGE_Baseline_Torque_Law.png
   :width: 60%


References
----------

.. bibliography:: ../most/MOST.bib
   :style: unsrt
   :labelprefix: D
