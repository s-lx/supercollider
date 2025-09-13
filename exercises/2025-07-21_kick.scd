(
SynthDef(\sn, {
	var sig, env, modEnv;
	env = Env.perc(\atk.ar(0.01), \rel.ar(0.5)).kr(2);
	modEnv = Env([140, 40], [0.1]).ar;
	sig = SinOsc.ar(modEnv);
	sig = sig * env;
	// sig = sig.softclip;
	sig = Pan2.ar(sig, \pos.ar(0), \level.ar(0.9));
	Out.ar(\out.ar(0), sig);
}).add;
)

x = Synth(\sn);

(
Pbindef(\snp,
	\instrument, \sn,
	\dur, Pwhite(0.49, 0.51).trace,
	\level, Pseq([1.0, 0.5, 0.5, 0.5], inf)
).play
)

s.boot;
