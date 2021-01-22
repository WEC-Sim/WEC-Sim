.. _dev-getting-started:

Getting Started
===============

The WEC-Sim source code is hosted on the `WEC-Sim GitHub repository 
<https://github.com/WEC-Sim/wec-sim>`_. WEC-Sim developers are recommended to 
fork the GitHub repository. If you plan to contribute to the WEC-Sim code, 
please fork the official `WEC-Sim repository <https://github.com/WEC-Sim/WEC-Sim>`_.
This method allows you to create a personal copy of the WEC-Sim repository, 
which can be freely edited without changing the official repository. It is 
easily compared to the main repository when pushing changes or pulling updates. 

Once you have forked the code on GitHub, navigate in the git command line to 
the desired directory. Clone the fork:: 

	>> git clone https://github.com/USERNAME/WEC-Sim/

Push local commits to GitHub::

	>> git push your_remote your_branch

To sync your fork with the official repository, add a remote::

	>> git remote add origin https://github.com/WEC-Sim/WEC-Sim.git

Once the origin repository is set, pull updates to WEC-Sim::

	>> git pull origin master

.. Note::
    The remotes can be named by any convention the user desires. However it is 
    common for 'origin' to point to the official repository that the fork came 
    from.


For details on creating and using a fork, see the `forking instructions 
<https://help.github.com/articles/fork-a-repo/>`_ provided by GitHub. 

If you make improvements to the code that you would like included in the 
WEC-Sim master code, please submit a `pull request 
<https://help.github.com/articles/using-pull-requests/>`_. This pull request 
will then be reviewed, merged into the `WEC-Sim development branch 
<https://github.com/WEC-Sim/WEC-Sim>`_, and included in future WEC-Sim 
releases. For more details see the :ref:`Development Overview <dev-overview>`. 
