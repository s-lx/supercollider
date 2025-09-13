s.reboot;

(
SynthDef(\sawnice, {
	var sig, env;
	env = Env.perc(\atk.ar(0.1), \rel.ar(0.2)).kr(2);
	sig = Saw.ar(\freq.ar(440));
	sig = RLPF.ar(sig, (\freq.ar() + \ffreq.ar(80)), \q.ar(1.0));
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.6));
	Out.ar(\out.ar(0), sig)
}).add;
)

Synth(\sawnice, [\freq, [220, 440], \rel, 2]);

(
Pbindef(\sani,
	\instrument, \sawnice,
	\degree, [1, 2, 6, 4] * 0.4,
	\rel, Prand([[1, 2], [1, 1], [0.2, 0.4], [0.4, 0.2], [0.2, 0.2]], inf) * 0.08,
	\dur, 0.2,
	\amp, 0.06,
//).play(quant: 1)
).quant = 1;
)

(
Pbindef(\sanib,
	\instrument, \sawnice,
	\degree, Pseq([[1, 2, 3], [2, 3, 4], [3, 4, 5]], inf),
	\ffreq, Pseq([-10, 0, 10, 20, 30, 40, 50, 70], inf),
	\dur, 0.4,
	\q, 0.1,
	\rel, 0.2,
//).play(quant: 1)
).quant = 1;
)
