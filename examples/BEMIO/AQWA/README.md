# Ansys AQWA Examples
* **Coer_Comp Example**
* **Cubes Example**
* **Cylinder Example**
* **Ellipsoid Example**
* **OSWEC Example**
* **RM3 Example**
* **Sphere Example**
* **WEC3 Example**

## Directions

First, the geometry should be imported and each body moved to their respective center of gravity (cg). 
For the example cases, the cg can be found in the .pot file from the WAMIT examples or in the .AH1 file for AQWA examples. 
Then, the bodies need to be turned into thin surfaces using Thin/Surface command.
Next, the bodies should be sliced at the water surface level (XY Plane) using the slice command and grouped back into their main parts. 
For instance, the RM3 was split into 4 bodies. Then, the 2 float bodies were used to form a new part called float, and the same was done for the 2 spar bodies.

## Input Settings

Most of the necessary input settings can be found within the .AH1 file for each AQWA case. The following settings should be upodated based on the example being run:

* **Geometry**
	* **Water Depth**: ___ m
	* **Water Size X/Y**: __ m (should be much larger than device)
* **Point Mass (for each part)**
    * **Mass Definition**: Manual Definition
    * **X/Y/Z**: _ m
    * ** Mass**: ___ kg
	* **Define Inertia Values By**: Radius of Gyration
	* **[Kxx Kyy Kzz]**: [_ _ _] m
* **Mesh**
	* The Defeaturing Tolerance and Maximum Element Size should be iteratively changed until the desired frequencies are available to be run.
* **Analysis Settings**
	* **Ignore Modelling Rule Violations**: Yes
	* **ASCII Hydrodynamic Database**: Yes
* **Wave Directions**
	* **Interval**: ___°
	* **Number of Intermediate Directions**: _
* **Wave Frequencies**
	* **Range**: Manual Definition
	* **Number of Intermediate Values**: __
	* The specific frequencies simulated for each example can be found in the respective .AH1 files