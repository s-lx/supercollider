
s.reboot;
s.quit;


{PinkNoise.ar() * 0.2!2}.play

(
SynthDef(\fmsin, {
	var sig, env, modSig, modEnv;
	env = Env.perc(\atk.ar(0.2), \rel.ar(1.5)).kr(2);
	modEnv = Env.perc(\modAtk.ar(0.1), \modRel.ar(1.0)).kr();
	modSig = SinOsc.ar(\modFreq.ar(120));
	modSig = (modSig * modEnv).range(21, 1);
	sig = SinOsc.ar(\freq.ar(440) * modSig);
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(1.9));
	sig = Limiter.ar(sig, 0.2);
	Out.ar(\out.ar(0), sig);
}).add;
)

Synth(\fmsin)

t = TempoClock.new(120/60).permanent_(true);

(
Pbindef(\a,
	\instrument, \fmsin,
	\dur, Pwhite(0.02, 1.2),
).play(t, quant: 1);
)

(
Pbindef(\a,
	\instrument, \fmsin,
	\degree, Prand([[0, 1, 2], 4, -4, 6, 1, [2, 4, 6]], inf),
	\modFreq, Pwhite(120, 820) * 10,
	\modAtk, Pwhite(0.08, 0.18),
	\modRel, Pwhite(0.1, 0.4),
	\atk, Pwhite(0.01, 0.2),
	\rel, Pwhite(0.02, 0.6) * 0.2,
	\dur, Pwhite(0.02, 1.2),
	\pos, Pwhite(-0.6, 0.6),
).quant_(1)
)