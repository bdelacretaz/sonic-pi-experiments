/*
Granular synth using the GrainFM UGen.

Meant to be used in Sonic Pi, see the example
at the end of this file.
*/

(
var synth = SynthDef(\grainfm, {
	|
	amp = 1,
	trigrate = 0,
	graindur = 0.2,
	release = 0.2,
	note = 60,
	modfreq = 200,
	modratio = 1,
	modindex = 10,
	filtertype = 0,
	cutoff = 1200,
	res = 1,
	pan = 0,
	out_bus = 0
	|
	var carfreq = note.midicps;
	var snd, rq, mfenv;

	// res < 1 combined with high cutoff crashes SC in my tests
	res = res.max(1).min(1000);

	// If trigger rate is not specified, use carrier frequency
	trigrate = Select.kr(trigrate > 0, [ carfreq, trigrate ]);

	// If modratio is not specified, use modfreq as a fixed rate
	modfreq = Select.kr(modratio > 0, [ modfreq, carfreq * modratio ]);

	// GrainFM, limit, filter and pan
	snd = GrainFM.ar(1, Impulse.kr(trigrate), dur:graindur, carfreq:carfreq, modfreq:modfreq, index:modindex);
	snd = Limiter.ar(snd);

	// Optional RLPF or MoogFF filter
	rq = res.max(0.1).reciprocal;
	snd = Select.ar(filtertype > 0, [ MoogFF.ar(snd, freq:cutoff, gain:res) , RLPF.ar(snd, freq:cutoff, rq:rq )]);

	// Pan and out
	snd = Pan2.ar(snd, pan, Line.kr(2, 0, release, amp, doneAction: 2));
	Out.ar(out_bus, snd);
});

synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

// Local testing
x.postln
x = Synth(\grainfm, [\note, 60, \modratio, 4.99, \modfreq, 22, \envdur, 5, \rate, 1200, \graindur, 0.5, \cutoff, 225, \res,0.04, \pan, 0]);
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
notes = [:g4, :c4, :c5, :g5, :g3]

bright = 1
filtertype = 0
res = 1

with_fx :reverb, room:0.2 do
  live_loop "notes" do
    #stop
    note = notes.choose
    freq = midi_to_hz(note) * 5
    play note-24,
      release:rrand(0.1,0.4),graindur:rrand(0.01,0.04),
      filtertype: filtertype,
      trigrate:322,modfreq:223,
      cutoff:freq * bright * rrand(0.1,0.3),res:res * rrand(1,3),
      pan: rrand(-0.9,0.9),
      amp:0.4
    sleep [0.25,0.25,0.5].choose
  end
end

with_fx :flanger do
  live_loop "bg" do
    note = notes.choose
    freq = midi_to_hz(note) * 2
    #stop
    play [7,9,11].choose,
      filtertype: filtertype,
      release:rrand(0.2,0.4),graindur:rrand(0.01,0.02),
      trigrate:434,modratio:rrand(20,30),
      cutoff:freq * bright * rrand(0.4,0.18),res: res * 0.8,
      pan: rrand(-0.8,0.8),
      amp:rrand(2,3)
    sleep 0.25
  end
end

with_fx :echo, decay:0.1 do
  live_loop "grains" do
    note = notes.choose
    #stop
    # TODO without +0, doesn't play the right note
    play note+0,
      filtertype: filtertype,
      modratio:rrand(5.9,24),
      graindur:rrand(0.001,0.04),
      release:rrand(0.05,0.25),
      pan:rrand(-0.3,0.3),
      amp:0.7
    sleep [0.25,0.5].choose
  end
end
*/