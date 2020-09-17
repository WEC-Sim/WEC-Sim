
Mathew's Thoughts
=================

On everything up to the tutorials (updated 2020/09/16)
------------------------------------------------------

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

.. note::
	This is the new bit...

Having completed the Simulink On-ramp, I really think it would be useful
to point new users towards this training and also really sell WEC-Sim as about
Simscape tool. Having never used Simulink before coming to this tool, I really
wasn't sure how a Simulink problem works with MATLAB and the documentation
doesn't really shout "I'm a Simscape model, so you'd better learn it, first!"

Which brings me to OOP. Having understood a bit more about the relationship
between Simulink and MATLAB, I can see the idea behind the representing 
blocks as objects. I think this could be made easier, nonetheless,
and I've suggested one approach which will automagically generate the objects
when blocks are created (see https://github.com/WEC-Sim/WEC-Sim/issues/405).
Ultimately, the average user is still going to interact with these objects
like a glorified config file, so I still don't see the need to train the user
in OOP quite so hard as the docs currently do.

.. note::
	That ends the new bit

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
`doc8 <https://github.com/pycqa/doc8>`_ so that the source is readable. I think
I'm going to write a blog extolling the virtues of hard wrapping.

On the tutorials
----------------

* BEMIO really is an integral part of WEC-Sim, because there doesn't seem to be 
  any other description of how to generate the h5 files manually.
* The BEMIO steps are also glossed over by using the included scripts, yet they
  are obviously doing a lot of work.
* I think I would point people to the Simulink on-ramp before they undertake the
  tutorial, as it will really help answer some basic questions for new users.
* It's weird that the WEC-Sim Simulink blocks don't appear in the search when 
  you double-click the search space.
* It would be really nice to auto-create the objects when placing blocks, but
  also to be able to use the run simulation button rather than type wecSim into
  MATLAB.  

On the API
----------

.. note::
	I've edited this in light of my new knowledge, also.

The API shows the same issues as the rest of the docs by mixing user centric 
information with details that are more focused on the developer. I *still* 
believe this is because there is too much responsibility placed on the classes 
(they are both the UI and the business logic). I would consider trying to slim 
down the classes associated to the blocks to just what the user will interact 
(effectively they would be types) and then create either functions or new 
classes from the rest. I mentioned temporal coupling before, which probably 
indicates that the classes are doing too many things. 
