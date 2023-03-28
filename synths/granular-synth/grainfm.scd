/*
Granular synth built from out of the box UGens,
no extensions required.

Meant to be used in Sonic Pi:

load_synthdef "/tmp/synthdefs/grainfm.scsyndef"
use_bpm 120
use_synth :grainfm
rate = [100, 150, 200, 300, 400, 600, 800]
amp = 1

with_fx :reverb, room:0.2 do
  live_loop "notes" do
    freq = rate.choose
    play 0,
      envdur:rrand(0.01,0.3),graindur:rrand(0.02,0.04),
      rate:322,modfreq:223,carfreq:freq,
      cutoff:freq * rrand(0.2,0.5),res:0.3,
      amp:amp,
      pan: rrand(-1,1)
    sleep 0.25
  end
end

live_loop "bg" do
  freq = rate.choose * 0.25
  play 0,
    envdur:rrand(0.2,0.6),graindur:rrand(0.1,0.04),
    rate:324,modfreq:22,carfreq:freq,
    cutoff:freq * rrand(0.2,0.4),res:0.1,
    amp:amp,
    pan: rrand(-1,1)
  sleep 0.25
end
*/

(
(
SynthDef(\grainfm, {
	|
	gate = 1,
	amp = 1,
	rate = 20,
	graindur = 0.2,
	envdur = 1,
	carfreq = 440,
	modfreq = 200,
	cutoff = 1200,
	res = 1,
	pan = 0,
	out_bus = 0
	|
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

//	})).writeDefFile("/tmp/synthdefs/")
})).send(s);
)

// Local testing (requires the ".send above)
x.postln
x = Synth(\grainfm, [\envdur, 5, \rate, 1200, \graindur, 0.05, \cutoff, 225, \res,0.04, \pan, 0]);
x.free()
x.set(\carfreq, 440);
x.set(\modfreq, 1);
x.set(\rate, 12);
x.set(\amp, 0.5);
x.set(\cutoff, 185);
x.set(\res, 0.45);
x.set(\graindur, 0.05);
