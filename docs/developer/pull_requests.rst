.. _dev-pull-requests:

Pull Requests
===============

A stable version of WEC-Sim is maintained on the `WEC-Sim master branch <https://github.com/WEC-Sim/WEC-Sim>`_, and `WEC-Sim releases <https://github.com/WEC-Sim/WEC-Sim/releases>`_ are tagged on GitHub. 
WEC-Sim development is performed on `WEC-Sim dev branch <https://github.com/WEC-Sim/WEC-Sim/tree/dev>`_ using a `fork-based workflow <https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow>`_. 
New WEC-Sim features are developed on forks of the WEC-Sim repository, and `pull-requests <https://github.com/WEC-Sim/WEC-Sim/pulls>`_ are submitted to merge new features from a development fork into the main WEC-Sim repository. 
Pull-requests for new WEC-Sim features should be submitted to the WEC-Sim dev branch. 
The only exception to this workflow is for bug fixes; pull-request for bug fixes should be should submitted to the WEC-Sim master branch.
When a new version of WEC-Sim is released, the dev branch is pulled into master where all changes are incorporated into the code.


A `pull request (PR) <https://help.github.com/articles/using-pull-requests/>`_  should focus on one update at a time. 
This ensures that PR revisions are easily tracked, and keeps the repository history remains clean. 
If working on multiple updates, please use different branches, and submit separate pull requests. 
Once a PR is merged please delete legacy branches to keep your fork clean. 

Prior to submitting a pull request, pull the latest commits from the WEC-Sim repository, resolve any merge conflicts, and commit revisions to your fork:: 

	>> git pull origin <branch>
	>> git commit -m 'commit message'
	>> git push <USERNAME> <branch>

In order for a pull request to be merged into the WEC-Sim repository it must pass all software tests, refer to 
:ref:`dev-software-tests`. 
To submit a pull request, navigate to the `WEC-Sim's pull requests <https://github.com/WEC-Sim/WEC-Sim/pulls>`_ and submit a new pull request. 