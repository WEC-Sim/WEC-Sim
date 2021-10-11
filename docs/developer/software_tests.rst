.. _dev-software-tests:

Software Tests
===============

WEC-Sim includes continuous integration tests that check the source code's 
functionality. The tests are run each time changes are made to the repository, 
and are designed to ensure that the code is performing as expected. New tests 
are developed each time new functions are added or modified. **Developers 
should run software tests before submitting a pull request.** If all tests 
pass, submit your PR. Refer to MATLAB's `unit test 
<https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html?s_tid=CRUX_lftnav>`_ 
and `continuous integration <https://www.mathworks.com/help/matlab/matlab_prog/continuous-integration-with-matlab-on-ci-platforms.html>`_ 
documentation for more information. Please post a question on the `Issues Page 
<https://github.com/WEC-Sim/WEC-Sim/issues>`_ if you have difficulty using the 
tests. 

The WEC-Sim tests are located in the ``$WECSIM/tests`` directory. To run the 
WEC-Sim tests locally, navigate to the ``$WECSIM`` (e.g. 
``C:/User/Documents/GitHub/WEC-Sim``) directory, and type the following command 
into the MATLAB Command Window:: 

	>> results = wecSimTest();
	
	
	Totals:
	   38 Passed, 0 Failed, 0 Incomplete.
	   

This executes the WEC-Sim tests and generates a build report. The WEC-Sim Applications 
repository also contains tests of each applications case. To run the applications 
tests locally, navigate to the the ``$WEC-Sim_Applications`` directory, and use the 
``runTests`` command to generate a build report.