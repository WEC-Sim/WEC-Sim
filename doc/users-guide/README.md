# How to edit and update the WEC-Sim Users Guide

## Required packages
1. Python
1. Sphinx
  1. Install using ``pip install sphinx``
  1. Install the bibtex extension for sphinx using ``pip install sphinxcontrib-bibtex``
  1. Install the rtd theme for sphinx using ``pip install sphinx_rtd_theme``. You might have to manually move it to the ``sphinx/themes/`` directory.

## NOTE
The WEC-Sim documentation is located in the ``$WECSIM_SOURCE/doc/users-guide/`` folder that will be referred to as the ``$USERS_GUIDE`` folder.

## Edit WEC-Sim Users Guide
The users guide is developed using [Sphinx](http://sphinx-doc.org/). To edit or add to the users guide, modify source files located in the ``$USERS_GUIDE/source`` folder using syntax described in the [Sphinx Documentation](http://sphinx-doc.org/contents.html).

## Build the HTML users guide
In the ``$USERS_GUIDE`` folder type ``make html`` from the command line to build the documentation. This builds a html formatted copy of the documentation in the ``$USERS_GUIDE/build/html`` folder. After building the HTML users guide, you can view the local copy of the documentation by:
  * Opening the ``$HTML/index.html`` file in a web browser
  * Opening the 

## Update the documentation on the http://wec-sim.github.io/WEC-Sim website
The github.io website renders the documentation in your ``gh-pages`` branch as a website located at http://<REPOSITIORY NAME>.github.io/<PROJECT NAME>. The easiest way to update the website is to make the ``$HTML`` folder a clone of ``gh-pages`` branch of WEC-Sim. Here are the steps to do this:

1. **Build the WEC-Sim HTML Users Guide as described above** 

1. **Push the documentation to gh-pages:** You must push the content in the  ``$WECSIM_SOURCE/doc/users-guide/build/html`` folder to the WEC-Sim GitHub gh-pages. The gh-pages branch is rendered on the WEC-Sim Users Guide website - http://wec-sim.github.io/WEC-Sim/. The easiest way to do this is to clone the WEC-Sim ``gh-pages`` branch into the ``$HTML`` folder folder so you can easily push the html documentation to ``gh-pages``.

  * Insure the `$build` folder is listed in the `$WECSIM_SOURCE/doc/users-guide/.gitignore` file.
  * Delete all contents in the ``build
  * Make the html documentation: ``$cd $WECSIM_SOURCE/doc/users-guide`` then ``make html``
  * 
  * Move to the `$WECSIM_SOURCE/doc/users-guide/build/html folder and clone the WEC-Sim gh-pages branch
  ```
  cd $WECSIM_SOURCE/doc/users-guide/build/html
  git clone --depth 1 -b gh-pages https://github.com/WEC-Sim/WEC-Sim.git
  ```
  This will create a folder called `WEC-Sim` in your `$WECSIM_SOURCE/doc/users-guide/build/html` directory that is a clone of gh-pages

  * Move the `$WECSIM_SOURCE/doc/users-guide/build/html/WEC-Sim/.git` and `$WECSIM_SOURCE/doc/users-guide/build/html/WEC-Sim/nojekyl` to the `$WECSIM_SOURCE/doc/users-guide/build/html` folder and then remove the `$WECSIM_SOURCE/doc/users-guide/build/html/WEC-Sim/` folder.
  ```
  cd $WECSIM_SOURCE/doc/users-guide/build/html
  mv WEC-Sim/.git ./
  mv WEC-Sim/.nojekyll ./
  rm -rf WEC-Sim/
  ```

  This effectively makes the html folder a clone of gh-pages.

1. Now that `$WECSIM_SOURCE/doc/users-guide/build/html` is a clone of gh-pages, you can update the WEC-Sim Users Guide website by performing the following commands:
```
cd $WECSIM_SOURCE/doc/users-guide/
make html
cd $WECSIM_SOURCE/doc/users-guide/build/html
git add -A
git commit -m 'Descriptive commit message'
git push
```
