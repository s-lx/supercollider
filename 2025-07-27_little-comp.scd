// open file "2025-07-27_groups+effects_file.scd" and run code

(
SynthDef(\distortedSin, {
	var sig, env;
	env = Env.perc(\atk.ar(0.01), \rel.ar(2.8)).kr(2);
	sig = SinOsc.ar(\freq.ar(440));
	sig = sig.max(0.002);
	sig = sig * env;
	sig = RLPF.ar(sig, (\freq.ar() + 80), 0.4);
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig)
}).add;
)

~distSine = Synth(\distortedSin, [\out, ~reverbEffect, \amp, 1], target: ~sources)

(
p = Pbindef(\st,
	\instrument, \distortedSin,
	\scale, Scale.minor,
	\degree, Pseq([2, 4, 6, [2, 14, 6] * Prand([0.25, 0.5, 0.75, 1, -1], 1), Prand([Rest(), [1, -1]], 1)], inf),
	\rel, Pseq([3, 3, 3, 5, 2], inf),
	\amp, Pseq([0.4, Pwhite(0.01, 0.2, 4)] * 0.4, inf),
	).play(quant: 1);
// ).quant = 1;
)

