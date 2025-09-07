/*
- explore groups
*/

// Keep watching everything in the NodeTree
s.plotTree;

(
// Create some buses
~reverbBus = Bus.audio(s, 2);
~masterBus = Bus.audio(s, 2);

// Define groups
 ~sources = Group.new;
 ~effects = Group.new(~sources, \addAfter);
~master = Group.new(~effects, \addAfter);

SynthDef(\reverb, {
	var sig, in;
	in = In.ar(~reverbBus, 2);
	sig = FreeVerb.ar(in, \mix.ar(0.8), \room.ar(0.8), \damp.ar(0.5));
	Out.ar(~masterBus, sig);
}).play(target: ~effects);

SynthDef(\limiter, {
	var sig, in;
	in = In.ar(~masterBus, 2);
	sig = Limiter.ar(in, \level.ar(1.0));
	Out.ar(0, sig);
}).play(target: ~master);
)

(
SynthDef(\sine, {
	var sig, env;
	env = Env.perc(\atk.ar(0.01), \rel.ar(1)).kr(2);
	sig = SinOsc.ar(\freq.ar(440));
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add;
)

y = Synth(\sine, [\out, ~reverbBus, \amp, 90]);

(
Pbindef(\a,
	\instrument, \sine,
	\amp, Pwhite(0.5, 2.0),
	\pos, Pwhite(-1.0, 1.0),
	\atk, Pwhite(0.001, 0.4),
	\rel, Pwhite(0.5, 1.0),
	\degree, Prand([[1, 2, 4], 3, [2, -2, 0], [1, 2, 4, 8]], inf),
	\group, ~sources,
	\out, Prand([~masterBus, ~reverbBus], inf),
).play
)

s.plotTree
s.reboot;
