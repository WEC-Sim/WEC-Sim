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
Paragraphs should be written as blocks, while maintaining the 84 character limit.
The most common exception is when a url itself is over 84 characters than it maybe
create a long line. 
TODO

Code
^^^^

Formatting
""""""""""
Code should be limited to 84 characters per line. Use line breaks to prevent code
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

Do::
    
    TODO

Don't::
    
    TODO

Inline comments should be concise and only explain what is not apparent from 
variable naming and functions called in that line. Inline comments should not 
make a line longer than the 84 character limit. The one exception to this are 
the comments used to describe class inputs. For the API to compile correctly, a
variable's description must exclusively use the line the variable is defined on.

Do::
    
    TODO

Don't::
    
    TODO

Block comments should precede the code block they pertain to. Block comments
should be limited to large chunks of code that requires a more detailing 
explanation or reasoning. It is suggested to section the relevant code
that pertains to the relevant block comment (``%%`` in MATLAB).

Do::
    
    TODO

Don't::
    
    TODO


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
---------------
TODO
divison of the library, run from simulink setup, etc



