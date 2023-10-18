.. _dev-added-mass:

Theoretical Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Added mass is a special multi-directional fluid dynamic phenomenon that most
physics software cannot account for well.
Modeling difficulties arise because the added mass force is proportional to acceleration.
However most time-domain simulations are attempting to use the calculated forces to determine 
a body's acceleration, which then determines the velocity and position at the next time step.
Solving for acceleration when forces are dependent on acceleration creates an algebraic loop.

The most robust solution is to combine the added mass matrix with the rigid body's mass and inertia,
shown in the manipulation of the governing equation below: 

.. math::

    M\ddot{X_i} &= \Sigma F(t,\omega) - A\ddot{X_i} \\
    (M+A)\ddot{X_i} &= \Sigma F(t,\omega) \\
    M_{adjusted}\ddot{X_i} &= \Sigma F(t,\omega)

where capital :math:`M` is the mass matrix, :math:`A` is the added mass, and subscript :math:`i` represents the timestep being solved for. 
In this case, the adjusted body mass matrix is defined as the sum of the translational mass (:math:`m`), inertia tensor (:math:`I`), and the added mass matrix:

.. math::

    M_{adjusted} = \begin{bmatrix}
                       m + A_{1,1} & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & m + A_{2,2} & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & m + A_{3,3} & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & I_{1,1} + A_{4,4} & -I_{2,1} + A_{4,5} & -I_{3,1} + A_{4,6} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & I_{2,1} + A_{5,4} & I_{2,2} + A_{5,5} & -I_{3,2} + A_{5,6} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & I_{3,1} + A_{6,4} & I_{3,2} + A_{6,5} & I_{3,3} + A_{6,6} \\
                   \end{bmatrix}

This formulation is desirable because it removes the acceleration dependence from the right hand side of the governing equation. 
Without this treatment, the acceleration causes an unsolvable algebraic loop. 
There are alternative approximations to solve the algebraic loop, but simulation robustness and stability become increasingly difficult.

The core issue with this combined mass formulation is that Simscape Multibody, and most other physics software, do not allow a generic body to have a degree-of-freedom specific mass.
For example, a rigid body can't have one mass for surge motion and another mass for heave motion. 
Simscape rigid bodies only have one translational mass, a 1x3 moment of inertia matrix, and 1x3 product of inertia matrix. 

WEC-Sim's Implemenation
^^^^^^^^^^^^^^^^^^^^^^^^

Due to this limitation, WEC-Sim cannot combine the body mass and added mass on the left-hand side of the equation of motion (as shown above).
The algebaric loop can be solved by predicting the acceleration at the current time step, and using that to calculate the added mass force.
But this method can cause numerical instabilities.
Instead, WEC-Sim decreases the added mass force magnitude by moving *some* components of added mass into the body mass, while a modified added mass force is calculated with the remainder of the added mass coefficients. 

There is a 1-1 mapping between the body's inertia tensor and rotational added mass coefficients.
These added mass coefficients are entirely lumped with the body's inertia.
Additionally, the surge-surge (1,1), sway-sway (2,2), heave-heave (3,3) added mass coefficients correspond to the translational mass of the body, but must be treated identically.

WEC-Sim implements this added mass treatment using both a modified added mass matrix and a modified body mass matrix:

.. math::

    M\ddot{X_i} &= \Sigma F(t,\omega) - A\ddot{X_i} \\
    (M+dMass)\ddot{X_i} &= \Sigma F(t,\omega) - (A-dMass)\ddot{X_i} \\
    M_{adjusted}\ddot{X_i} &= \Sigma F(t,\omega) - A_{adjusted}\ddot{X_i} \\

where :math:`dMass` is the change in added mass and defined as:

.. math::

    dMass &=  \begin{bmatrix}
                 \alpha Y & 0 & 0 & 0 & 0 & 0 \\
                 0 & \alpha Y & 0 & 0 & 0 & 0 \\
                 0 & 0 & \alpha Y & 0 & 0 & 0 \\
                 0 & 0 & 0 & A{4,4} & -A{5,4} & -A{6,4} \\
                 0 & 0 & 0 & A{5,4} & A{5,5} & -A{6,5} \\
                 0 & 0 & 0 & A{6,4} & A{6,5} & A{6,6} \\
              \end{bmatrix} \\
    Y &= (A_{1,1} + A_{2,2} + A_{3,3}) \\
    \alpha &= body(iBod).adjMassFactor

