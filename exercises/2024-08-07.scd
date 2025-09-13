(
b = Buffer.read(s,"/Users/sebastianlex/Music/Samples/2024_Fano/klopfen_Fano.wav");
)

b.play
b.numFrames/s.sampleRate

(
SynthDef(\jampler, {
	arg out = 0, buf = 0, start = 0, rel = 0.5, rate = 1, amp = 0.8;
	var sig, env;
	rate = BufRateScale.kr(buf) * rate;
	start = start * s.sampleRate;
	env = Env.perc(attackTime: 0.01, releaseTime: rel).kr(2);
	sig = PlayBuf.ar(1, buf, rate: rate, startPos: start, loop: 1);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig ! 2)
}).add
)

Synth(\jampler, [\buf, b, \start, 0.1, \rate, 2])


(
t = TempoClock(120/60);
p = Pbind(\instrument, \jampler,
	\dur, Pwhite(0.4, 0.48, inf),
	\rate, Pwhite(0.8, 2.4, inf),
	\amp, Pseq([1.0, 0.4, 0.6, 0.4], inf),
	\start, Pseq([0, Pwhite(1.0, 2.0, 3)], inf),
	\rel, 0.2
)
)

~pat = p.play(t);
