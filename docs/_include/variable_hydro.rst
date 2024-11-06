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
To implement variable hydrodynamics:

1. Initialize the Body
    Create a body instance in the ``wecSimInputFile.m`` with a cell array of H5 files 
    containing the hydrodyamic datasets:
        
        ``body(1) = bodyClass({'H5FILE_1.h5','H5FILE_2.h5','H5FILE_3.h5','H5FILE_4.h5','H5FILE_5.h5');``

    If only one H5 file is used to initialize a body object, variable hydrodynamics
    will not be used, regardless of the ``option`` flag below.

2. Enable Variable Hydrodynamics
    Set the ``body.variableHydro.option`` flag to enable variable hydrodynamics:

        ``body(1).variableHydro.option = 1;``

    If the ``option`` flag is not turned on (``option==0``), then extra H5 files are ignored.

3. Set the Initial Hydrodynamic Index
    The flag ``body.variableHydro.hydroForceIndexInitial`` allows the user to set the
    default hydrodynamic dataset. The initial set of hydrodynamic coefficients
    represents the body at the start of a simulation and likely its equilibrium 
    position. It is used to define the body's mass, center of gravity, 
    and center of buoyancy. 

        ``body(1).variableHydro.hydroForceIndexInitial = 1;``
    
    This parameter is flexible because an initial index of one is not always convenient
    and may complicate indexing logic. For example, consider a flap-based device with
    multiple hydrodynamic datasets at various pitch angles (-50:10:50). It is most convenient
    and straightforward to treat these angles in numerical order in BEM simulations, 
    indexing logic, and other data processing. In this case the initial position is at a pitch angle of 0 so 
    ``body.variableHydro.hydroForceIndexInitial = 6;``.

4. Control the varying hydrodynamics in Simulink
    The index ``body1_hydroForceIndex`` in Simulink
    (or ``body1_hydroForceIndex`` for body 2, etc) controls the hydrodynamic coefficients used
    in the hydrodynamic force calculations at a given time.
    Users *must* create their own logic and indexing signal in Simulink. A ``GoTo`` 
    block named ``body1_hydroForceIndex``, ``body2_hydroForceIndex``, etc must take 
    a signal for each variable hydro body so that the corresponding body block can select the correct 
    hydrodynamic coefficients during the simulation

    This example, from the Varible Hydro Passive Yaw application, takes in position, wave direction, and 
    BEM directions, calculates the index at a given time, and sends it to a ``GoTo`` block named 
    ``body1_hydroForceIndex``.

    .. figure:: /_static/images/variable_hydro_logic_example.PNG
        :width: 500pt
        :figwidth: 500pt
        :align: center


Variable hydrodynamics is body dependent and does not need to be applied to 
every body in a simulation.


.. Note::
    Variable hydrodynamics is not compatible with the following features:

    * State-space radiation calculations
    * FIR Filter radiation calculations
    * Generalized body modes
    * Non-hydrodynamic and drag bodies


Application
""""""""""""
See the :ref:`user-applications-variable-hydro` WEC-Sim_Application for a demonstration of setting up and using variable hydrodynamics.

Additional Considerations
""""""""""""""""""""""""""
* Investigate which advanced feature (variable hydrodynamics, passive yaw, large XY displacements, etc) will accomplish your modeling goals most effectively
* Keep the state's range small
* Input BEM data to cover the entire range of the state
* A very fine state discretization may be required. Conduct a state discretization study to find the resolution required for accurate results.
* If a very fine state discretization is required, use may be able to use BEMIO to create new datasets by interpolating between BEM simulations instead of simulating thousands of distinct BEM solutions. See the :ref:`user-applications-variable-hydro` Application for an example.
* Validate using high fidelity data
* The hydroData directory may become very large
* All BEM data is contained within the ``body`` variable. Pre-processing remains very fast, so it's not recommended to save ``body`` to an output file or the file size may increase drastically.
* Conditions that require a varying mass, center of gravity, or center of buoyancy are not yet implemented.
