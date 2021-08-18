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
TODO 
mass adjustment and restoration, simulink issues, etc
changing factor, problems, etc

.. _dev-overview-library:

Library Updates
---------------
TODO
divison of the library, run from simulink setup, etc



