# Refer to [WEC-Sim documentation](http://wec-sim.github.io/WEC-Sim) for more information.
[![DOI](https://zenodo.org/badge/20451353.svg)](https://zenodo.org/badge/latestdoi/20451353)
[![Documentation](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/docs.yml/badge.svg)](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/docs.yml)
[![Run MATLAB tests on main branch](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/run-tests-main.yml/badge.svg?branch=main)](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/run-tests-main.yml)
[![Run MATLAB tests on dev branch](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/run-tests-dev.yml/badge.svg?branch=dev)](https://github.com/WEC-Sim/WEC-Sim/actions/workflows/run-tests-dev.yml)

## WEC-Sim Repository

* **Docs**: [WEC-Sim documentation](http://wec-sim.github.io/WEC-Sim), to refer to [doc compile instructions](https://github.com/WEC-Sim/WEC-Sim/tree/main/docs) 
* **Examples**: WEC-Sim  examples
* **Source**: WEC-Sim source code
* **Tests**: WEC-Sim tests for [MATLAB Continuous Integration](https://www.mathworks.com/solutions/continuous-integration.html)
* **Tutorials**: [WEC-Sim tutorials](http://wec-sim.github.io/WEC-Sim/main/user/tutorials.html)

Refer to the [WEC-Sim Applications](https://github.com/WEC-Sim/WEC-Sim_Applications) repository for more applications of WEC-Sim.

## Source Code Management

A stable version of WEC-Sim is maintained on WEC-Sim's [main branch](https://github.com/WEC-Sim/WEC-Sim), and WEC-Sim [releases](https://github.com/WEC-Sim/WEC-Sim/releases) are tagged on GitHub. 
WEC-Sim development is performed on WEC-Sim's [dev branch](https://github.com/WEC-Sim/WEC-Sim/tree/dev) using a [forking workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow). 
New WEC-Sim features are developed on forks of the WEC-Sim repository, and [pull-requests](https://github.com/WEC-Sim/WEC-Sim/pulls) are submitted to merge new features from a development fork into the main WEC-Sim repository. 
Pull requests for new WEC-Sim features should be submitted to the WEC-Sim dev branch. 
The only exception to this workflow is for bug fixes; pull requests for bug fixes should be should submitted to the WEC-Sim main branch.
When a new version of WEC-Sim is released, the dev branch becomes the main branch, and all updates are included in the tagged release.

