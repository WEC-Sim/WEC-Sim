.. _dev-library:

WEC-Sim Library
===============

The WEC-Sim Library is in the ``$WECSIM/source/lib`` directory, and includes the following files:

=========================   	================================== 	
**Simulink Library**            	**File name**         			
WEC-Sim Library    		``WECSim_Lib.slx``    			
Frames Sublibrary		``WECSim_Lib_Frames.slx``		
Body Elements Sublibrary	``WECSim_Lib_Body_Elements.slx``	
Constraints Sublibrary	    	``WECSim_Lib_Constraints.slx``		
PTOs Sublibrary	   	    	``WECSim_Lib_PTOs.slx``			
Cables Sublibrary		``WECSim_Lib_Cables.slx``		
Moorings Sublibrary	    	``WECSim_Lib_Moorings.slx``		
=========================   	================================== 	

GitHub tracks when a change is made to a binary file (e.g. ``*.slx``), but not the specific revisions made. 
This makes tracking revisions to the WEC-Sim Library more challenging than revisions to text files (e.g. ``*.m``). 
The WEC-Sim Library is saved as a `Custom Simulink Library <https://www.mathworks.com/help/simulink/ug/creating-block-libraries.html>`_ with sublibaries.
To ensure backwards compatibility, a `Forwarding Table <https://www.mathworks.com/help/simulink/ug/make-backward-compatible-changes-to-libraries.html>`_ is used. 



.. _dev-library-format:

Formatting 
-----------
Please format the color of library blocks according to their function:

=========================   	================================== 	
**Library Function**            **Color**         			
Input				Green
Output				Red
From Workspace			Yellow
Simulink Function		Orange
Subsystem			Gray
Linked Block			Light Blue
=========================   	================================== 	

.. figure:: /_static/images/dev/library_format.png
    :align: center
    :width: 400pt
    
    WEC-Sim Library blocks with color formatting 
  	


.. _dev-library-development:

Library Development
----------------------
When masks are modified, Simulink executes the mask initialization code. If Simulink does not have access to the WEC-Sim objects in the Simulink workspace, Simulink will throw an error message and would not allow any changes.

In order to modify blocks masks the variable being modified must be accesible to Simulink's workspace. This can be acheived by running any ``wecSimInputFile.m`` script without executing WEC-Sim. Running the ``wecSimInputFile.m`` script populates the MATLAB worskpace with the pertinent data objects using WEC-Sim's class definitions. This enables the block masks to have access to the properties and methods for the pertinent class (e.g., ``bodyClass``, ``waveClass`` etc.).

Simulink then executes each block mask's initialization code before accepting any changes. Some of the WEC-Sim library blocks auto-generate additional blocks based on the ``wecSimInputFile.m`` script. To ensure that the library block auto-generates such blocks only when WEC-Sim is run, make sure to delete the auto-generated blocks before saving the modified block to the WEC-Sim library. 
     
.. Note::
	This is especially important for the Wave Markers and for B2B   

.. _dev-sim-funcs:

Simulink Functions
------------------
Whenever a Simulink Function is called from the WEC-Sim Library, save the function to the ``$WECSIM/source/simulink/functions`` directory. 
This allows revisions to Simulink Functions to be more easily tracked by Git. 
Simulink Model Functions should be saved to the ``$WECSIM/source/functions/simulink/model`` directory. 
Simulink Mask Functions should be saved to the ``$WECSIM/source/functions/simulink/mask`` directory. 
Refer to the :ref:`dev-library-format` section for details on block color formatting.


The ``$WECSIM/source/functions/simulink/model`` directory contains functions called by the Simulink model during runtime. 
These functions implement physics equations such as calculation of the irregular excitation force or the radiation damping convolution integral. These functions greatly affect the accuracy of WEC-Sim.
Whereas the functions in the ``$WECSIM/source/functions/simulink/mask`` directory are only used in preprocessing when running WEC-Sim from Simulink, refer to Run from Simulink :ref:`dev-run-sim-lib`.

