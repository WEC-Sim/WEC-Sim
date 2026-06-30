
This section provides an overview of WEC-Sim's mooring class features; for more 
information about the mooring class code structure, refer to 
:ref:`user-code-structure-mooring-class`. 

Floating WEC systems are often connected to mooring lines to keep the device in 
position. WEC-Sim allows the user to model the mooring dynamics in the 
simulation by specifying the mooring matrix, a mooring lookup table, or coupling with MoorDyn. To 
include mooring connections, the user can use the mooring block (i.e., Mooring 
Matrix block, Mooring Lookup Table block, or MoorDyn Connection block) 
given in the WEC-Sim library under Moorings lib 
and connect it between the body and the Global reference frame. The Moordyn Connection
block can also be placed between two dynamic bodies or frames. Refer to the 
:ref:`rm3_moordyn`, and the :ref:`webinar8` for more information. 

MoorDyn is hosted on a separate `MoorDyn repository <https://github.com/WEC-Sim/moorDyn>`_. 
It must be download separately, and all files and folders should be placed in 
the ``$WECSIM/functions/moorDyn`` directory. 

.. _mooring-matrix:

Mooring Matrix
^^^^^^^^^^^^^^

When the mooring matrix block is used, the user first needs to initiate the 
mooring class by setting :code:`mooring(i) = mooringClass('mooring name')` in 
the WEC-Sim input file (``wecSimInputFile.m``). Typically, the mooring 
connection location also needs to be specified, :code:`mooring(i).location = [1x3]` 
(the default connection location is ``[0 0 0]``). The user can also define the 
mooring matrix properties in the WEC-Sim input file using: 

* Mooring stiffness matrix - :code:`mooring(i).matrix.stiffness = [6x6]` in [N/m]

* Mooring damping matrix - :code:`mooring(i).matrix.damping = [6x6]` in [Ns/m]

* Mooring pretension - :code:`mooring(i).matrix.preTension = [1x6]` in [N]

.. Note::

    "i" indicates the mooring number. More than one mooring can be specified in 
    the WEC-Sim model when the mooring matrix block is used. 

.. _mooring-lookup:

Mooring Lookup Table
^^^^^^^^^^^^^^^^^^^^

When the mooring lookup table block is used, the user first needs to initiate the 
mooring class by setting :code:`mooring(i) = mooringClass('mooring name')` in 
the WEC-Sim input file (``wecSimInputFile.m``). Typically, the mooring 
connection location also needs to be specified, :code:`mooring(i).location = [1x3]` 
(the default connection location is ``[0 0 0]``). The user must also define the 
lookup table file in the WEC-Sim input file with :code:`mooring(i).lookupTableFile = 'FILENAME';`

The lookup table dataset should contain one structure that contains fields for each index and each force table:


	+----------------+----------------------+--------------+
	| *Index Name*   |    *Description*     | *Dimensions* |
	+----------------+----------------------+--------------+
	|       X        | Surge position [m]   |    1 x nX    |
	+----------------+----------------------+--------------+
	|       Y        | Sway position [m]    |    1 x nY    |
	+----------------+----------------------+--------------+
	|       Z        | Heave position [m]   |    1 x nZ    |
	+----------------+----------------------+--------------+
	|       RX       | Roll position [deg]  |    1 x nRX   |
	+----------------+----------------------+--------------+
	|       RY       | Pitch position [deg] |    1 x nRY   |
	+----------------+----------------------+--------------+
	|       RZ       | Yaw position [deg]   |    1 x nRZ   |
	+----------------+----------------------+--------------+
    
    
	+----------------+--------------------+--------------------------------+
	| *Force Name*   | *Description*      |          *Dimensions*          |
	+----------------+--------------------+--------------------------------+
	|       FX       | Surge force [N]    | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+
	|       FY       | Sway force [N]     | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+
	|       FZ       | Heave force [N]    | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+
	|       MX       | Roll force [Nm]    | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+
	|       MY       | Pitch force [Nm]   | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+
	|       MZ       | Yaw force [Nm]     | nX x nY x nZ x nRX x nRY x nRZ |
	+----------------+--------------------+--------------------------------+


.. _mooring-moordyn:

MoorDyn
^^^^^^^

