.. _dev-getting-started:

Getting Started
===============

The WEC-Sim source code is hosted on `WEC-Sim's GitHub repository <https://github.com/WEC-Sim/wec-sim>`_. 
Please fork the WEC-Sim repository if you plan to contribute to the WEC-Sim code.
Forking the repository allows developers to create a personal copy of the WEC-Sim repository that can be edited idependently.
For details on creating and using a fork, refer to `GitHub's forking documentation <https://help.github.com/articles/fork-a-repo/>`_. 

Once you have forked the repository on GitHub, add the fork's remote, and pull the fork into your local directory:: 

	>> git remote add <USERNAME> https://github.com/<USERNAME>/WEC-Sim.git
	>> git pull <USERNAME> <branch>


Push local commits to fork on GitHub::

	>> git push <USERNAME> <branch>

Pull updates from WEC-Sim origin::

	>> git pull origin <branch>


.. Note::
	This example defines ``origin`` as `WEC-Sim's GitHub repository <https://github.com/WEC-Sim/wec-sim>`_, and ``<USERNAME>`` as the developer's fork. Develoeprs may use whatever convention they prefer, refer to `GitHub documentation on configuring remotes <https://docs.github.com/en/github/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork>`_





