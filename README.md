# How to Update the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim)

## Download/Install Required Packages
### Step 1. Download and Install Python 
  - Windows: Download and install [Python3](https://www.python.org/downloads/) or [Anaconda](https://www.anaconda.com/distribution/)
 
### Step 2. Add Python to System Path
  - Windows: Modify the PATH in environmental variables to include: C:\PYTHON;C:\PYTHON\Scripts
	     If Anaconda was used to install Python add python to the system path as: C:\Users\yourUserName\Anaconda3
  ([more info here](http://stackoverflow.com/questions/3701646/how-to-add-to-the-pythonpath-in-windows-7))
  You can also add through the command prompt using: SETX PATH "%PATH%;newPathstoAdd"
  - **NOTE:** MAC/LINUX skip to Step 3, Python is already added to path
  
### Step 3. Download/Install [Sphinx](http://www.sphinx-doc.org/en/stable/index.html) package
  - Install Sphinx from cmd ``pip install -U Sphinx`` 
    ([more info here](http://www.sphinx-doc.org/en/master/usage/installation.html))
  - **NOTE:** You may need to configure PROXY settings ([see info here](https://cinhtau.net/2018/04/16/python-proxy-windows/))

### Step 4. Download/Install Sphinx extensions
  - Install rtd theme ``pip install -U sphinx_rtd_theme``
  - Install BibTex ``pip install -U sphinxcontrib-bibtex``
  - Install matlabdomain ``pip install -U sphinxcontrib-matlabdomain``
  

## Update the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim) Content
The WEC-Sim documentation located on the [gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages), referred to as ``<GH-PAGES>``. The WEC-Sim Website is developed as restructured text files that are compiled by [Sphinx](http://www.sphinx-doc.org/en/master/) into html files. To edit the WEC-Sim Website, modify the source files located in the ``<GH-PAGES>/source`` directory using the syntax described on the [Sphinx Website](http://www.sphinx-doc.org/en/master/). Once you are done editing, cd to your local ``$GH-PAGES`` directory from cmd, clean the previous compile with ``clean html``, and compile the updated the documentation with ``make html``. This compiles an html version of the website in ``<GH-PAGES>/``. After compiling the updated website, you can view the local copy of the website by opening the ``<GH-PAGES>/index.html`` file from your local directory, and viewing it in a web browser (before pushing it online). 

### Best Practices
  - Run spell check (not built into most text editors)
  - When compiling the website, ``make clean`` and then ``make html``

### Formatting Guidelines
  - `$CASE` to refer to WEC-Sim case directory
  - `$WECSIM` to refer to WEC-Sim directory
  - `$WECSIM/source` to refer to WEC-Sim source directory
  - `*.mat` syntax to refer to file extension
  - use ``insert code`` to reference code
  - Title `####` with overline
  - Heading 1 `======`
  - Heading 2 `------`
  - Heading 3 `^^^^^^`
  - Heading 4 `""""""`
  - Heading 5 `++++++`
  - Use this style guide: https://documentation-style-guide-sphinx.readthedocs.io/en/latest/style-guide.html

### Terminology Guidelines
  - post-processing (not postprocessing)
  - pre-processing (not preprocessing)  
  - nondimensional (not non-dimensional)
  - nonlinear (not non-linear)
  - drivetrain (not drive-train)


## Push the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim) Updates to GH-PAGES
Using GitHub, gh-pages renders the documentation on the ([gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages)) as the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim). The user then pushes changes in the html documentation directly to the [gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages). Here are the steps to do this:

  ```Shell
  # Move to the local gh-page directory in cmd
  cd <GH-PAGES>

  # Clean and build the html documentation in cmd
  make clean
  make html

  # Use Git-shell to check status of the gh-pages branch, then commit and push changes. 
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```
