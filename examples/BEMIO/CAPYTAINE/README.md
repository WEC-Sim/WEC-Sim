# Description of the files
## in this directory

- `pyproject.toml` contains some Python metadata about the test case, most importantly the packages that need to be installed to run the test case.
- `requirements.txt` and `.python-version` are the description of the Python environment that has been used to compute in the provided `outputs` directory. You don't *need* to use the exact same environment, but in case you have issues with your current environment you can fallback on it. Using the [uv](https://docs.astral.sh/uv/) package manager for Python, each test case can be rerun with the command
```shell
uv run --no-project --with-requirements requirements.txt python <subdirectory>/main.py
```
- `run_all.py` can be used to rerun all the test cases with e.g.:
```shell
uv run --no-project --with-requirements requirements.txt python run_all.py
```

## in the project directories

- `*.dat` files are mesh files in Nemoh's format.
- `main.py` is the Python script using Capytaine to compute hydrostatics and hydrodynamics coefficients.
- `outputs/KH_*.dat` and `outputs/Hydrostatics_*.dat` are hydrostatics in Nemoh format, that can be read by BEMIO.
- `outputs/*.nc` are the hydrodynamics coefficients in Capytaine's format.


