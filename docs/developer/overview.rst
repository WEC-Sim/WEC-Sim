.. _dev-overview:

Overview
========

The :ref:`WEC-Sim development team <developers>` 
is currently engaged in continuous code development and support. Efforts are 
made by the development team to improve the code's flexibility, accuracy, and 
usability. The :ref:`dev-getting-started` section describes the development
team's current workflow for users who wish to submit features and ehancements
for consideration. The rest of the developer manual attempts to document specific
complexities and choices made during code development for user's reference. It 
is intended as a reference for users and members of the large development team
when creating new features. This is done in the hopes of creating a sustainable
software that can outlive any possible cease in development efforts.

.. _dev-overview-style:

Formatting & Style Guide
------------------------
There are many different ways to style and format MATLAB code. The development
team believes that choosing a certain style and sticking to it is more important
than the style itself. However, like all parts of open-source software the style 
and formatting are also under iterative and suggestions for improvement are 
welcome.

Currently, WEC-Sim does not contain an automated linter to format proposed 
enhancements. Therefore, it is the responsibility of each contributor to follow 
this style guide. A consistent style will result in a code that is easy to read 
and understand while remaining concise where possible. The same philosophy 
applies to documentation. Detailed style and formatting specifications are 
given here with examples


Documentation
^^^^^^^^^^^^^
The written documentation should follow same guidelines that written code does.
Paragraphs should be written as blocks, while maintaining the 80 character limit.
One common exception to this character-per-line rule is when a long url is used 
it may create a long line. 

TODO

Code
^^^^

Formatting
""""""""""
Code should be limited to 80 characters per line. Use line breaks to prevent code
from running over this limit. This helps keep code readable for most windows sizes
without requiring users to side-scroll, which makes code difficult to read. 

Indents should be four spaces (no tabs). Among other things, functions, if 
statements, for loops, while loops, switch-case statements, try-catch 
statements, and classes should include indentation.

Mathematical operators in WEC-Sim may or may not contain whitespace around them.
It is suggested to wrap ``=, +, -, *, /, \, |, ||, &, &&, <, <=, >, >=, ==`` 
with whitespaces, whereas other operators such ``^, (), [], {}`` do not contain 
wrapped whitespace to make the code more concise and able to be read quickly.
Additionally, this implies the correct order of operation to the reader: 
parantheses and exponents are performed first so they do not contain whitespace,
while multiplication, division, addition and subtraction operators are performed 
last so they contain whitespace.

Do::
    
    x = (a && b) || (c && d);
    y = (3 + 4) * 6^3 - 12 == z;
    n = m ./ r.^2 - [1, 2, 3; 4, 5, 6; 7, 8, 9];


Don't::
    
    x = (a&&b)||(c&&d);
    y = (3+4)*6^3-12==z;
    n = m./r.^2-[1,2,3;4,5,6;7,8,9];
    

Commenting
""""""""""
In general, inline and block comments should not repeat information that variable
names imply. For example, commenting that a line "adds x and y" is unvaluable and
distracting because the line of code itself will imply this (``z = x + y``). Use 
comments to explain why or how something is done rather than what is done. The
'what' of a code can be inferred with careful reading (or easy reading when 
variables are named in an informative way), but the why or how something is done 
cannot. Indent comments and the commenting character (``%``) to the same level as 
the code they pertain to. Leave one space between the character and a comment.

For comments that require their own line but are not a multi-line block comment, 
place them directly above the relevant code. Leave one blank line above the 
comment and one blank line after the pertinent code to separate it from code it
does not reference.

Inline comments should be concise and only explain what is not apparent from 
variable naming and functions called in that line. Inline comments should not 
make a line longer than the 80 character limit. The one exception to this are 
the comments used to describe class inputs. For the API to compile correctly, a
variable's description must exclusively use the line a variable definition ends on.

Block comments should precede the code block they pertain to. Block comments
should be limited to large chunks of code that requires a more detailing 
explanation or reasoning. It is suggested to section the relevant code
that pertains to the relevant block comment (``%%`` in MATLAB).


