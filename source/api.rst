.. _api:

WEC-Sim API
===========



.. _response:

Response Class
------------------

.. autoclass:: source.objects.responseClass
    :members:
    :exclude-members: wave, bodies, ptos, constraints, mooring 
    :no-undoc-members:


Wave Class
------------------

.. autoclass:: source.objects.waveClass
    :members: type
    :undoc-members:
    
    .. automethod:: source.objects.waveClass.plotSpectrum
	
	
testing Wave Class
------------------

.. autoclass:: source.objects.waveClass
    
	.. autoattribute:: source.objects.waveClass.type
	
	.. automethod:: source.objects.waveClass.plotSpectrum


testing
---------

Class definition and optional signature

.. class:: source.objects.responseClass()

Reference

:class:`source.objects.responseClass`


Attribute
.. attribute:: source.objects.responseClass.wave


Not working... 

.. automodule:: source.objects

.. module:: source.objects



testing Response Class
-----------------------

.. autoclass:: source.objects.responseClass

	.. autoattribute:: source.objects.responseClass.wave
	
	.. automethod:: source.objects.responseClass.plotResponse
