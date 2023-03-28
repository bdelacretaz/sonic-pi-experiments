# Here's a possible solution for
# the live loops exercise

notes = [:c3, :d3, :e3, :f3, :g3, :f3, :e3, :d3]

live_loop :piano do
  use_synth :piano
  notes.length.times do
    note = notes.tick
    play note
    sleep 0.5
  end
end

live_loop :kick do
  sample :drum_bass_hard
  sleep 1
end

live_loop :snare do
  sleep 1
  sample :drum_snare_hard
  sleep 1
end

live_loop :hat do
  sample :drum_cymbal_closed
  sleep 0.5
  sample :drum_cymbal_open, finish:0.1, release:0.01, amp:0.5
  sleep 0.5
end