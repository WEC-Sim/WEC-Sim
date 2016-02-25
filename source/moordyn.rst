.. _moordyn:

Mooring Modeling
------------------------------
Floating WEC systems are often connected to mooring lines to keep the device in position. WEC-Sim allows the user to model the mooring dynamics in the simulation by specifying the mooring matrix or coupling with MoorDyn. To include mooring connections, the user can use the mooring block (i.e., Mooring Matrix block or MoorDyn block) given in the WEC-Sim library under Moorings lib and connect it between the body and the Global reference frame. Please see the following Tutorial subsection for more information.


Using Mooring Matrix
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When the mooring matrix block is used, the  mooring matrix can be specified in the WEC-Sim input file (``wecSimInputFile.m``). The options inlcude:

* Mooring stiffness matrix - :code:`mooring(i).mooring.k = [6x6]`

* Mooring damping matrix - :code:`mooring(i).mooring.c = [6x6]`

* Mooring pretension - :code:`mooring(i).mooring.preTension = [6x1]`

Note: More than one mooring matrix can be speficied in the WEC-Sim model. 

Using MoorDyn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When the moorDyn block is used


Tutorial: RM3 with MoorDyn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. Note::

	Coming soon!