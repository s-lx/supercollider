s.reboot;

(
~bufnum = Buffer.alloc(s, s.sampleRate * 4, 1);
)

(
SynthDef(\recorder, {
	var sig, in;
	in = SoundIn.ar(0);
	sig = RecordBuf.ar(in, \bufnum.ar(~bufnum), loop: 0, doneAction: 2);
}).add;
)

~bufnum.plot
Synth(\recorder)

(
SynthDef(\player, {
	var sig, env;
	env = Env.linen(0.1, \sustain.ar(2), 0.1, curve: \sine).kr(2);
	sig = PlayBuf.ar(1, \bufnum.ar(~bufnum), \rate.ar(1.0), startPos: \startPos.ar(0.0), loop: 1);
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0.0), \amp.ar(0.9));
	Out.ar(\out.ar(0), sig)
}).add;
)

Env.linen(0.1, 2, 0.1, curve: \sine).plot;
Synth(\player, [\rate, -1]);

t = TempoClock.new(120/60).permanent_(true);
(
Pbindef(\p,
	\instrument, \player,
	\rate, Pwhite(0.995, 1.051),
	\startPos, Pseq([0.3, 0.2, 0.1, 0.4] * 40 * s.sampleRate, inf) * Pwhite(0.95, 1.052),
	\sustain, Pseq([1.4, 1.2, 0.7, 1.0] * 0.25, inf),
	\amp, Pseq([0.9, 0.2, 0.5, 0.4] * 9, inf),
// ).play(t, quant: 1);
	).quant = 1;
)

s.sampleRate * 4
(0.5 * 4 * s.sampleRate) * 2
