# Descriptions of the files in each directory:

- `spar.dat` and `float.dat` are mesh files in Nemoh's format for the two components of the device.
- `main.py` is the Python script using Capytaine to compute hydrostatics and hydrodynamics coefficients.
- `pyproject.toml` contains some Python metadata about the test case, most importantly the packages that need to be installed to run the test case.
- `requirements.txt` and `.python-version` are the description of the Python environment that has been used to compute in the provided `outputs` directory. You don't *need* to use the exact same environment, but in case you have issues with your current environment you can fallback on them. Using the [uv](https://docs.astral.sh/uv/) package manager for Python, the study can be rerun with the command
```shell
uv run --with-requirements requirements.txt python main.py
```

- `outputs/KH_*.dat` and `outputs/Hydrostatics_*.dat` are hydrostatics in Nemoh format, that can be read by BEMIO.
- `outputs/rm3_hydrodynamics.nc` are the hydrodynamics coefficients in Capytaine's format.
