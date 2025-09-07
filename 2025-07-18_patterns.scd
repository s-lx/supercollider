(
{SinOsc.ar([[100, 400], [200, 600]]) * EnvGen.kr(Env.perc());}.play
{SinOsc.ar([150, 300]!2) * EnvGen.kr(Env.perc());}.play
)

{PinkNoise.ar()!2 * Env.perc().kr()}.play

(
f = {|freq = 220, mul = 0.2, mul2 = 0.1|
	var sig, env;
	env = XLine.kr(doneAction: 2);
	sig = SinOsc.ar(freq,mul: mul)!2;
	sig = sig + PinkNoise.ar(mul2);
	sig = sig * env;
}
)

x = f.play;
x.set(\freq, 90, \mul2, 0.08, \mul, 0.8)
x.release(0.4)

y = f.play;


(
x = {|gate = 0|
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0.2, 0],
			[0.02, 1, 4],
			[0, -1, -4],
			2
		),
		gate,
	);
	sig = SinOsc.ar(\freq.kr(440)) * 0.3;
	sig = sig * env;
	sig = sig !2;
}.play
)

x.set(\gate, 1, \freq, 220)
x.set(\gate, 0, \freq, 220)
x.free;

(
SynthDef(\miti, {
	var sig, env;
	env = Env.perc().kr(2);
	sig = SinOsc.ar(\freq.ar(440));
	sig = sig * env * \amp.ar(0.2);
	Out.ar(\out.ar(0), sig!2)
}).add
)

Synth(\miti);

(
p = Pbind(
	\instrument, \miti,
	\freq, 180,
	\amp, 0.3,
	\dur, Pfunc({~dur}),
)
)
TempoClock.default.tempo = (120/60);
x = p.play(quant: 4);
x.stop();


y = d.play(quant: 4);
y.stop();
(
d = Pbindf(p,
	\dur, Pseq([1, 1, 2, 1.5, 0.5], 5),
	\amp, Pfunc({
		|ev|
		var amps = [0.8, 0.01, 0.01, 0.01];
		amps[ev.value] * ~amp})
))

~amp = 0.8;
~dur = 0.9;

x.stop();

(
{
	var sig, pan, mod;
	pan = PinkNoise.kr.range(-1, 1);
	mod = SinOsc.ar(140) * 1000;
	sig = SinOsc.ar(mod + 220) * 0.2;
	sig = Pan2.ar(sig, pan);
}.play;
)

Pset

{~deg = 3; nil;}


(
x = Pfunc({ |inval| (10 * inval.value) }).asStream;
[2, 3, 2].do { |i| x.next(i).postln };
x.nextN(5, (:0..)).postln;
)

(
~amp = 0.8;
~amps = [0.9, 0.6, 0.2, 0.2, 0.4];

~freqs = [220, 440, 660, 700, 440];
~oct = 0.4;

p = Pbind(
	\instrument, \miti,
	\index, Pseq([0, 1, 2, 3, 4], inf),
	\freq, Pfunc({
		arg ev;
		~freqs[ev[\index]] * ~oct
	}),
    \dur, 1,
    \amp, Pfunc({ |ev|
        ~amps[ev[\index]] * ~amp
    })
);
)

p.play

(
~amp = 0.2;
~amps = [0.9, 0.8, 0.1, 0.1];

p = Pbind(
	\instrument, \miti,
    \dur, 1,
    \amp, Pfunc({ Pseq(~amps, 1).asStream.next }) * Pfunc({ ~amp })
);
)

p.play;


(
~amp = 0.1;
~amps = [1, 0.4, 0.4, 0.1];

p = Pbind(
	\instrument, \miti,
    \dur, 1,
    \amp, Plazy { Pseq(~amps, inf) } * Pfunc({~amp})
);

p.play;
)

(
~amp = 0.4;
~amps = [0.1, 0.1, 0.1, 0.1];

Pbindef(\dynAmp,
    Pbind(
		\instrument, \miti,
        \dur, 1,
        \amp, Plazy { Pseq(~amps, inf) } * ~amp
    )
);

Pdef(\dynAmp).play;
)


