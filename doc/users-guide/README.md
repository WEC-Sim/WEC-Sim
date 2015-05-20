# How to view WEC-Sim Users Guide
The Users Guide can be viewed online at http://wec-sim.github.io/WEC-Sim/.

# How to edit and update the WEC-Sim Users Guide (for developers)
These instructions provide guidance on how to edit the WEC-Sim users-guide.

## Required packages
1. Python
1. Sphinx
  1. Install using ``pip install sphinx``
  1. Install the bibtex extension for sphinx using ``pip install sphinxcontrib-bibtex``
  1. Install the rtd theme for sphinx using ``pip install sphinx_rtd_theme``. You might have to manually move it to the ``sphinx/themes/`` directory.

## Edit WEC-Sim Users Guide
The users guide is developed using [Sphinx](http://sphinx-doc.org/). To edit or add to the users guide, modify source files located in the ``$WECSIM_SOURCE/doc/users-guide/source`` folder. If you add a new file, be sure to include it in the ``index.html`` file.

## Build the HTML users guide
in the ``$WECSIM_SOURCE/doc/users-guide/`` folder type ``make html`` from the command line.

## Update the WEC-Sim master branch
Insure your changes to the WEC-Sim Users Guide are saved by pushing them to the WEC-Sim GitHub Website
```
git add $WECSIM_SOURCE/doc/users-guide/source/*
git add $WECSIM_SOURCE/doc/users-guide/source/_static/*
git commit -m 'Descriptive commit message'
git push
```

Note that these commands will not push the HTML source to the WEC-Sim Online Users Guide. The procedure for how to do this is described in a later section.



## View the HTML users guide locally on your computer
After building the HTML users guide, you can view it on your computer by opening the ``$WECSIM_SOURCE/doc/users-guide/build/html/index.html`` file in a web browser.

## Update the documentation on the WEC-Sim Users Guide website
Unfortunately, this is a bit complicated. The general procedure is this.
1. **Check your WEC-Sim branch:** Insure you are in the WEC-Sim master branch by typing ``git status`` from within the $WECSIM_SOURCE folder.
1. **Build the WEC-Sim HTML Users Guide:** Rnun the following commands to make the HTML documentation on your system
```
cd $WECSIM_SOURCE/doc/users-guide
make html
```
1. **Push the documentation to gh-pages:** You must push the content in the  ``$WECSIM_SOURCE/doc/users-guide/build/html`` folder to the WEC-Sim GitHub gh-pages which is rendered on the WEC-Sim Users Guide website - http://wec-sim.github.io/WEC-Sim/. To do this you will make the ``$WECSIM_SOURCE/doc/users-guide/build/html`` folder a clone of the WEC-Sim gh-pages branch and push the html source code to gh-pages using the following steps:
  * Insure the `html` folder is listed in the `$WECSIM_SOURCE/doc/users-guide/build/.gitignore` file

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
