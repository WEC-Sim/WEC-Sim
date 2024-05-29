
This section provides an overview of WEC-Sim's constraint and PTO classes; for 
more information about the constraint and PTO classes' code structure, refer to 
:ref:`user-code-structure-constraint-class` and 
:ref:`user-code-structure-pto-class`. 

Modifying Constraints and PTOs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default linear and rotational constraints and PTOs allow for heave and 
pitch motions of the follower relative to the base. To obtain a linear or 
rotational constraint in a different direction you must modify the constraint's 
or PTO's coordinate orientation. The important thing to remember is that a 
linear constraint or PTO will always allow motion along the joint's Z-axis, and 
a rotational constraint or PTO will allow rotation about the joint's Y-axis. To 
obtain translation along or rotation about a different direction relative to 
the global frame, you must modify the orientation of the joint's coordinate 
frame. This is done by setting the constraint's or PTO's :code:`orientation.z` 
and :code:`orientation.y` properties which specify the new direction of the Z- 
and Y- joint coordinates. The Z- and Y- directions must be perpendicular to 
each other. 

As an example, if you want to constrain body 2 to surge motion relative to body 
1 using a linear constraint, you would need the constraint's Z-axis to point in 
the direction of the global surge (X) direction. This would be done by setting 
:code:`constraint(i).orientation.z=[1,0,0]` and the Y-direction to any 
perpendicular direction (can be left as the default y=[0 1 0]). In this 
example, the Y-direction would only have an effect on the coordinate on which 
the constraint forces are reported but not on the dynamics of the system. 
Similarly if you want to obtain a yaw constraint you would use a rotational 
constraint and align the constraint's Y-axis with the global Z-axis. This would 
be done by setting :code:`constraint(i).orientation.y=[0,0,1]` and the 
z-direction to a perpendicular direction (say [0,-1,0]). 

.. Note::

    When using the Actuation Force/Torque PTO or Actuation Motion PTO blocks, 
    the loads and displacements are specified in the local (not global) 
    coordinate system. This is true for both the sensed (measured) and actuated 
    (commanded) loads and displacements.

Additionally, by combining constraints and PTOs in series you can obtain 
different motion constraints. For example, a massless rigid rod between two 
bodies, hinged at each body, can be obtained by using a two rotational 
constraints in series, both rotating in pitch, but with different locations. A 
roll-pitch constraint can also be obtained with two rotational constraints in 
series; one rotating in pitch, and the other in roll, and both at the same 
location. 

Incorporating Joint/Actuation Stroke Limits
"""""""""""""""""""""""""""""""""""""""""""

Beginning in MATLAB 2019a, hard-stops can be specified directly for PTOs and 
translational or rotational constraints by specifying joint-primitive dialog 
options in the ``wecSimInputFile.m``. Limits are modeled as an opposing spring 
damper force applied when a certain extents of motion are exceeded. Note that 
in this implementation, it is possible that the constraint/PTO will exceed 
these limits if an inadequate spring and/or damping coefficient is specified, 
acting instead as a soft motion constraint. More detail on this implementation 
can be found in the `Simscape documentation <https://www.mathworks.com/help/physmod/sm/ref/prismaticjoint.html#mw_316368a1-4b9e-4cfb-86e0-9abdd0c4d7a8>`_.
To specify joint or actuation stroke limits for a PTO, the following parameters 
must be specified in ``wecSimInputFile.m`` 

	:code: `pto(i).hardStops.upperLimitSpecify = 'on'`
	:code: `pto(i).hardStops.lowerLimitSpecify = 'on'`

to enable upper and lower stroke limits, respectively. The specifics of the 
limit and the acting forces at the upper and lower limits are described in turn 
by 

	pto(i).hardStops.upperLimitBound
	pto(i).hardStops.upperLimitStiffness
	pto(i).hardStops.upperLimitDamping
	pto(i).hardStops.upperLimitTransitionRegionWidth
	pto(i).hardStops.lowerLimitBound
	pto(i).hardStops.lowerLimitStiffness
	pto(i).hardStops.lowerLimitDamping
	pto(i).hardStops.lowerLimitTransitionRegionWidth

