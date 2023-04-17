// Minimal synthdef to demonstrate the "play :c3 + 0" problem
(
var synth = SynthDef(\playtest, {
	|
	note = 60,
	out_bus = 0
	|
	var snd = Pan2.ar(SinOsc.ar(note.midicps), level: Line.kr(2, 0, 0.2, 1, doneAction: 2));
	note.poll(2);
	Out.ar(out_bus, snd);
});

synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

/* Sonic Pi example
load_synthdef "/tmp/synthdefs/playtest.scsyndef"
use_bpm 120
use_synth :playtest

live_loop "t" do
  # without the +0, \playtest receives note=0
  play :c3 + 0
  sleep 1
end
*/