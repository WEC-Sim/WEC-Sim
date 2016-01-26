
Please visit the [WEC-Sim website](http://wec-sim.github.io/WEC-Sim) for more information.
=======
# How to update the WEC-Sim website

## Download and Install Required Packages
1. Download and Install [Python27](https://www.python.org/downloads/)

1. Add Python and Python Scripts to system path
	1. [Windows](http://stackoverflow.com/questions/3701646/how-to-add-to-the-pythonpath-in-windows-7) - modify the PATH in environmental variables to include: C:\PYTHON27;C:\PYTHON27\Scripts 
	1. MAC/LINUX -  Phython is already installed on MAC/LINUX

1. Download and Install [Sphinx](http://www.sphinx-doc.org/en/stable/index.html)
  	1. [Windows](http://sphinx-doc.org/latest/install.html#windows-install-python-and-sphinx)
  	1. [MAC/LINUX](http://www.sphinx-doc.org/en/stable/install.html#mac-os-x-install-sphinx-using-macports)
	  	1. Install on cmd using ``pip install -U Sphinx``
 NOTE: You may need to configure PROXY

1. Install bibtex extension for Sphinx
	  1. Install on cmd using ``pip install sphinxcontrib-bibtex``
	  1. Install the rtd theme using ``pip install sphinx_rtd_theme``. 
 NOTE: You may have to manually move it to the ``sphinx/themes/`` directory.

## Edit WEC-Sim Users Guide
The WEC-Sim documentation is located on the WEC-Sim/gh-pages branch, https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages, which will be referred to as the ``$USERS_GUIDE``.

The users guide is developed using [Sphinx](http://sphinx-doc.org/) and rendered in html. To edit  the users guide, modify the source files located in the ``$USERS_GUIDE/source`` folder using syntax and methods described in the [Sphinx Documentation](http://sphinx-doc.org/contents.html). Once you are done editing, move to the ``$USERS_GUIDE`` folder type ``make html`` from the command line to build the documentation. This builds a html formatted copy of the documentation in the ``$USERS_GUIDE/`` folder. After building the HTML users guide, you can view the local copy of the documentation by:
  * Opening the ``$USERS_GUIDE/index.html`` file in a web browser

## Push Documentation to  http://wec-sim.github.io/WEC-Sim
The github.io website renders the documentation in the WEC-Sim/gh-pages branch as a website located at http://wec-sim.github.io/WEC-Sim/index.html. The user then pushes changes in the html documentation directly to the WEC-Sim/gh-pages branch. Here are the steps to do this:

  ```Shell
  # Move to the build directory in cmd
  cd $USERS_GUIDE

  # Build the html documentation in cmd
  make html

  # Use Git-shell to check status of the gh-pages branch, then commit and push changes. 
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```