where pto(i) is replaced with constraint(i) on all of the above if the limits 
are to be applied to a constraint. 

In MATLAB versions prior to 2019a, specifying any of the above parameters will 
have no effect on the simulation, and may generate warnings. It is instead 
recommended that hard-stops are implemented in a similar fashion using an 
Actuation Force/Torque PTO block in which the actuation force is specified in a 
custom MATLAB Function block. 

.. _pto-pto-extension:

Setting PTO or Constraint Extension
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The PTO and Constraint classes have an Extension value that
can be specified to define the initial displacement of 
the PTO or constraint at the beginning of the simulation, allowing the user to set the 
ideal position for maximum wave capture and energy generation. This documentation
will use the PTO as an example, but the proces is applicable to both translational, 
rotational, or spherical PTOs and constraints. 
Whereas the initial displacement feature only defines this updated position for the PTO,
the PTO Extension feature propagates the change in position to all bodies and joints
on the Follower side of the PTO block. This allows for an accurate reflection of the 
initial locations of each component without having to calculate and individually
define each initial displacement or rotation. To set the extension of a PTO, the 
following parameter must be specified in ``wecSimInputFile.m``::

	pto(i).extension.PositionTargetSpecify = '1'

to enable the joint's target position value to be defined. The specifics of the 
extension are described in turn by::

	pto(i).extension.PositionTargetValue
	pto(i).extension.PositionTargetPriority

``PositionTargetValue`` defines the extension magnitude and ``PositionTargetPriority``
specifies Simulink's priority in setting the initial target value in regards
to other constraints and PTOs. The priority is automatically set to "High" when 
the extension is initialized but can be adjusted to "Low" if required by Simulink.

The figure below shows the PTO extension feature on the WECCCOMP model at 0.1 m.
The left image is at equilibrium (:code:`pto(i).extension.PositionTargetSpecify=0`),
and the right image set as
:code:`pto(i).extension.PositionTargetSpecify=1` with the WEC body moving in 
accordance with the set PTO Extension value.

.. figure:: /_static/images/WECCCOMP_PTO_Extension.png
   :align: center
   :width: 500pt
   
   ..
   
   WECCCOMP Model PTO Extension

While this method generally fits most WEC models, there are specific 
designs such as the RM3 that may have a larger DOF and are dependent on
the particular block orientation in the simulink model in terms of which 
body blocks will move in response to a PTO initial extension. These specific 
cases require extra setup on the users end if looking to define a 
different body's motion than the one automatically established. For the RM3
model, a set PTO Extension value results in movement in the float body.
However, if the user would like the movement to be within the spar instead,
extra steps are required. To view examples of how to set the PTO Extension
for both the float as well as the spar view the RM3 PTO Extension examples
on the `WEC-Sim Applications repository 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ .

For the spherical PTO which can rotate about three axes, 
``pto(i).extension.PositionTargetValue`` must be a 1x3 array that specifying
three consecutive rotations about the Base frame's axes in the X-Y-Z convention.

.. Note:: 
   The PTO extension is not valid for PTO already actuated by user-defined motion
   (Translational PTO Actuation Motion, Rotational PTO Actuation Motion).

.. _pto-pto-sim:

PTO-Sim
^^^^^^^

PTO-Sim is the WEC-Sim module responsible for accurately modeling a WEC's 
conversion of mechanical power to electrical power. While the PTO blocks native 
to WEC-Sim are modeled as a simple linear spring-damper systems, PTO-Sim is 
capable of modeling many power conversion chains (PCC) such as mechanical 
and hydraulic drivetrains. PTO-Sim is made of native Simulink blocks 
coupled with WEC-Sim, using WEC-Sim's user-defined PTO blocks, where the 
WEC-Sim response (relative displacement and velocity for linear motion and 
angular position and velocity for rotary motion) is the PTO-Sim input. 
Similarly, the PTO force or torque is the WEC-Sim input. For more information 
on how PTO-Sim works, refer to [So et al., 2015] and :ref:`webinar3`. 

The files for the PTO-Sim tutorials described in this section can be found in 
the **PTO-Sim** examples on the `WEC-Sim Applications repository 
<https://github.com/WEC-Sim/WEC-Sim_Applications>`_ . Four PTO examples are 
contained in the PTO-Sim application and can be used as a starting point for 
users to develop their own. They cover two WEC types and mechanical, hydraulic, 
and electrial PTO's: 

	+--------------------------------+-------------------------------------------+
	|     **PTO-Sim Application**    |               **Description**             |                
	+--------------------------------+-------------------------------------------+
	|   RM3_cHydraulic_PTO           | RM3 with compressible hydraulic PTO       |
	+--------------------------------+-------------------------------------------+
	|   RM3_DD_PTO                   | RM3 with direct drive linear generator    |
	+--------------------------------+-------------------------------------------+
	|   OSWEC_Hydraulic_PTO          | OSWEC with hydraulic PTO (adjustable rod) |
	+--------------------------------+-------------------------------------------+
	|   OSWEC_Hydraulic_Crank_PTO    | OSWEC with hydraulic PTO (crank)          |
	+--------------------------------+-------------------------------------------+

