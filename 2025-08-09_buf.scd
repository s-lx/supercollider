s.boot;

(
~tape = Buffer.alloc(s, s.sampleRate * 2, 1);
)

(
SynthDef(\rec, {
		var sig, in;
	in = SoundIn.ar(0);
	sig = RecordBuf.ar(in, ~tape, offset: 0, recLevel: 1, preLevel: 0, run: 1, loop: 0, trigger: 1.0, doneAction: 2);
	}
).add;
)

Synth(\rec);

~tape.plot


(
SynthDef(\play, {
	var sig, env;
	env = Env.linen.(0.1, 2, 0.1).kr(2);
	sig = PlayBuf.ar(1, ~tape, loop: 1);
	sig = sig *env;
	Out.ar(0 ,sig)
}
).add
)

Synth(\play)



(
Pbindef(\p,
	\instrument, \play,
).play
)