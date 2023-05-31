.. _dev-morison-element:

As a reminder from the WEC-Sim Theory Manual, the Morison force equation assumes that the fluid forces in an oscillating flow on a structure of slender cylinders or other similar geometries arise partly from pressure effects from potential flow and partly from viscous effects. A slender cylinder implies that the diameter, :math:`D`, is small relative to the wave length, :math:`\lambda`, which is generally satisfied when :math:`D/\lambda<0.1-0.2`. If this condition is not met, wave diffraction effects must be taken into account. Assuming that the geometries are slender, the resulting force can be approximated by a modified Morison formulation for each element on the body.

Fixed Body
^^^^^^^^^^

For a fixed body in an oscillating flow the force imposed by the fluid is given by:

.. math::
    \vec{F}_{ME} = \underbrace{\rho \forall C_{m} \dot{\vec{u}}}_{\text{Inertia}} + \underbrace{\frac{1}{2} \rho A C_{D} \vec{u} | \vec{u} |}_{Drag}
    :label: fixed

where :math:`\vec{F}_{ME}` is the Morison element hydrodynamic force, :math:`\rho` is the fluid density, :math:`\forall` is the displaced volume, :math:`C_{m}` is the inertia coefficient, :math:`A` is the reference area, :math:`C_{D}` is the drag coefficient, and :math:`u` is the fluid velocity. The inertia coefficient is defined as: 

.. math::
    C_{m} = 1 + C_{a}
    :label: inertiacoeff

where :math:`C_{a}` is the added mass coefficient. The inertia term is the sum of the Froude- Krylov Force, :math:`\rho \forall \dot{u}`, and the hydrodynamic mass force, :math:`\rho C_{a} \forall \dot{u}`. The inertia and drag coefficients are generally obtained experimentally and have been found to be a function of the Reynolds (Re) and Kulegan Carpenter (KC) numbers

.. math:: 
    \text{Re} = \frac{U_{m}D}{\nu}~~\&~~ \text{KC} = \frac{U_{m}T}{D}~~
    :label: kcre

where :math:`U_{m}` is the maximum fluid velocity,  and :math:`\nu` is the kinematic viscosity of the fluid, and :math:`T` is the period of oscillation.  Generally when KC is small then :math:`\vec{F}` is dominated by the inertia term when the drag term dominates at high KC numbers.  If the fluid velocity is sinusoidal then :math:`u` is given by:

.. math:: 
    u(t) = U_{m} \sin \left( \sigma t \right)~~
    :label: sinusoidalflow

where :math:`\sigma = 2\pi/T`.  This can be taking further by considering the body is being is impinged upon by regular waves of the form:

.. math:: \eta(x,t) & = A \cos \left( \sigma t - k \left[ x \cos \theta + y \sin \theta\right] \right) = \Re \left\lbrace -\frac{1}{g}\frac{\partial \phi_{I}}{\partial t} \bigg|_{z=0} \right\rbrace~~, \\ \phi_{I}(x,z,t) & = \Re \left\lbrace \frac{Ag}{\sigma} \frac{\cosh \left(k (z+h) \right)}{\cosh \left( kh \right)} i e^{i(\sigma t-k\left[ x \cos \theta + y \sin \theta\right])} \right\rbrace~~, \\ \sigma^{2} & = gk\tanh\left(kh\right)
   :label: eqna

where :math:`\eta` is the wave elevation, :math:`\phi_{I}` is the incident wave potential, :math:`A` is the wave amplitude, :math:`k` is the wave number (defined as :math:`k=\frac{2\pi}{\lambda}` where :math:`\lambda` is the wave length), :math:`g` is gravitational acceleration, :math:`h` is the water depth, :math:`z` is the vertical position in the water column, :math:`\theta` is the wave heading. The fluid velocity can then be obtained by taking the graident of Eqn. :eq:`eqna` :

