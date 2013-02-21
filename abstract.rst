Hashdist - yet another desperate attempt at fixing scientific software distribution

How many researcher-hours are wasted every year editing makefiles and
trying to get software to build on a new cluster? Wouldn't it be nice
if somebody just solved the problem?

We (me and some others you don't know) haven't done so yet, but we
believe we have some new ideas and that we will make some real headway
on this problem. We've only burned 1/3 of the funding so far and
nothing is ready for consumption, but I'll describe the ideas and
our path forwards.

I'll probably touch upon things like:

 - Cryptographic hash functions
 - Software and reproducible research
 - Why the others are wrong and we are right
 - How our ideas build on previous ideas (in software design), and
   couldn't have happened 10 years ago.

Note: This is not part of my PhD; I've taken 2 months leave from my
PhD to work on Hashdist with funding from the US Army Engineer
Research and Development Center. All our code is open source.


--

Plan:

 - why existing solutions are not good enough
 - problem of relying on sysadmin
   - used to be the case: use stable stack of software
   - revolution in terms of sharing code/open source
     - towards sharing smaller and smaller pieces
       - thanks to GitHub (nimble; makes SourceForge look like an elephant)
     - used
     - Python that's happening
     - Dense linear algebra research that's happening
   - => coding is social and immediate, can't rely on sysadmin
   - distribution holds things back
     - large scale: PETSc
     - smaller scale: HEALPix incl. gaussian rng
 - theory
   - cryptographic hashes
   - collision chances
   - git
   - want that for software stacks
     - reproducible research
     - ideally
 - hashdist ideas

 - integer linear programming
   - 'which lapack to use a free variable'
   - allow to move software from Linux to Mac, via clusters, etc.
