.. _dev-api:

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
    :members: type, T, H, spectrumType, gamma, phaseSeed, spectrumDataFile, etaDataFile, freqRange, numFreq, waveDir, waveSpread, viz, statisticsDataLoad, freqDisc, wavegauge1loc, wavegauge2loc, wavegauge3loc, currentSpeed, currentDirection, currentOption, currentDepth
    :no-undoc-members:    

.. automethod:: objects.waveClass.waveClass

.. automethod:: objects.waveClass.plotEta

.. automethod:: objects.waveClass.plotSpectrum

.. automethod:: objects.waveClass.waveSetup

.. automethod:: objects.waveClass.listInfo

.. automethod:: objects.waveClass.waveNumber

.. automethod:: objects.waveClass.checkinputs

.. automethod:: objects.waveClass.waveElevationGrid


.. The waveClass API documents public properties and methods only, we should probably add private as well
