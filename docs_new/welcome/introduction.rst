.. _user-getting-started:

Overview of WEC-Sim
=======================

.. TODO:
	content to cover:
	X reiterate home page data
	X WEC-Sim capabilities / core features
	- high level input/output
	- compare to other codes
		advantages over other options
	- speed / accuracy?
		Could reference OC6P1 paper and comparison?
	- variety of applications cases
	- paraview figures /gifs of Application cases
		Could cite private industries who have used WEC-Sim? Justification-increase their visibility and show our credibility/experience
	- break up paragraphs with figures. Demonstrate I/O, BEM
	- Is all the above just condensing the following sections into too much information? -> check with team

.. TODO:
	plots:
	speed comparison with similar codes?
	accuracy comparison with similar codes?
	OC6 Phase 1
	effect of WS adv. features
		b2b
		NLhydro
		nonhydro
		mooring
		numerical options
		passive yaw
		MCR / batch run -> large power matrix?
	.
	figures:
	RM's
	OSWEC
	desal
	WECCCOMP
	GBM
	ptosim?
	wigley?
	Any teamer?
	FOSWEC

WEC-Sim (Wave Energy Converter SIMulator) is an open-source code for simulating wave energy converters. 
The code is developed in MATLAB/SIMULINK using the multi-body dynamics solver Simscape Multibody. 
WEC-Sim has the ability to model devices that are comprised of hydrodynamic bodies, joints and constraints, power take-of systems, and mooring systems.
Simulations are performed in the time-domain by solving the governing wave energy converter equations of motion in the 6 
rigid Cartesian degrees-of-freedom, plus any number of user-defined modes. 
As long as boundary element method data is available, a body may also move in any number of generalized body modes such as shear, torsion, or bending.

At a high level, the only external input that WEC-Sim requires is boundary element method data from codes such as WAMIT, AQWA, Capytaine, HAMS, etc. 
The boundary element method represents the hydrodynamic response of the device for a given wave frequency. 
WEC-Sim uses this data to simulate devices in the time-domain where they can be better coupled with controls, power take-off systems, and other external bodies and forcings. 
WEC-Sim outputs the motions, forces and power absorbed or lost in individual bodies, joints and PTOs. 
Output is readily available in MATLAB for custom post-processing or coupling with external tools such as the `WecOptTool <https://snl-waterpower.github.io/WecOptTool/>`_.

* insert birds-eye view figure of WEC-Sim's place in MRE development (geometry/design, BEM, WEC-Sim, {MHKit, WecOptTool, efficiency, dev, etc}). Higher level / less W-S detail than Workflow diagram


.. TODO: 
	maybe reference?
	"WEC-Sim's time domain model is more robust and accurate in modeling controls, forcings, and body motions than extending frequency-based models such as WAMIT or Ansys AQWA. 
	Its intended use is similar to softward such as Orcina OrcaFlex or Ansys AQWA in the time domain."
	.
	speed/accuracy comparisons to external codes

Several interfaces with Simulink are included that allow users to couple WEC-Sim with a wide variety of other models and scripts relevant to their devices.
Complex power take-off systems and advanced control algorithms are just two examples of the advanced tools that can be coupled with WEC-Sim.

.. figure:: /_static/images/new_figs/OSWEC_with_ptosim.JPG
   :width: 750pt

.. TODO:
	insert simulink diagram of WEC with advanced controls model

Together with PTO and control systems, WEC-Sim is able to model a wide variety of marine devices.
The WEC-Sim Applications repository contains a wide variety of scenarios that WEC-Sim can model. This repository includes both demonstrations of WEC-Sim's advanced features and applications of WEC-Sim to unique devices.

.. TODO:
	use table instead of figures to list WEC-Sims key capabilities?

WEC-Sim's capabilities include the ability to model both nonlinear hydrodynamic effects (Froude-Krylov forces and hydrostatic stiffness) and nonhydrodynamic bodies, body-to-body interactions, mooring systems, passive yawing. WEC-Sim contains numerous numerical options and ability to perform highly customizable batch simulations. WEC-Sim can take in data from a variety of boundary element method codes using its BEMIO (BEM-in/out) functionality and can output paraview files for visualization. Some of its advanced features are highlighted in the figures below.

.. TODO:
	insert plots showing WEC-Sim adv. features
	from above:
	X b2b
	X NLhydro
	nonhydro?
	X numerical options
	passive yaw
	MCR / batch run -> large power matrix?

.. |b2b| image:: /_static/images/new_figs/b2b_comparison2.png
   :width: 400pt
.. |nlh| image:: /_static/images/new_figs/nlhydro_comparison4.png
   :width: 400pt
.. |num| image:: /_static/images/new_figs/numOpt_comparison.png
   :width: 400pt
.. |yaw| image:: /_static/images/new_figs/passiveYaw_comparison.png
   :width: 400pt


+---------+---------+
|  |nlh|  +  |num|  |
+---------+---------+
|  |b2b|  +  |yaw|  |
+---------+---------+



The Paraview figures below highlight some of WEC-Sim's capabilities and the various geometries that have been successfully modeled.

.. TODO:
	insert figures of special geometries that WEC-sim can handle
	from above:
	RM's
	OSWEC
	desal
	WECCCOMP
	GBM
	ptosim?
	wigley?
	Any teamer?
	FOSWEC?
	mooring