// FMGrain synth built from out of the box UGens, no extensions

(
(
SynthDef(\fmgrain, {
	|
	gate = 1,
	amp = 1,
	rate = 20,
	pan = 0,
	noiserange = 10,
	noisefreq = 1,
	dur = 0.2,
	carfreq = 440,
	modfreq = 200,
	cutoff = 1200,
	res = 1,
	out_bus = 0
	|
	var freq = LFNoise0.kr(noisefreq).exprange(200, noiserange);
	var ctls = [
		// freq, phase, amp
		[freq, 0, 1],
		[freq, 0, 1],
		[LFNoise2.kr(0.5).exprange(3, 80), 0, 1],
		[LFNoise2.kr(0.5).exprange(3, 800), 0, 1],
		[LFNoise2.kr(0.5).exprange(3, 800), 0, 1],
		[LFNoise2.kr(0.5).exprange(0.3, 10), 0, 1]
	];
	var mods = [
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseX.kr(0, 3),
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseX.kr(0, 3),
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
		{ LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3)
	];
	var fm = FM7.ar(ctls, mods);
	var filtered = RLPF.ar(fm, cutoff, res);
	var trigger = Impulse.ar(rate);
	var grained = GrainIn.ar(2, trigger, dur, fm, pan);
	Out.ar(0, grained);

//})).writeDefFile("/tmp/synthdefs/")
})).send(s);
)

// Local testing (requires the ".send above)
x.postln
x = Synth(\fmgrain);
x.set(\carfreq, 440);
x.set(\cutoff, 185);
x.set(\res, 0.05);
x.set(\modfreq, 141);
x.set(\noisefreq, 200);
x.set(\noiserange, 2205);
x.set(\dur, 0.02);
x.set(\rate, 200);
x.set(\gate,0);
x.free()