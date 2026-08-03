# WEC-Sim FOH Quick Fix Notes

## Motivation

MathWorks/Sandia discussion on variable-step solver slowdowns indicated that discrete signals converted to continuous signals in WEC-Sim can force solver resets and Jacobian recalculation. First-Order Hold (FOH) blocks were identified as a quick workaround at these discrete-to-continuous interfaces.

Because `.slx` library diffs are not easily trackable in Git, this document serves as a written record of the specific library changes made.

## Modified file

`source/lib/WEC-Sim/WECSim_Lib_Body_Elements.slx`

## Library change made

This work does **not** remove any existing `Rate Transition` blocks.

Instead, a `First-Order Hold` block was inserted immediately downstream of each targeted `Rate Transition` block, and the original signal path was rewired from:

`Rate Transition -> downstream block`

to:

`Rate Transition -> First-Order Hold -> downstream block`

The inserted FOH blocks were named using the pattern:

- `FOH_after_Rate_Transition`
- `FOH_after_Rate_Transition1`

The FOH parameter was set to:

- `Ts = simu.dt`

## Final library coverage

- Rate Transition blocks: 18
- Inserted First-Order Hold blocks: 18

## Detailed library locations modified

### Rigid Body / Hydrodynamic Body

#### Hydrostatic Restoring Force Calculation / Linear and Nonlinear Restoring Force Variant Subsystem / Nonlinear Hydrostatic Restoring Force
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Surface Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`

#### Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / FIR Filter Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

### Flex Body

#### Hydrostatic Restoring Force Calculation / Hydrostatic Restoring Force Calculation / Linear and Nonlinear Restoring Force Variant Subsystem / Nonlinear Hydrostatic Restoring Force
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Surface Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

#### Wave Radiation Forces Calculation / Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / Convolution Integral Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`

#### Wave Radiation Forces Calculation / Wave Radiation Forces Calculation / SS CI and Constant-Damping-CoeVariant Subsystem / FIR Filter Calculation
- Added `FOH_after_Rate_Transition` after `Rate Transition`
- Added `FOH_after_Rate_Transition1` after `Rate Transition1`

## Validation summary

- OSWEC runs successfully with the modified shared library
- RM3 runs successfully with the modified shared library
- OSWEC and RM3 each inherit 18 FOH blocks
- Flex Body runtime validation is still pending

## Open questions

- It has not yet been isolated whether every individual `Rate Transition` block contributes to the solver reset issue
- It is possible that fewer FOH blocks would be sufficient
- It may be preferable in some cases to reduce or remove specific `Rate Transition` blocks directly instead of keeping the broader workaround

## Planned follow-on testing

- `WEC-Sim_Applications/Desalination`
- `WEC-Sim_Applications/Generalized_Body_Mode`
- OWC application(s) that exercise Flex Body paths
- nonlinear excitation application

Suggested solver comparisons:
- `ode45`
- a case-appropriate variable-step implicit solver

Suggested variable-step performance setting:
- increase `simu.dt` to `0.5` so WEC-Sim does not artificially limit the maximum time step

## Caveat

A Simulink disabled-library-link warning was observed related to:

`WECSim_Lib_Body_Elements/Flex Body/Wave Radiation Forces Calculation/Wave Radiation Forces Calculation`

No link restore/push was performed during this quick-fix work.