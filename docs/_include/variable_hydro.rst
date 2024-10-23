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
Users write the index ``body1_hydroForceIndex`` in Simulink, which indexes 
``body.hydroForce.hf{i}`` and selects the hydrodynamic force coefficients used
in the hydrodynamic force calculations at a given time.

Application
""""""""""""
See the Variable Hydro WEC-Sim_Application for a demonstration of setting up and using this feature.

Tips
""""
- Investigate other features that can accomplish your modeling goals (passive yaw, large XY displacements, etc) more effectively
- Keep the state's range small
- Input BEM data to cover the entire range of the state
- A very fine state discretization may be required. Study and iterate to fine the best state discretization
- If a very fine state discretization is required, use BEMIO to create new datasets by interpolating between BEM simulations instead of simulating thousands of distinct BEM solutions
- Validate using high fidelity data
- The hydroData directory may become very large
- All BEM data is contained within the ``body`` variable. Pre-processing remains very fast, so it's not recommended to save ``body`` to an output file or the file size will increase drastically.
- Variable masses are not yet implemented.



