((
~pat = Pseq([1, 2, 3, 4], 4, Pfunc({~random}));
~seq = ~pat.asStream;
).postln;)
~random = 1;
~seq.next;
~seq.reset;

(
(0.99).postln;
(0.99).postcs;\
)

(
(degree: [0, 3, 5]).play;
)

s.reboot;

////////////////////////////////////////////
//////// REC und PLAY aus dem kopf ////////
///////////////////////////////////////////

(
// create a tape with a specific length
~tape1 = Buffer.alloc(s, s.sampleRate * 8, 1);
~tape2 = Buffer.alloc(s, s.sampleRate * 4, 1);

// create a device to record onto the tape
(
SynthDef(\recorder, {
	var sig, in;
	in = SoundIn.ar();
	sig = RecordBuf.ar(in, \bufnum.ar(~tape1), loop: 0, doneAction: 2);
}).add;
)
)

// press record
Synth(\recorder);
Synth(\recorder, [\bufnum, ~tape2]);

(
r = Routine{
	1.wait;
	"3".postln;
	1.wait;
	"2".postln;
	1.wait;
	"1".postln;
	1.wait;
	"REC".postln;
	Synth(\recorder);
	8.wait;
	"STOP".postln;
}
)

r.play;
r.reset;

(
t = Routine {
	3.do{
		arg item;
		(3 - item).postln;
		1.wait;
	};
	"REC".postln;
		3.do{
		arg item;
		(3 - item).postln;
		1.wait;
	};
	"STOP".postln;
}
)
t.play;
t.reset



// test what is on the tape
~tape1.play;
~tape2.play;

// create a device to playback the tape
(
SynthDef(\player, {
	var sig, env;
	// env = Env.sine(\length.ar(1)).kr(2);
	env = Env.new([0, 1, 1, 0], [0.01, \length.ar(1), 0.01], [10, 1, -10]).kr(2);
	sig = PlayBuf.ar(1, \bufnum.ar(~tape1), \rate.ar(1), startPos: (\startPos.ar(0) * s.sampleRate), loop: \loop.ar(1));
	sig = sig * env;
	sig = Pan2.ar(sig, level: \level.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add;
)

(
SynthDef(\warpPlayer, {
	var sig, env;
	env = Env.new([0, 1, 1, 0], [0.01, \length.ar(1), 0.01], [10, 1, -10]).kr(2);
	sig = Warp1.ar(1, \bufnum.ar(~tape1), \pointer.ar(0), \freqScale.ar(1), \winSize.ar(0.2));
	sig = sig * env;
	sig = Pan2.ar(sig, level: \level.ar(0.8));
	Out.ar(\out.ar(0), sig);
}).add;
)
Env.sine(1, 1).test.plot;
Env.new([0, 1, 1, 0], [0.01, 1, 0.01], [10, 1, -10]).test.plot;

// playback the tape
Synth(\player);
Synth(\player, [\startPos, 2, \length, 4]);
Synth(\player, [\bufnum, ~tape1, \startPos, 2, \length, 2, \rate, 1]);

Synth(\warpPlayer);
Synth(\warpPlayer, [\pointer, 0, \freqScale, 1, \winSize, 1]);


(
Pbindef(\tapeplay,
	\instrument, \player,
	\bufnum, Pseq([~tape1], inf),
	\startPos, Pwhite(0, 8),
	\rate, Pwhite(0.5, 1.5) * Prand([-1, 1], inf),
	\length, 0.1,
	\dur, 0.1,
	\level, 1.2,
).play
)

(
Pbindef(\tapeplay2,
	\instrument, \warpPlayer,
	\bufnum, ~tape2,
	\pointer, Pwhite(0.0, 0.2),
	\length, Pbrown(1.0, 6.0, 1),
	\freqScale, Pbrown(0, 20, 0.5),
	\winSize, Pwhite(0.1, 4.0),
	\dur, Pwhite(1.0, 3.0),
	\level, Pwhite(0.1, 0.8),
).play
)


s.plotTree;
