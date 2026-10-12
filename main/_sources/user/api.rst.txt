.. _user-api:

API
===

.. _simulation:

Simulation Class
------------------

.. autoclass:: objects.simulationClass
	:members:
	:exclude-members: simulationClass, caseDir, numCables, numConstraints, numDragBodies, numHydroBodies, numMoorings, numPtos, numPtoSim, time, caseFile, cicLength, cicTime, date, gitCommit, maxIt, outputDir, wsVersion, checkInputs, setup, listInfo, loadSimMechModel, rhoDensitySetup, getGitCommit
	:no-undoc-members: 
    

.. _wave:

Wave Class
------------------

.. autoclass:: objects.waveClass
    :members: 
    :exclude-members: waveClass, amplitude, deepWater, dOmega, omega, phase, power, spectrum, type, typeNum, waveAmpTime, waveAmpTimeViz, wavenumber, checkInputs, setup, listInfo, calculateElevation, waveElevationGrid
    :no-undoc-members:    


.. _body:

Body Class
------------------

.. autoclass:: objects.bodyClass
    :members:
    :exclude-members: bodyClass, dofEnd, dofStart, hydroData, b2bDOF, hydroForce, massCalcMethod, number, total, geometry, checkInputs, listInfo, loadHydroData, nonHydroForcePre, dragForcePre, hydroForcePre, adjustMassMatrix, restoreMassMatrix, storeForceAddedMass, forceAddedMass, importBodyGeometry, triArea, checkStl, triCenter, setNumber, setDOF
    :no-undoc-members:
    
.. _constraint:

Constraint Class
------------------

.. autoclass:: objects.constraintClass
    :members:
    :exclude-members: constraintClass,number, checkLoc, setOrientation, listInfo, setNumber
    :no-undoc-members:

.. _ptoAPI:

PTO Class
------------------

.. autoclass:: objects.ptoClass
    :members:
    :exclude-members: ptoClass, number, checkLoc, setOrientation, listInfo, setPretension, setNumber
    :no-undoc-members:

.. _mooringAPI:

Mooring Class
-------------

.. autoclass:: objects.mooringClass
	:members: 
	:exclude-members: mooringClass, orientation, number, listInfo, setLoc, setNumber
	:no-undoc-members:

.. _cableAPI:

Cable Class
-------------

.. autoclass:: objects.cableClass
	:members:
	:exclude-members: cableClass, number, location, volume, setTransPTOLoc, checkLoc, setOrientation, setVolume, dragForcePre, linearDampingMatrix, setCb, setLength, listInfo, setNumber

.. _response:

Response Class
------------------

.. autoclass:: objects.responseClass
    :members:
    :exclude-members: responseClass, bodies, cables, constraints, moorDyn, mooring,  ptos, ptosim, wave, loadMoorDyn, saveText
    :no-undoc-members:
    