When a MoorDyn block is used, the user first needs to initiate the mooring class by 
setting :code:`mooring = mooringClass('mooring name')` in the WEC-Sim input 
file (``wecSimInputFile.m``), followed by setting :code:`mooring(i).moorDyn = 1` to 
initialize a MoorDyn connection. Each MoorDyn connection can consist of multiple 
lines and each line may have multiple nodes. The number of MoorDyn lines and nodes in 
each line should be defined as ``mooring(i).moorDynLines = <Number of mooring lines>`` 
and ``mooring(i).moorDynNodes(iLine) = <Number of mooring nodes in line>`` (only used 
for ParaView visualization), respectively and should match the number of lines and nodes 
specified in the MoorDyn input file. The order of the lines should also be the same 
between the WEC-Sim and MoorDyn input files (i.e., for a model with two MoorDyn 
connections, all lines corresponding to ``mooring(1)`` should be defined in the 
MoorDyn input file before the lines for ``mooring(2)``).

A mooring folder that includes a MoorDyn input file (``lines.txt``) is required 
in the simulation folder. The body and corresponding mooring attachment points are 
defined in the MoorDyn input file. MoorDyn handles the kinematic transform to 
convert the mooring forces from the attachment points to the 6 degree of freedom 
force acting on the current location of the body's center of gravity. The body 
location in the MoorDyn input file can be set to 0. Then, the location of all
points/nodes in the MoorDyn input file are specified relative to the global 
frame for all attachment types. 

Alternatively, the body locations can be set according to the center of gravity 
and the 'body#' attachments will need to be specified relative to each body 
location. In this case, the initial displacement of the mooring line in WEC-Sim 
(``mooring(i).initial.displacement``) should match the location of the connected 
body in the MoorDyn input file or the difference in location between two 
connected bodies. This method is no longer used in our examples as it can be 
confusing, but it should produce the same results.

.. Note::
    WEC-Sim/MoorDyn coupling now allows more than one mooring connnection (i.e., 
    multiple MoorDyn Connection blocks) in the simulation, but there can only be 
    one call to MoorDyn (i.e., one MoorDyn Caller block).

.. _rm3_moordyn:

RM3 with MoorDyn
""""""""""""""""

This section describes how to simulate a mooring connected WEC system in 
WEC-Sim using MoorDyn. The RM3 two-body floating point absorber is connected to 
a three-point catenary mooring system with an angle of 120 between the lines in 
this example case. The RM3 with MoorDyn folder is located under the `WEC-Sim 
Applications <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ repository. 

* **WEC-Sim Simulink Model**: Start out by following the instructions on how to 
  model the :ref:`user-tutorials-rm3`. To couple WEC-Sim with MoorDyn, the 
  MoorDyn Connection block is added in parallel to the constraint block and the 
  MoorDyn Caller block is added to the model (no connecting lines).

.. _WECSimmoorDyn:

.. figure:: /_static/images/WECSimMoorDyn.png
    :width: 320pt
    :align: center

* **WEC-Sim Input File**: In the ``wecSimInputFile.m`` file, the user needs to 
  initiate the mooring class and MoorDyn and define the number of mooring lines.

.. _WECSimInputMoorDyn:

.. rli:: https://raw.githubusercontent.com/WEC-Sim/WEC-Sim_Applications/main/Mooring/MoorDyn/wecSimInputFile.m
   :language: matlab

* **MoorDyn Input File**: A mooring folder that includes a moorDyn input file 
  (``lines.txt``) is created. The moorDyn input file (``lines.txt``) is shown 
  in the figure below. More details on how to set up the MooDyn input file are 
  described in the `MoorDyn Documentation <https://moordyn.readthedocs.io/en/latest/>`_. 
  One specific requirement when using WEC-Sim with MoorDyn is that the Body(s) in which 
  the mooring lines are attached to should be labeled as "Coupled" in the MoorDyn input 
  file, which allows for WEC-Sim to control the body dynamics.
  Note: WEC-Sim now uses MoorDyn v2.

.. _moorDynInput:

.. figure:: /_static/images/moorDynInput.png
    :width: 400pt
    :align: center

* **Simulation and Post-processing**: Simulation and post-processing are the 
  same process as described in Tutorial Section.

.. Note::
    You may need to install the MinGW-w64 compiler to run this simulation.