.. math::
   u (x,z,t) & = \Re \left\lbrace \frac{\partial \phi_{I}}{\partial x} \right\rbrace = \frac{Agk}{\sigma} \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \cos \left( \sigma t - k x \right) \cos\left(\theta\right)~~,\\
   v (x,z,t) & = \Re \left\lbrace \frac{\partial \phi_{I}}{\partial y} \right\rbrace = \frac{Agk}{\sigma} \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \cos \left( \sigma t - k x \right)\sin\left(\theta\right)~~,\\
   w (x,z,t) & = \Re \left\lbrace \frac{\partial \phi_{I}}{\partial z} \right\rbrace = -\frac{Agk}{\sigma} \frac{\sinh \left( k (z+h)\right)}{\cosh \left( kh \right)} \sin \left( \sigma t - k x \right)~~,
   :label: eqnb
      
The acceleration of the fluid particles will then be obtained by taking the time derivative of Eqn. :eq:`eqnb` :

.. math:: 
   \dot{u} (x,z,t) & = \frac{\partial u}{\partial t} = -Agk \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \sin \left( \sigma t - k x \right) \cos\left(\theta\right)~~,\\
   \dot{v} (x,z,t) & = \frac{\partial v}{\partial t} = -Agk \frac{\cosh \left( k (z+h)\right)}{\cosh \left( kh \right)} \sin \left( \sigma t - k x \right) \sin\left(\theta\right)~~,\\
   \dot{w} (x,z,t) & = \frac{\partial w}{\partial t} = -Agk \frac{\sinh \left( k (z+h)\right)}{\cosh \left( kh \right)} \cos \left( \sigma t - k x \right)~~,
   :label: dotuw
   
.. figure:: /_static/images/HorizontalVerticalOrbitalVelocity.jpg
   :width: 400pt
   :align: center
   
   Horizontal and vertical orbital velocity magnitude for a wave period of 10 s and water depth of 50 m with a wave heading of 0 rads.

.. figure:: /_static/images/MagAngleOrbitalVelocity.jpg
   :width: 400pt
   :align: center
      
   Orbital velocity magnitude vectors for a wave period of 10 s and water depth of 50 m with a wave heading of 0 rads.

Moving Body
^^^^^^^^^^^

If the body is allowed to move in an oscillating flow then Eqn. :eq:`fixed` must be adjusted as follows:

.. math::
   \vec{F}_{ME} = \rho \forall \dot{\vec{u}} + \rho \forall C_{a} \left( \dot{\vec{u}} - \dot{\vec{U}} \right) + \frac{1}{2}\rho C_{D} A \left( \vec{u} - \vec{U} \right) \left| \vec{u} - \vec{U} \right|~~
   :label: moving
   
where :math:`U` is the body velocity.  In the calculations performed by WEC-Sim, it is assumed that the body does not alter the wave field and the fluid velocity and acceleration can be calculated from the incident wave potential as from Eqn. :eq:`eqnb` and :eq:`dotuw`.


