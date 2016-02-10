.. _features:


Advanced Features
===================

Nonlinear Hydrodynamic Forces
-----------------------
As described previously, WEC-Sim in based on linear hydrodynamic wave theory, which is reasonable if, the motion of the WEC device is small with respect to the device dimensions, and the submerged surface area remains approximately constant. If the system hydrodynamics are *slightly* nonlinear, WEC-Sim’s nonlinear hydrodynamics option, **simu.nlHydro = 2**, may be used to improve the simulation accuracy. That being said, WEC-Sim cannot, and is not intended to, model highly nonlinear hydrodynamic events such as wave slamming, overtopping, etc. 

Specifying the nonlinear hydrodynamics option in WEC-Sim prompts the calculation of the buoyancy force and Froude-Krylov portion of the excitation force based on the instantaneous position of the body and wave elevation, rather than the BEM calculated linear hydrodynamic force coefficients. The nonlinear buoyancy and the Froude-Krylov force components are obtained by integrating the static and dynamic pressures, respectively, over the instantaneous submerged surface area, as determined by the position of the body and wave elevation at each time step. Where, the static pressure is simply, :math:`P_{S} = \rho gz`, and the dynamic pressure is calculated based on the wave type specified; for example,  :math:`P_{D} = \frac{1}{2}\rho gHe^{kz} \sin{(\omega t - kx)}`, for an infinite depth regular wave. Currently, WEC-Sim’s nonlinear hydrodynamic option may be invoked with regular and irregular waves, finite and infinite depth waves, but not with user-defined irregular waves. 

When the nonlinear hydrodynamics option is specified, the .stl geometry file, which is only used for visualization purposes in linear simulations, is also used as the discretized body surface on which the nonlinear pressure forces are integrated. As such, when the nonlinear hydrodynamics option is used, additional care must be taken in creating the .stl file. The simulation accuracy will increase with increased surface resolution (i.e. the number of discretized surface panels specified in the .stl file), but the computation time will also significantly increase. An option available to reduce the nonlinear simulation time is to specify a nonlinear time step, **simu.dtFeNonlin**. The nonlinear time step specifies the interval at which the nonlinear hydrodynamic forces are calculated, separately, and presumably at a larger interval than the system level simulation time step (**simu.dt**). As the ratio of the nonlinear to system time step increases, the computation time is reduced, but again, at the expense of the simulation accuracy.

State-Space Representation
-----------------------
.. Note::

	Coming soon!

Body-To-Body Interaction
-----------------------
.. Note::

	Coming soon!

.. include:: ptosim.rst

.. include:: moordyn.rst

.. include:: viz.rst
