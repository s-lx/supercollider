s.reboot;
s.plotTree;

(
~limiter = Bus.audio(s,2);
~reverb = Bus.audio(s, 2);
~master = Group.tail(s);
~effects = Group.before(~master);
)

(
SynthDef(\lim, {
	var sig, in;
	in = In.ar(~limiter, 2);
	sig = Limiter.ar(in);
	Out.ar(0, sig)
}).add
)

e = Synth(\lim, target: ~master)
e.free

(
SynthDef(\reverb, {
	var sig, in;
	in = In.ar(~reverb, 2);
	sig = FreeVerb.ar(in, \mix.ar(0.5), \room.ar(1.0));
	Out.ar(~limiter, sig)
}).add
)

f = Synth(\reverb, target: ~effects)
f.set(\mix, 0.8, \room, 0.7)
f.free;

(
SynthDef(\sinn, {
	var sig, env;
	env = Env.perc().kr(2);
	sig = Pulse.ar(\freq.ar(220));
	sig = RLPF.ar(sig, 220, 0.2);
	sig = sig * env * \amp.ar(1);
	Out.ar(\out.ar(0), sig!2)
}).add
)

Synth(\sinn, [\out, ~reverb, \amp,1]);

(
Pbindef(\pat,
	\instrument, \sinn,
	\degree, Prand([[1, 2, 8], [1, 2, 4]], inf).trace,
	\out, ~reverb,
	\amp, 0.9,
).quant = 1
//).play(quant: 1)
)
