# WEC-Sim FOH Radiation Quick Fix Notes

## Motivation

MathWorks/Sandia discussion on variable-step solver slowdowns identified a discrete-to-continuous interface issue in WEC-Sim. In particular, Rate Transition blocks in radiation/convolution paths can introduce discrete signal changes that cause variable-step physical solvers such as `daessc` to reset and recalculate Jacobians. First-Order Hold (FOH) blocks were suggested as a quick workaround.


## Modified file

`source/lib/WEC-Sim/WECSim_Lib_Body_Elements.slx`

## Change made

This change does not remove any existing `Rate Transition` blocks.

First-Order Hold blocks were inserted immediately downstream of selected `Rate Transition` blocks in the Rigid Body wave-radiation/convolution path. The affected signal paths were rewired from:

`Rate Transition -> downstream block`

to:

`Rate Transition -> First-Order Hold -> downstream block`

Each inserted FOH block uses:

`Ts = simu.dt`

where `simu.dt` is the WEC-Sim simulation time-step/sample-time setting from the input file.

## Final scope of this narrowed fix

This narrowed fix adds 7 First-Order Hold blocks in:

`Rigid Body / Hydrodynamic Body / Wave Radiation Forces Calculation`

### Detailed locations modified

#### 1. Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Calculation

Full path:

`WECSim_Lib_Body_Elements/Rigid Body/Hydrodynamic Body/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Calculation`

Blocks added:

- `FOH_after_Rate_Transition` after `Rate Transition`
- `FOH_after_Rate_Transition1` after `Rate Transition1`

#### 2. Convolution Integral Calculation / Convolution Variant Subsystem / Convolution Integral Surface Calculation

Full path:

`WECSim_Lib_Body_Elements/Rigid Body/Hydrodynamic Body/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Surface Calculation`

Blocks added:

- `FOH_after_Rate_Transition` after `Rate Transition`
- `FOH_after_Rate_Transition1` after `Rate Transition1`

#### 3. Parent Convolution Integral Calculation

Full path:

`WECSim_Lib_Body_Elements/Rigid Body/Hydrodynamic Body/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation`

Block added:

- `FOH_after_Rate_Transition` after `Rate Transition`

#### 4. FIR Filter Calculation

Full path:

`WECSim_Lib_Body_Elements/Rigid Body/Hydrodynamic Body/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/FIR Filter Calculation`

Blocks added:

- `FOH_after_Rate_Transition` after `Rate Transition`
- `FOH_after_Rate_Transition1` after `Rate Transition1`

## Library coverage

For this narrowed fix:

- Library FOH blocks added: 7
- A two-body Rigid Body OSWEC model inherits 14 FOH blocks

## Validation summary

Testing was performed using Nate's confirmed OSWEC `daessc` slowdown reproducer.

Configuration:

- Model: `OSWEC`
- Solver: `daessc`
- SolverType: Variable-step
- MaxStep: `0.1`
- RelTol: `1e-3`
- End time: `400 s`



## Current status

Based on the confirmed OSWEC `daessc` reproducer, the Rigid Body radiation/convolution FOH group appears to be the smallest robust fix currently supported by testing.

This notes file documents the narrowed 7-block fix.

## Caveats

This OSWEC case does not exercise Flex Body paths. Flex Body FOH remains follow-on validation with the appropriate application case(s).

Current conclusions are based on repeated timing tests with solver settings and FOH block counts verified after each run.