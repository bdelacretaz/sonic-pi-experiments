// Example from the Sonic Pi Help
(
SynthDef(\piTest,
         {|freq = 200, amp = 1, out_bus = 0 |
           Out.ar(out_bus,
                  SinOsc.ar([freq,freq],0,0.5)* Line.kr(1, 0, 5, amp, doneAction: 2))}
).writeDefFile("/tmp/synthdefs")
)
