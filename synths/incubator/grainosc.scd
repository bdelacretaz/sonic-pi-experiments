/*
Granular synth using sin and saw oscillators
and noise as input.

Meant to be used in Sonic Pi, see the example
at the end of this file.

Audio examples at
https://kdrive.infomaniak.com/app/share/117216/2aa82066-b6dc-4699-88f3-ffe322d486ae
*/

(
var synth = SynthDef(\grainosc, {
	|
	amp = 1,
	note = 60,
	sinamp = 1,
	sawamp = 1,
	pulseamp = 0,
	pw = 0.5,
	noiseamp = 0,
	detune = 0.1,
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
	var mix = Limiter.ar(Mix.new([
		SinOsc.ar(freq) * sinamp,
		Saw.ar(freq * (1+detune)) * sawamp,
		Pulse.ar(freq * (1-detune), pw, pulseamp),
		PinkNoise.ar(noiseamp)
	]));
	var trigger = Impulse.kr(trigrate);
	var grained = GrainIn.ar(1, trigger, graindur, mix);
	Out.ar(out_bus,
		Limiter.ar(Pan2.ar(
			RLPF.ar(
				grained,
				cutoff,
				res
			),
			pan,
			amp * EnvGen.kr(env, doneAction: 2);
		))
	);
});
synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

// Local testing
x.postln
x = Synth(\grainosc, [\attack, 0, \release, 10, \rate, 1200, \graindur, 0.01, \note, 62, \cutoff, 825, \res,0.01, \pan, 0,\amp, 1]);
x.set(\pan, -1);
x.set(\pan, 1);
x.set(\noiseamp, 1, \sinamp, 0, \sawamp, 0);
x.set(\noiseamp, 0, \sinamp, 1, \sawamp, 0);
x.set(\noiseamp, 0, \sinamp, 0, \sawamp, 1);
x.set(\amp, 25);
x.set(\amp, 1);
x.set(\cutoff, 880);
x.set(\cutoff, 220);
x.set(\res, 0.01);
x.set(\trigrate, 2);
x.set(\graindur, 0.01);
x.set(\note, 50);
x.set(\note, 62);
x.set(\note, 74);
x.free

/* Sonic Pi example
load_synthdef "/tmp/synthdefs/grainosc.scsyndef"
use_bpm 120
use_synth :grainosc
notes = [:g3, :c3, :c4, :g4]

with_fx :reverb, room:0.2 do
  live_loop "softgrain" do
    #stop
    play notes.choose,
      amp: 2.5,
      peak: 1,
      release: rrand(0.3, 0.5),
      cutoff: rrand(400,1250),
      res: rrand(0.1, 0.002),
      sinamp:rrand(1,30),
      sawamp:rrand(0,3),
      pulseamp:rrand(2,4),
      pw:0.2,
      noiseamp:rrand(0.1,2.8),
      graindur:rrand(0.1,0.03),
      pan:rrand(-0.9,0.9)
    sleep 0.25
  end
end

with_fx :echo, decay:0.1 do
  live_loop "bass" do
    #stop
    note = notes.choose - 12
    play note,
      peak: rrand(0.5,2),
      release: rrand(0.2,0.3),
      graindur:rrand(0.02,0.3),
      sawamp:0, #rrand(0.1,1.5),
      sinamp:0, #rrand(0.2,2),
      pulseamp:rrand(0.2,1),
      pw:rrand(0.1,0.8),
      detune:rrand(0.005, 0.01),
      noiseamp:rrand(0.1,0.5),
      attack:rrand(0.1,0.2),
      cutoff:rrand(220,880),
      res:rrand(0.1,0.05),
      pan:rrand(-0.7,0.7),
      amp:0.5
    play note - 12,
      release:rrand(0.2,0.4),
      cutoff:rrand(240,430),
      res:0.1,
      graindur:rrand(0.02,0.2),
      amp:1
    sleep 0.25
  end
end

*/