.. _dev-run-sim:

Run from Simulink
---------------------
The :ref:`user-advanced-features-simulink` feature allows users to initialize WEC-Sim from the command window and then run the simulation directly from Simulink. 
This feature allows greater compatibility with other models or hardware-in-the-loop simulations.

Internally, the Run From Simulink functionality differs from executing the ``wecSim`` command by how the input file is run. 
The ``wecSim`` command begins by running the ``wecSimInputFile`` in the current directory and continuing with the pre-processing steps. 
Run From Simulink differs by either:

  * Running the input file selected in the Global Reference Frame (when the ``Input File`` option is selected)   
  * Writing and then running a new input file ``wecSimInputFile_customParameters.m`` (when the Global Reference when the ``Custom Parameters`` option is selected)
   

.. _dev-run-sim-custom:

Custom Parameters
^^^^^^^^^^^^^^^^^^^
WEC-Sim allows users to define input file parameters inside Simulink block masks. 
When using the ``Custom Parameters`` setting, users can both load an input file into the block masks and write an block masks to an input file.
This feature was created so that users have a written record of case parameters utilized during a simulation run from Simulink.

The mask of each library block allows users to define a subset of possible input parameters that would be defined in the ``wecSimInputFile``. 
The values that a user inputs to a block are stored as mask parameters. 
When a block mask is accessed, a prompt similar to the figure below appears:

.. figure:: /_static/images/dev/mask_user_grf.png
    :align: center
    :width: 400pt
    
    Simulation class parameters defined in the Global Reference Frame.

Turning on certain flags may change the visibility of other parameters. 
For example, the wave type will affect which wave settings are visible to a user:

.. figure:: /_static/images/dev/mask_user_grf_waveOptions.png
    :align: center
    :width: 400pt

    Wave class parameters defined in the Global Reference Frame. Visibility changes based on the selected wave type,

The spectrum type, frequency discretization and phase seed are not used for regular waves, so they are no visible. 
Similarly, a visibility-flag relation is present for each body's Morison element options, nonhydro body parameters, etc. 
Having a flag change the visibility of options that cannot be used may help new users understand the interdependence of input parameters.

.. Note::
	To decrease the burden of maintaining these masks, only the most common input file parameters can be defined in Simulink. 
	For example, the Global Reference Frame contains simulationClass parameters such as ``mode``, ``explorer``, ``solver``, time information, and state space flags. 
	However less common parameters such as ``mcrMatFile``, ``saveStructure``, ``b2b`` and others are not included. 
	

.. _dev-run-sim-lib:

Library Masks
^^^^^^^^^^^^^^^^^^^^
In order to maintain the functionality of the :ref:`user-advanced-features-simulink` feature, the WEC-Sim Library must be updated when new features are added.
Developers may add additional options using the below instructions.

WEC-Sim is developed as a class based software. 
This results in a complex interplay between the class variables and those defined in the block masks. 
The difficult and complex part of this feature comes from three aspects:

    * Changing parameter visibility based on a flags value (``callbacks``)    
    * Writing an input file from mask parameters (``writeInputFromBlocks``, ``writeLineFromVar``)    
    * Writing block parameters when loading an input file (``writeBlocksFromInput``)

Each of these items will be addressed in this section, but first an overview of the mask set-up is given. 
It is recommended that developers review Mathworks `Simulink.MaskParameter <https://www.mathworks.com/help/simulink/slref/simulink.maskparameter-class.html>`_ documentation before preceding with edits to this advanced feature. 

