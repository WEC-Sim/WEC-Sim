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

First, the geometry needs to be imported and each body moved to their respective center of gravity (cg). 
For the example cases, the cg can be found in the .pot file from the WAMIT examples. 
Then, the bodies need to be turned into thin surfaces using Thin/Surface command.
Next, the bodies should be sliced at the water surface level (XY Plane) and grouped back into their main parts. 
For instance, the RM3 was split into 4 bodies. Then, the 2 float bodies were used to form a new part called float, and the same was done for the 2 spar bodies.

## Input Settings

Most of the necessary input settings can be found within the .AH1 file for each AQWA case. The following settings were changed from their defaults, but kept consistent for each case:

For each body:
	* **Point Mass**
		* **Define Inertia Values By**: Radius of Gyration
		* **[Kxx Kyy Kzz]**: [1 1 1] m
* **Mesh**
	* The Defeaturing Tolerance and Maximum Element Size were iteratively changed until the desired frequencies were available to be run.
* **Analysis Settings**
	* **Ignore Modelling Rule Violations**: Yes
	* **ASCII Hydrodynamic Database**: Yes
* **Wave Directions**
	* **Interval**: 180°
	* **Number of Intermediate Directions**: 1
* **Wave Frequencies**
	* **Range**: Manual Definition
	* **Number of Intermediate Values**: 48
	* The specific frequencies simulated can be found in the .AH1 file