Variables, Functions and Classes
""""""""""""""""""""""""""""""""
Variable, function and class names should be in ``camelCase`` format. They 
should be concise but informative. Avoid abbreviations that make names ambiguous
or filler words that make names verbose. Do not use MATLAB reserved variable names 
or use repeat function names. Class properties and methods should have the 
appropriate set access and get access. Functions should always include a unit test
in the respective test location. Function should contain docstrings and be setup
in the following format::

    function FUNCTIONNAME(PARAMETERS, ...)
        % Desription of the function
        %
        % Parameters
        % ------------
        %     NAME : TYPE
        %         Description of variable
        %     
        %     NAME : TYPE
        %         Description of variable
        %
        % Returns
        % ------------
        %     NAME : TYPE
        %         Description of variable
        %     
        %     NAME : TYPE
        %         Description of variable
        %
        
        arguments
            function argument validation ...
        end
        
        content ...
        
    end



.. _dev-overview-mass:

Added Mass Treatment
--------------------
Added mass is a special multi-directional fluid dynamic phenomenon that most
physics software cannot account for well. WEC-Sim uses a special added mass 
treatment to get around the current limitations of Simscape Multibody. For the 
most robust simulation, the added mass matrix should be combined with the mass 
and inertia, shown in the manipulation of the governing equation below: 

.. math::

    m\ddot{X_i} &= \Sigma F(t,\omega) - A(\omega)\ddot{X_i} \\
    (m+A(\omega))\ddot{X_i} &= \Sigma F(t,\omega)

The subscript ``i`` represents the timestep being solved for. In this 
case, the mass of a body is set to the sum of the translational mass, rotational 
inertia and the added mass matrix:

.. math::

    M_{adjusted} = m+A(\omega) = \begin{bmatrix}
                       m + A_{1,1} & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & m + A_{2,2} & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & m + A_{3,3} & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & I_{1} + A_{4,4} & A_{4,5} & A_{4,6} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & A_{5,4} & I_{2} + A_{5,5} & A_{5,6} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & A_{6,4} & A_{6,5} & I_{3} + A_{6,6} \\
                   \end{bmatrix}

This formulation is also ideal because it completely removes the acceleration 
dependence from the right hand side of the equation. Without this treatment, the 
acceleration creates an unsolvable algebraic loop. There are ways to get around 
this issue, but simulation robustness and stability become more difficult.

The core issue with this combined mass formulation is that Simscape does not 
allow a generic body to have a degree-of-freedom specific mass.
A Simscape body is only allowed to have one translational mass and three values 
of inertia about each translational axis. This results in a four-component mass, 
far less than a complete 36-component added mass.

Due to this limitation, WEC-Sim cannot combine the mass and added mass on 
the left-hand side of the equation of motion, as shown above. Instead, WEC-Sim 
moves some components of added mass, while the majority of the components remain 
on the right-hand side. There is a 1-1 mapping between rotational inertia and the 
roll-roll, pitch-pitch, yaw-yaw added mass components. Additionally, some 
combination of the surge-surge, sway-sway, heave-heave components correspond to 
the translational mass of the body. Therefore, WEC-Sim treats the added mass in 
the following way:

.. math::

    M_{adjusted} &= m_{body} + \alpha Y; Y = (A_{1,1} + A_{2,2} + A_{3,3}) \\
    I_{adjusted} &= \begin{bmatrix}
                       I_{1} + A_{4,4} \\
                       I_{2} + A_{5,5} \\
                       I_{3} + A_{6,6} \\
                   \end{bmatrix} \\
    A_{adjusted} &= \begin{bmatrix}
                       A_{1,1} - \alpha Y & A_{1,2} & A_{1,3} & A_{1,4} & A_{1,5} & A_{1,6} \\
                       A_{2,1} & A_{2,2} - \alpha Y & A_{2,3} & A_{2,4} & A_{2,5} & A_{2,6} \\
                       A_{3,1} & A_{3,2} & A_{3,3} - \alpha Y & A_{3,4} & A_{3,5} & A_{3,6} \\
                       A_{4,1} & A_{4,2} & A_{4,3} & 0 & A_{4,5} & A_{4,6} \\
                       A_{5,1} & A_{5,2} & A_{5,3} & A_{5,4} & 0 & A_{5,6} \\
                       A_{6,1} & A_{6,2} & A_{6,3} & A_{6,4} & A_{6,5} & 0\\
                   \end{bmatrix}

The factor :math:`\alpha` represents ``simu.adjMassWeightFun``, which defaults to 2.

