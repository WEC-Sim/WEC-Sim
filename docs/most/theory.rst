.. _most-theory:

Theory
======

.. _most-theory-wind:

Wind Conditions
---------------


.. _most-theory-aero:

Aerodynamic Loading
-------------------
In MOST, the aerodynamic forces are determined using the blade element momentum theory (BEM), implemented in :cite:`ning2014simple` . This approach is considered the standard model for aerodynamic modeling. However, unlike FAST, the current study utilizes a look-up table for computing aerodynamic forces.
To calculate the contribution of each blade to the axial and tangential forces and moments, three input variables are considered: the average wind speed on the blade, the rotor angular speed, and the blade pitch. To reduce the number of required points for discretization, the angular speed and blade pitch are discretized around steady state values, excluding points that are not reachable during normal operating conditions.
:math:`\dot{X}`

In WEC-Sim, wave forcing components are modeled using linear coefficients 
obtained from a frequency-domain potential flow Boundary Element Method (BEM) 
solver (e.g., WAMIT :cite:`Lee2006`, Aqwa :cite:`AQWA`, NEMOH :cite:`NEMOH`, and Capytaine :cite:`ancellin2019,babarit2015`). 
The BEM solutions are obtained by solving the Laplace equation 
for the velocity potential, which assumes the flow is inviscid, incompressible, 
and irrotational. More details on the theory for the frequency-domain BEM can 
be found in :cite:`Lee2006`. 

.. _most-theory-rosco:

ROSCO Controller
----------------

References
----------

.. bibliography:: ../most/MOST.bib
   :style: unsrt
   :labelprefix: A
