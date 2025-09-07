(
a = Buffer.read(s,"/Users/sebastianlex/Music/Samples/2024_Fano/Umgebung_Fano.wav")
)

a.play;
a. numChannels;
a.sampleRate;
a.numFrames;
a.numFrames/s.sampleRate;

(
SynthDef(\sampler, {
	arg rate = 1, buf = 0, start = 0, rel = 1, amp = 0.4;
	var sig, env;
	start = start * s.sampleRate;
	env = Env.perc(attackTime: 0.01, releaseTime: rel).kr(2);
	rate = BufRateScale.kr(buf) * rate;
	sig = PlayBuf.ar(2, buf, rate, startPos: start, loop: 1);
	sig = env * sig;
	sig = sig * amp;
	Out.ar(\out.kr(0), sig ! 2);
}).add;
)

x = Synth(\sampler, [buf: a.bufnum, rate: -0.2, start: 5, rel: 15, \amp, 0.8]);

(
t = TempoClock(40/60);
p = Pbind(\instrument, \sampler,
	\dur , Pdefn(\durdef, Pseq([0.1, 0.1, 0.1, 0.1, Prand([Rest(2), Rest(0.2), Rest(0.6)], 1), 0.1, 0.1, 0.2, 0.1, 0.4], inf)),
	\start, Pwhite(1, 40, inf),
	\rate, Pdefn(\ratedef, Pwhite(-1.4, 1.4, inf)),
	\amp, Pdefn(\ampdef, Pseq([0.8, 0.4, 0.4, 0.4], inf)),
	\rel, Pdefn(\reldef, 1)
)
)

p.play(t);

Pdefn(\durdef, Pseq([0.1, 0.1, 0.1, 0.1, Prand([Rest(2), Rest(0.2), Rest(0.6)], 1), 0.1, 0.1, 0.2, 0.1, 0.4], inf));
Pdefn(\durdef, 0.1)
Pdefn(\ampdef, Pseq([0.8, 0.1, 0.2, 0.1], inf))
Pdefn(\ratedef, Pwhite(-1, -0.1), inf)
Pdefn(\ratedef, -0.5)
Pdefn(\ratedef, Pwhite(-1.4, 1.4, inf))
Pdefn(\reldef, Pwhite(2, 6), inf)
Pdefn(\reldef, 0.2)
Pdefn(\reldef, Pseq([0.8, 0.2, 0.4, 0.2], inf))

s.boot;

