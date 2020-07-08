
Mathew's Thoughts
=================

On everything up to the tutorials
---------------------------------

Considering the docs first, I think there is a real need to draw a line between 
what is required for a user (both in terms of using the tool and the theory 
they need to know) and in terms of a developer. To me, currently this code only 
caters to the user/developer kind of professional, who is likely embedded in a 
research institution. To appeal to a wider audience, more detail is required 
about what the advantages of using the tool are, what it produces and how to 
interpret it, how to set up the inputs, and succinct, but detailed, theory for 
what they need to know to create/interpret the inputs and outputs. And then the 
rest can go into a developer manual. 

I suspect some of the reason that the docs are as they are is the assumption 
that the tutorials can not be understood without the preceding documentation, 
but I think the real case is that the documentation can not be understood 
without the tutorials, at the moment. It would be much better to put the 
tutorials up front and then link to information in later docs that enforces 
concepts in the tutorial, if that's the primary learning route for a user. 

From a user's perspective, I also think that streamlining the way the tool is 
run would be useful (note, I'm not a user, really, so take this with a pinch of 
salt - it would be nice to ask some external users about this - but then 
everyone hates change too). I really think that given the cost of purchasing 
Simulink and Simscape, to not try and encapsulate this tool within it, is a bit 
of a miss. We might as well help people to use the tool they have paid for, and 
sure that includes MATLAB, but there are `ways of exporting outputs of Simulink 
models to MATLAB 
<https://uk.mathworks.com/help/Simulink/ug/export-simulation-data-1.html>`_, 
so all the post-processing stuff can still be done in MATLAB if desired. 

Which brings me to OOP. It's not clear in the documentation (up to the 
tutorials) why the user is required to use OOP beyond setting up a config file. 
But setting up a config file is easily done in ASCII which most non-developers 
will be more comfortable with or even `it could be done directly in Simulink 
<https://uk.mathworks.com/help/Simulink/ug/setting-up-configuration-sets.html>`_. 
I think OOP is the right choice for coding the backend model and works well 
with matching to the Simulink blocks, but I don't see any advantages (from what 
I have read so far) of using OOP for the user. 

My last issue is with the way the constraints, PTO and moorings are modelled. 
It seems a bit confused and could be made a bit more clear if moorings were 
treated like "constraints" and PTOS. Then constraints could be "joints", the 
DOFs afforded by moorings could be dealt with in the moorings blocks and the 
model would capture the physical aspect of these systems better. I suspect that 
some of the problem comes from the (almost) inclusion of moordyn and its 
slightly different mode of operation. I think the way moordyn is added to the 
model and the way it's (not) distributed is wrong. I think more effort should 
be made to incorporate it directly into WEC-Sim (such that the user doesn't 
know it's there) by abstracting it's use and calling it directly, and that it 
should be packaged in WEC-Sim as well (or at least packaged by WEC-Sim as a 
kind of proper plugin). Less of an issue, but I also think the global 
reference frame block could be broken down somewhat, because it does too many 
things. 

Finally, in terms of these docs themselves, they are super hard to read and
some standard should be "enforced" by linting using something like 
`doc8 <https://github.com/pycqa/doc8>`_ so that the source is readable.

On the tutorials
----------------

* BEMIO really is an integral part of WEC-Sim, because there doesn't seem to be 
  any other description of how to generate the h5 files manually.

On the API
----------

The API shows the same issues as the rest of the docs by mixing user centric 
information with details that are more focussed on the developer. This is 
because the classes are used for both user interaction and Simulink 
interaction, but they don't suit either well, IMO. The issue with Simulink is 
that it is really difficult to find the documentation of the methods that are 
called because they are called on objects but the docs are associated to 
classes. Also there seems to be a lot of temporal coupling in the classes 
(which is bad), so it looks like functions might have been a better choice for 
the Simulink interface. What about `System Objects 
<https://uk.mathworks.com/help/simulink/slref/matlabsystem.html>`_?
