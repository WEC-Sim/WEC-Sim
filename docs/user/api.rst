.. _user-api:

API
===

.. _simulation:

Simulation Class
------------------

.. autoclass:: objects.simulationClass
	:members:
	:exclude-members: wsVersion, gitCommit, date, outputDir, time, inputFile, logFile, caseFile, caseDir, cicLength, maxIt, cicEndTime, numHydroBodies, numDragBodies, numPtos, numConstraints, numCables, numMoorings, listInfo, getWecSimVer, loadSimMechModel, simulationClass, setup, checkinputs, rhoDensitySetup, getGitCommit, simulationClass
	:no-undoc-members: 
    

.. _wave:

Wave Class
------------------

.. autoclass:: objects.waveClass
    :members: 
    :exclude-members: typeNum, bemFreq, deepWater, waveAmpTime, waveAmpTime1, waveAmpTime2, waveAmpTime3, waveAmpTimeViz, A, w, phase, dw, k, S, Pw, waveClass, waveSetup, listInfo, waveNumber, checkinputs, waveElevationGrid
    :no-undoc-members:    


.. _body:

Body Class
------------------

.. autoclass:: objects.bodyClass
    :members:
    :exclude-members: hydroData, geometry, hydroForce, h5File, hydroTotal, massCalcMethod, number, total, dofCoupled, hydroForcePre, adjustMassMatrix, restoreMassMatrix, storeForceAddedMass, setInitDisp, bodyGeo, triArea, bodyGeo, triArea, triCenter, rotateXYZ, verts_out, offsetXYZ, readH5File, loadHydroData, dragForcePre, listInfo, checkStl, checkinputs, forceAddedMass, bodyClass
    :no-undoc-members:
    
.. _constraint:

Contstraint Class
------------------

.. autoclass:: objects.constraintClass
    :members:
    :exclude-members: number, checkLoc, setOrientation, setInitDisp, listInfo, constraintClass
    :no-undoc-members:

.. _ptoAPI:

PTO Class
------------------

.. autoclass:: objects.ptoClass
    :members:
    :exclude-members: number, checkLoc, setOrientation, setInitDisp, listInfo, setPretension, ptoClass
    :no-undoc-members:

.. _mooringAPI:

Mooring Class
-------------

.. autoclass:: objects.mooringClass
	:members:
	:exclude-members: orientation, number, moorDyn, moorDynInputRaw, listInfo, setLoc, setInitDisp, moorDynInput, mooringClass
	:no-undoc-members:

.. _cableAPI:

Cable Class
-------------

.. autoclass:: objects.cableClass
	:members:
	:exclude-members: number, loc, rotloc1, rotloc2, cg1, cb1, cg2, cb2, dispVol, setTransPTOLoc, checkLoc, setOrientation, setDispVol, dragForcePre, linDampMatrix, setCb, setCg, setLoc, setL0 listInfo, cableClass

.. _response:

Response Class
------------------

.. autoclass:: objects.responseClass
    :members:
    :exclude-members: bodies, cables, constraints, moorDyn, mooring,  ptos, ptosim, wave, loadMoorDyn, responseClass
    :no-undoc-members:
    
