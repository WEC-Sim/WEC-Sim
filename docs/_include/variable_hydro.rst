.. _user-advanced-features-variable-hydro:

Overview
""""""""""

Variable Hydrodynamics enables users to change the 
*state* of a hydrodyamic body during simulation. A body's *state* could reflect
any number of scenarios, such as a variable geometry 
changing shape, a flooding body, a change in operational depth, load shedding 
capabilities, time-dependent changes to a device, etc. A signal, such as 
kinematics, dynamics, or time, is used to alter the state of the device
during simulation. This feature expands WEC-Sim's simulation capabilities and enables
modeling a new breadth of scenarios in the time domain.

The varying state of a body is represented by changing the hydrodynamic
coefficients used to calculate hydrodyamic forcing during the simulation.
User defined logic and user selected signals determine
when the state changes. The Variable Hydrodynamics feature does not determine
a specific scenario, state, signal, or discretization required.

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
Variable hydrodynamics is body dependent and does not need to be applied to 
every body in a simulation. To implement variable hydrodynamics for a given body:

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

    .. figure:: /_static/images/variable_hydro_logic_example.png
        :width: 500pt
        :figwidth: 500pt
        :align: center

.. Note::
    Variable hydrodynamics is not compatible with the following features:

    * State-space radiation calculations
    * FIR Filter radiation calculations
    * Generalized body modes
    * Non-hydrodynamic and drag bodies
    * Conditions that require a variable mass, center of gravity, or center of buoyancy

Application
""""""""""""
See the :ref:`user-applications-variable-hydro` WEC-Sim_Application for a demonstration of setting up and using variable hydrodynamics.

Additional Considerations
""""""""""""""""""""""""""
Variable hydrodynamics is a complex feature that should be used with caution. 
Before using variable hydrodynamics, consider the advantages and disadvantages 
of other advanced features that can accomplish modeling goals effectively
(passive yaw, large XY displacements, etc).

Thoroughly define the range of the state that is varying. 
Input BEM data to cover the entire range of the state. Sufficiently discretize
the state to prevent numerical instabilities when switching occurs while reaching
an acceptable computational expense. The Variable Hydro Passive Yaw application 
demonstrates how to process BEM datasets with BEMIO and interpolate between them to increase
state resolution without requiring many BEM simulations. Due to the number of H5 files
required, the hydroData directory may become very large.

All H5 files are loaded into the respective ``body`` variable, making the size 
of these variables very large. Pre-processing remains very fast, so it is not 
recommended to save ``body`` to an output file or the file size may increase drastically.
