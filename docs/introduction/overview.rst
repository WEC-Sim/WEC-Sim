.. _intro-overview:

Overview
=======================

.. TODO
    - compare to other codes?
        table of advantages over similar codes
        speed / accuracy comparison
        Reference OC6P1 paper and how well WEC-Sim performs


WEC-Sim (Wave Energy Converter SIMulator) is an open-source software for simulating wave energy converters. 
It is developed in MATLAB/SIMULINK using the multi-body dynamics solver Simscape Multibody. 
WEC-Sim has the ability to model devices that are comprised of hydrodynamic bodies, joints and constraints, power take-of systems, and mooring systems. 
Simulations are performed in the time-domain by solving the governing wave energy converter equations of motion in the 6 rigid Cartesian degrees-of-freedom. 
A body may also contain any number of generalized body modes to represent hydrodynamic effects in shear, torsion, bending, and others.

.. /_static/images/overview/overview_diagram.JPG
.. figure:: /_static/images/WEC-Sim_flowChart.png
   :width: 750pt

At a high level, the only external input WEC-Sim requires is hydrodynamic data from boundary element method (BEM) software such as WAMIT, NEMOH, Aqwa, and Capytaine. 
The boundary element method data represents the hydrodynamic response of the device for a given wave frequency. 
WEC-Sim uses this data to simulate devices in the time-domain where they can be coupled with controls, power take-off systems, and other external bodies and forces. 
WEC-Sim outputs the motions, forces, and power for individual bodies, joints and PTOs in MATLAB for custom post-processing or coupling with external tools. 

Several interfaces with Simulink are included that allow users to couple WEC-Sim with a wide variety of other models and scripts relevant to their devices. 
Complex power take-off systems and advanced control algorithms are just two examples of the advanced tools that can be coupled with WEC-Sim. 

.. figure:: /_static/images/overview/OSWEC_with_ptosim.png
   :width: 750pt
   
   Block diagram of an OSWEC device with hydraulic PTO created with PTO-Sim.

.. figure:: /_static/images/overview/wecccomp_diagram.png
   :width: 400pt
   
   Block diagram of the WECCCOMP device with advanced controller.

Together with PTO and control systems, WEC-Sim is able to model a wide variety of marine devices. 
The WEC-Sim Applications repository contains a wide variety of scenarios that WEC-Sim can model. 
This repository includes both demonstrations of WEC-Sim's advanced features and applications of WEC-Sim to unique devices. 

WEC-Sim's capabilities include the ability to model both nonlinear hydrodynamic effects (Froude-Krylov forces and hydrostatic stiffness) and nonhydrodynamic bodies, body-to-body interactions, mooring systems, passive yawing. 
WEC-Sim contains numerous numerical options and ability to perform highly customizable batch simulations. WEC-Sim can take in data from a variety of boundary element method software using its BEMIO (BEM-in/out) functionality and can output paraview files for visualization. 
Some of its advanced features are highlighted in the figures below. 


.. |b2b| image:: /_static/images/overview/b2b_comparison2.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |nlh| image:: /_static/images/overview/nlhydro_comparison4.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |num| image:: /_static/images/overview/numOpt_comparison.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |yaw| image:: /_static/images/overview/passiveYaw_comparison.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |mcr1| image:: /_static/images/overview/mcr_waveElev-heaveResp.png
   :width: 400pt
   :height: 175pt
   :align: middle
   
.. |mcr2| image:: /_static/images/overview/mcr_powerMatrix.png
   :width: 400pt
   :height: 175pt
   :align: middle

+-------------------------------------------------------------------+
|                   Advanced Features Demonstration                 |
+=================================+=================================+
| |nlh|                           | |num|                           |
| Nonlinear hydrodynamics         | Various numerical options       |
+---------------------------------+---------------------------------+
| |b2b|                           | |yaw|                           |
| Body-to-body interactions       | Passive yaw                     |
+---------------------------------+---------------------------------+
| |mcr1|                          | |mcr2|                          |
| Multiple case run: elevation    | Multiple case run: power matrix |
+---------------------------------+---------------------------------+


WEC-Sim can model a wide variety of marine renewable energy and offshore devices.
The figures below highlight a small sample of devices that WEC-Sim has successfully modeled in the past.
 
.. TODO:
    Paraview figures or Simscape diagrams:
    RM5
    GBM -> use more flexible design where bending can be seen
    COER COMP
    OC6 Phase II (future)
    FOSWEC
    desal
    ptosim
    Industry/academic designs? 


.. |rm3| image:: /_static/images/overview/rm3_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WEC-Sim/tree/master/examples/RM3
   

.. |oswec| image:: /_static/images/overview/oswec_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WEC-Sim/tree/master/examples/OSWEC


.. |sphere| image:: /_static/images/overview/sphere_freedecay_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WEC-Sim_Applications/tree/master/Free_Decay


.. |ellipsoid| image:: /_static/images/overview/ellipsoid_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WEC-Sim_Applications/tree/master/Nonlinear_Hydro


.. |gbm| image:: /_static/images/overview/gbm_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WEC-Sim_Applications/tree/master/Generalized_Body_Modes


.. |wigley| image:: /_static/images/overview/wigley_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/Wigley
   

.. |wec3| image:: /_static/images/overview/wecccomp_iso_side.png
   :align: middle
   :width: 400pt
   :target: https://github.com/WEC-Sim/WECCCOMP


.. |oc6p1| image:: /_static/images/overview/oc6_iso_side.png
   :align: middle
   :width: 400pt
   

.. rm3 Reference Model 3
   oswec Bottom-fixed Oscillating Surge WEC (OSWEC)
   sphere 
   ellipsoid Ellipsoid
   gbm Barge with Four Flexible Body Modes
   wigley Wigley Ship Hull
   wec3 Wave Energy Converter Control Competition (WECCCOMP) Wavestar Device
   oc6p1 OC6 Phase I DeepCwind Floating Semisubmersible
   

+----------------------------------------------------------------------+----------------------------------------------------------------------+
| Sample of devices that have been with WEC-Sim                                                                                               |
+======================================================================+======================================================================+
| |rm3|                                                                | |oswec|                                                              |
| Reference Model 3                                                    | Bottom-fixed Oscillating Surge WEC (OSWEC)                           |
+----------------------------------------------------------------------+----------------------------------------------------------------------+
| |sphere|                                                             | |ellipsoid|                                                          |
| Hemisphere in Free Decay                                             | Ellipsoid                                                            |
+----------------------------------------------------------------------+----------------------------------------------------------------------+
| |wigley|                                                             | |gbm|                                                                |
| Wigley Ship Hull                                                     | Barge with Four Flexible Body Modes                                  |
+----------------------------------------------------------------------+----------------------------------------------------------------------+
| |wec3|                                                               | |oc6p1|                                                              |
| Wave Energy Converter Control Competition (WECCCOMP) Wavestar Device | OC6 Phase I DeepCwind Floating Semisubmersible                       |
+----------------------------------------------------------------------+----------------------------------------------------------------------+