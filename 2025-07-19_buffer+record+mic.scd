(
SynthDef(\play, {
	var sig, env;
	env = Env.perc().kr(2);
	sig = PlayBuf.ar(1, )
})
)

(
SynthDef(\record, {
	var in;
	in = SoundIn.ar();
	RecordBuf.ar(in, \bufnum.ar(0), doneAction: 2, loop: 0);
}).add;

SynthDef(\playback, {
	var playbuf, env;
	env = Env.sine(0.8).kr(2);
	playbuf = PlayBuf.ar(1,\bufnum.ar(0), \rate.ar(1), startPos: \startPos.ar(0), loop: \loop.ar(0), doneAction: 2);
	playbuf = playbuf * env;
	playbuf = Pan2.ar(playbuf, \pos.ar(0), \amp.ar(0.8));
	Out.ar(\out.ar(0), playbuf);
}).add;
)

(
~bufferLength = 5;
~numChannels = 1; // if changed to 2 change PlayBuf in SynthDef "playback"
/** allocate buffer **/
~buf = Buffer.alloc(s, s.sampleRate * ~bufferLength, ~numChannels);
)


/** record **/
Synth(\record, [\bufnum, ~buf]);

/** playback **/
Synth(\playback, [\bufnum, ~buf]);
);

(
Pbindef(\buff,
	\instrument, \playback,
	\bufnum, ~buf,
	\dur, Pseq([0.4, 0.8, 0.8, 0.8, 0.8] * 0.1, inf),
	\rate, Pwhite(0.09, 1.1, inf) * Prand([-0.5, 0.5], inf),
	\startPos, Pwhite(1000, 400000, inf),
	\amp, Pseq([3.5, 1.2, 1.2, 1.2, 1.2] * 0.4, inf)
	).play
)


/** save recording to disc **/
~buf.write("~/buf.aiff".standardizePath);

/** cleanup buffer **/
~buf.close;
~buf.free;