(
~amp = 0.6;
~amps = [0.9, 0.1, 0.6, 0.2, 0.9];

p = Pbind(
	\instrument, \miti,
    \dur, 1,
    \index, Pseq((0..(~amps.size - 1)), inf),
    \amp, Pfunc({ |ev| ~amps[ev[\index]] * ~amp })
);

p.play;
)

(
SynthDef(\maka, {
	var sig, env, mod;
	env = Env.perc(\att.ar(0.001), \rel.ar(0.5)).kr(2);
	sig = SinOsc.ar(\freq.ar(440) * SinOsc.ar(120, mul: 50000));
	sig = sig + (ClipNoise.ar() * \noisAmp.ar(0.1));
	sig = sig * env;
	sig = RLPF.ar(sig, 680, 0.4);
	sig = sig * \amp.ar(0.8);
	sig = Pan2.ar(sig, \pos.ar(0), \level.ar(1));
	Out.ar(\out.ar(0), sig);
}).add;
)

Synth(\maka, [\rel: 0.2]);

(
Pbindef(\c, \instrument, \maka,
	\rel, 0.2,
	\level, Pseq([1.2, 0.4, 0.4, 0.4], inf),
	\degree, Prand([1, 2, 0.7, 0.6], inf),
	\dur, Pwhite(0.09, 0.11, inf),
	\pos, 0,
).play(quant: 1)
)

(
Pbindef(\a, \instrument, \maka,
).play(quant: 1)
)

(
Pbindef(\a,
	[\degree, \amp], Pseq([[Pseq([1, 4, 16, 2], 2).asStream, 0.2], [-2, 0.1], [-2, 0.3], [0, 0.3]], inf),
	\dur, Pseq([Prand([1, 2, 4],1), 0.2, 0.2, 0.2, 0.6, 0.6, 0.2], inf),
	\att, Prand([0.001, 0.01, 0.004, 0.6], inf),
	\rel, Prand([2, 0.2, 0.8, 0.2, 0.1],inf),
	\noisAmp, Pbrown(0.0, 0.1, 0.02, inf),
).quant = 1
)

Scale.directory;
Scale.majorPentatonic;

(
Pbindef(\a,
	\scale, Scale.majorPentatonic,
	\root, 2,
	\octave, Prand([4, 5, 4, 4, 3], inf),
	\degree, Pseq([Prand([[1, 4], [14, 2, 7], 8, [12, 10]], 2), -2, -4, 0, 4, 8, 2], inf),
	\amp, Pseq([0.3, 0.1, 0.2, 0.2] * 0.2, inf),
	\dur, Pseq([Prand([1, 2, 3],1), 0.2, 0.2, 0.2, 0.6, 0.6, 0.2], inf),
	\att, Prand([0.001, 0.01, 0.004, 0.6], inf),
	\rel, Pseq([1.8, 0.2, 1.2, 0.2, 0.1],inf),
	\noisAmp, Pbrown(0.0, 0.04, 0.002, inf)/2,
	\level, 0.9,
	\pos, Pbrown(-1, 1, 0.02, inf),
).quant = 1
)

(
Pbindef(\a,
	[\degree, \amp], Pseq([[Pseq([1, 4, 16, 2], 2).asStream, 0.2], [-2, 0.1], [-2, 0.3], [0, 0.3]], inf),
	\dur, Pseq([1, 0.2, 0.2, 0.2, 0.6, 0.6, 0.2], inf),
	\att, Prand([0.001, 0.01, 0.004, 0.6], inf),
	\rel, Prand([2, 0.2, 0.8, 0.2, 0.1],inf),
	\noisAmp, Pbrown(0.0, 0.2, 0.02, inf),
).quant = 1
)

(
Pbindef(\a,
	[\degree, \amp], Pseq([[Prand([26, -4, 26, 2], 4).asStream, 0.2], [-2, 0.1], [-2, 0.3], [0, 0.3]], inf),
	\dur, Pseq([1, 0.2, 0.2, 0.2, 0.6, 0.6, 0.2], inf),
	\att, Prand([0.001, 0.01, 0.004, 0.6], inf),
	\rel, Prand([2, 0.2, 0.8, 0.2, 0.1],inf),
	\noisAmp, Pbrown(0.0, 0.2, 0.02, inf),
).quant = 1
)












