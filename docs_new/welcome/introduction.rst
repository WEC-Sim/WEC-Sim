.. _welcome-intro:

Overview of WEC-Sim
=======================

.. TODO:
    content to cover:
    X reiterate home page data
    X WEC-Sim capabilities / core features
    X high level input/output
    - compare to other codes
        advantages over other options
    - speed / accuracy?
        Could reference OC6P1 paper and comparison?
    - highlight variety of applications that have been successfully modeled with WEC-Sim
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
        X b2b
        X NLhydro
        nonhydro
        X mooring
        X numerical options
        X passive yaw
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

WEC-Sim (Wave Energy Converter SIMulator) is an open-source code for simulating 
wave energy converters. The code is developed in MATLAB/SIMULINK using the 
multi-body dynamics solver Simscape Multibody. WEC-Sim has the ability to model 
devices that are comprised of hydrodynamic bodies, joints and constraints, 
power take-of systems, and mooring systems. Simulations are performed in the 
time-domain by solving the governing wave energy converter equations of motion 
in the 6 rigid Cartesian degrees-of-freedom, plus any number of user-defined 
modes. As long as boundary element method data is available, a body may also 
move in any number of generalized body modes such as shear, torsion, or 
bending. 

.. figure:: /_static/images/new_figs/overview_diagram.JPG
   :width: 750pt

At a high level, the only external input that WEC-Sim requires is boundary 
element method data from codes such as WAMIT, AQWA, Capytaine, HAMS, etc. The 
boundary element method represents the hydrodynamic response of the device for 
a given wave frequency. WEC-Sim uses this data to simulate devices in the 
time-domain where they can be better coupled with controls, power take-off 
systems, and other external bodies and forcings. WEC-Sim outputs the motions, 
forces and power absorbed or lost in individual bodies, joints and PTOs. Output 
is readily available in MATLAB for custom post-processing or coupling with 
external tools such as the `WecOptTool <https://snl-waterpower.github.io/WecOptTool/>`_. 

.. TODO: 
    reference other codes or not?
    speed/accuracy comparisons to external codes?
    .
    "WEC-Sim's time domain model is more robust and accurate in modeling controls, forcings, and body motions than extending frequency-based models such as WAMIT or Ansys AQWA. 
    Its intended use is similar to softward such as Orcina OrcaFlex or Ansys AQWA in the time domain."
    .

Several interfaces with Simulink are included that allow users to couple 
WEC-Sim with a wide variety of other models and scripts relevant to their 
devices. Complex power take-off systems and advanced control algorithms are 
just two examples of the advanced tools that can be coupled with WEC-Sim. 

.. figure:: /_static/images/new_figs/OSWEC_with_ptosim.JPG
   :width: 750pt

.. TODO:
    insert simulink diagram of WEC with advanced controls model

Together with PTO and control systems, WEC-Sim is able to model a wide variety 
of marine devices. The WEC-Sim Applications repository contains a wide variety 
of scenarios that WEC-Sim can model. This repository includes both 
demonstrations of WEC-Sim's advanced features and applications of WEC-Sim to 
unique devices. 

.. TODO:
    use table instead of figures to list WEC-Sims key capabilities?

WEC-Sim's capabilities include the ability to model both nonlinear hydrodynamic 
effects (Froude-Krylov forces and hydrostatic stiffness) and nonhydrodynamic 
bodies, body-to-body interactions, mooring systems, passive yawing. WEC-Sim 
contains numerous numerical options and ability to perform highly customizable 
batch simulations. WEC-Sim can take in data from a variety of boundary element 
method codes using its BEMIO (BEM-in/out) functionality and can output paraview 
files for visualization. Some of its advanced features are highlighted in the 
figures below. 

.. TODO:
    insert plots showing WEC-Sim adv. features
    from above:
    X b2b
    X NLhydro
    nonhydro?
    X numerical options
    X passive yaw
    MCR / batch run -> large power matrix?

