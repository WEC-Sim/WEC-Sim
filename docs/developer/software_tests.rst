.. _dev-software-tests:

Software Tests
===============

WEC-Sim includes `MATLAB Continuous Integration <https://www.mathworks.com/solutions/continuous-integration.html>`_ tests that check the source code's stability and generate a build report. 
The continuous integration tests are run each time a commit is made to the WEC-Sim GitHub repository, and the stability of each commit is available via `WEC-Sim's GitHub Actions <https://github.com/WEC-Sim/WEC-Sim/actions>`_. 
Tests are run on both the `WEC-Sim master <https://github.com/WEC-Sim/WEC-Sim/tree/master>`_ and `WEC-Sim dev <https://github.com/WEC-Sim/WEC-Sim/tree/dev>`_ branches.
To ensure stability across MATLAB distributions, WEC-Sim tests are also run on current and prior MATLAB releases. 
Refer to MATLAB's `unit test framework <https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html?s_tid=CRUX_lftnav>`_ and `continuous integration <https://www.mathworks.com/help/matlab/matlab_prog/continuous-integration-with-matlab-on-ci-platforms.html>`_ documentation for more information. 

When new features are added, tests should developed to verify functionality. 
All tests should be run locally to ensure stability prior to submitting a pull request. 
In order for a pull request to be merged into the WEC-Sim repository it must pass all software tests, refer to 
:ref:`dev-pull-requests`. 

.. _dev-software-tests-ws:

WEC-Sim Tests
--------------
The WEC-Sim tests are located in the ``$WECSIM/tests`` directory. 
To execute the WEC-Sim tests locally and generates a build report, navigate to the ``$WECSIM`` directory (e.g. ``C:/User/Documents/GitHub/WEC-Sim``), and type the following command in the MATLAB Command Window:

.. code-block:: matlabsession

	>> results = wecSimTest()
	
	
	Totals:
	   38 Passed, 0 Failed, 0 Incomplete.
	   

.. _dev-software-tests-wsa:

WEC-Sim Applications Tests
---------------------------
The `WEC-Sim Applications repository <https://github.com/WEC-Sim/WEC-Sim_Applications>`_ includes tests of each applications case. 
To execute the WEC-Sim Applications tests locally and generates a build report, navigate to the ``$WECSIM_Applications`` directory (e.g. ``C:/User/Documents/GitHub/WEC-Sim``), and type the following command in the MATLAB Command Window:

.. code-block:: matlabsession

	>> results = wecSimAppTest()
	
	
	Totals:
	   43 Passed, 0 Failed, 0 Incomplete


.. TO DO: add section about regression and compilation tests

.. Regression Tests
.. WEC-Sim regression tests are used to compare the latest version of WEC-Sim with a solution from a previous (stable) release. A maximum difference is asserted in each unit test to ensure that the latest version does not deviate from a previous release.

.. Compilation Tests
.. WEC-Sim compilation tests are used to check that new features do not break existing functionality by verifying that WEC-Sim runs for a selection of existing application cases. However, for these cases no regression comparison is performed.	
	   