Tutorial: RM3 with PTO-Sim
""""""""""""""""""""""""""

This section describes how to use RM3 with PTO-Sim. Two tutorials will be given 
in this section: one for the RM3 with a hydraulic PTO and 
another for the RM3 with a direct drive PTO. 

.. _pto-rm3-hydraulic:

RM3 with Hydraulic PTO
++++++++++++++++++++++

The hydraulic PTO example used in this section consists of a piston, a 
rectifying valve, a high pressure accumulator, a hydraulic motor coupled to a 
rotary generator, and a low pressure accumulator. 

.. figure:: /_static/images/HYDPHYMODEL.PNG
   :width: 500pt 

In this section, a step by step tutorial on how to set up and run the RM3 
simulation with PTO-Sim is provided. All the files used in WEC-Sim will remain 
the same, but some may need to be added to the working folder. The ``wecSimInputFile.m`` must
be modified to add the definition of the different PTO-Sim blocks. The files used to run RM3 with
PTO-Sim case are the following: 

* WEC-Sim input file: ``wecSimInputFile.m`` (make sure to set the PTO linear 
  damping to zero)
* Simulink model: ``RM3.slx``
* Geometry file for each body: ``float.stl`` and ``plate.stl``
* Hydrodynamic data file(s): ``rm3.h5``
* Optional user defined post-processing file: ``userDefinedFunction.m``

**Simulink Model**

The Simulink model can be built as follows:

* Step 1: Navigate to the RM3 example ``$WECSIM/examples/RM3``.

* Step 2: Open ``RM3.slx`` file and replace Translational PTO with 
  Translational PTO Actuation Force. 

.. figure:: /_static/images/translational_pto.PNG
   :width: 500pt 

* Step 3: Create a subsystem and rename it to PTO-Sim where the input is the response and
  output is force.

.. figure:: /_static/images/rm3with_pto_sim.PNG
   :width: 500pt

* Step 4: Go to Simulink Library Browser to access the PTO-Sim Library. 

.. figure:: /_static/images/pto_sim_lib.png
   :width: 500pt

* Step 5: By looking at the physical hydraulic PTO model as shown above, the user 
  can simply drag and drop PTO-Sim library blocks. Hydraulic cylinder, rectifying valve, and accumulator 
  blocks are located under the Hydraulic block. The electric generator equivalent circuit is located under the Electric library. 