One can see that the summation of the adjusted mass, inertia and added mass would 
be identical to the original summation above. The main point being the governing 
equation of motion does not change, only its implementation. A simulation class 
weight factor controls the degree to which the added mass is adjusted to create the 
most robust simulation possible. To see its effects, set ``simu.adjMassWeightFun = 0``
and WEC-Sim will likely become unstable.

However WEC-Sim again contains an unsolvable algebraic loop due to the acceleration 
dependence. WEC-Sim removes this algebraic problem using a Simulink 
``Transport Delay`` with a very small time delay (``1e-8``). Normally this would 
result in using the acceleration at a previous time step to calculate the added 
mass force. However, since the time delay is smaller than the simulation time step 
Simulink will extrapolate the previous step to within 1e-8 of the current time step. 
This will convert the algebraic loop equation of motion to a solvable one:

.. math::

    m_{adjusted}\ddot{X_i} &= \Sigma F(t,\omega) - A(\omega)_{adjusted}\ddot{X}_{i - (10^{-8}/dt)} \\

The acceleration used for the added mass represents the previous time step 
(``i-1``) interpolated to ``1e-8`` seconds before the current time step being 
solved. This can be thought of as a ``i-0.001%`` time step; a close approximation 
of the current time step.



.. _dev-overview-library:

Library Updates
===============

Tracking Library Changes
------------------------

The WEC-Sim library is one of the most difficult files to manage on GitHub. Git 
cannot track specific changes to binary files (such as ``.slx``) well. This 
creates a problem when two version of the library each with their own 
enhancements need to be merged into the development branch. 

To decrease the frequency of these merge conflicts, the development team split 
the library into multiple files in WEC-Sim v4.4. A combination of separate 
library files linked using the Forwarding Table and Referenced Subsystems are 
used to maintains backwards compatibility while splitting the library into 
different files. 

It is *highly recommended* that all developers use the 
`MATLAB External Merge Tool <https://www.mathworks.com/help/simulink/ug/customize-external-source-control-to-use-matlab-for-comparison-and-merge.html>`_
to compare library versions when there are merge conflicts. The MATLAB tool is 
easy to install and allows users to compare changes directly in Simulink.

To use the tool, merge both branches locally and resolve any conflicts using the 
merge tool. For example, take the branches ``A`` and ``B`` that each contain 
new WEC-Sim features. In the Git for Windows command line, these changes can be 
merged using::
    
    # Checkout the A branch and get the latest changes online
    git checkout A
    git pull REMOTE/A
    
    # Fetch updates to the B branch
    git fetch REMOTE
    
    # Merge B branch into A branch
    git merge B
    
    # Resolve library conflicts using the MATLAB merge tool
    git mergetool -t mlMerge source/lib/WEC-Sim/WECSim_Lib.slx

The merge tool will then open a special Simulink GUI that allows users to 
compare code versions both textually and within the block diagram. For each 
conflict select the appropriate version of the code to use. When finished, save 
the simulink diagram and commit using::

    git add source/lib/WEC-Sim/WECSim_Lib.slx
    git commit -m 'merge branch A and branch B changes'


Run From Simulink
---------------------
The Run From Simulink advanced feature allows users to initialize WEC-Sim 
from the command window and then begin the simulation from Simulink. This 
feature allows greater compatibility with other models or 
hardware-in-the-loop simulations that must start in Simulink.


Using the Run From Simulink Feature
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The basic steps to run WEC-Sim from Simulink are:

    1. Open the relevant WEC-Sim Simulink file (``.slx``).
    2. Set the Global Reference Frame to use an input file or set custom parameters
    3. Type ``wecSimInitialize`` in the Command Window
    4. Run the model from Simulink

Internally, the Run From Simulink functionality differs from the ``wecSim`` command in 
how the input file is run. All other pre-processing is identical to the
command line method. The standard ``wecSim`` command begins by running 
the ``wecSimInputFile`` in the current directory and continuing with the 
pre-processing steps. Run From Simulink instead either:

   1. Runs the file chosen in the Global Reference Frame 
   (when the 'Input File' option is selected)
   
   2. Writes and then runs a new input file ``wecSimInputFile_customParameters.m``
   (when the Global Reference when the 'Custom Parameters' option is selected). 
   

