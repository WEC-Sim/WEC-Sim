.. _dev-advanced-features:

Advanced Features
=================


Added Mass
-----------

.. include:: /_include/added_mass.rst


Morison Element
---------------

.. include:: /_include/morison_element.rst

.. TO DO: add passive yaw
.. TO DO: add morison element
.. TO DO: add passive yaw
.. TO DO: add PTO-Sim

Extract Mask Variables
----------------------
The Simulink variable workspace is inaccesible in the MATLAB workspace by default.
Simulink variables can be imported to the MATLAB workspace using the block handle 
of the Simulink block being probed. The block parameters can be used by developers
to programmatically set block parameters by being able to access the unique tags
that Simulink uses for a particular block parameter. This is also useful for the code
initialization of Simulink mask blocks.
The function :code:`ExtractMaskVariables()` 
located in :code:`source\functions\simulink\mask`, can be used to extract the block
parameters in following steps,

* Open the pertinent Simulink model,
* Run the function with the address of the block being probed as the argument,
* Explore the :code:`mask` data structure in the MATLAB workspace.


.. figure:: /_static/images/extractMaskVariables.PNG
   :width: 550pt
   :figwidth: 550pt
   :align: center