To use MoorDyn in WEC-Sim, please

1. Download moorDyn from repo <https://github.com/WEC-Sim/moorDyn> 
2. Place all the files and folders under `WEC-Sim/source/functions/moorDyn` folder

**Note for Mac Users:**

You need to rename the `.dylib` library that corresponds to your system architecture 
(type of CPU) to `libmoordyn.dylib` before completing step 2 above. 
- Apple Silicon (2020 and later): run `mv libmoordyn-arm64.dylib libmoordyn.dylib`
- Intel (pre 2020): run `mv libmoordyn-x86_64.dylib libmoordyn.dylib`

--------------------- MoorDyn v2.3.7 -------------------------

Copyright 2014-2016 Matt Hall <mtjhall@alumni.uvic.ca>

MoorDyn is a lumped-mass mooring line model intended for coupling with floating structure codes.

v2 builds upon v1 by adding new features including rigid bodies and support for wave loading at 
the free surface. WEC-Sim works properly with MoorDyn v2, but compatibility of the new features 
in WEC-Sim is currently still under development. 

MoorDyn is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

MoorDyn is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
General Public License for details.

You should have received a copy of the GNU General Public License 
along with MoorDyn.  If not, see <http://www.gnu.org/licenses/>.

If the MoorDyn files on this repository are not functioning on your system, you should compile the code from source following the steps in the [documentation](https://moordyn.readthedocs.io/en/latest/). MoorDyn will automatically build with the right architecture for your system. Once you have your local MoorDyn library and source code, replace `MoorDyn.h`, `MoorDynAPI.h`, and the library file (e.g., `libmoordyn.dll`) from this repo with your local copy.

---------------------- More Information -------------------------

More information about MoorDyn is now available at [moordyn.readthedocs.io](https://moordyn.readthedocs.io/en/latest/) -- including the User's Guide, source code, and examples.  

For information about MoorDyn's formulation and some validation 
results, see M. Hall and A. Goupee, ìValidation of a lumped-mass 
mooring line model with DeepCwind semisubmersible model test 
data,î Ocean Engineering, vol. 104, pp. 590ñ603, Aug. 2015.  
<http://www.sciencedirect.com/science/article/pii/S0029801815002279>

---------------------- Troubleshooting -------------------------

**Mac architecture issue:**

If WECSim on Mac gives architecture errors when running MoorDyn similar to:

    Error using wecSim (line 46)
    There was an error loading the library "WEC-Sim/source/functions/moorDyn/libmoordyn.dylib"
    dlopen(WEC-Sim/source/functions/moorDyn/libmoordyn.dylib, 0x0006): tried:
    'WEC-Sim/source/functions/moorDyn/libmoordyn.dylib' (mach-o file, but is an incompatible architecture
    (have 'x86_64', need 'arm64e' or 'arm64')),
    'WEC-Sim/source/functions/moorDyn/libmoordyn.dylib' (mach-o file, but is an incompatible
    architecture (have 'x86_64', need 'arm64e' or 'arm64'))

then you have a mismatch between the MoorDyn compiled architecture and your system architecture. To resolve this, double check you copied and renamed the `.dylib` corrsponding to your system into the `WEC-Sim/source/functions/moorDyn` folder.

If that doesnt work, you should compile the code from source following the steps in the [documentation](https://moordyn.readthedocs.io/en/latest/). MoorDyn will automatically build with the right architecture for your system. Once you have your local MoorDyn library and source code, replace `MoorDyn.h`, `MoorDynAPI.h`, and `libmoordyn.dylib` from this repo with your local copy. The `.h` files can be found in `MoorDyn/source/`, and the library files can be found in `MoorDyn/build/source/`. 

Note: to force MoorDyn to compile for a different architecture, add the `-DCMAKE_OSX_ARCHITECTURES=<insert architecture>` to your cmake call. 
