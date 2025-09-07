(
SynthDef(\per4, {
	arg sig, env;
	env = Env.linen(\atk.ar(0.1), \sus.ar(0.2), \rel.ar(0.1), \lvl.ar(0.8), \curve.ar(\sin)).ar(2);
	sig = Pulse.ar(\freq.ar(440));
	sig = sig * env;
	sig = RLPF.ar(sig, \freq.ar() - 80, \res.ar(0.2));
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add
)

(
SynthDef(\sini, {
	arg sig, env;
	env = Env.linen(\atk.ar(0.1), \sus.ar(0.2), \rel.ar(0.1), \lvl.ar(0.8), \curve.ar(\sin)).ar(2);
	sig = SinOsc.ar(\freq.ar(440));
	sig = sig * env;
	//sig = RLPF.ar(sig, \filFreq.ar(1420), \res.ar(0.05));
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add
)

(
SynthDef(\ini, {
	arg sig, env;
	env = Env.perc(0.001, 0.02).ar(2);
	sig = SinOsc.ar(LFNoise2.kr(1000).range(120, 2000));
	sig = sig * env;
	sig = RLPF.ar(sig, \filFreq.ar(810), \res.ar(1));
//	sig = sig * (PinkNoise.ar() * 0.8);
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add
)

Synth(\per4)

(
Synth(\per4, [\freq, ((120.rand) + 320), \atk, 1.rand, \rel, 2.rand])
)

Env.linen(0.01, 0.2, 0.1, 0.8, \sin).plot;

t = TempoClock.new(75/60);

(
Pbindef(\a_pat,
	\instrument, \per4,//Pseq([\per4, \sini], inf),
	\scale, Scale.majorPentatonic,
	//\root, Pseq([-6, -5, Rest(1), 14], inf),
	\root, Pseq([[-6, -5, 4], [-7, -8, 3]], inf),
	\degree, Pwhite([1, 2, 3], [5, 6, 7]),
	\atk, Pwhite(0.01, 1),
	\rel, Pwhite(0.1, 2),
	\amp, Pwhite(0.0021, 0.1),
	\dur, Pwhite(1, 2),
//).play(t, quant: 1)
).quant = 1
)


(
Pbindef(\ii,
	\instrument, \ini,
	\amp, Pseq([1, 0.8, 0.8, 0.8], inf),
	\amp, Pseq([1.5, 0.4, 0.6, 0.4], inf),
	\dur, Prand([Rest(1), Pwhite(0.2, 0.6, 4)], inf),
//).quant = 1
).play(t, quant: 1)
)
s.reboot