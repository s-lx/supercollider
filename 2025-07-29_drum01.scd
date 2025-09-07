(
SynthDef(\drm, {
	var sig, env, freqEnv;
	env = Env.perc(\atk.ar(0.01), \rel.ar(0.2)).kr(2);
	freqEnv = Env.perc(0.01, (\rel.ar() * 0.8)).kr().range(20, 100);
	sig = Pulse.ar([freqEnv * 0.8, freqEnv * 0.6, freqEnv * 0.75, freqEnv * 0.65, freqEnv]);
	sig = sig.sum.range(-0.9, 0.9).scope;
	sig = sig * (SinOsc.ar(220) * 0.5);
	sig = sig * env;
	sig = RLPF.ar(sig, freqEnv * 2.5);
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(1.8));
	Out.ar(\out.ar(~limiter), sig)
}).add;
)

Synth(\drm);

(
Pbindef(\drum,
	\instrument, \drm,
	\dur, 1,
	\stretch, Pseq([1, Pwhite(0.4, 1.0, 3)], inf),
	\rel, Pseq([0.4, Pwhite(0.4, 0.8 , 3)], inf).trace,
	\amp, Pseq([2.4, 1.4, 1, 0.6] * 0.6, inf),
	\out, 0,
// ).play(quant: 1);
).quant = 1;
)

s.plotTree
