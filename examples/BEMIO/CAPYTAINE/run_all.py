import importlib

for directory in [
    "sphere",
    "ellipsoid",
    "cylinder",
    "cubes",
    "coer_comp",
    "oswec",
    "rm3",
]:
    print("Running ", directory)
    importlib.import_module(f"{directory}.main")
    # Tricky way to run the file {directory}/main.py byt importing it as a module
