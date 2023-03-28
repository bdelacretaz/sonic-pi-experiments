// Minimal Granular Synth, meant to be used in Sonic Pi:
// Adapted from http://ringbuffer.org/sound_synthesis_introduction/Processed_Recording/supercollider-granular-example/
//
// # Sonic Pi example:
// load_synthdef "/tmp/synthdefs/mgs.scsyndef"
//
// use_bpm 120
// freq = [ 250, 500, 700, 1200 ]
// center = [ 0, 0.5, 1 ]
// live_loop "test" do
//   use_synth :mgs
//   play 1, pitch: 1, density:freq.tick('f'), amp:0.5, center:center.tick('c'), dur:rrand(1,2)
//   sleep 1
// end


(
SynthDef(\mgs, {
	|
	density = 250,
	pitch   = 1,
	dur     = 0.1,
	center  = 0,
	amp = 1,
	out_bus = 0
	|

	var buffer = Buffer.readChannel(s,"/tmp/synthdefs/ambi_drone.flac",channels:0);
	//buffer.duration;

	var trigger = Impulse.kr(density);
	Out.ar(out_bus, amp * TGrains.ar(1, trigger, buffer, pitch, center, dur));

})).writeDefFile("/tmp/synthdefs/")
//})).send(s);

// Local testing (requires the ".send above)
x = Synth(\mgs);
x.set(\center,0.5);
x.set(\density,250);
x.set(\dur,0.3);
x.set(\pitch, 1.8);

x.free()