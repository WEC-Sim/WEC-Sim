
.. note::
    Along a similar theme, I think this section tries to do too much and, 
    therefore doesn't really achieve anything well. The application programming 
    interface `"defines interactions between multiple software intermediaries" 
    <https://en.wikipedia.org/wiki/Application_programming_interface>`_, and 
    your intermediaries here are the end-user and Simulink. Thus, this needs 
    to be a user experience (i.e. Useful, Usable, Findable, Credible, Desirable 
    Accessible and Valuable) and, at the same time, document the interface to 
    Simulink, which is more focussed on the developer, rather than the user. It 
    isn't super clear in here what is user focussed and additionally there's no 
    easy way to trace which documentation belongs to the methods called in 
    Simulink (because information about which classes the methods are called on 
    is missing). It would be much easier to trace what code is being called in 
    Simulink if they were just functions, in this case, which again calls in to 
    question the choice of using classes in the architecture. 
    
    For this piece of documentation, I think it should focus on interactions 
    with the user, therefore properties and methods that are consumed by 
    Simulink or in the main function shouldn't be included. Also, improving the 
    introductions to the classes by explaining their purpose better and 
    integrating the constructor documentation, rather than it being documented 
    as a separate method would be useful. Additionally, because these classes 
    need configured, some pointers as to which parameters must be set, would be 
    helpful, IMO. 
    
    For now, everything else can be documented inside the code and marked as 
    private using the exclude-members directive (although some of the docs are 
    not readable in the source code, because each sentence is on a line again, 
    and the current choice of members listed in the exclude-members directive 
    seems to be without any logic that I can extract). You could then build a 
    developer API to explain the other methods and properties in the classes, 
    but a lot of other documentation would be required to explain how 
    everything works together, particularly the relationship to Simulink and 
    what data it generates. In any case, these classes have some serious 
    `temporal coupling 
    <https://www.pluralsight.com/tech-blog/forms-of-temporal-coupling/>`_, 
    issues, generally considered as bad class design. Polymorphic 
    subclasses would help for the user setting up different sub-entities, but 
    that is on the user focussed side, and I suspect there are a number of 
    other temporal couplings with Simulink that again point towards functions 
    being a more appropriate choice of container. 
    
    Finally, the wave class is documented differently to the other classes
    because it's methods are called at the top level using automethod, rather
    than included as members of the class.

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

.. _mooring:

Mooring Class
-------------

.. autoclass:: source.objects.mooringClass
	:members:
	:exclude-members: listInfo
	:no-undoc-members:

.. _pto:

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
