s.reboot;

(
~bufb = Buffer.alloc(s, s.sampleRate * 4, 1);
)

~bufb.free;
~bufb.plot;

(
SynthDef(\rec, {
	var sig, in;
	in = SoundIn.ar(0, 1);
	sig = RecordBuf.ar(in, \bufnum.ar(~bufb), loop: 0, trigger: \reset.ar(0), doneAction: 2);
	// Out.ar(0, sig);
}).add;
)

(
t = Task {
	0.5.wait;
	("bereit").postln;
	1.wait;
	("rec start").postln;
	Synth(\rec, [\reset, 1]);
	1.wait;
	("1s").postln;
	1.wait;
	("2s").postln;
	1.wait;
	("3s").postln;
	1.wait;
	("rec end").postln;
}
)

t.start;

(
SynthDef(\play, {
	var sig, env;
	env = Env.linen(0.1, \rel.ar(3.8), 0.1, 0.9, \sine).kr(2);
	sig = PlayBuf.ar(1, \bufnum.ar(~bufb), \rate.ar(1), startPos: (\startPos.ar(0) * s.sampleRate), loop: 1);
	// sig = Normalizer.ar(sig, 0.9, 0.1);
	sig = sig * env * 4;
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.9));
	sig = Limiter.ar(sig);
	Out.ar(0, sig);
}).add;
)

Env.linen(0.2, 3.8, 0.2, 0.9, \sine).test.plot;
Synth(\play);

(
Pbindef(\abc,
	\instrument, \play,
	\rate, Pseq([0.2, 0.1, 0.4, 0.8], inf),
	\startPos, Pseq([0, 3, 0.17, (Pwhite(0.0, 3.0, 1))], inf) * Prand([-1, 1], inf),
	\amp, Pseq([1.2, 0.8, 0.8, 1.2], inf),
	\dur, (Pseq([2.8, 1.5, 0.9, 1.2], inf) * Pxrand([0.1, 0.2, 0.4, 0.1, 2, 0.4, 1.0, 4, 0.2], inf)),
	\rel, Pwhite(0.4, 2.2),
	).play(quant: 1);
// ).quant = 1;
)
