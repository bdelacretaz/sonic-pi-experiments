# Play the a melody using a loop and
# a list for the notes, like this:
# notes = [:c3, :d3, :e3, :f3, :g3, :f3, :e3, :d3, :c3]
# notes.length.times do
#   note = notes.tick
#   # add code here to play the note and wait
# end

notes = [:c3, :d3, :e3, :f3, :g3, :f3, :e3, :d3, :c3]
use_synth :prophet
notes.length.times do
  note = notes.tick
  puts note
  play note
  sleep 0.5
end