---
title: 'WEC-Sim: the Wave Energy Converter Simulation'
tags:
  - wave energy converters
  - marine energy
  - numerical modeling
  - MATLAB
  - Simulink
authors:
  - name: Kelley Ruehl
    corresponding: true
    orcid: 0000-0002-7379-4206
    equal-contrib: true
    affiliation: 1
  - name: Nathan Tom
    equal-contrib: true
    affiliation: 2
    orcid: 0000-0002-8489-312X
  - name: David Ogden
    equal-contrib: true
    affiliation: 3
  - name: Yi-Hsiang Yu
    equal-contrib: true
    affiliation: 4
  - name: Adam Keester
    equal-contrib: true
    affiliation: 1
    orcid: 0009-0002-8562-6813
  - name: Dominic Forbush
    equal-contrib: true
    affiliation: 1
    orcid: 0000-0001-8994-7257
  - name: Jorge Leon
    equal-contrib: true
    affiliation: 1
  - name: Jeff Grasberger
    equal-contrib: true
    affiliation: 1
    orcid: 0000-0003-3374-6119
  - name: Salman Husain
    equal-contrib: true
    affiliation: 2
affiliations:
 - name: Sandia National Laboratories, Albuquerque, NM, USA
   index: 1
 - name: National Renewable Energy Lab, Golden, CO, USA
   index: 2
 - name: Velocity Global, London, UK
   index: 3
 - name: National Yang Ming Chiao Tung University, Hsinchu, Taiwan
   index: 4
date: 16 May 2022
bibliography: paper.bib

# Summary

WEC-Sim (Wave Energy Converter SIMulator) is an open-source software for simulating wave energy converters. 
The software is developed in MATLAB/SIMULINK using the multi-body dynamics solver Simscape Multibody. 
WEC-Sim has the ability to model devices that are comprised of bodies, joints, power take-off systems, and mooring systems. 
WEC-Sim can model both rigid bodies and flexible bodies with generalized body modes. 
Simulations are performed in the time-domain by solving the governing wave energy converter equations of motion in the 6 Cartesian degrees-of-freedom, plus any number of user-defined modes. 
The WEC-Sim Applications repository contains a wide variety of scenarios that WEC-Sim can be used to model, including desalination, mooring dynamics, nonlinear hydrodynamic bodies, passive yawing, batch simulations and many others. 
The software is flexible and can be adapted to many scenarios within the wave energy industry.

# Statement of need

temp...

# Acknowledgements

Funding to support WEC-Sim is provided by the U.S. Department of Energy, Office of Energy Efficiency and Renewable Energy, Water Power Technologies Office.

This article has been authored by an employee of National Technology & Engineering Solutions of Sandia, LLC under Contract No. DE-NA0003525 with the U.S. Department of Energy (DOE). The employee owns all right, title and interest in and to the article and is solely responsible for its contents. The United States Government retains and the publisher, by accepting the article for publication, acknowledges that the United States Government retains a non-exclusive, paid-up, irrevocable, world-wide license to publish or reproduce the published form of this article or allow others to do so, for United States Government purposes. The DOE will provide public access to these results of federally sponsored research in accordance with the DOE Public Access Plan https://www.energy.gov/downloads/doe-public-access-plan.

This work was authored in part by the National Renewable Energy Laboratory, operated by Alliance for Sustainable Energy, LLC,for the U.S. Department of Energy (DOE) under Contract No. DE-AC36-08GO28308. The views expressed in the article do not necessarily represent the views of the DOE or the U.S. Government. The U.S. Government retains and the publisher, by accepting the article for publication, acknowledges that the U.S. Government retains a nonexclusive, paid-up, irrevocable, worldwide license to publish or reproduce the published form of this work, or allow others to do so, for U.S. Government purposes.


# References