Beyond simply allowing users to initialize WEC-Sim and start the 
simulation from Simulink, WEC-Sim allows users to define input file parameters 
inside Simulink block masks. When using the ``Custom Parameters`` setting, 
users can both load an input file into the block masks and write an block masks
to an input file. This feature was created so that users have a written record 
of case parameters utilized during a simulation run from Simulink.

User Definition of Custom Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

The mask of each library block allows users to define a subset of possible 
input parameters that would be defined in the ``wecSimInputFile``. The values 
that a user inputs to a block are stored as mask parameters. When a block mask 
is accessed, a prompt similar to the figure below appears:

.. figure:: /_static/images/dev/mask_user_grf.png
    :align: center
    :width: 400pt
    
    A sample of simulation class parameters may be defined in the Global 
    Reference Frame.

Turning on certain flags may change the visibility of other parameters. For 
example, the wave type will affect which wave settings are visible to 
a user:

.. figure:: /_static/images/dev/mask_user_grf_waveOptions.png
    :align: center
    :width: 400pt

The spectrum type, frequency discretization and phase seed are not used for 
regular waves, so they are no visible. Similarly, a visibility-flag relation 
is present for each body's Morison element options, nonhydro body parameters, 
etc. Having a given flag change the visibility of options that cannot be used 
may help new users understand the interdependence of input parameters.

Note that to decrease the burden of maintaining these masks, only the most 
common input file parameters can be defined in Simulink. For example, 
the Global Reference Frame contains simulationClass parameters such as 
``mode, explorer, solver,`` time information, and state space flags. However 
less common parameters such as ``mcrCaseFile, saveStructure, b2b`` and others 
are not included. Users or developers may add additional options using the 
below instructions.


Library Developments with the Run From Simulink Feature
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WEC-Sim is originally developed as a class based software, not a simulink-based 
one. This results in a complex interplay between the class variables and those 
defined in the block masks. The difficult and complex part of this feature 
comes from three aspects:

    * Changing parameter visibility based on a flags value (``callbacks``)
    
    * Writing an input file from mask parameters (``writeInputFromBlocks``, ``writeLineFromVar``)
    
    * Writing block parameters when loading an input file (``writeBlocksFromInput``)

Each of these items will be addressed in this section, but first an overview of 
the mask set-up is given. It is recommended that developers briefly review 
Mathworks `Simulink.MaskParameter documentation 
<https://www.mathworks.com/help/simulink/slref/simulink.maskparameter-class.html>`_ 
before preceeding with edits to this advanced feature. 

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
``body(i).initDisp`` under the initDisp tab, etc. This method of placing class
structures into tabs helps organize the mask and write parameters to the input 
file.


Parameter Specifics
"""""""""""""""""""

Each mask parameter has certain properties (``name, value, prompt, type``), 
attributes, and dialog options (``visible, callback``) that must be properly 
defined:

.. figure:: /_static/images/dev/mask_dev_grf.png
    :align: center
    :width: 400pt
    

**Properties**

The properties of a mask parameter define the ``name, value, type`` and 
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

**Dialog Options**

The dialog options are primarily used to change a parameter's visibility, 
tooltip and define a callback function. A tooltip defines a string that 
appears when a user hovers on a parameter. This can be useful to provide 
additional context that is too long for the prompt. A parameter's callback functions run whenever the value is updated. In WEC-Sim,
mask callbacks are typically used to with flag parameters to update the 
visibility of other parameters:

================ ====================================== ==========
Block / class     Mask parameter                         Callback
================ ====================================== ==========
PTO, constraint   upperLimitSpecify, lowerLimitSpecify   hardStopCallback
Body              STLButton                              stlButtonCallback
Body              H5Button                               h5ButtonCallback
Body              nhBody, (morisonElement.) on           bodyClassCallback
================ ====================================== ==========


Callback Functions
""""""""""""""""""

WEC-Sim callback functions can be split into several categories by their use:

===================== ======================================
Category               Function name
===================== ======================================
Button callbacks       inFileButtonCallback.m, etaButtonCallback.m, spectrumButtonCallback.m, h5ButtonCallback.m, stlButtonCallback.m, loadInputFileCallback.m
Visibility callbacks   hardStopCallback.m, waveClassCallback.m, bodyClassCallback.m, customVisibilityCallback.m, inputOrCustomCallback.m
===================== ======================================

