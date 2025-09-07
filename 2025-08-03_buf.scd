s.boot;
(
~tape = Buffer.alloc(s, 4 * s.sampleRate, 1);
)

(
SynthDef(\recorder, {
	var sig, in;
	in = SoundIn.ar(0);
	sig = RecordBuf.ar(in, ~tape, loop: 0, doneAction: 2);
}).add
)

Synth(\recorder);

(
SynthDef(\player, {
	var sig, env;
	env = Env.linen(0.1, \sustain.ar(2), 0.1, curve: \sine).kr(2);
	sig = PlayBuf.ar(1, ~tape, \rate.ar(1), startPos: \startPos.ar(0) * s.sampleRate, loop: 1);
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0));
	Out.ar(\out.ar(0), sig)
}).add
)

Synth(\player, [\sustain, 4.0.rand, \rate, 1.0.rand * [-1, 1].choose, \startPos, 4.0.rand])

2.0.rand
4.rand
[-1, 1].choose
1.0.rand * [-1, 1].choose

(
t = Task{
	"beginn".postln;
	Synth(\player, [\sustain, 4.0, \rate, 1.0, \startPos, 0]);
	5.5.wait;
	23.do{ arg i; i = i +1;
		Synth(\player, [\sustain, 3.0.rand, \rate, 1.0.rand * [-1, 1].choose, \startPos, 4.0.rand]);
		(2.5.rand + 0.2).wait;
		i.postln;
	};
	1.5.wait;
	Synth(\player, [\sustain, 4.0, \rate, 1.0, \startPos, 0]);
	"ende".postln;
}
)

t.play;
t.stop;
t.reset;
