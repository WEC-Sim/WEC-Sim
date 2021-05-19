.. _dev-overview:

Overview
========

The `WEC-Sim development team <http://wec-sim.github.io/WEC-Sim/index.html#wec-sim-developers>`_ 
is currently engaged in continuous code development and support. Efforts are 
made by the development team to improve the code's flexibility, accuracy, and 
usability. 

Online Forum
^^^^^^^^^^^^^

Please post questions about WEC-Sim on the `Issues Page 
<https://github.com/WEC-Sim/WEC-Sim/issues>`_. This forum is managed and 
continuously monitored by the WEC-Sim code development team and users. The 
issues page is frequently used to interact with the WEC-Sim community, ask 
questions, request new features, and report bugs. 

Pull Requests
^^^^^^^^^^^^^

The WEC-Sim team currently uses a fork-pull request based development workflow. 
In this system, features are incorporated into the development branch ('dev') 
of the WEC-Sim repository by a pull request (PR) from an individual's fork. 

Contributors who wish to propose new features or improvements to WEC-Sim should 
follow the same workflow so their suggestions can be evaluated and implemented 
easily. First, follow the :ref:`Developer Instructions <dev-getting-started>` 
to fork the repository. 

A pull request should focus on one feature or update at a time. This ensures 
that bugs within a PR are easily identified, and the repository history remains 
clean and straightforward. Fixing many issues within a single PR, often leads 
to hard-to-track changes and difficulty in merging the branch. If multiple PRs 
are submitted, use different branches on your fork to keep track of them. 
Delete branches once a PR is closed to keep your fork clean. 

To submit a pull request of your feature, first pull the latest commits to the 
WEC-Sim/master branch:: 

	>> git pull origin master

Merge any conflicts that occur when pulling the latest updates, and implement 
your changes. Commit changes and push them to your fork:: 

	>> git commit -m 'commit message'
	>> git push REMOTE_NAME BRANCH_NAME

Run the software test (below). If successful, you may submit a PR for your 
improvements. Navigate to the `WEC-Sim repository 
<https://github.com/WEC-Sim/WEC-Sim/pulls>`_ on GitHub and click 'New Pull 
Request'. For more details on submitting pull requests, see the `About pull 
requests <https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests>`_ 
documentation on GitHub.

.. _dev-overview-tests:

Software Tests
^^^^^^^^^^^^^^

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

Run Tests
"""""""""

The WEC-Sim tests are located in the ``$WECSIM/tests`` directory. To run the 
WEC-Sim tests locally, navigate to the ``$WECSIM`` (e.g. 
``C:/User/Documents/GitHub/WEC-Sim``) directory, and type the following command 
into the MATLAB Command Window:: 

	>> runtests
	
	
	Totals:
	   25 Passed, 0 Failed, 0 Incomplete.
	   

This executes the WEC-Sim tests and generates a build report.
