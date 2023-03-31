/*
Granulator effect for Sonic Pi, see the example
at the end of this file.
TODO VarLag options
*/

(
var synth = SynthDef(\granulator, {
	|
	in_bus = 0,
	out_bus = 0,
	amp = 1,
	mix = 0.8,
	pan = 0,
	graindur = 0.2,
	rate = 223
	|
	var dry, wet, mixed, trigger;
	var defaultslide = 0.01;
	dry = In.ar(in_bus, 2);
	trigger = Impulse.kr(rate);
	wet = GrainIn.ar(2, trigger, in:dry, dur:VarLag.kr(graindur, defaultslide));
	mix = Clip.kr(mix);
	pan = Clip.kr(pan, -1, 1);
	mixed = Mix.new([
		Pan2.ar(dry, pan, VarLag.kr(1-mix, defaultslide)),
		Pan2.ar(wet, pan, VarLag.kr(mix, defaultslide))
	]);
	mixed = Pan2.ar(Limiter.ar(mixed), VarLag.kr(pan), VarLag.kr(amp));
	Out.ar(out_bus, mixed);
});
synth.add;
synth.writeDefFile("/tmp/synthdefs/")
)

/* Sonic Pi example
load_synthdef "/tmp/synthdefs/granulator.scsyndef"
use_bpm 120
use_synth :piano
notes = [:g3, :c3, :c4, :g4]


with_fx "granulator" , rate:155, graindur:2, mix:0.5, pan:1, amp:0.1 do |fx|
  live_loop "softgrain" do
    stop
    #does not work? fx.control("pan", rrand(-1, 1))
    fx.control("amp", rrand(0.1, 1))
    fx.control("graindur", rrand(2, 1))
    #fx.control("rate", rrand(155, 660))

    play notes.choose, release:0.5
    sleep 0.25
  end
end
*/