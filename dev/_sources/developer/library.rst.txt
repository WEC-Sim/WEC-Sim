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
