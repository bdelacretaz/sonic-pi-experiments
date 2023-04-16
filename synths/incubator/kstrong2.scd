(
var synth = SynthDef(\kstrong2, {
	|
	amp = 1,
	pan = 0,
	note = 60,
	trigrate = 2000,
	attack = 0.1,
	release = 0.3,
	noisetype = 0,
	noiseamp = 0.1,
	decaytime=10,
	coef=0.1,
	peak = 1,
	envCurve = -4,
	cutoff = 2400,
	res = 1,
	out_bus = 0
	|
	var freq = note.midicps;
	var trigger = Impulse.kr(trigrate);
	var env = Env.perc(attack, release, peak, envCurve);
	var noise = Select.ar(noisetype, [
		WhiteNoise.ar(noiseamp),
		PinkNoise.ar(noiseamp),
		BrownNoise.ar(noiseamp),
		GrayNoise.ar(noiseamp),
		ClipNoise.ar(noiseamp)
	]);
	var snd =  Pluck.ar(noise, trigger, freq.reciprocal, freq.reciprocal, decaytime, coef);
	Out.ar(out_bus,Limiter.ar(Pan2.ar(RLPF.ar(snd,cutoff,res),pan,amp * EnvGen.kr(env, doneAction: 2))));
	});
synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

// Local testing
x.postln
x = Synth(\kstrong2, [\attack, 0, \release, 10, \note, 62, \trigrate, 2, \cutoff, 1825, \res,0.01, \pan, 0,\amp, 1]);
x.set(\pan, -1);
x.set(\pan, 1);
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
load_synthdef "/tmp/synthdefs/kstrong2.scsyndef"
use_bpm 120
use_synth :kstrong2
notes = [:g3, :c3, :c4, :g4, :g5]

live_loop "brushes" do
  #stop
  play notes.choose + 12,
    pan:rrand(-0.5,0.5),
    trigrate: 1.5,
    noisetype: rrand(0,5),
    release:rrand(0.2,0.5),
    peak:rrand(0.2,5),
    decaytime:0.5,
    coef:0.7,
    cutoff:rrand(440,2240),
    res:0.1,
    amp:4
  sleep 0.25
end

live_loop "higher" do
  #stop
  play notes.choose + 12,
    noisetype:3,
    decaytime:rrand(0.2,0.4),
    coef:rrand(0.5,0.9),
    trigrate:7.3,
    release:rrand(0.2,1.5),
    amp:2
  sleep 0.25
end
*/