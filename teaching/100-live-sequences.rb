# This Sonic Pi example demonstrates various
# ways to program melodic or ryhthmic sequences

use_bpm 120

# LIVE CONTROL SECTION
# Change these variables and use run to update
# the live sequence

# Level of each part
ampKick = 1.5
ampHat = 1
ampBass = 1.5
ampArp = 1
ampPluck = 1

# Transpose the sequence (use 0, 5, 7 for example)
transpose = 0

# Fast (1) /slow (0) blade sequence
fast = 1

# TIMING LOOPS SECTION
live_loop :sixteens do
  sleep 0.25
end

live_loop :eights do
  sync :sixteens
  sync :sixteens
end

# INSTRUMENT LOOPS SECTION

# kick on all 4/4 beats
# Snare on the off beats
snarePattern = [true,false]
live_loop :kicksnare do
  sync :eights
  sync :eights
  sample :drum_heavy_kick, amp:ampKick
  if snarePattern.tick
  then
    sample :drum_snare_soft, amp:ampKick
  end
end


# Separate loop for the hi hat pattern
# that's programmed explicitly

live_loop :hat do
  sync :eights
  3.times do
    sample :drum_cymbal_closed, amp:ampHat
    sync :eights
  end
  sample :drum_cymbal_closed, amp:ampHat
  sleep 0.25
  
  # From time to time play an open hi hat
  if one_in(3)
  then
    sample :drum_cymbal_open, finish:0.1, release:0.1, amp:0.6 * ampHat
  else
    sample :drum_cymbal_closed, amp:ampHat
  end
end

# Semi-random synth sequence from a set of notes
in_thread do
  notes = [ :c3, :g4, :g3, :d3, :c4, :g3 ]
  live_loop :bass do
    sync :sixteens
    use_synth :fm
    play notes.choose + transpose, release:0.2, amp:ampBass
  end
end

# Semi-random notes from a chord
with_fx :reverb do
  live_loop :arpeggio do
    sync :sixteens
    use_synth :piano
    play chord(:c6, :m7).choose + transpose, release: 0.3, amp:0.5 * ampArp
  end
end

# Programmed synth sequence
with_fx :reverb do
  notes = [ :c3, :g4, :g3, :d3, :c4, :g3, :c2, :g3, :c3, :d3 ]
  live_loop :pluck do
    if fast == 1
    then
      sync :sixteens
    else
      sync :eights
    end
    
    # Use some randomness for the release
    use_synth :pluck
    play notes.tick + transpose, release:rrand(0.1,0.8), amp:ampPluck
  end
end
