define :pat_player do |pattern, i, args = {}|
  pat = parse_pattern pattern, args
  pos = i % pat.length
  e = pat.ring[i]
  rate = args[:rate] ? args[:rate] : 1
  echo_phase = 1
  echo_mix = 0
  amp = args[:amp] ? args[:amp] : 1
  
  if rev_elements = args[:reverse]
    rate *= -1 if rev_elements.include? pos
  end
  
  if echo_elements = args[:echo]
    echo_phase = echo_elements[pos]
    echo_mix = echo_phase && args[:echo_mix] ? args[:echo_mix] : 1
  end
  
  with_fx :echo, phase: echo_phase, mix: echo_mix do
    case e
    
    when :x
      sample :drum_cymbal_closed, amp: 0.5 * amp, rate: rate
    when :X
      sample :drum_cymbal_closed, amp: 1 * amp, rate: rate
      
    when :s
      sample :drum_snare_hard, amp: 0.7 * amp, rate: rate
      
    when :S
      sample :drum_snare_hard, amp: 1 * amp, rate: rate
      
    when :r
      sample :drum_roll, amp: 0.5 * amp, rate: rate
    when :R
      sample :drum_roll, amp: 1 * amp, rate: rate
      
    when :b
      sample :drum_bass_hard, amp: 0.7 * amp, rate: rate
      cue :bass_drum
    when :B
      sample :drum_bass_hard, amp: 1 * amp, rate: rate
      cue :bass_drum
      
    when :i
      sample :elec_pop, amp: 0.7 * amp, rate: rate
    when :I
      sample :elec_pop, amp: 1 * amp, rate: rate
      
    when :c
      sample :drum_cowbell, amp: 0.5 * amp, rate: rate
    when :C
      sample :drum_cowbell, amp: 1 * amp, rate: rate
      
    when :p
      sample :perc_snap, amp: 0.5 * amp, rate: rate
    when :P
      sample :perc_snap, amp: 1 * amp, rate: rate
      
    when :l
      sample :elec_ping, amp: 0.5 * amp, rate: rate
    when :L
      sample :elec_ping, amp: 1 * amp, rate: rate
      
    when :o
      sample :drum_cymbal_open, amp: 0.5 * amp, rate: rate
    when :O
      sample :drum_cymbal_open, amp: 1 * amp, rate: rate
    end
  end
end

define :parse_pattern do |pattern, args|
  pattern.tr('|', '').split('').map do |x|
    x.to_sym
  end
end


##############################################
# Loop
##############################################


live_loop :drum_pat_test do
  i = tick
  pat_player 'X-x-|X-x-|X-x-|X-x-|X-x-|X-x-|X-o-|X-x-', i, {rate: 1, amp: 1.2 + rand(0.2)}
  pat_player 'P---|p---|P---|p---|P---|p---|P---|p---', i, {amp: 1.1 + rand(0.2)}
  pat_player '---s|----|--s-|----|---s|----|----|-sS-', i, {amp: 1 + rand(0.2), rate: 1, reverse: [10], echo: {10 => [0.125, 0.25].choose}}
  pat_player 'b---|----|----|----|b---|----|B---|----', i, {amp: 1.4, echo: {16 => [0.5, 0.125].choose}}
  pat_player '----|--c-|', i, {amp: 0.3}
  pat_player 'l--l|', i, {amp: 0.5, rate: 1}
  
  sleep 0.125 - rand(0.0005)
end

live_loop :bass_line do
  i = tick
  sync :bass_drum
  use_synth :pulse
  
  bass_notes = [38, 45, 48, 50, 50, 48, 45, 38].ring
  loop_tick = 0
  (ring, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 16, 16, 16, 16, 16, 16)[i].times do
    
    play note: bass_notes[i + loop_tick], pulse_width: 0.4, attack: 0.01, decay: 0.127, sustain_level: 0, amp: 0.9
    play note: bass_notes[i + loop_tick] + 12, pulse_width: 0.4, attack: 0.01, decay: 0.127, sustain_level: 0, amp: 0.5
    
    loop_tick += 1
    sleep 0.125
    
  end
  
end















