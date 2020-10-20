.. WEC-Sim Documentation

.. figure:: _images/wec_sim_header.png
   :target: https://github.com/WEC-Sim/WEC-Sim


.. toctree::
   :maxdepth: 4
   :hidden:

   getting_started.rst
   overview.rst
   theory.rst
   code_structure.rst   
   tutorials.rst
   advanced_features.rst
   webinars.rst   
   license.rst
   acknowledgements.rst
   publications.rst
   release_notes.rst
   contact.rst
   api.rst
   terminology.rst

.. Note:: 
	Adam:
	I agree with many of Mat's comments on this page. I think that this section might be better off merged with the getting started page and labeled 'Introduction to WEC-Sim'. It can include some examples of WEC-Sims ability and more details to draw users in. What can WEC-Sim simulate? What does a user require to run it? (qualitative overview, not the same technical details and file types in the overview section) Draw users/developers in and introduce them to WEC-sims extensive capabilities

	Other issues:
	- it doesn't appear on the TOC on the left of the webpage,
	- it appears as Ch. 17 in the compiled pdf, not at the beginning
	- In the pdf, the list of authors in the title page runs off the page


######################################################
WEC-Sim (Wave Energy Converter SIMulator) 
######################################################
`WEC-Sim (Wave Energy Converter SIMulator) <https://github.com/WEC-Sim/WEC-Sim>`_ is an open-source code for simulating wave energy converters. The code is developed in MATLAB/SIMULINK using the multi-body dynamics solver Simscape Multibody. WEC-Sim has the ability to model devices that are comprised of rigid bodies, joints, power take-off systems, and mooring systems. Simulations are performed in the time-domain by solving the governing wave energy converter equations of motion in 6 degrees-of-freedom. 

.. Note:: 
	Adam:
	WEC-Sim is no longer restricted to rigid bodies with the addition of the GBM feature

.. _developers:

WEC-Sim Developers
=====================
WEC-Sim is a collaboration between the `National Renewable Energy Laboratory (NREL) <http://www.nrel.gov/water/>`_ and `Sandia National Laboratories (Sandia) <http://energy.sandia.gov/energy/renewable-energy/water-power/>`_, funded by the U.S. Department of Energy’s Water Power Technologies Office. Due to the open source nature of the code, WEC-Sim  has also had many external contributions, for more information refer to  :ref:`acknowledgements`. 
    
* Yi-Hsiang Yu (NREL - PI)
* Kelley Ruehl (Sandia - PI)
* Jennifer Van Rij (NREL)
* Nathan Tom (NREL)
* Dominic Forbush (Sandia)
* David Ogden (NREL)



Funding
================
Development and maintenance of the WEC-Sim code is funded by the U.S. Department of Energy’s Water Power Technologies Office. WEC-Sim code development is a collaboration between the National Renewable Energy Laboratory and Sandia National Laboratories.

The National Renewable Energy Laboratory is a national laboratory of the U.S. Department of Energy, Office of Energy Efficiency and Renewable Energy, operated by the Alliance for Sustainable Energy, LLC. under contract No. DE-AC36-08GO28308.

Sandia National Laboratories is a multi-mission laboratory managed and operated by National Technology and Engineering Solutions of Sandia, LLC., a wholly owned subsidiary of Honeywell International, Inc., for the U.S. Department of Energy’s National Nuclear Security Administration under contract DE-NA0003525.

.. Note:: 
	Adam:
	This information is repeated from the acknowledgements section.



.. Indices and tables
.. ========================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`