* Step 6: Since multiple PTO-Sim blocks will be used, it is necessary to name each block to identify them
  when its variables are defined in the ``wecSimInputFile.m``. To change the name of each block, 
  double click the block and add the name ``ptoSim(i)`` where ``i`` 
  must be different for each block used in the simulation. The name of each block
  will be used in the ``wecSimInputFile.m`` to define its variables.

.. figure:: /_static/images/PTOSimBlock1.png
   :width: 500pt


* Step 7: Connect the inputs and outputs of the blocks according to the desired physical layout.

.. figure:: /_static/images/RM3withPTOSimBlocks.png
   :width: 500pt

* Step 8: Define the input for ``Rload`` in the Electric Generator block. The input could be a constant
  value or it could be used to control the load of the generator to achieve a desired physical behaviour.
  In this example, the value of ``Rload`` is used to control the shaft speed of the generator by using a
  simple PI controller. The desired shaft speed in this case is 1000 rpm. The Electric Generator 
  Equivalent Circuit block has two outputs: the electromagnetic torque and the shaft speed. It is
  necessary to use a bus selector to choose the desired output, which in this example is the shaft speed.

.. figure:: /_static/images/GeneratorSpeedControl.png
   :width: 500pt

**Input File**

In this section, the WEC-Sim input file (``wecSimInputFile.m``) is defined and 
categorized into sections such as hydraulic cylinder, rectifying check valve, high pressure 
accumulator, low pressure accumulator, hydraulic motor, and generator. 
  
.. _WECSimInput:

.. rli:: https://raw.githubusercontent.com/WEC-Sim/WEC-Sim_Applications/main/PTO-Sim/RM3/RM3_cHydraulic_PTO/wecSimInputFile.m
   :language: matlab   

**Simulation and Post-processing**

Simulation and post-processing are similar process as described in :ref:`user-tutorials-rm3`.
There are some specific variable definitions that must be considered when using the output
signals of the PTO-Sim blocks. For example, the hydraulic accumulator has two output signals: flow rate
and pressure, and the time vector. In the RM3 example with hydraulic PTO, the high pressure hydraulic
accumulator was defined as ``ptoSim(3)`` in the WEC-Sim input file; then, to use the output
flow rate and pressure of this block, the next line of code must be used:

``FlowRateAccumulator = output.ptoSim(3).FlowRate``
``PressureAccumulator = output.ptoSim(3).Pressure``

In general, the output signal of any PTO-Sim block can be used with this line of code:  ``output.ptoSim(i).VariableName``

RM3 with Direct Drive PTO
+++++++++++++++++++++++++

A mechanical PTO is used in this example and is modeled as a direct drive 
linear generator. The main components of this example consist of magnets and a 
coil where the magnet assembly is attached to the heaving float and the coil is 
located inside the spar. As the float moves up and down, the magnet assembly 
creates a change in the magnetic field surrounding the spar that contains the 
coil: therefore, current is induced in the coil and electricity is generated. 

.. figure:: /_static/images/MECHANICALPTO.PNG
   :width: 500pt

**Simulink Model**

Steps 1 through 4 are the same as in :ref:`pto-rm3-hydraulic`. 

* Step 5: Look for the block "Direct Drive Linear Generator" and drag the block into the PTO-Sim subsystem


* Step 6: Connect the input "respose" to the input of the PTO-Sim block and the output "Force" to the output of the subsystem.

.. figure:: /_static/images/DirectDrivePorts.png
   :width: 500pt

**Input File, Simulation, and Post-processing**

The same as :ref:`pto-rm3-hydraulic`.