Visibility callbacks are used with flag parameters to update the visibility of 
available options. For example, if ``body(i).morisonElement.on=0``, then a user
is not able to define ``body(i).morisonElement.cd, .ca,`` etc. This method is 
also how the Global Reference Frame turns off all custom parameters when it is 
set to use an input file.The visibility callbacks function by calling the 
value of a flag:

.. code-block:: matlabsession

    >> mask = Simulink.Mask.get(bodyBlockHandle)
    >> meParam = mask.getParameter('on')
    >> nhBodyParam = mask.getParameter('nhBody')


Depending on the value of a flag, the visibility of individual variables or an 
entire tab can be changed:

.. code-block:: matlabsession

    >> meTab = mask.getDialogControl('morisonElement');
    >> if nhBodyParam.value >= 1
    >>     cgParam.Visible = 'on';
    >>     cbParam.Visible = 'on';
    >> else
    >>     cgParam.Visible = 'off';
    >>     cbParam.Visible = 'off';
    >> end
    >> 
    >> if meParam.value >= 1
    >>     meTab.Visible = 'on';
    >> else
    >>     meTab.Visible = 'off';
    >> end


Button callbacks typically open a file explorer and allow users to select 
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
    >>     fileParam = mask.getParameter('spectrumDataFile')
    >>     fileParam.value = [filepath,filename];
    >> end


Writing Input File from Mask
""""""""""""""""""""""""""""

WEC-Sim writes an input file from mask parameters using the functions 
``writeInputFromBlocks`` and ``writeLineFromVar``. WEC-Sim scans the open 
Simulink file for all blocks, and reorders them based on the typical input file
order: ``simu, waves, body, constraint, pto, mooring``. WEC-Sim also creates 
default copies of each class. All mask variables are looped through and written
to ``wecSimInputFile_simulinkCustomParameters`` using the function 
``writeLineFromVar``. This function takes in a default class, variable name, 
mask value, number and structure value. For example, in the body class:

.. code-block:: matlabsession

    >> writeLineFromVar(body, 'option', maskVars, maskViz, num, 'morisonElement');

This function allows WEC-Sim to easily compare the mask value with the default, 
assign variables to a certain class number and structure. Checking a mask value 
against the class default keeps the new input file clean and easy to read. It is
critical that any mask parameter written with this function is named 
identically to its class counterpart. It returns a string to 
``writeInputFromBlocks`` that is immediately written to the input file. As of 
now, developers must manually add line that will print a new mask parameter to 
the input file.


Writing Mask Parameters from Input File
"""""""""""""""""""""""""""""""""""""""

WEC-Sim loads mask parameters from an input file using the function 
``writeBlocksFromInput``. This function is called by ``loadInputFileCallback`` 
in the ``Global Reference Frame``. This function loops through all blocks in 
the Simulink model. Within each block, the chosen input file is run. Values of 
each class variables are assigned directly to the mask value. The default is 
not checked in this instance, as the mask cannot be cleaned up in the same 
method as the input file. Developers must manually add a line in each case of 
``writeBlocksFromInput`` when renaming or creating a new mask parameter.


Summary
"""""""

**To create or rename a mask parameter**

1. Change the mask parameter name and default value in Simulink
2. If tied to a flag, update callbacks to hide/show the parameter
3. Update writeInputFromBlocks and writeBlocksFromInput with the new parameter 
   name

**Creating a new class or block**

1. Setup the mask parameter structure described above, or copy from another block 
   in that class:
   
   .. code-block:: matlabsession
       
       >> pSource = Simulink.Mask.get(srcBlockName)
       >> pDest = Simulink.Mask.create(destBlockName)
       >> pDest.copy(pSource)

2. Ensure that inputOrCustomCallback functions correctly to hide/show all custom
   parameters depending on the ``Global Reference Frame`` setting.
   
3. If tied to a flag, update callbacks to hide/show parameters
4. Permanently hide any parameters not used in that class (e.g. 
   6DOF Constraint does not have end stops, so that tab is not visible)
5. A new class will also require new writeInputFromBlocks and 
   writeBlocksFromInput sections

.. Note::
    * Mask parameters should always have the same name as the corresponding 
      class property
    * All mask parameters should have the ability to write to an input file and
      load from Simulink
