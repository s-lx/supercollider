s.reboot;

(
~tapeLength = 4;
~tapeLoop = Buffer.alloc(s, ~tapeLength * s.sampleRate);
)

(
SynthDef(\recorder, {
	var sig, in;
	in = SoundIn.ar();
	sig = RecordBuf.ar(in, \bufnum.ar(~tapeLoop), preLevel: 0.35, loop: 0, doneAction: 2);
}).add;
)

(
t = Task {
	"prepare recording - 2s".postln;
	2.wait;
	Synth(\recorder);
	//s.record(duration: 5);
	"recording".postln;
	~tapeLength.do({
		arg i, item;
		item = ~tapeLength - i;
		item.postln;
		1.wait;
	});
	"recording stopped".postln;
}
)

t.start;
s.plotTree;
~tapeLoop.plot;
~tapeLoop.play;

(
SynthDef(\player, {
	var sig, env;
	env = Env.linen(0.01, \length.ar(2), 0.01, curve: \sine).kr(2);
	sig = PlayBuf.ar(1, \bufnum.ar(~tapeLoop), \rate.ar(1), startPos: \startPos.ar(0), loop: \loop.ar(1));
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), sig)
}).add
)

(
Synth(\player, [\rate, 12, \length, 12, \amp, 0.3]);
Synth(\player, [\rate, (rand(0.02) + 0.01), \length, 12, \amp, 2.2]);
)

Synth(\player)

s.record;
s.record(duration: 5);
s.stopRecording;











