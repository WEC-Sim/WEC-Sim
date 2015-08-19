# How to edit and update the WEC-Sim Users Guide

## Required packages
1. Python
1. Sphinx
  1. Install using ``pip install sphinx``
  1. Install the bibtex extension for sphinx using ``pip install sphinxcontrib-bibtex``
  1. Install the rtd theme for sphinx using ``pip install sphinx_rtd_theme``. You might have to manually move it to the ``sphinx/themes/`` directory.

## Edit and update WEC-Sim html users guide
The WEC-Sim documentation is located on the WEC-Sim/gh-pages branch, which will be referred to as the ``$USERS_GUIDE``.


The users guide is developed using [Sphinx](http://sphinx-doc.org/) and rendered in html. To edit or add to the users guide, modify the source files located in the ``$USERS_GUIDE/source`` folder using syntax and methods described in the [Sphinx Documentation](http://sphinx-doc.org/contents.html). Once you are done editing, move to the ``$USERS_GUIDE`` folder type ``make html`` from the command line to build the documentation. This builds a html formatted copy of the documentation in the ``$USERS_GUIDE/`` folder. After building the HTML users guide, you can view the local copy of the documentation by:
  * Opening the ``$USERS_GUIDE/index.html`` file in a web browser

## Push documentation to  http://wec-sim.github.io/WEC-Sim
The github.io website renders the documentation in the ``gh-pages`` branch as a website located at http://wec-sim.github.io/WEC-Sim/index.html. The easiest way to update the website is to make the ``$USERS_GUIDE/source/html`` folder a clone of ``gh-pages`` branch of WEC-Sim. The user can then push changes in the html documentation directly to the ``gh-pages`` branch. Here are the steps to do this in a Linux/Mac Terminal, note that windows instructions are very similar:

  ```Shell
  # Move to the build directory in cmd
  cd $USERS_GUIDE

  # Build the html documentation in cmd
  make html

  # Use git to check the status of the gh-pages branch, then commit and push changes. Once this step is performed the WEC-Sim website should be updated with any changes that were made to the source code.
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```