.. _api:

WEC-Sim API
===========

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



.. _response:

Response Class
------------------

.. autoclass:: source.objects.responseClass
    :members:
    :exclude-members: wave, bodies, ptos, constraints, mooring 
    :no-undoc-members:


