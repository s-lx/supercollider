
s.reboot;
s.plotTree;

(
~limiter = Bus.audio(s, 2);

SynthDef(\limiter, {
	var sig, in;
	in = In.ar(~limiter);
	sig = in;
	Out.ar(0, sig);
}).add;
Synth(\limiter, addAction: \addToTail);∏

)

(
~distortBus = Bus.audio(s, 2);

SynthDef(\dist, {
	var sig, in;
	in = In.ar(~distortBus);
	sig = in.clip2(\clip.ar(0.2));
	sig = Pan2.ar(sig);
	Out.ar(\out.ar(0), sig);
}).add;

d = Synth(\dist, addAction: \addToTail);
)

(
~verbBus = Bus.audio(s, 2);

SynthDef(\verb, {
	var sig, in;
	in = In.ar(~verbBus);
	sig = GVerb.ar(in, \roomsize.ar(10), \revtime.ar(10), \damping.ar(0.5), \inputbw.ar(0.5), \spread.ar(15), \drylevel.ar(1), \earlyreflevel.ar(0.7), \taillevel.ar(0.5), \maxroomsze.ar(900));
	sig = Limiter.ar(sig, 0.9);
	Out.ar(\out.ar(0), sig);
}).add;

v = Synth(\verb, addAction: \addToTail);
v.set(\damping, 0.1);
v.set(\maxroomsze, 50);
)

(
SynthDef(\sinus, {
	var sig, env;
	env = Env.perc(\atk.ar(0.01), \rel.ar(0.8)).kr(2);
	sig = SinOsc.ar(\freq.ar(440));
	sig = sig * env;
	sig = Splay.ar(sig);
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add;
)

t = TempoClock(120/60).permanent_(true);

(
Pbindef(\x, \instrument, \sinus).play(t, quant: 4);
Pbindef(\x, \out, ~verbBus);
Pbindef(\x, \dur, Pseq([1, 1.2, 1.8, 2.1], inf), \rel, 2);
Pbindef(\x, \amp, 0.2)
)
