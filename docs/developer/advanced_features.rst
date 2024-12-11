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

.. _dev-advanced-features-variable-hydro:

Variable Hydrodynamics
----------------------
The variable hydrodynamics implementation was created to make the minimal
number of alterations to, and best fit WEC-Sim's previous pre-processing 
structure:

* ``h5File``
   * Instead of initializing the body class with one string 
     (one H5 file name), a cell array of strings can be passed, e.g.
   * body(1) = bodyClass({'H5FILE_1.h5','H5FILE_2.h5','H5FILE_3.h5');
* ``hydroData``
   * Each H5 file is processed into a hydroData structure. All structs are 
     concatenated into ``hydroData`` which is now an array of structures instead
     of one struct.
* ``hydroForce``
   * Ideally, hydroForce would also be a structure array becuase the format is 
     clean, easy to understand, and easy to index into. However, all 
     information in ``hydroForce`` needs to be loaded into Simulink at run time.
     Structure arrays cannot be loaded into Simulink in this way. So, 
     ``hydroForce`` is a nested structure containing ``hf1``, ``hf2``, ... ``hfn``. 
     Each instance of hf1, hf2, etc is an identical structure that contains
     hydrodynamic force coefficients that are applied at runtime.
     A custom bus is created using ``struct2bus.m`` to map all
     hydroForce data into Simulink.

The scenario being modeled, state changed, signals used to vary hydrodynamics,
and the user logic is completely undefined so as to not artifically restrict the
applicability of variable hydrodynamics.

The method of loading in many distinct sets of BEM data provides some flexibility
to the implementation, but it does not allow for instantaneous interpolation
between datasets. In some instances this will speed up simulations, for example
compared to passive yaw in irregular waves. However the limitation of this 
method is that switching between BEM datasets can become noisy and unstable, 
requiring a very fine discretization of BEM datasets input to WEC-Sim.
