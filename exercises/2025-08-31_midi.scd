s.reboot
MIDIClient.init;

// MIDI target
~midiOut = MIDIOut.newByName("Univer Inter", "Univer Inter").latency_(Server.default.latency);

(
Pbindef(\modul,
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, "midiOut",    // MIDI target
    \chan, [0, 1],
    \degree, Pwhite(-7, 12, inf),
	\sustain, Pseq([Pwhite(0.2, 0.8, 1), 0.8, 3], inf),
    \dur, Pseq([1, 1, 4], inf),
).play;
//).quant = 1;
)

MIDIClient.destinations;
~midiOut.value
