# Visit the [WEC-Sim website](http://wec-sim.github.io/WEC-Sim) for more information.

## WEC-Sim Repository

* **Examples**: WEC-Sim model examples
* **Source**: WEC-Sim source code
* **Tests**: WEC-Sim tests run by Jenkins CI
* **Tutorials**: [WEC-Sim Tutorials](http://wec-sim.github.io/WEC-Sim/tutorials.html)

Refer to the [WEC-Sim Applications](https://github.com/WEC-Sim/WEC-Sim_Applications)
repository for more applications of the WEC-Sim code.

## Documentation

### Compile Instructions

These instructions work for both Linux and Windows. For Windows, remember to
replace slashes (`/`) in paths with backslashes (`\ `).

#### Setup Sphinx (One Time Only)

1. Install [Anaconda Python](https://www.anaconda.com/distribution/).

2. Create the Sphinx environment:
   
   ```
   > conda create -c conda-forge -n _sphinx click colorama colorclass future pip "sphinx=1.8.5" sphinxcontrib-bibtex sphinx_rtd_theme 
   > activate _sphinx
   (_sphinx) > pip install sphinxcontrib-matlabdomain
   (_sphinx) > pip install --no-deps sphinxext-remoteliteralinclude
   (_sphinx) > pip install https://github.com/H0R5E/sphinxcontrib-versioning/archive/v1.8.5_support.zip
   (_sphinx) > conda deactivate
   >
   ```

#### Testing the Current Branch

The documentation for the current branch can be built locally for inspection 
prior to publishing. They are built in the `docs/_build` directory. Note, 
unlike the final documentation, version tags and other branches will not be 
available. 

To test the current branch, use the following:

```
> activate _sphinx
(_sphinx) > cd path/to/WEC-Sim
(_sphinx) > sphinx-build -b html docs docs/_build/html
(_sphinx) > conda deactivate
>
```

The front page of the docs can be accessed at 
`docs/_build/html/index.html`. 

#### Building Final Version Locally

The final documentation can be built locally for inspection prior to 
publishing. They are built in the `docs/_build` directory. Note, docs are built 
from the remote, so only pushed changes will be shown. 

To build the docs as they would be published, use the following:

```
> activate _sphinx
(_sphinx) > cd path/to/WEC-Sim
(_sphinx) > sphinx-versioning build -b docs docs/_build/html
(_sphinx) > conda deactivate
>
```

The front page of the docs can be accessed at 
`docs/_build/html/index.html`. 

#### Publishing Final Version Remotely

The WEC-Sim docs are rebuilt automatically following every merge commit made 
to the master branch of the [WEC-Sim/WEC-Sim](
https://github.com/WEC-Sim/WEC-Sim) repository. They can also be  published 
manually, as follows:

```
> activate _sphinx
(_sphinx) > cd path/to/WEC-Sim
(_sphinx) > sphinx-versioning push -b -e .nojekyll -e README.md -P <REMOTE> docs <BRANCH> .
(_sphinx) > conda deactivate
>
```

\<REMOTE\> refers to the git remote which will be pushed to and \<BRANCH\> 
refers to the target branch on the remote. Note, this command will add a new 
commit to the remote, so use with care.
