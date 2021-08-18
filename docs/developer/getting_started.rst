.. _dev-getting-started:

Getting Started
===============

The WEC-Sim source code is hosted on the `WEC-Sim GitHub repository 
<https://github.com/WEC-Sim/wec-sim>`_. WEC-Sim developers are recommended to 
fork the GitHub repository. If you plan to contribute to the WEC-Sim code, 
please fork the official WEC-Sim repository.
This method allows you to create a personal copy of the WEC-Sim repository, 
which can be freely edited without changing the official repository. It is 
easily compared to the main repository when pushing changes or pulling updates. 

Once you have forked the code on GitHub, navigate in the git command line to 
the desired directory. Clone the fork:: 

	>> git clone https://github.com/USERNAME/WEC-Sim/

Push local commits to GitHub::

	>> git push your_remote your_branch

To sync your fork with the official repository, add a remote::

	>> git remote add upstream https://github.com/WEC-Sim/WEC-Sim.git

Once the origin repository is set, pull updates to WEC-Sim::

	>> git pull upstream master

.. Note::
    The remotes can be named by any convention the user desires. However it is 
    common for `'upstream' to point to the official repository 
    <https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork>`_
    that the fork came from, while origin points to a user's fork of the official repository.


For details on creating and using a fork, see the `forking instructions 
<https://help.github.com/articles/fork-a-repo/>`_ provided by GitHub. 


.. _dev-getting-started-prs:

Pull Requests
-------------

The WEC-Sim team currently uses a fork-pull request based development workflow. 
In this system, features are incorporated into the development branch ('dev') 
of the WEC-Sim repository by a `pull request (PR) 
<https://help.github.com/articles/using-pull-requests/>`_ from an individual's fork. 
When a new version of WEC-Sim is released, the dev branch is pulled into master 
where all changes are incorporated into the code.

Contributors who wish to propose new features or improvements to WEC-Sim should 
follow the same workflow so their suggestions can be evaluated and implemented 
easily. First, follow the above directions to fork the repository. 

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

.. _dev-getting-started-tests:

Software Tests
--------------

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