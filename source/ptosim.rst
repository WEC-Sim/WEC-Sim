.. _ptosim:

Power Take-Off/PTO-Sim
----------------------------
PTO-Sim is the WEC-Sim module responsible for accurately modeling a WEC's conversion of mechanical power to electrical power. 
While the PTO blocks native to WEC-Sim are modeled as a simple linear spring-damper systems, PTO-Sim is capable of modeling many power conversion chains (PCC) such as mechanical drivetrain and hydraulic drivetrain. 
PTO-Sim is made of native Simulink blocks coupled with WEC-Sim, using WEC-Sim's user-defined PTO blocks, where the WEC-Sim response (relative displacement and velocity for linear motion and angular position and velocity for rotary motion) is the PTO-Sim input. 
Similarly, the PTO force or torque is the WEC-Sim input. 
For more information on how PTO-Sim works, refer to [So et al., 2015].

The files for the tutorials described in this section can be found in the `WEC-Sim Applications repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_.


Tutorial: RM3 with PTO-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This section describes how to use RM3 with PTO-Sim. Two tutorials will be given in this section: one for the RM3 with a hydraulic PTO (non-compressible and compressible) and another for the RM3 with a direct drive PTO.

RM3 with Hydraulic PTO
..........................
	The hydraulic PTO example used in this section consists of a piston, a rectifying valve, a high pressure accumulator, a hydraulic motor coupled to a rotary generator, and a low pressure accumulator.   

	.. figure:: _static/HYDPHYMODEL.PNG
	   :width: 400pt 

	There are two ways of modeling the hydraulic PTO: with a compressible fluid hydraulic, and with a non-compressible fluid hydraulic. The compressible fluid model uses the properties of fluid such as an effective bulk modulus and density while the non-compressible fluid does not.

	Modeling RM3 with Hydraulic PTO
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	In this section, a step by step tutorial on how to set up and run the RM3 simulation with PTO-Sim is provided. All the files used in WEC-Sim will remain the same. An additional file that is needed is the PTO-Sim input file (``ptoSimInputFile.m``). If the rotary generator lookup table is used, a datasheet that contains generator efficiency, torque, and angular velocity is needed and should be named as ``table`` in Workspace (``table.eff``, ``table.Tpu``,and ``table.omegapu``). More details, refer to `Step 8`_. In summary, the files need to run RM3 with PTO-Sim case are the following:

	* WEC-Sim input file: ``wecSimInputFile.m`` (make sure to set the PTO linear damping to zero)
	* Simulink model: ``RM3.slx``
	* Geometry file for each body: ``float.stl`` and ``plate.stl``
	* Hydrodynamic data file(s): ``rm3.h5``
	* Optional user defined postprocessing file: ``userDefinedFunction.m``
	* PTO-Sim input file: ``ptoSimInputFile.m``
	* Datasheet for the rotary generator: ``table`` (``table.eff``, ``table.Tpu``,and ``table.omegapu``)


	Simulink Model
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	The Simulink model can be built as following:

	* Step 1: User can get started from RM3 example.

	.. figure:: _static/COPYRM3.PNG
	   :width: 400pt

	* Step 2: Open ``RM3.slx`` file and replace Translational PTO (local Z) with Translational PTO UD Force (Local Z). 

	.. figure:: _static/TRANSLATIONALPTOUD.PNG
	   :width: 400pt 

	* Step 3: Use a subsystem and rename it to PTO-Sim where input is response and output is force.

	.. figure:: _static/RM3WITHPTOSIMBLOCK.PNG
	   :width: 400pt

	* Step 4: Go inside PTO-Sim block and add one bus selector and two selector blocks. Since PTO-Sim block is connected to the WEC-Sim translational joint block, you can select position and velocity and therefore <signal1> and <signal2> will change to <position> and <velocity>. Because the heave motion is driving the piston, selection index of each selector needs to be changed to 3.

	.. figure:: _static/SELECTORS.PNG
	   :width: 400pt

	* Step 5: Go to Simulink Library Browser to access PTO-Sim Library. 

	.. figure:: _static/OPENPTOSIMLIB.PNG
	   :width: 400pt

	* Step 6: By looking at the physical hydraulic PTO model as shown above, user can simply drag and drop PTO-Sim library blocks. Piston, valves, accummulator blocks are located under Hydraulic block. Rotary generator lookup table is under Generator block. 

	.. figure:: _static/USEPTOSIMLIB.PNG
	   :width: 400pt

	* Step 7: Since two accumulators are needed for the high pressure accumulator and low pressure accumulator, user need to douple-click on each block and give a number to each accumulator. For example, ``ptosim.accumulator(1)`` is called high pressure accumulator and ``ptosim.accumulator(2)`` is called low pressure accumulator.

	.. figure:: _static/MULTIPLEACCUMULATORS.PNG
	   :width: 400pt

	.. _`Step 8`:

	* Step 8: If a rotary generator lookup table is used, this block assumes user will provide the datasheet. After the datasheet is loaded into ``Workspace``, it needs to be named as ``table`` because the word ``table`` is used inside Simulink lookup table block. The datasheet in tutorials is taken from ABB datasheet part number M3BJ315SMC. The lookup table takes three inputs: efficiency (``table.eff``), anglular velocity (``table.Tpu``), and generator torque (``table.omegapu``), respectively. 

	.. figure:: _static/ROTARYHIGHLEVELBLOCK.PNG
	   :width: 400pt

	.. figure:: _static/ROTARYBLOCK.PNG
	   :width: 400pt

	.. figure:: _static/ROTARYGENLOOKUPTABLE.PNG
	   :width: 400pt

	* Step 9: After the high pressure and low pressure accumulators have been identified, and the rotary generator lookup table datasheet has been setup, all the blocks can be connected together. 

	Position and velocity from selectors are used as inputs of compressible fluid piston. This block also needs to know top and bottom volumetric flows which come from the rectifying check valve. The piston then outputs PTO force that will be used by WEC-Sim. Two other outputs are the piston pressures. The rectifying check valve takes both the pressures from the piston and accumulators. Both high and low pressure accumulators takes the volumetric flows from the rectifying check valve and hydraulic motor. The hydraulic motor uses the knowledge of the pressures from both accumulator and generator torque from the rotary generator. The rotary generator needs angular velocity from the hydraulic motor. The figure below shows how to connect all the blocks together.


	.. figure:: _static/HYDPTOSIM.PNG
	   :width: 400pt


	Input File
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	In this section, PTO-Sim input file (``ptoSimInputFile.m``) is defined and categorized into sections such as piston, rectifying check valve, high pressure accumulator, hydraulic motor, low pressure accumulator, and rotary generator.

	.. figure:: _static/PTOSIMINPUTFILE.PNG
	   :width: 400pt

	Simulation and Postprocessing
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Simulation and postprocessing are the same process as described in WEC-Sim Simulation example above.


RM3 with Direct Drive PTO
..............................
	A mehchanical PTO is used in this example and is modeled as a direct drive linear generator. The main components of this example consist of magnets and a coil where the magnet assembly is attached to the heaving float and the coil is locacted inside the spar. As the float moves up and down, the magnet assembly creates a change in the magnetic field surrounding the spar that contains the coil: therefore, current is induced in the coil and electricity is generated.

	.. figure:: _static/MECHANICALPTO.PNG
	   :width: 400pt


	Simulink Model
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Step 1 through 3 are the same as in `RM3 with hydraulic PTO`_.

	* Step 4: Go inside PTO-Sim block and add one bus selector and one selector blocks. Only velocity is needed for this example.

	.. figure:: _static/SELECTORS2.PNG
	   :width: 400pt

	* Step 5: Go to PTO-Sim library.
	* Step 6: By looking at the physical mechanical PTO model as shown above, the user can simply drag and drop PTO-Sim library blocks. In this case, only the direct drive linear generator is needed, and it is located under generator box.

	.. figure:: _static/USEPTOSIMLIB2.PNG
	   :width: 400pt

	* Step 7: Simply connect velocity from the selector to the input of the direct drive linear generator. The ouput PTO force is fed back to WEC-Sim. 

	.. figure:: _static/DDLINEARGENPTOSIM.PNG
	   :width: 400pt

	Input File, Simulation, and Postprocessing
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



Tutorial: OSWEC with PTO-Sim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes how to use OSWEC with PTO-Sim. The same process as described in `RM3 with PTO-Sim <http://wec-sim.github.io/WEC-Sim/features.html#tutorial-rm3-with-pto-sim>`_ ; however, since OSWEC is a rotary device, it takes torque as an input and a rotary to linear motion conversion block is needed. The tutorials can be found on the `WEC-Sim_Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository (both for a crank and for a rod).

