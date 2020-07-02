.. _api:

WEC-Sim API
===========

.. _body:

Body Class
------------------

.. autoclass:: source.objects.bodyClass
    :members:
    :exclude-members: hydroData, bodyGeometry, hydroForce, h5File, hydroDataBodyNum, massCalcMethod, bodyNumber, bodyTotal, lenJ, hydroForcePre, adjustMassMatrix, restoreMassMatrix, storeForceAddedMass, setInitDisp, bodyGeo, triArea, bodyGeo, triArea, triCenter, rotateXYZ, verts_out, offsetXYZ
    :no-undoc-members:
    
.. _constraint:

Contstraint Class
------------------

.. autoclass:: source.objects.constraintClass
    :members:
    :exclude-members: constraintNum
    :no-undoc-members:

.. _mooringAPI:

Mooring Class
-------------

.. autoclass:: source.objects.mooringClass
	:members:
	:exclude-members: listInfo
	:no-undoc-members:

.. _ptoAPI:

PTO Class
------------------

.. autoclass:: source.objects.ptoClass
    :members:
    :exclude-members: ptoNum
    :no-undoc-members:
    
.. _response:

Response Class
------------------

.. autoclass:: source.objects.responseClass
    :members:
    :exclude-members: wave, bodies, ptos, constraints, mooring 
    :no-undoc-members:

.. _simulation:

Simulation Class
------------------

.. autoclass:: source.objects.simulationClass
	:members:
	:exclude-members: listInfo, getWecSimVer
	:no-undoc-members: 
    
.. _wave:

Wave Class
------------------

.. autoclass:: source.objects.waveClass
    :members: type, T, H, spectrumType, gamma, phaseSeed, spectrumDataFile, etaDataFile, freqRange, numFreq, waveDir, waveSpread, viz, statisticsDataLoad, freqDisc, wavegauge1loc, wavegauge2loc, wavegauge3loc, currentSpeed, currentDirection, currentOption, currentDepth
    :no-undoc-members:    

.. automethod:: source.objects.waveClass.waveClass

.. automethod:: source.objects.waveClass.plotEta

.. automethod:: source.objects.waveClass.plotSpectrum


.. automethod:: source.objects.waveClass.waveSetup
.. automethod:: source.objects.waveClass.listInfo

.. automethod:: source.objects.waveClass.waveNumber

.. automethod:: source.objects.waveClass.checkinputs

.. automethod:: source.objects.waveClass.write_paraview_vtp

.. automethod:: source.objects.waveClass.waveElevationGrid


.. The waveClass API documents public properties and methods only, we should probably add private as well
