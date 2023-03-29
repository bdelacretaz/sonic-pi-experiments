/*
Granular synth using sin and saw oscillators
and noise as input.
Meant to be used in Sonic Pi, see the example
at the end of this file.
*/

(
var synth = SynthDef(\grainosc, {
	|
	amp = 1,
	note = 60,
	sinamp = 1,
	sawamp = 1,
	noiseamp = 0,
	graindur = 0.5,
	trigrate = 20,
	cutoff = 1200,
	res = 1,
	pan = 0,
	attack = 0.01,
	release = 1,
	peak = 1,
	envCurve = -4,
	r = 1.0,
	out_bus = 0
	|
	var freq = note.midicps;
	var env = Env.perc(attack, release, peak, envCurve);
	var mix = Mix.new([
		SinOsc.ar(freq) * sinamp,
		Saw.ar(freq) * sawamp,
		PinkNoise.ar(noiseamp)
	]);
	var trigger = Impulse.kr(trigrate);
	var grained = GrainIn.ar(1, trigger, graindur, mix);
	Out.ar(out_bus,
		Pan2.ar(
			RLPF.ar(
				grained,
				cutoff,
				res
			),
			pan,
			amp * EnvGen.kr(env, doneAction: 2);
		)
	);
});
synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

// Local testing (requires the ".send above)
x.postln
x = Synth(\grainosc, [\attack, 0, \release, 1, \rate, 1200, \graindur, 0.05, \note, 62, \cutoff, 225, \res,0.04, \pan, 0,\amp, 1]);
x.free;
x.set(\pan, -1);
x.set(\pan, 1);
x.set(\noiseamp, 1, \sinamp, 0, \sawamp, 0);
x.set(\amp, 2);
x.set(\amp, 1);
x.set(\sinamp, 0);
x.set(\sinamp, 0);
x.set(\sawamp, 0);
x.set(\pulseamp, 2);
x.set(\cutoff, 880);
x.set(\cutoff, 220);
x.set(\res, 0.5);
x.set(\trigrate, 2);
x.set(\graindur, 0.01);
x.set(\freq, 220);
x.set(\freq, 440);
x.set(\freq, 880);
x.free

Env.adsr(0.02, 0.2, 0.25, 1, 1, -4).test(2).plot;
Env.perc(0.01, 1.0, 1.0, -4).test(2).plot;

/* Sonic Pi example
load_synthdef "/tmp/synthdefs/grainosc.scsyndef"
use_bpm 120
use_synth :grainosc
notes = [:g3, :c3, :c4, :g4]
amp = 0.5

with_fx :reverb, room:0.2 do
  live_loop "softgrain" do
    play notes.choose,
      amp: 0.5,
      peak: 1,
      release: rrand(0.5, 0.7),
      cutoff: rrand(800,1250),
      res: rrand(0.1, 0.2),
      sinamp:rrand(1,30),
      sawamp:rrand(0,3),
      noiseamp:rrand(0.1,0.2),
      graindur:rrand(0.1,0.05),
      pan:rrand(-0.9,0.9),
      amp:amp
    sleep 0.25
  end
end

live_loop "bass" do
  note = notes.choose - 12
  play note,
    peak: rrand(0.5,1),
    release: rrand(0.1,0.5),
    graindur:rrand(0.02,0.2),
    sawamp:rrand(0.1,1.5),
    sinamp:rrand(0.2,2),
    cutoff:rrand(220,880),
    res:rrand(0.1,0.2),
    pan:rrand(-0.5,0.5),
    amp:amp
  play note - 12,
    release:0.2,
    cutoff:240,
    res:0.5,
    graindur:rrand(0.1,0.3),
    amp:amp
  sleep 0.25
end
*/