When masks are modified, Simulink executes the mask initialization code. If Simulink does not have access to the WEC-Sim objects in the Simulink workspace, Simulink will throw an error message and would not allow any changes.
To modify blocks masks,

     * Before modifying a block mask, the variable being modified should be accesible to Simulink's workspace. This can be acheived by making sure that the ``source`` folder in the WEC-Sim directory is added to MATLAB path, and running any available ``wecSimInputFile.m`` script without running WEC-Sim. Running the ``wecSimInputFile.m`` script populates the MATLAB worskpace with the pertinent data objects using WEC-Sim's class definitions. This enables the block masks to have access to the properties and methods for the pertinent class (e.g., ``bodyClass``, ``waveClass`` etc.).
     * Simulink executes each block mask's initialization code before accepting any changes. Some of the WEC-Sim library blocks auto-generate additional blocks based on the ``wecSimInputFile.m`` script. To ensure that the library block auto-generates such blocks only when WEC-Sim is run, make sure to delete the auto-generated blocks before saving the modified block to the WEC-Sim library. 
     
.. Note::
	This is especially important for the Wave Markers and for B2B   .

Mask Structure
""""""""""""""
Each block mask first contains the ``number`` as in historical WEC-Sim set-up; 
``body(1)``, ``pto(2)``, ``constraint(1)``, etc. Next there is a string 
that clarifying that no custom parameters on shown when the ``Global Reference 
Frame`` is set to use an input file. A folder than contains all custom 
parameters within tabs.

.. figure:: /_static/images/dev/mask_dev_body.png
    :align: center
    :width: 400pt

Within the custom parameters folder are various tabs. The first tab contains 
parameters not within a class structure. Additional tabs are organized based 
on what class structures are used. For example all parameters within the 
``body(i).morisonElement`` structure are under the morisonElement tab, 
``body(i).initial`` under the tab, etc. This method of placing class
structures into tabs helps organize the mask and write parameters to the input 
file.


Parameter Specifics
"""""""""""""""""""

Each mask parameter has certain properties (``name``, ``value``, ``prompt``, ``type``), 
attributes, and dialog options (``visible``, ``callback``) that must be properly 
defined:

.. figure:: /_static/images/dev/mask_dev_grf.png
    :align: center
    :width: 400pt
    

**Properties**

The properties of a mask parameter define the ``name``, ``value``, ``type`` and 
user-facing ``prompt``. The mask name must be *identical* to the name of the 
corresponding class property. This is essential to easily writing/reading an 
input file to/from the mask. The defaults of each parameter should be the same 
as the corresponding class property.

