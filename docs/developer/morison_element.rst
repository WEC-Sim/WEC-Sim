.. _dev-morison-element:

Fixed Body
##########

For a fixed body in an oscillating flow the force imposed by the fluid is given by:

.. math::

    \vec{F} = \underbrace{\rho \forall C_{m} \dot{\vec{u}}}_{\text{Inertia}} + \underbrace{\frac{1}{2} \rho A C_{D} \vec{u} | \vec{u} |}_{Drag}

where :math:`\vec{F}` is the Morison element hydrodynamic force, :math:`\rho` is the fluid density, :math:`\forall` is the displaced volume, :math:`C_{m}` is the inertia coefficient, :math:`A` is the reference area, :math:`C_{D}` is the drag coefficient, and :math:`u` is the fluid velocity. The inertia coefficient is defined as: 

.. math::

    C_{m} = 1 + C_{a},

where :math:`C_{a}` is the added mass coefficient. The inertia term si the sum of the Froude Krylov Force, :math:`\rho \forall \dot{u}`, and the hydrodynamic mass force, :math:`\rho C_{a} \forall \dot{u}`. The inertia and drag coefficients are generally obtained experimentally and have been found to be a function of the Reynolds (Re) and Kulegan Carpenter (KC) numbers

.. math:: \text{Re} = \frac{U_{m}D}{\nu}~~\&~~ \text{KC} = \frac{U_{m}T}{D}~~

where :math:`U_{m}` is the maximum fluid velocity,  and :math:`\nu` is the kinematic viscosity of the fluid, and :math:`T` is the period of oscillation.  Generally when KC is small then :math:`\vec{F}` is dominated by the inertia term when the drag term dominates at high KC numbers.  If the fluid velocity is sinusoidal then :math:`u` is given by:

.. math:: u(t) = U_{m} \sin \left( \sigma t \right)~~

where :math:`\sigma = 2\pi/T`.  This can be taking further by considering the body is being is impinged upon by regular waves of the form:

.. math:: \eta(x,t) & = & A \cos \left( \sigma t - k x\right) = \Re \left\lbrace -\frac{1}{g}\frac{\partial \phi_{I}}{\partial t} \bigg|_{z=0} \right\rbrace~~, \\ \phi_{I}(x,z,t) & = & \Re \left\lbrace \frac{Ag}{\sigma} \frac{\cosh \left(k (z+h) \right)}{\cosh \left( kh \right)} i e^{i(\sigma t-kx)} \right\rbrace~~,
   :label: eqna

where :math:`\eta` is the wave elevation, :math:`\phi_{I}` is the incident wave potential, :math:`A` is the wave amplitude, :math:`k` is the wave number (defined as :math:`k=\frac{2\pi}{\lambda}` where :math:`\lambda` is the wave length), :math:`g` is gravitational acceleration, :math:`h` is the water depth, and :math:`z` is the vertical position in the water column. The fluid velocity can then be obtained by taking the graident of Eqn. :eq:`eqna`

.. math::
   u (x,z,t) & = & \Re \left\lbrace \frac{\partial \phi_{I}}{\partial x} \right\rbrace = \frac{Agk}{\sigma} \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \cos \left( \sigma t - k x \right)~~,\\
   w (x,z,t) & = & \Re \left\lbrace \frac{\partial \phi_{I}}{\partial z} \right\rbrace = -\frac{Agk}{\sigma} \frac{\sinh \left( k (z+h)\right)}{\cosh \left( kh \right)} \sin \left( \sigma t - k x \right)~~,
   :label: eqnb
      
The acceleration of the fluid particles will then be obtained by taking the time derivative of Eqn. :eq:`eqnb`

.. math:: 
   \dot{u} (x,z,t) & = & \frac{\partial u}{\partial t} = -Agk \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \sin \left( \sigma t - k x \right)~~,\\
   \dot{w} (x,z,t) & = & \frac{\partial w}{\partial t} = -Agk \frac{\sinh \left( k (z+h)\right)}{\cosh \left( kh \right)} \cos \left( \sigma t - k x \right)~~,
   :label: dotuw
   
