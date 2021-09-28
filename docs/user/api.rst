.. _dev-api:

API
===

.. _simulation:

Simulation Class
------------------

.. autoclass:: objects.simulationClass
	:members:
	:exclude-members: wsVersion, gitCommit, simulationDate, outputDir, time, inputFile, logFile, caseFile, caseDir, CIkt, maxIt, CTTime, numWecBodies, numDragBodies, numPtos, numConstraints, numCables, numMoorings, listInfo, getWecSimVer, loadSimMechModel, setupSim, checkinputs, rhoDensitySetup, getGitCommit, simulationClass
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


.. _body:

Body Class
------------------

.. autoclass:: objects.bodyClass
    :members:
    :exclude-members: hydroData, bodyGeometry, hydroForce, h5File, hydroDataBodyNum, massCalcMethod, bodyNumber, bodyTotal, lenJ, hydroForcePre, adjustMassMatrix, restoreMassMatrix, storeForceAddedMass, setInitDisp, bodyGeo, triArea, bodyGeo, triArea, triCenter, rotateXYZ, verts_out, offsetXYZ, readH5File, loadHydroData, dragForcePre, listInfo, checkStl, checkinputs, forceAddedMass, bodyClass
    :no-undoc-members:
    
.. _constraint:

Contstraint Class
------------------

.. autoclass:: objects.constraintClass
    :members:
    :exclude-members: constraintNum, checkLoc, setOrientation, setInitDisp, listInfo, constraintClass
    :no-undoc-members:

.. _ptoAPI:

PTO Class
------------------

.. autoclass:: objects.ptoClass
    :members:
    :exclude-members: ptoNum, checkLoc, setOrientation, setInitDisp, listInfo, setPretension, ptoClass
    :no-undoc-members:

.. _mooringAPI:

Mooring Class
-------------

.. autoclass:: objects.mooringClass
	:members:
	:exclude-members: loc, mooringNum, moorDyn, moorDynInputRaw, listInfo, setLoc, setInitDisp, moorDynInput, mooringClass
	:no-undoc-members:

.. _cableAPI:

Cable Class
-------------

.. autoclass:: objects.cableClass
	:members:
	:exclude-members: cableNum, loc, rotloc1, rotloc2, cg1, cb1, cg2, cb2, dispVol, setTransPTOLoc, checkLoc, setOrientation, setDispVol, dragForcePre, linDampMatrix, setCb, setCg, setLoc, setL0 listInfo, cableClass

.. _response:

Response Class
------------------

.. autoclass:: objects.responseClass
    :members:
    :exclude-members: wave, bodies, ptos, constraints, mooring, cable, loadMoorDyn, responseClass
    :no-undoc-members:
    
