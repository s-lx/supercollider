(
SynthDef(\fm, {
	var mod, sig, env1, env2;
	env1 = Env.adsr().kr(2, \gate.kr(1));
	env2 = Env.perc(attackTime: 1.2).kr();
	mod = SinOsc.ar(\modfreq.kr(220), mul: 30);
	sig = SinOsc.ar(\freq.kr(440) + mod);
	sig = sig * env1;
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ar(0), sig ! 2);
}).add;
)

x = Synth(\fm);
x.set(\gate, 0);

(
t = TempoClock.new(120/60);

~fmpat = Pbind(\instrument, \fm,
	\freq, Prand([220, 440, 660], inf),
	\modfreq, Pwhite(60, 880, inf),
	\dur, Pdefn(\def, Prand([1, 4, 2, 6], inf), inf),
	\gate, Pseq([0, 1], inf);
)
)

~fmpat.play(t, quant: 4);

Pdefn(\def, Pseq([0.15, 0.1, 0.1], inf));
Pdefn(\def, Prand([1, 4, 2, 6], inf), inf);

s.plotTree;
s.boot;