.. figure:: /_static/images/HorizontalVerticalOrbitalVelocity.jpg
   :width: 400pt
   :align: center
   
   Horizontal and vertical orbital velocity magnitude for a wave period of 10 s and water depth of 50 m.

.. figure:: /_static/images/MagAngleOrbitalVelocity.jpg
   :width: 400pt
   :align: center
      
   Orbital velocity magnitude vectors for a wave period of 10 s and water depth of 50 m.

Moving Body
###########

If the body is allowed to move in an oscillating flow then Eqn.~(\ref{eqn:Fixed}) must be adjusted as follows:

.. math::
   \vec{F} = \rho \forall \dot{\vec{u}} + \rho \forall C_{a} \left( \dot{\vec{u}} - \dot{\vec{U}} \right) + \frac{1}{2}\rho C_{D} A \left( \vec{u} - \vec{U} \right) \left| \vec{u} - \vec{U} \right|~~,
   
where :math:`U` is the body velocity.  In the calculations performed by WEC-Sim, it is assumed that the body does not alter the wave field and the fluid velocity and acceleration can be calculated from the incident wave potential as from Eqn. :eq:`eqnb` and :eq:`dotuw`.


Review of Rigid Body Dynamics
*****************************

A rigid body is an idealization of a solid body in which deformation is neglected. In other words, the distance between any two given points of a rigid body remains constant in time regardless of external forces exerted on it.  The position of the whole body is represented by its linear position together with its angular position with a global fixed reference frame.  WEC-Sim calculates the position, velocity, and acceleration of the rigid body about its center of gravity; however, the placement of each morrison element will have a different local velocity that affects the fluid force.  The relative velocity between point A and point B on a rigid body is given by:

.. math::
   \vec{V}_{A} = \vec{V}_{B} + \omega \times r_{BA}~~,
   :label: relV

where :math:`\omega` is the angular velocity of the body and :math:`\times` denotes the cross product.  Taking the time derivative of Eqn. :eq:`relV` provides the relative acceleration:

.. math::
   \vec{\dot{V}}_{A} = \vec{\dot{V}}_{B} + \omega \times \omega \times r_{BA} + \dot{\omega} \times r_{BA}~~.
   
Implementation Within WEC-Sim
#############################

Test

Option 1
********

Test

Option 2
********

The WEC-Sim Option 1 implementation solves for the of the Morison Element Force (MEF) from the individual x-, y-, and z-components of the relative flow velocity and acceleration; however, this results in incorrect outputs at certain orientations of the flow and Morison Element. As opposed to solving for the x-, y-, and z-components of the MEF, the force could be calculated relative to the magnitude of the flow and distributed among its unit vector direction. Therefore the approach used in Option 2 is to decompose the fluid motion and body motion into tangential and normal components of the Morison Element, as depicted in Figure :ref:`fig-option-2`

.. _fig-option-2:

.. figure:: /_static/images/option2Schematic.jpg
   :width: 600pt
   :align: center
      
   Schematic of the water flow vector decomposition reletive to the Morison Element orientation.
      
Test Test
=========

In mathematics, for a given vector at a point on a surface, the vector can be uniquely decomposed into the sum of its tangential and normal components. The tangential component of the vector, :math:`v_{\parallel}`, is parallel to the surface while the normal component of the vectors, :math:`v_{\perp}`, is perpendicular to the surface. This property is used in relation to the ME’s central axis. The WEC-Sim input file was altered to consider a tangential and normal component for the drag coefficient [C_(d),C_(d)] , added mass coefficient [C_(a),C_(a)], characteristic area [A,A_(||)], and the central axis vector of the ME [z_x,z_y,z_z].

Fluid velocity, fluid acceleration, WEC body velocity and WEC body acceleration are decomposed into tangential and normal components in the updated code. A general vector, k, can be decomposed into the tangential component as a projection of vector k on to the central axis z as follows:
	
.. math::
  \vec{k}

As the vector k is uniquely decomposed into the sum of its tangential and normal components, the normal component can be defined as the difference between the vector k and its tangential component, in Equation 14.

The Morison equation for a moving body relative to fluid flow is modified to include the following decomposition of force components and consider the magnitude of the flow into Equation 15. 