OSWEC with Hydraulic PTO
.................................

	A hydraulic PTO or mechanical PTO can be used with OSWEC but for simplicity a hydraulic PTO will be used as an example.

	.. figure:: _static/OSWECPHYMODEL.PNG
	   :width: 400pt

	.. figure:: _static/MoTIONMECHANISM.PNG
	   :width: 400pt

	Modeling of OSWEC with Hydraulic PTO
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	The same as `RM3 with hydraulic PTO`_.

	Simulink Model
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	The Simulink model can be built as following:

	* Step 1: Copy OSWEC tutorial folder to get started. 

	.. figure:: _static/COPYOSWEC.PNG
	   :width: 400pt

	* Step 2: Open ``OSWEC.slx`` file and replace Rotary PTO (Local RY) with Rotational PTO UD Torque (Local RY).

	.. figure:: _static/OSWECWITHPTOSIMBLOCK.PNG
	   :width: 400pt

	* Step 3: Use a subsystem and rename it to PTO-Sim where input is response and output is torque.

	.. figure:: _static/OSWECWITHPTOSIMBLOCK1.PNG
	   :width: 400pt

	* Step 4: Go inside PTO-Sim block and drag and drop one bus selector and two selector blocks. Since pitch is driving the piston, selection index of each selector needs to be changed to 5. Next, go to PTO-Sim library and drag and drop all the blocks for the hydraulic PTO. The rotary to linear adjustable rod block can be found under rotary to linear conversion box. 

	.. figure:: _static/USEPTOSIMLIB3.PNG
	   :width: 400pt

	* Step 5: The rotary to linear adjustable rod block takes angular position and velocity from index selector blocks and PTO force from compressible fluid piston block. The outputs of the rotary to linear adjustable rod block are linear position, velocity, and torque. Linear position and velocity are used as inputs for compressible fluid piston and torque is fed back to WEC-Sim. The rest of the connects are the same as in RM3 with hydraulic PTO. The user is encouraged to go up one level to check the connections between PTO-Sim and WEC-Sim.  

	.. figure:: _static/HYDPTOSIMOSWEC.PNG
	   :width: 400pt

	Input File, Simulation, and Postprocessing
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	The same as `RM3 with hydraulic PTO`_.


Other PTO-Sim Tutorials
~~~~~~~~~~~~~~~~~~~~~~~

Other PTO-Sim tutorials that were not discussed above can be found on the `WEC-Sim_Applications repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_.

	+--------------------------------+-------------------------------------------+
	|     **PTO-Sim Application**    |               **Description**             |                
	+--------------------------------+-------------------------------------------+
	|   RM3_Hydraulic_PTO            | RM3 with hydraulic PTO                    |
	+--------------------------------+-------------------------------------------+
	|   RM3_cHydraulic_PTO           | RM3 with compressible hydraulic PTO       |
	+--------------------------------+-------------------------------------------+
	|   RM3_DD_PTO                   | RM3 with direct drive linear generator    |
	+--------------------------------+-------------------------------------------+
	|   OSWEC_Hydraulic_PTO          | OSWEC with hydraulic PTO (adjustable rod) |
	+--------------------------------+-------------------------------------------+
	|   OSWEC_Hydraulic_Crank_PTO    | OSWEC with hydraulic PTO (crank)          |
	+--------------------------------+-------------------------------------------+