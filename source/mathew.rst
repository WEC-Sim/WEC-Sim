
Mathew's Overall Thoughts
=========================

Just notes for now and subject to change!

User Interface
--------------

I don't understand the design decisions made for the user interaction. Given
they have to use, and understand to some extent, simulink then why not make
the whole UI in simulink? This aligns with the general thought I have had
in my mind going through this, that WEC-Sim could be better aligned for the
non-developer user than it is now.

Use of OOP
----------

On the point of UI, there just doesn't seem any good reason to expose the
user to the OOP parts of the code if it's just being used to define a 
configuration file. You're having to explain to users how OOP works in the
webinars and the objects are never really used as objects, so why bother? 
I think the basic user would be more comfortable creating a configuration
file and you could expose the objects if desired somehow. I think the primary
UI route should be just through simulink, however, if possible.

User Documentation
------------------

Again, I can't help thinking that some focus on the non-developer user for the
documentation would be good too. There is too much focus on the implementation
and not enough on the use and advantages of its use.

The docs should be linted using something like 
`doc8 <https://github.com/pycqa/doc8>`_ so that the source is readable.
