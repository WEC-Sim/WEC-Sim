.. _terminology:

Terminology
===========


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
Pitch (Ry)         Rotation about the Y-axis
PM                 Pierson-Moskowitz Specturm
PTO                Power Take-Off
Radiation Damping  :math:`B(\omega)`
Roll (Rx)          Rotation about the X-axis
``$SOURCE``        WEC-Sim source code directory
Surge(x)           Motion along the X-axis
Sway (Y)           Motion along the Y-axis
Wave Excitation    :math:`F_{exc}`
Yaw (Rz)           Rotation about the Z-axis	
================== ==========================================


Variables
---------
======================= ===================================================
Variable       	 	Definition
======================= ===================================================
:math:`A` *	 	Wave amplitude (m), :math:`A = \frac{H}{2}`
:math:`A(\omega)`	Frequency dependent radiation added mass (kg)
:math:`A_{\infty}`	Added mass at infinite frequency (kg)
:math:`B(\omega)`	Frequency dependent radiation wave damping (N/m/s)
:math:`C_{a}` 		Morison element coefficient of added mass
:math:`C_{d}` 		Quadratic drag coefficient
:math:`C_{m}` 		Mooring damping matrix (N/m/s)
:math:`C_{pto}` 	PTO damping coefficient (N/m/s)
:math:`C_{v}` 		Linear (viscous) damping coefficient (N/m/s)
:math:`\eta` 		Incident wave (m)
:math:`f` 		Wave frequency (Hz)
:math:`F_{B}` 		Net buoyancy restoring force (N) or torque (N.m)
:math:`F_{exc}` 	Wave excitation force (N) or torque (N.m)
:math:`F_{rad}`		Wave radiation force (N) or torque (N.m)
:math:`F_{pto}`		Power take-off force (N) or torque (N.m)
:math:`F_{me}`		Morison element force (N) or torque (N.m)
:math:`F_{v}`		Damping or friction force (N) or torque (N.m)
:math:`F_{m}`		Mooring connection force (N) or torque (N.m)
:math:`g` 		Gravity (m/s/s)
:math:`h` 		Water depth (m)
:math:`H` 		Wave height (m)
:math:`H_{s}`		Significant wave height, mean wave height of the tallest third of waves (m)
:math:`H_{m0}`		Spectrally derived significant wave height (m)
:math:`k` 		Wave number (rad/m), :math:`k = \frac{2\pi}{\lambda}`
:math:`K_{hs}` 		Linear hydrostatic restoring coefficient (N/m)
:math:`K_{m}` 		Mooring stiffness matrix (N/m)
:math:`K_{pto}` 	PTO stiffness coefficient (N/m)
:math:`\lambda`		Wave length (m)
:math:`m` 		Mass of body (kg)
:math:`m_k`		Spectral moment of k, for k = 0,1,2,...
:math:`\omega` 		Wave frequency (rad/s), :math:`\omega = \frac{2\pi}{T}`
:math:`\phi` 		Wave phase (rad)
:math:`R_{f}` 		Ramp function 
:math:`\rho` 		Water density (kg/m3)
:math:`t`  		Simulation time (s)
:math:`t_{r}` 		Ramp time (s)
:math:`\theta`		Wave direction (Degrees) 
:math:`T_{e}` *		Energy period (s)
:math:`T_{p}` 		Peak period (s)
:math:`X` 		Translation and rotation displacement vector (m) or (rad)
======================= ===================================================

.. Note:: 
	This section is a work in progress, * means may not be used in WEC-Sim doc
