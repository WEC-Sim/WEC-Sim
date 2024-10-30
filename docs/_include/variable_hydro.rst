.. _user-advanced-features-variable-hydro:

Overview
""""""""""

Variable Hydrodynamics is an advanced feature that enables users to change the 
*state* of their device during simulation. In this context, a device *state* 
can be related to any number of scenarios, such as a variable geometry 
changing shape, a flooding body, a change in operational depth, load shedding 
capabilities, time-dependent changes to a device, etc. A signal, such as 
kinematics, dynamics, or time,  is used to alter the state of the device
during simulation. This feature expands WEC-Sim's simulation capabilities and enables
modeling a new breadth of scenarios in the time domain.

Different states of a device are represented by different sets of boundary 
element method data. User defined logic and user selected signals determine
when the state changes. The Variable Hydrodynamics feature does not determine
a specific scenario, state, signal, or discretization required. It is the 
user's responsibility to implement a specific variable hydrodynamics case
using best practices and validate the results with higher fidelity data.

Example
""""""""

For example, take the scenario where a device submerges to shed loads. Once the
total force on the device hits some threshold, a tether is reeled into submerge
the device, decreasing its operational depth by three meters. This could be
accomplished by defining a custom force on the body that is applied once the 
total force is large enough. 

Without variable hydrodynamics, as the device depth gets farther from it's 
initial position, the hydrodynamic loading becomes increasingly inaccurate.
Using variable hydrodynamics, the hydrodynamic loading can remain accurate 
by updating force coefficients based on the device's instantaneous depth.

In this example, the state of the device is its operational depth 
(heave position). The total force and heave position are both signals that 
dictate the varying hydrodynamics. The total force triggers a custom PTO
force, and the heave position determines what BEM dataset is used as the body
submerges.

User defined logic dictates how quickly the operational depth changes, and 
selects the corresponding BEM data at the new state.
In this case, the user could supply BEM datasets of the device at 
30 different depths over the 3m range. User defined logic then selects 
the BEM dataset most closely corresponding to the instantaneous 
heave position of the device. That new BEM dataset is then used to 
calculate the hydrodynamic forcing on the device until updated again.

Implementation
""""""""""""""
Variable hydrodynamics is implemented by allowing users to initialize a body
with a cell array of h5 files, as many as required. Each i-th h5 file is then pre-processed into
``body.hydroData(i)`` and ``body.hydroForce.hf{i}`` in the normal manner.
The entirety of body.hydroForce is loaded into Simulink using a custom bus. 
The index ``body1_hydroForceIndex`` in Simulink, which indexes 
``body.hydroForce.hf{i}`` and selects the hydrodynamic force coefficients used
in the hydrodynamic force calculations at a given time.
Users *must* create their own logic and index signal in Simulink. A ``GoTo`` 
block named ``body1_hydroForceIndex``, ``body2_hydroForceIndex`` must take 
the signal so that the body block can read the value and select the correct 
hydrodynamic coefficients.

Variable hydrodynamics is body dependent and does not need to be applied to 
every body in a simulation.
To turn on variable hydrodynamics, use the ``body.variableHydro.option`` flag in the 
wecSimInputFile and input multiple H5 files during the body initialization::

    body(1) = bodyClass({'H5FILE_1.h5','H5FILE_2.h5','H5FILE_3.h5','H5FILE_4.h5','H5FILE_5.h5');
    body(1).variableHydro.option = 1;


If ``body.variableHydro.option=0`` any extra H5 files in the body initialization 
are ignored. If only one H5 file is submitted to a file, variable hydrodynamics 
are turned off.

The flag ``body.variableHydro.hydroForceIndexInitial`` allows the user to set the
default index used to define the hydrodynamic coefficients. This initial dataset
should represent the body at the start of a simulation and likely its equilibrium 
position. The initial dataset will be used to define the mass, center of gravity, 
and center of buoyancy for a simulation.

This parameter is flexible because an initial index of zero is not always convenient
and can complicate indexing logic. For example, consider a flap-based device with
multiple hydrodynamic datasets at various pitch angles (-50:10:50). It is most convenient
to treat these angles in numerical order in BEM simulations, indexing logic, and other 
data processing. In this case the initial position is at a pitch angle of 0 so ``body.variableHydro.hydroForceIndexInitial=6;``.

Compatibility
"""""""""""""
Variable hydrodynamics is not compatible with certain WEC-Sim features. It cannot be used concurrently with:

* State-space radiation calculations
* FIR Filter radiation calculations
* Generalized body modes within the same body. Seperate bodies could each have generalized body modes and variable hydrodynamics however.
* Non-hydrodynamic and drag bodies


Application
""""""""""""
See the :ref:`user-applications-variable-hydro` WEC-Sim_Application for a demonstration of setting up and using variable hydrodynamics.

Tips
""""
* Investigate which advanced feature (variable hydrodynamics, passive yaw, large XY displacements, etc) will accomplish your modeling goals most effectively
* Keep the state's range small
* Input BEM data to cover the entire range of the state
* A very fine state discretization may be required. Conduct a state discretization study to find the resolution required for accurate results.
* If a very fine state discretization is required, use may be able to use BEMIO to create new datasets by interpolating between BEM simulations instead of simulating thousands of distinct BEM solutions. See the :ref:`user-applications-variable-hydro` Application for an example.
* Validate using high fidelity data
* The hydroData directory may become very large
* All BEM data is contained within the ``body`` variable. Pre-processing remains very fast, so it's not recommended to save ``body`` to an output file or the file size may increase drastically.
* Conditions that require a varying mass, center of gravity, or center of buoyancy are not yet implemented.
