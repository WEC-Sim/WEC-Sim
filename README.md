# How to edit and update the WEC-Sim Users Guide
## Note
The WEC-Sim documentation is located in the ``$WECSIM_SOURCE/doc/users-guide/`` folder, which will be referred to as the ``$USERS_GUIDE`` folder.

## Required packages
1. Python
1. Sphinx
  1. Install using ``pip install sphinx``
  1. Install the bibtex extension for sphinx using ``pip install sphinxcontrib-bibtex``
  1. Install the rtd theme for sphinx using ``pip install sphinx_rtd_theme``. You might have to manually move it to the ``sphinx/themes/`` directory.

## Edit and update WEC-Sim html users guide
The users guide is developed using [Sphinx](http://sphinx-doc.org/) and rendered in html. To edit or add to the users guide, modify the source files located in the ``$USERS_GUIDE/source`` folder using syntax and methods described in the [Sphinx Documentation](http://sphinx-doc.org/contents.html). Once you are done editing, move to the ``$USERS_GUIDE`` folder type ``make html`` from the command line to build the documentation. This builds a html formatted copy of the documentation in the ``$USERS_GUIDE/build/html`` folder. After building the HTML users guide, you can view the local copy of the documentation by:
  * Opening the ``$USERS_GUIDE/build/index.html`` file in a web browser
  * Opening the ``$USER_GUIDE/USERS_GUIDE-LOCAL.html`` in a web browser

## Update the documentation on the http://wec-sim.github.io/WEC-Sim website
The github.io website renders the documentation in the ``gh-pages`` branch as a website located at http://wec-sim.github.io/wec-sim. The easiest way to update the website is to make the ``$USERS_GUIDE/source/html`` folder a clone of ``gh-pages`` branch of WEC-Sim. The user can then push changes in the html documentation directly to the ``gh-pages`` branch. Here are the steps to do this in a Linux/Mac Terminal, note that windows instructions are very similar:

  ```Shell
  # Move to the build directory
  cd $USERS_GUIDE/build

  # Remove the html folder in the build directory
  rm -rf html

  # Clone the gh-pages branch into a folder named html
  git clone --depth 1 -b gh-pages https://github.com/WEC-Sim/WEC-Sim.git html

  # Move back to the users guide directory
  cd $USERS_GUIDE

  # Build the html documentation
  make html

  # Move $BEMIO_SOURCE/build/html directiory
  cd $BEMIO_SOURCE/build/html

  # Use git to check the status of the gh-pages branch, then commit and push changes. Once this step is performed the WEC-Sim website should be updated with any changes that were made to the source code.
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```