Review of Rigid Body Dynamics
"""""""""""""""""""""""""""""

A rigid body is an idealization of a solid body in which deformation is neglected. In other words, the distance between any two given points of a rigid body remains constant in time regardless of external forces exerted on it.  The position of the whole body is represented by its linear position together with its angular position with a global fixed reference frame.  WEC-Sim calculates the position, velocity, and acceleration of the rigid body about its center of gravity; however, the placement of each morrison element will have a different local velocity that affects the fluid force.  The relative velocity between point A and point B on a rigid body is given by:

.. math::
   \vec{U}_{A} = \vec{U}_{B} + \omega \times r_{BA}~~
   :label: relV

where :math:`\omega` is the angular velocity of the body and :math:`\times` denotes the cross product.  Taking the time derivative of Eqn. :eq:`relV` provides the relative acceleration:

.. math::
   \vec{\dot{U}}_{A} = \vec{\dot{U}}_{B} + \omega \times \omega \times r_{BA} + \dot{\omega} \times r_{BA}~~
   :label: relA
   
WEC-Sim Implementations
^^^^^^^^^^^^^^^^^^^^^^^

As discussed in the WEC-Sim user manual, there are two options to model a Morison element(s) and will be described here in greater detail so potential developers can modify the code to suit their modeling needs.

Option 1
""""""""

In the first Morison element implementation option, the acceleration and velocity of the fluid flow are estimated at the Morison point of application, which can include both wave and current contributions, and then subtracts the body acceleration and velocity for the individual translational degrees of freedom (x-, y-, and z-components). The fluid flow properties are then used to calculate the Morison element force, indepenently for each degree of freedom, as shown by the following expressions:  

.. math::
   F_{ME,x} & = \rho \forall \dot{u}_{x} + \rho \forall C_{a,x} \left( \dot{u}_{x} - \dot{U}_{x} \right) + \frac{1}{2}\rho C_{D,x} A_{x} \left( u_{x} - U_{x} \right) \left| u_{x} - U_{x} \right|~~, \\
   F_{ME,y} & = \rho \forall \dot{u}_{y} + \rho \forall C_{a,y} \left( \dot{u}_{y} - \dot{U}_{y} \right) + \frac{1}{2}\rho C_{D,y} A_{y} \left( u_{y} - U_{y} \right) \left| u_{y} - U_{y} \right|~~, \\
   F_{ME,z} & = \rho \forall \dot{u}_{z} + \rho \forall C_{a,z} \left( \dot{u}_{z} - \dot{U}_{z} \right) + \frac{1}{2}\rho C_{D,z} A_{z} \left( u_{z} - U_{z} \right) \left| u_{z} - U_{z} \right|~~, \\
   \vec{M} & = \vec{r} \times \vec{F} = \left[ r_{g,x}, r_{g,y}, r_{g,z} \right] \times \left[ F_{x}, F_{y}, F_{z} \right]
   :label: mefOption1

where :math:`r_{g}` is the lever arm from the center of gravity of the body to the Morison element point of application. Option 1 provides the most flexibility in setting independent Morison element properties for the x-, y-, and z-directions; however, a limitation arises that the fluid flow magnitude does not consider the other fluid flow components. Depending on the simulation enviroment this approach can provide the same theoretical results as taking the magnitude of the x-, y-, and z-components of the fluid flow, but is case dependent. A comparison between the outputs of Option 1 and Option 2 can be found later in the Developer Manual Morison Element documentation. 

Option 2
""""""""

The WEC-Sim Option 1 implementation solves for the of the Morison element force from the individual x-, y-, and z-components of the relative flow velocity and acceleration; however, this results in incorrect outputs at certain orientations of the flow and Morison Element. As opposed to solving for the x-, y-, and z-components of the Morison element force, the force can be calculated relative to the magnitude of the flow and distributed among its unit vector direction. Therefore the approach used in Option 2 is to decompose the fluid and body velocity and acceleration into tangential and normal components of the Morison element, as depicted in Figure :ref:`fig-option-2`

.. _fig-option-2:

.. figure:: /_static/images/option2Schematic.jpg
   :width: 600pt
   :align: center
      
   Schematic of the water flow vector decomposition reletive to the Morison Element orientation.
      
In mathematics, for a given vector at a point on a surface, the vector can be uniquely decomposed into the sum of its tangential and normal components. The tangential component of the vector, :math:`v_{\parallel}`, is parallel to the surface while the normal component of the vectors, :math:`v_{\perp}`, is perpendicular to the surface which is used in relation to the central axis to the Morison element. The WEC-Sim input file was altered to consider a tangential and normal component for the drag coefficient [:math:`C_{d\perp}` , :math:`C_{d\parallel}`] , added mass coefficient [:math:`C_{a\perp}` , :math:`C_{a\parallel}`], characteristic area [:math:`A_{\perp}` , :math:`A_{\parallel}`], and the central axis vector of the ME  = [ :math:`\vec{z} = `:math:`z_{x}` , :math:`z_{y}` , :math:`z_{z}` ].

A general vector, :math:`\vec{k}`, can be decomposed into the normal component as a projection of vector k on to the central axis z as follows:

.. math::
   \vec{k}_{\parallel} = \frac{\vec{z} \cdot \vec{k}}{ || \vec{z} || } \frac{ \vec{z} }{ || \vec{z} || }
   :label: parallel
   
As the vector :math:`\vec{k}` is uniquely decomposed into the sum of its tangential and normal components, the normal component can be defined as the difference between the vector :math:`\vec{k}` and its tangential component as follows:

.. math::
   \vec{k}_{\perp} = \vec{k} - \vec{k}_{\parallel}
   :label: perpendicular

Using this vector multiplication, the tangential and normal components of the fluid flow can be obtained as follows:

.. math::
   \vec{u}_{\parallel} = \frac{\vec{z} \cdot \vec{u}}{ || \vec{z} || } \frac{ \vec{z} }{ || \vec{z} || } \\
   \vec{u}_{\perp} = \vec{u}-\vec{u}_{\perp}
   :label: Vparper
   
The Morison element force equation for a moving body relative to the fluid flow is modified to include the following decomposition of force components and consider the magnitude of the flow:

.. math::
   \vec{F}_{ME} = \rho C_{M,\parallel} \forall \left( \dot{\vec{u}}_{\parallel} - \dot{\vec{U}}_{\parallel} \right) + \frac{1}{2}\rho C_{d,\parallel} \left( \vec{v}_{\parallel} - \vec{U}_{\parallel} \right) \lvert \vec{v}_{\parallel} - \vec{U}_{\parallel} \rvert + \\
   \rho C_{M,\perp} \forall \left( \dot{\vec{u}}_{\perp} - \dot{\vec{U}}_{\perp} \right) + \frac{1}{2}\rho C_{d,\perp} \left( \vec{v}_{\perp} - \vec{U}_{\perp} \right) \lvert \vec{v}_{\perp} - \vec{U}_{\perp} \rvert
   :label: mefOption2

Comparison of Performance Between Option 1 and Option 2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

A simple test case, which defines a Morison element as vertical and stationary relative to horizontal fluid flow, was built to compare the Morison element force calculation between Option 1 and Option 2 within WEC-Sim. Theoretically, the magnitude of the Morison element force should remain constant as the orientation of the flow direction is rotated in the X-Y plane. The MF was calculated as the orientation of the flow was rotated about the z-axis from 1 to 360 degrees where the central axis of the ME is parallel wtih the z-axis. The remaining WEC-Sim input values for the simulation can be found in the following table. 

=========================   	===================== 	================================== 	
**Variable Type**            	**Variable Symbol**	**WEC-Sim Input Values**         			
ME Central Axis     		:math:`\vec{z}`		[0, 0 , 1]    			
Fluid flow velocity		:math:`\vec{U}`		[-1, 0, 0] :math:`m/s`		
Fluid flow acceleration		:math:`\vec{\dot{U}}`   [-1, 0, 0] :math:`m/s^{2}`	
Drag Coefficient	    	:math:`C_{D}`		[1, 1, 0]		
Mass Coefficient	   	:math:`C_{a}`		[1, 1, 0]			
Area 				:math:`A`		[1, 1, 0]		
Density 		    	:math:`\rho`		1000 :math:`kg/m^{3}`
Displaced Volume		:math:`\forall`		0.10 :math:`m^{3}`
=========================   	===================== 	==================================

.. figure:: /_static/images/compPerformanceBetweenOption1Option2.png
   :width: 500pt
   :align: center
      
   Graphical representation of the comparison between ME Option 1 and Option 2 within WEC-Sim.
   
:math:`F_{ME,1}` and :math:`F_{ME,2}` is the Morison element force output from Option 1 and Option 2 within WEC-Sim, respectively. Shown in the above figure, in Option 1 there is an oscillation in Morison element magnitude with flow direction while Option 2 demonstrates a constant force magnitude at any flow direction. The reason behind this performance is that Option 1 solves for the MF individually using the individual the x-, y-, and z- components of the flow while Option 2 calculates the force relative to the flow magnitude and distributed among the normal and tangential unit vectors of the flow.
