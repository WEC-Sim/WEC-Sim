.. _dev-added-mass:

Added mass is a special multi-directional fluid dynamic phenomenon that most
physics software cannot account for well. WEC-Sim uses a special added mass 
treatment to get around the current limitations of Simscape Multibody. For the 
most robust simulation, the added mass matrix should be combined with the mass 
and inertia, shown in the manipulation of the governing equation below: 

.. math::

    m\ddot{X_i} &= \Sigma F(t,\omega) - A(\omega)\ddot{X_i} \\
    (m+A(\omega))\ddot{X_i} &= \Sigma F(t,\omega)

The subscript ``i`` represents the timestep being solved for. In this 
case, the mass of a body is set to the sum of the translational mass, rotational 
inertia and the added mass matrix:

.. math::

    M_{adjusted} = m+A(\omega) = \begin{bmatrix}
                       m + A_{1,1} & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & m + A_{2,2} & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & m + A_{3,3} & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & I_{1} + A_{4,4} & A_{4,5} & A_{4,6} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & A_{5,4} & I_{2} + A_{5,5} & A_{5,6} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & A_{6,4} & A_{6,5} & I_{3} + A_{6,6} \\
                   \end{bmatrix}

This formulation is also ideal because it completely removes the acceleration 
dependence from the right hand side of the equation. Without this treatment, the 
acceleration creates an unsolvable algebraic loop. There are ways to get around 
this issue, but simulation robustness and stability become more difficult.

The core issue with this combined mass formulation is that Simscape does not 
allow a generic body to have a degree-of-freedom specific mass.
A Simscape body is only allowed to have one translational mass and three values 
of inertia about each translational axis. This results in a four-component mass, 
far less than a complete 36-component added mass.

Due to this limitation, WEC-Sim cannot combine the mass and added mass on 
the left-hand side of the equation of motion, as shown above. Instead, WEC-Sim 
moves some components of added mass, while the majority of the components remain 
on the right-hand side. There is a 1-1 mapping between rotational inertia and the 
roll-roll, pitch-pitch, yaw-yaw added mass components. Additionally, some 
combination of the surge-surge, sway-sway, heave-heave components correspond to 
the translational mass of the body. Therefore, WEC-Sim treats the added mass in 
the following way:

.. math::

    M_{adjusted} &= m_{body} + \alpha Y; Y = (A_{1,1} + A_{2,2} + A_{3,3}) \\
    I_{adjusted} &= \begin{bmatrix}
                       I_{1} + A_{4,4} \\
                       I_{2} + A_{5,5} \\
                       I_{3} + A_{6,6} \\
                   \end{bmatrix} \\
    A_{adjusted} &= \begin{bmatrix}
                       A_{1,1} - \alpha Y & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & A_{2,2} - \alpha Y & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & A_{3,3} - \alpha Y & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & 0 & A_{4,5} & A_{4,6} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & A_{5,4} & 0 & A_{5,6} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & A_{6,4} & A_{6,5} & 0\\
                   \end{bmatrix}

The factor :math:`\alpha` represents ``simu.adjMassWeightFun``, which defaults to 2.

One can see that the summation of the adjusted mass, inertia and added mass would 
be identical to the original summation above. The main point being the governing 
equation of motion does not change, only its implementation. A simulation class 
weight factor controls the degree to which the added mass is adjusted to create the 
most robust simulation possible. To see its effects, set ``simu.adjMassWeightFun = 0``
and WEC-Sim will likely become unstable.

However WEC-Sim again contains an unsolvable algebraic loop due to the acceleration 
dependence. WEC-Sim removes this algebraic problem using a Simulink 
``Transport Delay`` with a very small time delay (``1e-8``). Normally this would 
result in using the acceleration at a previous time step to calculate the added 
mass force. However, since the time delay is smaller than the simulation time step 
Simulink will extrapolate the previous step to within 1e-8 of the current time step. 
This will convert the algebraic loop equation of motion to a solvable one:

.. math::

    m_{adjusted}\ddot{X_i} &= \Sigma F(t,\omega) - A(\omega)_{adjusted}\ddot{X}_{i - (10^{-8}/dt)} \\

The acceleration used for the added mass represents the previous time step 
(``i-1``) interpolated to ``1e-8`` seconds before the current time step being 
solved. This can be thought of as a ``i-0.001%`` time step; a close approximation 
of the current time step.
