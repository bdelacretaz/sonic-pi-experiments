# Play the a melody using a loop and
# a list for the notes, like this:
use_bpm 120

# define a set of transpose and a set of notes
transpose = [ 0, 5, 0, 7, 5, 0 ]
notes = [:c3, :d3, :e3, :f3, :g3, :f3, :e3, :d3]

# for each transpose, play all notes once
transpose.length.times do
  t = transpose.tick('t')
  notes.length.times do
    play notes.tick + t
    sleep 0.5
  end
end
play :c3