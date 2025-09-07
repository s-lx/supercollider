s.boot;
s.reboot;
s.quit;
s.plotTree;

//////////////////////
/* Group definition */
//////////////////////
(
~sources = Group.head(s);
~effects = Group.after(~sources);
~master = Group.tail(s);
)

//////////////////////
//* Bus definition *//
//////////////////////
(
~reverb = Bus.audio(s, 2);
~limiter = Bus.audio(s, 2);
)

//////////////////////
//////* Master *//////
//////////////////////
(
SynthDef(\lim, {
	var sig, in;
	in = In.ar(~limiter, 2);
	// in = in * \masterVol.ar(0.9);
	sig = Limiter.ar(in);
	Out.ar(0, sig)
}).add
)
// start master synth
m = Synth(\lim, target: ~master);
// free
m.free

//////////////////////
//////* Effect *//////
//////////////////////
(
SynthDef(\verb, {
	var sig, in;
	in = In.ar(~reverb, 2);
	sig = FreeVerb.ar(in, \mix.ar(0.5), \room.ar(1.0));
	Out.ar(~limiter, sig)
}).add
)

// start effect synth
e = Synth(\reverb, target: ~effects)
// change effect synth
e.set(\mix, 0.8, \room, 0.7);
// free
e.free;