// FMGrain synth
// requires https://github.com/supercollider/sc3-plugins

(
(
SynthDef(\fmgrain, {
	|
	gate = 1,
	amp = 1,
	rate = 20,
	noiserange = 10,
	noisefreq = 1,
	dur = 0.2,
	carfreq = 440,
	modfreq = 200,
	cutoff = 1200,
	res = 1,
	out_bus = 0
	|
	var fm = FMGrain.ar(Impulse.ar(rate), dur, carfreq, modfreq,
		LFNoise1.kr(noisefreq).range(1, noiserange),
		EnvGen.kr(
			Env([0, 1, 0], [1, 1], \sin, 1),
			gate,
			levelScale: amp,
			doneAction: 2)
	);
	var filtered = RLPF.ar(fm, cutoff, res);
	Out.ar(0, filtered);

	})).writeDefFile("/tmp/synthdefs/")
//})).send(s);
)

// Local testing (requires the ".send above)
x.postln
x = Synth(\fmgrain);
x.set(\carfreq, 440);
x.set(\cutoff, 185);
x.set(\res, 0.05);
x.set(\modfreq, 141);
x.set(\noisefreq, 2);
x.set(\noiserange, 161);
x.set(\dur, 0.02);
x.set(\gate,0);
x.free()