# WEC-Sim FOH Quick Fix Notes

Branch: foh-quickfix-wecsim-wide  
Final tag: foh-quickfix-all-body-elements-working  
Final commit: f539172  

## Motivation

MathWorks/Sandia discussion on variable-step solver slowdowns indicated that discrete signals converted to continuous signals in WEC-Sim can force solver resets/Jacobian recalculation. First-Order Hold blocks were identified as a quick workaround at discrete-to-continuous interfaces.

## Modified file

source/lib/WEC-Sim/WECSim_Lib_Body_Elements.slx

## Change

Added First-Order Hold blocks after all Rate Transition blocks in WECSim_Lib_Body_Elements.slx.

Final library coverage:

- Rate Transition blocks: 18
- FOH_after_* blocks: 18

Covered paths:

- Rigid Body / Hydrodynamic Body / Hydrostatic Restoring Force Calculation
- Rigid Body / Hydrodynamic Body / Wave Radiation Forces Calculation
- Flex Body / Hydrostatic Restoring Force Calculation
- Flex Body / Wave Radiation Forces Calculation

FOH parameter:

- Ts = simu.dt

## Validation

### OSWEC

Example path:

examples/OSWEC

Result:

- SolverType: Variable-step
- Solver: ode15s
- MaxStep: 0.1
- RelTol: 1e-3
- FOH quick-fix blocks in OSWEC: 18
- Simulation elapsed time after final Flex Body addition: 15.693024 sec

### RM3

Example path:

examples/RM3

Result:

- SolverType: Fixed-step
- Solver: ode4
- MaxStep: 0.1
- RelTol: 1e-3
- FOH quick-fix blocks in RM3: 18
- Simulation elapsed time after final Flex Body addition: 5.931360 sec

## Notes

OSWEC and RM3 instantiate Rigid Body paths, so they show 18 FOH blocks. Flex Body paths are covered at the shared-library level, but no Flex Body example was available in this sandbox for runtime validation.

A Simulink disabled-library-link warning was observed related to:

WECSim_Lib_Body_Elements/Flex Body/Wave Radiation Forces Calculation/Wave Radiation Forces Calculation

No link restore/push was performed during this quick-fix work.