Parameters with a distinct set of values (flags, wave types, etc) should be of 
Type ``popup`` to limit users and more easily use callbacks dependent on their 
values. Use ``checkbox`` not ``popup`` for flags that take values of ``on, off``
(such as ``pto(i).lowerLimitSpecify``. Other parameters are typically of Type 
``edit`` to allow flexible user input.

**Attributes**

In general, most parameters should not be read only or hidden, and should be 
saved. One exception to this is the Global Reference Frame parameters ``waves``
and ``simu`` which identify the block in the workspace when reading/writing 
input files.

**Dialog**

The dialog options are primarily used to change a parameter's visibility, 
tooltip and define a callback function. A tooltip defines a string that 
appears when a user hovers on a parameter. This can be useful to provide 
additional context that is too long for the prompt. 
A parameter's callback functions run whenever the value is updated. In WEC-Sim,
mask callbacks are typically used to with flag parameters to update the 
visibility of other parameters:

====================== ====================================== ==========
Block / class           Mask parameter                         Callback
====================== ====================================== ==========
PTO, constraint, cable  upperLimitSpecify, lowerLimitSpecify   ``hardStopCallback``
Body                    STLButton                              ``stlButtonCallback``
Body                    H5Button                               ``h5ButtonCallback``
Body                    nonHydro, (morisonElement.) on         ``bodyClassCallback``
====================== ====================================== ==========

A specific variable's callbacks are defined in: 
``BLOCK/Mask Editor/Parameters & Dialog/PARAMETER/Property editor/Dialog/Callback/``.
For more information about the callback functions refer to :ref:`dev-sim-funcs` and :ref:`dev-run-sim-callback`.


.. _dev-run-sim-callback:

Callback Functions
""""""""""""""""""
All callbacks and other functions used in Simulink masks for the Run From 
Simulink feature are stored as ``*.m`` files in the 
``$WECSIM/source/functions/simulink/mask/`` directory, refer to :ref:`dev-sim-funcs`.


WEC-Sim callback functions can be split into several categories by their use:

===================== ======================================
Category               Functions
===================== ======================================
Button callbacks       ``inFileButtonCallback.m``, ``etaButtonCallback.m``, ``spectrumButtonCallback.m``, ``h5ButtonCallback.m``, ``stlButtonCallback.m``, ``loadInputFileCallback.m``, etc
Visibility callbacks   ``hardStopCallback.m``, ``waveClassCallback.m``, ``bodyClassCallback.m``, ``customVisibilityCallback.m``, ``inputOrCustomCallback.m``, etc
===================== ======================================

**Visibility callbacks** 

Visibility callbacks are used with flag parameters to update the visibility of 
available options. For example, if ``body(i).morisonElement.on=0``, then a user
is not able to define ``body(i).morisonElement.cd, .ca,`` etc. 
The visibility callbacks function by checking the value of a flag:

.. code-block:: matlabsession

    >> mask = Simulink.Mask.get(bodyBlockHandle)
    >> meParam = mask.getParameter('on')
    >> nonHydroParam = mask.getParameter('nonHydro')


Depending on the value of a flag, the visibility of individual variables or an 
entire tab can be changed:

.. code-block:: matlabsession

    >> meTab = mask.getDialogControl('morisonElement');
    >> if nonHydroParam.value >= 1
    >>     centerGravityParam.Visible = 'on';
    >>     centerBuoyancyParam.Visible = 'on';
    >> else
    >>     centerGravityParam.Visible = 'off';
    >>     centerBuoyancyParam.Visible = 'off';
    >> end
    >> 
    >> if meParam.value >= 1
    >>     meTab.Visible = 'on';
    >> else
    >>     meTab.Visible = 'off';
    >> end


This method is also how the Global Reference Frame turns off all custom 
parameters when it is set to use an input file. In this case,  
``inputOrCustomCallback`` is used. When a new class is created, developers must 
add the class variable (``body, simu, etc``) into the list checked in 
``inputOrCustomCallback``. This list is necessary to ensure that Simulink 
models can contain non-WEC-Sim blocks without error.

**Button callbacks** 

Button callback typically open a file explorer and allow users to select 
a given file. These buttons allow wave spectrum, wave elevation, body h5 or 
body STL files, etc to be defined in the mask. These callbacks use the MATLAB
command ``uigetfile()`` and then set the correct mask value based if a valid 
file is selected.

.. code-block:: matlabsession

    >> [filename,filepath] = uigetfile('.mat');
    >> 
    >> % Don't set value if no file is chosen, or prompt canceled.
    >> if ~isequal(filename,0) && ~isequal(filepath,0)
    >>     mask = Simulink.Mask.get(bodyBlockHandle)
    >>     fileParam = mask.getParameter('spectrumFile ')
    >>     fileParam.value = [filepath,filename];
    >> end


.. _dev-run-sim-input-mask:

Writing Input File from Mask
""""""""""""""""""""""""""""

WEC-Sim writes an input file from mask parameters using the functions ``writeInputFromBlocks`` and ``writeLineFromVar``. 
WEC-Sim scans the open Simulink file for all blocks, and reorders them based on the typical input file
order: ``simu``, ``waves``, ``body``, ``constraint``, ``pto``, ``cable``, ``mooring``. 
WEC-Sim also creates default copies of each class. 
All mask variables are looped through and written to ``wecSimInputFile_simulinkCustomParameters`` using the function ``writeLineFromVar``. 
This function takes in a default class, variable name, mask value, number and structure value. 
For example, in the body class:

.. code-block:: matlabsession

    >> writeLineFromVar(body, 'option', maskVars, maskViz, num, 'morisonElement');

This function allows WEC-Sim to easily compare the mask value with the default, 
assign variables to a certain class number and structure. Checking a mask value 
against the class default keeps the new input file clean and easy to read. It is
critical that any mask parameter written with this function is named 
identically to its class counterpart. It returns a string to 
``writeInputFromBlocks`` that is immediately written to the input file. As of 
now, developers must manually add a line to print a new mask parameter to 
the input file.


.. _dev-run-sim-mask-input:

Writing Mask Parameters from Input File
"""""""""""""""""""""""""""""""""""""""

WEC-Sim loads mask parameters from an input file using the function 
``writeBlocksFromInput``. This function is called by ``loadInputFileCallback`` 
in the ``Global Reference Frame``. This function loops through all blocks in 
the Simulink model. Within each block, the chosen input file is run. Values of 
each class variables are assigned directly to the mask value. The default is 
not checked in this instance, as the mask cannot be cleaned up in the same 
method as the input file. 

When creating a new class, developers must manually 
add a value to the `'type'` flag in ``loadInputFileCallback``. This ensures that 
the mask variables are set with the correct WEC-Sim class, i.e.:

.. code-block:: matlabsession

    >> maskVar. ... = body(1). ...;
    >> maskVar. ... = pto(2). ...;
    >> maskVar. ... = cable(3). ...;
    

Developers must also edit each case of ``writeBlocksFromInput`` when creating 
a new mask parameter or renaming a class property.


.. _dev-run-sim-summary:

Summary
"""""""

**To create or rename a mask parameter**

1. Change the mask parameter name and default value in Simulink
2. If tied to a flag, update callbacks to hide/show the parameter
3. Update ``writeInputFromBlocks`` and ``writeBlocksFromInput`` with the new parameter 
   name

**Creating a new class or block**

1. Setup the mask parameter structure described above, or copy from another block 
   in that class:
   
   .. code-block:: matlabsession
       
       >> pSource = Simulink.Mask.get(srcBlockName)
       >> pDest = Simulink.Mask.create(destBlockName)
       >> pDest.copy(pSource)

2. Ensure that ``inputOrCustomCallback`` functions correctly to hide/show all custom
   parameters depending on the ``Global Reference Frame`` setting.
   
3. If tied to a flag, update callbacks to hide/show parameters.

4. Permanently hide any parameters not used in that class (e.g. 
   6DOF Constraint does not have end stops, so that tab is not visible)

5. Create new ``writeInputFromBlocks`` and ``writeBlocksFromInput`` sections
   to tie the block mask to an input file.

.. Note::
    * Mask parameters should always have the same name as the corresponding 
      class property
    * All mask parameters should have the ability to write to an input file and
      load from Simulink
      
      
.. _dev-merge-tool:

MATLAB Merge Tool
------------------
It is recommended that developers use the `MATLAB Merge Tool <https://www.mathworks.com/help/simulink/ug/customize-external-source-control-to-use-matlab-for-comparison-and-merge.html>`_ to compare library versions when there are merge conflicts. 
The MATLAB Merge Tool allows users to compare changes directly in Simulink.
The merge tool will open a special Simulink GUI that allows users to compare code versions both textually and within the block diagram. 
To use the tool, merge both branches locally and resolve any conflicts using the merge tool. 

For example, take the branches ``<dev>`` and ``<new_feature>`` that each contain new WEC-Sim features. 
In the Git for Windows command line, these changes can be merged using::
    
    # Checkout the <dev> branch and pull the latest
    git checkout <dev>
    git pull <remote>/<dev>
    
    # Merge <new_feature> branch into <dev> branch
    git merge <new_feature>
    
    # Resolve library conflicts using the MATLAB merge tool
    git mergetool -t mlMerge source/lib/WEC-Sim/<library_file>.slx
    
    # Save desired revisions, then add and commit changes
    git add source/lib/WEC-Sim/<library_file>.slx
    git commit -m 'merge <dev> with <new_feature>'          
