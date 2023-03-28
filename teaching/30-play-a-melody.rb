# play a melody that goes up and down
# with the following notes:
# C3, D3, E3, F3, G3, F3, E3, C3
#
# And add a way to transpose it with
# a variable, as in this example:
#
# transpose = 5
# play :c3 + transpose

delay = 0.5
transpose = 5

use_synth :piano
play :c3 + transpose
wait delay
play :d3 + transpose
wait delay
play :e3 + transpose
wait delay
play :f3 + transpose
wait delay
play :g3 + transpose
wait delay
play :f3 + transpose
wait delay
play :e3 + transpose
wait delay
play :d3 + transpose
wait delay
play :c3 + transpose
