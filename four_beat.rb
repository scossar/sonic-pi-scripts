##| Beat Machine function
first_pass = true

##| define :four_beat do |beat_list, te_sample|
define :four_beat do |beat_list|
  beat_list.each_index do |index|
    
    prev_beat = beat_list[index - 1]
    curr_beat = beat_list[index]
    
    if 0 === index
      te_beat = curr_beat[:beat_time]
    else
      te_beat = curr_beat[:beat_time] - prev_beat[:beat_time]
    end
    te_beat
  end
end

define :metronome do
  amp = 0
  four_beat [
    {beat_time: 0, beat_amp: amp},
    {beat_time: 1, beat_amp: amp},
    {beat_time: 2, beat_amp: amp},
    {beat_time: 3, beat_amp: amp}
  ], :tabla_ke2
end

define :hats do
  four_beat [
    {beat_time: 0, beat_amp: 0.5},
    {beat_time: 0.5, beat_amp: 0.9},
    {beat_time: 0, beat_amp: 0.5},
    {beat_time: 0.5, beat_amp: 0.9},
    {beat_time: 1, beat_amp: 0.5},
    {beat_time: 1.5, beat_amp: 0.9},
    {beat_time: 2, beat_amp: 0.5},
    {beat_time: 2.5, beat_amp: 0.9},
    {beat_time: 3, beat_amp: 0.5,},
    {beat_time: 3.5, beat_amp: 0.9}
  ], :perc_snap
end

define :snare do
  four_beat [
    {beat_time: 0, beat_amp: 0.7, beat_echo: [0.333, 0.25, 0.666].choose},
    {beat_time: 3, beat_amp: 1, beat_echo: [0.333, 0.25, 0.666, 0.125].choose}
  ], :sn_dub
  sleep [2, 0].choose
end

define :bass do
  alt_switch = rand
  cue :alt_switch if alt_switch > 0.4
  four_beat [
    {beat_time: 0, beat_amp: 3},
    {beat_time: 1, beat_amp: 3},
    {beat_time: 2, beat_amp: 3},
    {beat_time: 3, beat_amp: 3}
  ], :drum_bass_hard
end

define :triangle do
  four_beat [
    {beat_time: 0, beat_amp: 0.5},
    {beat_time: 0.5, beat_amp: 0.5},
    {beat_time: 1, beat_amp: 0.5},
    {beat_time: 1.5, beat_amp: 0.5},
    {beat_time: 2, beat_amp: 0.5},
    {beat_time: 2.5, beat_amp: 0.5},
    {beat_time: 3, beat_amp: 0.5},
    {beat_time: 3.5, beat_amp: 0.5}
  ], :perc_bell
end

define :lead do
  use_synth :beep
  sleep [0.25, 1.5].choose
  low_int = [2, 6].choose
  high_int = [2, 5].choose
  sleep 1
  play :a4 - low_int, sustain: 0.25
  
  play :a4 + high_int, sustain: 2, decay: [0.5, 0.4].choose
end

define :bass_line do
  use_synth :beep
  play :e4, attack: 0, sustain: 0.5, release: 0.25
  play :d4, attack: 0, sustain: 0.5, release: 0.25
  sleep 1.25
  play :e4, attack: 0, sustain: 0.5, release: 0.25
  play :d4, attack: 0, sustain: 0.5, release: 0.25
end

live_loop :bass do
  bass
end

live_loop :alt do
  sync :alt_switch
  triangle
end