The resultant definition of the body mass matrix and added mass matrix are then:

.. math::

    M &=  \begin{bmatrix}
               m + \alpha Y & 0 & 0 & 0 & 0 & 0 \\
               0 & m + \alpha Y & 0 & 0 & 0 & 0 \\
               0 & 0 & m + \alpha Y & 0 & 0 & 0 \\
               0 & 0 & 0 & I_{4,4} + A_{4,4} & -(I_{5,4} + A_{5,4}) & -(I_{6,4} + A_{6,4}) \\
               0 & 0 & 0 & I_{5,4} + A_{5,4} & I_{5,5} + A_{5,5} & -(I_{6,5} + A_{6,5}) \\
               0 & 0 & 0 & I_{6,4} + A_{6,4} & I_{6,5} + A_{6,5} & I_{6,6} + A_{6,6} \\
           \end{bmatrix} \\
    A_{adjusted} &= \begin{bmatrix}
                       A_{1,1} - \alpha Y & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & A_{2,2} - \alpha Y & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & A_{3,3} - \alpha Y & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & 0 & A_{4,5} + A_{5,4} & A_{4,6} + A_{6,4} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & 0 & 0 & A_{5,6} + A_{6,5} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & 0 & 0 & 0 \\
                    \end{bmatrix}

.. Note::
    We should see that :math:`A_{4,5} + A_{5,4} = A_{4,6} + A_{6,4} = A_{5,6} + A_{6,5} = 0`, but there may be numerical differences in the added mass coefficients which are preserved.

Though the components of added mass and body mass are manipulated in WEC-Sim, the total system is unchanged.
This manipulation does not affect the governing equations of motion, only the implementation.

The fraction of translational added mass that is moved into the body mass is determined by ``body(iBod).adjMassFactor``, whose default value is :math:`2.0`.
Advanced users may change this weighting factor in the ``wecSimInuptFile`` to create the most robust simulation possible. 
To see its effects, set ``body(iB).adjMassFactor = 0`` and see if simulations become unstable.

This manipulation does not move all added mass components. 
WEC-Sim still contains an algebraic loop due to the acceleration dependence of the remaining added mass force from :math:`A_{adjusted}`, and components of the Morison Element force.
WEC-Sim solves the algebraic loop using a `Simulink Transport Delay <https://www.mathworks.com/help/simulink/slref/transportdelay.html>`_ with a very small time delay (``1e-8``).
This blocks extrapolates the previous acceleration by ``1e-8`` seconds, which results in a known acceleration for the added mass force.
The small extraplation solves the algebraic loop but prevents large errors that arise when extrapolating the acceleration over an entire time step.
This will convert the algebraic loop equation of motion to a solvable one:

.. math::

    M_{adjusted}\ddot{X_i} &= \Sigma F(t,\omega) - A_{adjusted}\ddot{X}_{i - (1 + 10^{-8}/dt)} \\

Working with the Added Mass Implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim's added mass implementation should not affect a user's modeling workflow.
WEC-Sim handles the manipulation and restoration of the mass and forces in the bodyClass functions ``adjustMassMatrix()`` called by ``initializeWecSim`` and ``restoreMassMatrix``, ``storeForceAddedMass`` called by ``postProcessWecSim``.
However viewing ``body.mass, body.inertia, body,inertiaProducts, body.hydroForce.fAddedMass`` between calls to ``initializeWecSim`` and ``postProcessWecSim`` will not show the input file definitions.
Users can get the manipulated mass matrix, added mass coefficients, added mass force and total force from ``body.hydroForce.storage`` after the simulation.
However, in the rare case that a user wants to manipulate the added mass force *during* a simulation, the change in mass, :math:`dMass` above, must be taken into account. Refer to how ``body.calculateForceAddedMass()`` calculates the entire added mass force in WEC-Sim post-processing.

.. Note:: If applying the method in ``body.calculateForceAddedMass()`` *during* the simulation, the negative of ``dMass`` must be taken: :math:`dMass = -dMass`. This must be accounted for because the definitions of mass, inertia, etc and their stored values are flipped between simulation and post-processing.

.. Note::
	Depending on the wave formulation used, :math:`A` can either be a function of wave frequency :math:`A(\omega)`, or equal to the added mass at infinite wave frequency :math:`A_{\infty}`
