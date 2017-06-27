Mooring/MoorDyn
------------------
Floating WEC systems are often connected to mooring lines to keep the device in position. WEC-Sim allows the user to model the mooring dynamics in the simulation by specifying the mooring matrix or coupling with MoorDyn. To include mooring connections, the user can use the mooring block (i.e., Mooring Matrix block or MoorDyn block) given in the WEC-Sim library under Moorings lib and connect it between the body and the Global reference frame. Please see the following Tutorial subsection for more information.


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
	A WEC-Sim/MoorDyn coupling example is provided in the `WEC-Sim Applications <https://github.com/WEC-Sim/WEC-Sim_Applications/tree/master/RM3_MoorDyn>`_ repository and will be described in the following subsection.

	.. Note: 
		WEC-Sim/MoorDyn coupling only allows one mooring configuration in the simulation.

Tutorial: RM3 with MoorDyn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	This section describes how to simulate a mooring connected WEC system in WEC-Sim using MoorDyn. The RM3 two-body floating point absorber is connected to a three-point catenary mooring system with an angle of 120 between the lines in this example case. The RM3 with MoorDyn folder is located under `WEC-Sim_Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_.


	* WEC Model: To couple WEC-Sim with MoorDyn, the MoorDyn Block is added in parallel to the constraint block

	.. _WECSimmoorDyn:

	.. figure:: _static/WECSimMoorDyn.png
	    :width: 320pt
	    :align: center


	* WEC-Sim input file: In the ``wecSimInput.m`` file, the user need to initiate the mooring class and define the number of mooring lines.

	.. _WECSimInputMoorDyn:

	.. literalinclude:: RM3MooDynwecSimInputFile.m
	   :language: matlab


	* MoorDyn Input File: A mooring folder that includes a moorDyn input file (``lines.txt``) is created. The moorDyn input file (``lines.txt``) is shown in the figure below. More details on how to setup the MooDyn input file were described in the MoorDyn User Guide :cite:`Hall2015MoorDynGuide`.

	.. _moorDynInput:

	.. figure:: _static/moorDynInput.png
	    :width: 400pt
	    :align: center

	* Simulation and Postprocessing: Simulation and postprocessing are the same process as described in Tutorial Section.
	
	.. Note::
		You may need to install the MinGW-w64 compiler to run this simulation.
