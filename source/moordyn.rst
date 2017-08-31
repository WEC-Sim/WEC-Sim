
Mooring/MoorDyn
---------------
Floating WEC systems are often connected to mooring lines to keep the device in position. WEC-Sim allows the user to model the mooring dynamics in the simulation by specifying the mooring matrix or coupling with MoorDyn. To include mooring connections, the user can use the mooring block (i.e., Mooring Matrix block or MoorDyn block) given in the WEC-Sim library under Moorings lib and connect it between the body and the Global reference frame. 
Refer the `MoorDyn Tutorial <http://wec-sim.github.io/WEC-Sim/advanced_features.html#tutorial-rm3-with-moordyn>`_ section, and the `Mooring Webinar <http://wec-sim.github.io/WEC-Sim/webinars.html#webinar-4-mooring-and-visualization>`_ for more information.

MoorDyn is hosted on  a seperate `MoorDyn repository <https://github.com/WEC-Sim/moorDyn>`_. It must be download seperately, and all files and folders should be placed in the ``$Source/functions/moorDyn`` directory.


Using Mooring Matrix
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	When the mooring matrix block is used, the user first needs to initiate the mooring class by setting :code:`mooring(i) = mooringClass('mooring name')` in the WEC-Sim input file (``wecSimInputFile.m``). Typically, the mooring connection location also need to be specified, :code:`mooring(i).ref = [1x3]` (the default connection location is ``[0 0 0]``). The user can also define the mooring matrix properties in the WEC-Sim input file using:

	* Mooring stiffness matrix - :code:`mooring(i).matrix.k = [6x6]`

	* Mooring damping matrix - :code:`mooring(i).matrix.c = [6x6]`

	* Mooring pretension - :code:`mooring(i).matrix.preTension = [1x6]`

	.. Note: 
		"i" indicates the mooring number. More than one mooring can be specified in the WEC-Sim model when the mooring matrix block is used. 

Using MoorDyn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	When the MoorDyn block is used, the user needs to initiate the mooring class by setting :code:`mooring = mooringClass('mooring name')` in the WEC-Sim input file (wecSimInputFile.m), followed by number of mooring lines is defined in MoorDyn (``mooring(1).moorDynLines = <Number of mooring lines>``)

	A mooring folder that includes a moorDyn input file (``lines.txt``) is required in the simulation folder. 
	

	.. Note: 
		WEC-Sim/MoorDyn coupling only allows one mooring configuration in the simulation.

Tutorial: RM3 with MoorDyn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	This section describes how to simulate a mooring connected WEC system in WEC-Sim using MoorDyn. The RM3 two-body floating point absorber is connected to a three-point catenary mooring system with an angle of 120 between the lines in this example case. The RM3 with MoorDyn folder is located under `WEC-Sim Applications repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_.


	* **WEC-Sim Simulink Model**: Start out by following the instructions on how to model the `RM3 Two-Body Point Absorber <http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3>`_. To couple WEC-Sim with MoorDyn, the MoorDyn Block is added in parallel to the constraint block

	.. _WECSimmoorDyn:

	.. figure:: _static/WECSimMoorDyn.png
	    :width: 320pt
	    :align: center


	* **WEC-Sim Input File**: In the ``wecSimInputFile.m`` file, the user need to initiate the mooring class and define the number of mooring lines.

	.. _WECSimInputMoorDyn:

	.. literalinclude:: RM3MooDynwecSimInputFile.m
	   :language: matlab


	* **MoorDyn Input File**: A mooring folder that includes a moorDyn input file (``lines.txt``) is created. The moorDyn input file (``lines.txt``) is shown in the figure below. More details on how to setup the MooDyn input file were described in the MoorDyn User Guide :cite:`Hall2015MoorDynGuide`.

	.. _moorDynInput:

	.. figure:: _static/moorDynInput.png
	    :width: 400pt
	    :align: center

	* **Simulation and Postprocessing**: Simulation and postprocessing are the same process as described in Tutorial Section.
	
	.. Note::
		You may need to install the MinGW-w64 compiler to run this simulation.
