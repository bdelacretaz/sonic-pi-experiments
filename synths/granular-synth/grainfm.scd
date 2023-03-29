/*
Granular synth using the GrainFM UGen.

Meant to be used in Sonic Pi, see the example
at the end of this file.

Audio examples at
https://kdrive.infomaniak.com/app/share/117216/2aa82066-b6dc-4699-88f3-ffe322d486ae
*/

(
var synth = SynthDef(\grainfm, {
	|
	gate = 1,
	amp = 1,
	rate = 20,
	graindur = 0.2,
	envdur = 1,
	note = 60,
	modfreq = 200,
	cutoff = 1200,
	res = 1,
	pan = 0,
	out_bus = 0
	|
	var carfreq = note.midicps;
	Out.ar(out_bus,
		Pan2.ar(
			RLPF.ar(
				GrainFM.ar(1, Impulse.kr(rate), graindur, carfreq, modfreq),
				cutoff,
				res
			),
			pan,
			Line.kr(2, 0, envdur, amp, doneAction: 2)
		)
	);
});

synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

// Local testing
x.postln
x = Synth(\grainfm, [\note, 60, \modratio, 0.3, \envdur, 5, \rate, 1200, \graindur, 0.5, \cutoff, 225, \res,0.04, \pan, 0]);
x.free()
x.set(\carfreq, 440);
x.set(\modfreq, 1);
x.set(\rate, 12);
x.set(\amp, 0.5);
x.set(\cutoff, 185);
x.set(\res, 0.45);
x.set(\graindur, 0.05);

/* Sonic Pi example

load_synthdef "/tmp/synthdefs/grainfm.scsyndef"
use_bpm 120
use_synth :grainfm
notes = [:g4, :c4, :c5, :g5]
freqs = [ 600, 200, 420 ]
amp = 0.5

with_fx :reverb, room:0.2 do
  live_loop "notes" do
    note = notes.choose
    freq = freqs.choose * 4
    play note,
      envdur:rrand(0.01,0.3),graindur:rrand(0.01,0.04),
      rate:322,modfreq:223,
      cutoff:freq * rrand(0.2,0.5),res:rrand(0.1,0.3),
      amp:amp * 0.5,
      pan: rrand(-1,1)
    sleep 0.25
  end
end

live_loop "bg" do
  note = notes.choose
  freq = freqs.choose * 6
  play note,
    envdur:rrand(0.2,0.6),graindur:rrand(0.01,0.02),
    rate:434,modfreq:22,
    cutoff:freq * rrand(0.2,0.5),res:0.3,
    amp:amp * 3,
    pan: rrand(-1,1)
  sleep 0.25
end
*/