Tutorial: OSWEC with PTO-Sim
""""""""""""""""""""""""""""

This section describes how to use the OSWEC model with PTO-Sim. The same 
process as described in :ref:`pto-rm3-hydraulic`; however, since the OSWEC is a 
rotary device, it takes torque as an input and a rotary to linear motion 
conversion block is needed. The tutorials can be found on the 
`WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ 
repository (both for a crank and for a rod). 

OSWEC with Hydraulic PTO
++++++++++++++++++++++++

A hydraulic PTO or mechanical PTO can be used with OSWEC but for simplicity a 
hydraulic PTO will be used as an example. An schematic representation of the OSWEC device
is shown in the figure below:

.. figure:: /_static/images/OSWECPHYMODEL.PNG
   :width: 500pt

Two blocks were developed in the PTO-Sim library to model a system like the OSWEC.
The blocks can be found under the ``Motion Convertion`` library.

.. figure:: /_static/images/MotionConversionLib.png
   :width: 500pt

The block "Rotary to Linear Adjustable Rod" is used to model a rod with a variable length. For the OSWEC case,
this block can be use when the cylinder rod of the hydraulic PTO is connected to the adjustable rod,
like in the schematic presented in the figure below:

.. figure:: /_static/images/AdjustableRodHPTO.png
   :width: 500pt


On the other hand, the block "Rotary to Linear Crank" is used to model a slider-crank mechanism that is used to convert
the rotational motion of the OSWEC device into linear motion for the hydraulic cylinder in the PTO. In this case, the
cylinder rod of the hydraulic PTO is connected to the slider part of the mechanism, as shown in the figure below:

.. figure:: /_static/images/SliderandCrankMechanism.png
   :width: 500pt

**Modeling of OSWEC with Hydraulic PTO**

The files needed for the OSWEC case are the same as the ones described in :ref:`pto-rm3-hydraulic`.

**Simulink Model**

The Simulink model can be built as following:

* Step 1: Copy the OSWEC example folder to get started  ``$WECSIM\examples\OSWEC``. 

* Step 2: Open ``OSWEC.slx`` file and replace Rotational PTO with 
  Rotational PTO Actuation Torque.

.. figure:: /_static/images/rotational_pto.PNG
   :width: 500pt

* Step 3: Create a subsystem and rename it to PTO-Sim where input is response and 
  output is torque.

.. figure:: /_static/images/oswec_pto_sim.PNG
   :width: 500pt

* Step 4: Go to Simulink Library Browser to access the PTO-Sim Library. 

* Step 5: By looking at the physical hydraulic PTO model as shown above, the user 
  can simply drag and drop PTO-Sim library blocks. Hydraulic cylinder, rectifying valve, and accumulator 
  blocks are located under the Hydraulic block. The electric generator equivalent circuit is located under the Electric library. 
  The "Rotary to Linear Adjustable Rod" is under the Motion Conversion library.

* Step 6: Since multiple PTO-Sim blocks will be used, it is necessary to name each block to identify them
  when its variables are defined in the ``wecSimInputFile.m``. To change the name of each block, 
  double click the block and add the name ``ptoSim(i)`` where ``i`` 
  must be different for each block used in the simulation. The name of each block
  will be used in the ``wecSimInputFile.m`` to define its variables. For this example,
  the motion conversion block will be called ``ptoSim(1)``

.. figure:: /_static/images/PTOSimBlock1OSWEC.png
   :width: 500pt


* Step 7: Connect the inputs and outputs of the blocks according to the desired physical layout.

.. figure:: /_static/images/OSWECPTOSimExample.png
   :width: 500pt

* Step 8: Define the input for ``Rload`` in the Electric Generator block. The input could be a constant
  value or it could be used to control the load of the generator to achieve a desired physical behaviour.
  In this example, the value of ``Rload`` is used to control the shaft speed of the generator by using a
  simple PI controller. The desired shaft speed in this case is 3000 rpm. The Electric Generator 
  Equivalent Circuit block has two outputs: the electromagnetic torque and the shaft speed. It is
  necessary to use a bus selector to choose the desired output, which in this example is the shaft speed.

**Input File, Simulation, and Post-processing**

The input file for this case is similar to the input file
described in :ref:`pto-rm3-hydraulic`. The naming and numbering of the PTO blocks
change in this case, but the way the variables are defined is the same.
