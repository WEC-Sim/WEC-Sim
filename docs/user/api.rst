.. _user-api:

API
===

.. _body:

Body Class
------------------

.. autoclass:: objects.bodyClass
    :members:
    :exclude-members: hydroData, bodyGeometry, hydroForce, h5File, hydroDataBodyNum, massCalcMethod, bodyNumber, bodyTotal, lenJ, hydroForcePre, adjustMassMatrix, restoreMassMatrix, storeForceAddedMass, setInitDisp, bodyGeo, triArea, bodyGeo, triArea, triCenter, rotateXYZ, verts_out, offsetXYZ
    :no-undoc-members:
    
.. _constraint:

Contstraint Class
------------------

.. autoclass:: objects.constraintClass
    :members:
    :exclude-members: constraintNum
    :no-undoc-members:

.. _mooringAPI:

Mooring Class
-------------

.. autoclass:: objects.mooringClass
	:members:
	:exclude-members: listInfo
	:no-undoc-members:

.. _ptoAPI:

PTO Class
------------------

.. autoclass:: objects.ptoClass
    :members:
    :exclude-members: ptoNum
    :no-undoc-members:
    
.. _response:

Response Class
------------------

.. autoclass:: objects.responseClass
    :members:
    :exclude-members: wave, bodies, ptos, constraints, mooring 
    :no-undoc-members:

.. _simulation:

Simulation Class
------------------

.. autoclass:: objects.simulationClass
	:members:
	:exclude-members: listInfo, getWecSimVer
	:no-undoc-members: 
    
.. _wave:

Wave Class
------------------

.. autoclass:: objects.waveClass
    :members: 
    :exclude-members: typeNum, bemFreq, deepWaterWave, waveAmpTime, waveAmpTime1, waveAmpTime2, waveAmpTime3, waveAmpTimeViz, A, w, phase, dw, k, S, Pw, waveClass, waveSetup, listInfo, waveNumber, checkinputs, waveElevationGrid
    :no-undoc-members:    



