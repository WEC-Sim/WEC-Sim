.. _most-theory:

Theory
======

.. _most-theory-wind:

Wind Conditions
---------------


.. _most-theory-aero:

Aerodynamic Loading
-------------------
In MOST, the aerodynamic forces are determined using the blade element momentum theory (BEM), implemented in :cite:`Cummins1962` . This approach is considered the standard model for aerodynamic modeling. However, unlike FAST, the current study utilizes a look-up table for computing aerodynamic forces.
To calculate the contribution of each blade to the axial and tangential forces and moments, three input variables are considered: the average wind speed on the blade, the rotor angular speed, and the blade pitch. To reduce the number of required points for discretization, the angular speed and blade pitch are discretized around steady state values, excluding points that are not reachable during normal operating conditions.

.. _most-theory-rosco:

ROSCO Controller
----------------

References
----------

.. bibliography:: MOST.bib
   :style: unsrt
   :labelprefix: A
