# Visit the [WEC-Sim website](http://wec-sim.github.io/WEC-Sim) for more information.

## WEC-Sim Documentation

### Compile Instructions

These instructions work for both Linux and Windows. For Windows, remember to
replace slashes (`/`) in paths with backslashes (`\ `).

#### Setup Sphinx (One Time Only)

1. Install [Anaconda Python](https://www.anaconda.com/distribution/).

2. Create the Sphinx environment:
   
   ```
   > conda create -c conda-forge -n _sphinx git click colorama colorclass future pip "sphinx=1.8.5" sphinxcontrib-bibtex sphinx_rtd_theme 
   > conda activate _sphinx
   (_sphinx) > pip install sphinxcontrib-matlabdomain
   (_sphinx) > pip install --no-deps sphinxext-remoteliteralinclude
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
> conda activate _sphinx
(_sphinx) > cd path/to/WEC-Sim
(_sphinx) > sphinx-build -b html docs_new docs/_build/html/new
(_sphinx) > conda deactivate
>
```

The front page of the docs can be accessed at 
`docs/_build/html/new/index.html`. 

#### Building Final Version Locally

The final documentation can be built locally for inspection prior to 
publishing. They are built in the `docs/_build` directory. Note, docs are built 
from the remote, so only pushed changes will be shown. 

To build the docs as they would be published, use the following:

```
> conda activate _sphinx
(_sphinx) > cd path/to/WEC-Sim
(_sphinx) > sphinx-versioning build docs_new docs/_build/html/new
(_sphinx) > conda deactivate
>
```

The front page of the docs can be accessed at 
`docs/_build/html/new/index.html`. 
