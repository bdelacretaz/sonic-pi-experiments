# Repeat something
# and use a synth with parameters
use_synth :piano
3.times do
  play :c4
  sleep 0.5
  play :d4, amp: 1
  sleep 0.5
  play :d4, amp:4
  sleep 0.5
end