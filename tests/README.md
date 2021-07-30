# WEC-Sim Tests
WEC-Sim tests run by Jenkins CI to test WEC-Sim, currently tests run RM3 WEC-Sim model with different wave cases.

## Regression Tests
WEC-Sim regression tests are used to compare the latest version of WEC-Sim with a solution from a previuos (stable) release. A maximum difference is asserted in each unit test to ensure that the latest version does not deviate from a previous release.


## Compilation Tests
WEC-Sim compilation tests are used to check that new features do not break existing functionality by verifying that WEC-Sim runs for a selection of existing application cases. However, for these cases no regression comparison is performed. 