# Instructions for updating the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim)

## Download/Install Required Packages
### Step 1. Download and Install Python 
  - Windows: Download and Install Python3 using [Anaconda](https://www.anaconda.com/distribution/). When installing Anaconda select the option to add Python to your environmental vairables. Follow [these instructions](https://docs.anaconda.com/anaconda/user-guide/tasks/proxy/) for using Anaconda behind a company proxy.
 - MAC/LINUX: Skip to Step 3, Python is already installed
 
### Step 2. Add Python to System Path 
  - Windows: Skip to Step 3 if option selected when installing Anaconda, otherwise modify the PATH in environmental variables to include: C:\PYTHON;C:\PYTHON\Scripts 
  ([more info here](http://stackoverflow.com/questions/3701646/how-to-add-to-the-pythonpath-in-windows-7)).
  - MAC/LINUX: Skip to Step 3, Python is already added to path
  
### Step 3. Download/Install [Sphinx](http://www.sphinx-doc.org/en/stable/index.html) and Sphinx extensions
  - Install Sphinx ``pip install -U Sphinx`` 
    ([more info here](http://www.sphinx-doc.org/en/master/usage/installation.html))
  - Install rtd theme ``pip install -U sphinx_rtd_theme``
  - Install BibTex ``pip install -U sphinxcontrib-bibtex``
  - Install matlabdomain ``pip install -U sphinxcontrib-matlabdomain``
  

## Update the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim)
The WEC-Sim documentation located on the [gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages), referred to as ``<GH-PAGES>``. The WEC-Sim Website is developed as restructured text `*.rst` files that are compiled by [Sphinx](http://www.sphinx-doc.org/en/master/) into `*.html` files. 

### Make local changes to the WEC-Sim Website
To edit the WEC-Sim Website, modify the restructured text  `*.rst` files located in the ``<GH-PAGES>/source`` directory. 
Syntax for restructured text files is described on the [Sphinx Website](http://www.sphinx-doc.org/en/master/). 
Once you're done editing, using the cmd navigate to your local ``<GH-PAGES>`` directory, clean the previous compile, and compile the updated the documentation. 
This step compiles the `*.rst` files into `*.html`. 
After compiling the updated website, you can view the local copy of the website by opening the ``<GH-PAGES>/index.html`` file from your local directory, and viewing it in a web browser (before pushing it online). 

  ```Shell
  # Move to the local gh-page directory in cmd
  cd <GH-PAGES>

  # Clean and build the html documentation in cmd
  make clean
  make html
  ```

### Push [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim) updates to the GH-PAGES branch
Using GitHub, gh-pages renders the documentation from the ([gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages)) as the [WEC-Sim Website](http://wec-sim.github.io/WEC-Sim). To make local updates live on the WEC-Sim website, push local documenation changes to the [gh-pages branch](https://github.com/WEC-Sim/WEC-Sim/tree/gh-pages) using the following commands:

  ```Shell
  # Use Git-shell to check status of the gh-pages branch, then commit and push changes. 
  git status
  git add -A
  git commit -m 'update to WEC-Sim documentation'
  git push
  ```
  
## Best Practices
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