.. |b2b| image:: /_static/images/new_figs/b2b_comparison2.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |nlh| image:: /_static/images/new_figs/nlhydro_comparison4.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |num| image:: /_static/images/new_figs/numOpt_comparison.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |yaw| image:: /_static/images/new_figs/passiveYaw_comparison.png
   :width: 400pt
   :height: 175pt
   :align: middle

+-------------------------------------------------------------+
|               Advanced Features Demonstration               |
+==============================+==============================+
| |           |nlh|            | |           |num|            |
| |  Nonlinear hydrodynamics   | | Various numerical options  |
+------------------------------+------------------------------+
| |           |b2b|            | |           |yaw|            |
| | Body-to-body interactions  | |        Passive yaw         |
+------------------------------+------------------------------+


WEC-Sim can accurately model a wide variety of marine renewable energy and offshore devices
due to its advanced features and capabilities, including those highlighted above.
The Paraview figures below highlight a small sample of devices that WEC-Sim has successfully modeled in the past.
 
.. TODO:
    insert figures of special geometries that WEC-sim has modeled
    add url to each case in the figure or image? 
    
    Paraview:
    X RM3 w/ mooring
    RM5
    X OSWEC
    BEMIO examples (cubes, cylinder, X ellipsoid, X sphere)
    X GBM -> more flexible design that can show off bending modes in a gif?
    X wigley hull
    COER COMP
    X WECCCOMP
    X OC6 Phase I
    OC6 Phase II
    FOSWEC?
    Other industry designs? (Aquaharmonics, Calwave, NWEI, ...?)
    
    Simulink + simscape explorer/Paraview:
    desal
    ptosim variations:
    	RM3 + hydraulic drive
    	RM3 + direct drive
    	OSWEC + crank
    	OSWEC + 
    Any teamer designs?


.. figure:: /_static/images/new_figs/rm3_iso_side.png
   :align: center
   :width: 500pt
   
   Reference Model 3


.. figure:: /_static/images/new_figs/rm3_iso_side.png
   :align: center
   :width: 500pt
   
   Reference Model 5 TODO


.. figure:: /_static/images/new_figs/oswec_iso_side.png
   :align: center
   :width: 500pt
   
   Bottom-fixed Oscillating Surge WEC (OSWEC)


TODO BEMIO cases


.. figure:: /_static/images/new_figs/sphere_freedecay_iso_side.png
   :align: center
   :width: 500pt
   
   Hemisphere in Free Decay


.. figure:: /_static/images/new_figs/ellipsoid_iso_side.png
   :align: center
   :width: 500pt
   
   Ellipsoid


.. figure:: /_static/images/new_figs/gbm_iso_side.png
   :align: center
   :width: 500pt
   
   Barge with Four Flexible Body Modes


.. figure:: /_static/images/new_figs/wigley_iso_side.png
   :align: center
   :width: 500pt
   
   Wigley Ship Hull
   
   
   TODO COER COMP


.. figure:: /_static/images/new_figs/wecccomp_iso_side.png
   :align: center
   :width: 500pt
   
   Wave Energy Converter Control Competition (WECCCOMP) Wavestar Device


.. figure:: /_static/images/new_figs/oc6_iso_side.png
   :align: center
   :width: 500pt
   
   OC6 Phase I DeepCwind Floating Semisubmersible
   



.. |viz_oswec| image:: /_static/images/new_figs/rm3_iso_side.png
   :align: middle
   
.. |viz_foswec| image:: /_static/images/new_figs/rm3_iso_side.png
   :align: middle
   
.. |viz_wigley| image:: /_static/images/new_figs/rm3_iso_side.png
   :align: middle


.. 
	+-------------------------------------------------------------+
	|                 Proven WEC-Sim Applications                 |
	+==============================+==============================+
	| |  Nonlinear hydrodynamics   | | Various numerical options  |
	| |                            | |                            |
	| |         |viz_rm3|          | |        |viz_oswec|         |
	+------------------------------+------------------------------+
	| |       Floating OSWEC       | |        Passive Yaw         |
	| |                            | |                            |
	| |        |viz_foswec|        | |        |viz_wigley|        |
	+------------------------------+------------------------------+
