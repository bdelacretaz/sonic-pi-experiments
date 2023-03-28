
//
// granular synthesis
// nova@deviator.si

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// main core stuff

// load buffers
p = "/Users/bert/Desktop/./stuff/tosave/basel-wonderful-world/wonderful-1/Audio Files/kamerasi_wubgt.wav";
b = Buffer.readChannel(s,p, channels:1);

// SynthDef granulator
(
SynthDef(\Granny, {

	arg bufnum,
	freq = 10, fvar = 1,
	dur = 0.1, durvar = 0,
	pos = 0, posvar = 0,
	pitch = 1, pitchvar = 0,
	width = 0.2,
	gain = 0.5,
	lpfFreq = 400
	;
	var signal;

	signal = GrainBuf.ar(
		numChannels: 2, // we want stereo!
		trigger: Impulse.kr(freq + (freq * (fvar * LFNoise2.kr(freq)))), // a UGen?
		dur: dur + (durvar * LFNoise2.kr(freq)), // in seconds
		sndbuf: bufnum,
		rate: pitch + (pitchvar * LFNoise2.kr(5)), // pitch !! WHAT IS THE SPEED OF VARIATIONS? setable??
		pos: pos + (posvar * LFNoise2.kr(freq)), // position 0-1
		interp: 2, // interpolation for pitchshifting
		pan: LFNoise1.kr(10).range(width.neg, width), // if numChannels=2, similar to Pan2, -1 left, +1 right
		//		envbunum: -1, // the buffer number cont. grain envelope
		maxGrains: 512,
		mul: gain,
		add: 0
	);

	signal = LPF.ar(
		in: signal,
		freq: lpfFreq);

	Out.ar(0, signal);

}).send(s)
)


// TESTS ////////////////////////////////////////////////////////////////
// execute these one line at the time to test
// if seting parameters through arguments work
x = Synth(\Granny, [\bufnum, b]); // construct the object / create a synth

// parameters:
x.set(\freq, 200);
x.set(\fvar, 0);
x.set(\dur, 0.3);
x.set(\durvar, 0.1);
x.set(\pos, 0.5);
x.set(\posvar, 0.01);
x.set(\pitch, 1);
x.set(\pitchvar, 0.01);
x.set(\width, 0.9);
x.set(\gain, 0.8);
x.set(\lpfFreq, 1200)
x.free;

