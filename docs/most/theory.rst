.. _most-theory:

Theory
======

.. _most-theory-aero:

Aerodynamic Loading
-------------------
In MOST, the aerodynamic forces are determined using the blade element momentum theory (BEMT), as implemented in :cite:`ning2014simple`. This approach is considered the standard model for aerodynamic modeling. The aerodynamic forces are computed using a precomputed look-up table. The contribution of each blade to the axial force FX, tangential force FY, bending moment MY and torque moment MX is a function of three input variables: the average wind speed on the blade, the rotor angular speed and the blade pitch. In order to decrease the points necessary for the discretization, the angular speed and the blade pitch are discretized around the steady state points, thus excluding the points that are never reached in operating conditions. The number of points is evenly spaced. MOST cannot not take into account the flexibility of the blade (rigid body assumption), the deflection of the wake due to the rotor yaw misalignment, dynamic stall and the wake dynamics.
The grid of the wind speed is created using the opensource software Turbsim, published by NREL :cite:`kelley2005overview`, and imported in Matlab environment. 
The average wind speed is determined by interpolating specific points for each blade in the wind grid along the blade length. The points should be taken closer to the tip (i.e. starting from the middle to the tip), and the  reason for that is that the wind speed has more influence at the final section of the blade.
the dynamics of the platform and the influence of the proper motion of the rotor is taken into account, adding the hub surge velocity to the wind speed, and hub pitch and yaw rotational velocity multiplied by a predefined distance d along the blade length (for example, two thirds of the blade length): :math:`V=v_{wind}+V{Xhub}+\omega_{pitch}*d*cos(\azimuth)+\omega_{yaw}*d*sin(\azimuth)`.

image:: reference_windturbine.jpg
   :width: 400pt
   :height: 175pt
   :align: middle

.. _most-theory-rosco:

ROSCO Controller
----------------
The wind turbine's control system is managed by the ROSCO controller (Reference Open-Source COntroller for fixed and floating offshore wind turbines), which was developed by the Delft University of Technology :cite:`abbas2022reference`. Unlike conventional controllers designed for specific turbines and difficult to adapt, the ROSCO controller is intended to serve as a reference that can be used by non-control engineers as well.
The primary goal of the controller is to maximize power output by modifying three control parameters: the rotor orientation (yaw system), the blade orientation (pitch system), and the generated torque. It achieves this through two methods of actuation: a variable-speed generator torque controller to manage generator power and a collective blade pitch controller to regulate rotor speed.
The behavior of the control system can be categorized into four regions, as depicted in Figure 20:

 Region 1: This region corresponds to wind speeds below the cut-in threshold, where there is insufficient wind to produce power. Here, the generator torque is set to zero, allowing the wind to accelerate the rotor for start-up.

 Region 2: This region corresponds to wind speeds below the rated conditions. The main objective here is to extract the maximum energy from the wind.

 Region 3: This region corresponds to wind speeds above the rated conditions. In this case, the power is limited to prevent damage to the components.

 Region 4: This region corresponds to wind speeds above the cut-out threshold, where the turbine needs to be turned off due to excessively strong winds. The blades are pitched to reduce thrust force to zero (feathering) to ensure safe shutdown.

Overall, the ROSCO controller provides an efficient and adaptable approach to optimizing power generation in wind turbines, making it accessible to a wider range of users, including non-control engineers.

image:: ROSCOregions.PNG
   :width: 400pt
   :height: 175pt
   :align: middle

References
----------

.. bibliography:: ../most/MOST.bib
   :style: unsrt
   :labelprefix: B
