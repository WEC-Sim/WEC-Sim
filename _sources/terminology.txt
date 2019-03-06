.. _terminology:

Terminology
===========


.. Note:: 
	This section is a work in progress, * means may not be used in WEC-Sim doc


================== ==========================================
Term               Definition
================== ==========================================
Added Mass         :math:`A(\omega)`
BEM	           Boundary Element Method
BEMIO              Boundary Element Method Input/Output
BS                 Bretschneider Wave Spectrum
``$CASE``          WEC-Sim case directory
Heave (Z)          Motion along the Z-axis
JS                 JONSWAP Spectrum
Pitch (RY)         Rotation about the Y-axis
PM                 Pierson-Moskowitz Specturm
PTO                Power Take-Off
Radiation Damping  :math:`B(\omega)`
Roll (RX)          Rotation about the X-axis
``$SOURCE``        WEC-Sim source code directory
Surge(x)           Motion along the X-axis
Sway (Y)           Motion along the Y-axis
Wave Excitation    :math:`F_{exc}`
Yaw (RZ)           Rotation about the Z-axis	
================== ==========================================


Variables
---------
======================= ===================================================
Variable       	 	Definition
======================= ===================================================
:math:`A` 	 	Wave amplitude (m), half of the wave height (m)
:math:`A(\omega)`	Frequency dependent radiation added mass
:math:`B(\omega)`	Frequency dependent radiation wave damping
:math:`\beta`		Wave direction (Degrees) 
:math:`\eta` 		Incident wave (m)
:math:`f` 		Wave frequency (Hz)
:math:`F_{B}` 		Net buoyancy restoring force (N) or torque (N.m)
:math:`F_{exc}` 	Wave excitation force (N) or torque (N.m)
:math:`F_{rad}`		Wave radiation force (N) or torque (N.m)
:math:`F_{PTO}`		Power take-off force (N) or torque (N.m)
:math:`F_{ME}`		Morison element force (N) or torque (N.m)
:math:`F_{v}`		Damping or friction force (N) or torque (N.m)
:math:`F_{m}`		Mooring connection force (N) or torque (N.m)
:math:`g` 		Gravity
:math:`H` 		Wave height (m)
:math:`H_{s}`		Significant wave height, mean wave height of the tallest third of waves (m)
:math:`H_{m0}`		Spectrally derived significant wave height (m)
:math:`k` 		Wave number
:math:`K_{hs}` 		linear hydrostatic restoring coefficient
:math:`m` 		Mass of body (kg)
:math:`m0`		Spectral moment
:math:`\omega` 		Wave frequency (rad/s)
:math:`\phi` 		Wave phase (rad)
:math:`R_{f}` 		Ramp function 
:math:`\rho` 		Water density (kg/m3)
:math:`t`  		Simulation time (s)
:math:`T_{e}` *		Energy period (s)
:math:`T_{p}` 		Peak period (s)
:math:`t_{r}` 		Ramp time (s)
======================= ===================================================
