# The live loops below all run in parallel
# and play their notes
#
# Improve them to create a nice loop with
# drums and the melody from the previous
# exercise.
#
# Experiment with the live loops, which
# can be updated with stopping the music

live_loop :piano do
  use_synth :piano
  play :c3
  sleep 1
end

live_loop :kick do
  sample :drum_bass_hard
  sleep 1
  sample :drum_snare_hard
  sleep 1
end

live_loop :hat do
  sample :drum_cymbal_closed
  sleep 1
  sample :drum_cymbal_open, finish:0.1, release:0.01, amp:0.5
  sleep 1

  # commenting a play or sample line is useful to hear
  # what the other loops are playing
  # sample :perc_bell
end