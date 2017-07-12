
# How to update the [WEC-Sim website](http://wec-sim.github.io/WEC-Sim)

## Download/Install Required Packages
1. Download and Install Python 
  - Windows: Download and install [Python27](https://www.python.org/downloads/) or [Anaconda](https:/www.continuum.io/downloads)
 
 **MAC/LINUX NOTE:**: Skip to Step 3, Python is already installed and added to path
 
2. Add Python and Python Scripts to system path
  - Windows: Modify the PATH in environmental variables to include: C:\PYTHON27;C:\PYTHON27\Scripts ([more info here](http://stackoverflow.com/questions/3701646/how-to-add-to-the-pythonpath-in-windows-7)), with Anaconda this is done automatically. 

3. Download/Install the python documentation package [Sphinx](http://www.sphinx-doc.org/en/stable/index.html)
  - Install Sphinx in cmd ``pip install -U Sphinx`` ([windows info here](http://sphinx-doc.org/latest/install.html#windows-install-python-and-sphinx)) ([MAC/LINUX info here](http://www.sphinx-doc.org/en/stable/install.html#mac-os-x-install-sphinx-using-macports))

 **NOTE:** You may need to configure PROXY, in cmd ``set http_proxy=<server>:<port#>``

4. Download/Install BibTeX extension for Sphinx
  - Install BibTex ``pip install sphinxcontrib-bibtex``
  - Install rtd theme ``pip install sphinx_rtd_theme``
 
 **NOTE:** You may have to manually move it to the ``sphinx/themes/`` directory.

5. Download/Install the Google Analytics extenstion for Sphinx ([more info here](http://www.milos.curuvija.com/miscellaneous/sphinx/sphinx_google_analytics_integration.html#))
  - Download sphinx-contrib [here](https://bitbucket.org/birkenfeld/sphinx-contrib/)
  - cd to directory in cmd``cd sphinx-contrib/googleanalytics`` 
  - Install google analytics ``python setup.py install`` 

 **NOTE:** You may want to manually move it to the ``sphinx-contrib/`` directory.

## Modify the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim) Content
The WEC-Sim documentation located on the WEC-Sim/gh-pages branch (https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages), will be referred to as the ``$WS_DOC``.

The WEC-Sim documentation is developed using [Sphinx](http://sphinx-doc.org/) and rendered in html. To edit  the users guide, modify the source files located in the **$WS_DOC/source** folder using syntax and methods described in the [Sphinx Documentation](http://sphinx-doc.org/contents.html). Once you are done editing, move to the **$WS_DOC** folder type ``make html`` from cmd to build the documentation. This builds a html formatted copy of the documentation in the **$WS_DOC/** folder. After building the HTML users guide, you can view the local copy of the documentation by opening the **$WS_DOC/index.html** file in a web browser

## Push Documentation to the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim)
The gh-pages website renders the documentation in the WEC-Sim/gh-pages branch as a website located at http://wec-sim.github.io/WEC-Sim/index.html. The user then pushes changes in the html documentation directly to the WEC-Sim/gh-pages branch. Here are the steps to do this:

  ```Shell
  # Move to the build directory in cmd
  cd $WS_DOC

  # Build the html documentation in cmd
  make html

  # Use Git-shell to check status of the gh-pages branch, then commit and push changes. 
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```

