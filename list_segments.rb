@test = 'this is a test'

define :fractal_arp do |pattern, depth|
  output = []
  depth.times do |i|
    puts i
    if i > 0
      pattern = pattern.map{|x| x + output[i - 1]}
    end
    output += pattern
  end
  
  output
end

define :fractal_slice do |pattern, min, max, level_length|
  min_pos = min * level_length
  max_pos = (max * level_length -1)
  pattern.slice min_pos..max_pos
end


define :normalize_ramp do |arr, min, max|
  pat = []
  arr.each do |x|
    if x < min
      diff = min - x
      num_octaves = (diff / 12.0).ceil
      pat.push(x + (12 * num_octaves))
    elsif x > max
      diff = x - max
      num_octaves = (diff / 12.0).ceil
      pat.push(x - (12 * num_octaves))
    else
      pat.push(x)
    end
  end
  pat
end

define :ramp_one do |mult|
  puts 'calling function'
  pat = []
  curr_inc = mult
  while curr_inc <= 1
    pat.push(curr_inc)
    if curr_inc === 0
      curr_inc = mult
    else
      curr_inc += curr_inc * mult
    end
  end
  pat
end

define :filter_ramp do |arr, min, max|
  pat = []
  arr.each do |x|
    if x >= min && x <= max
      pat.push(x)
    end
  end
  pat
end

define :mult_up do |mult, min, max|
  pat = []
  curr_inc = min
  while curr_inc < max
    pat.push(curr_inc)
    curr_inc *= mult
  end
  
  pat
end

res_pat = ramp_one 0.0125
res_pat = filter_ramp res_pat, 0.025, 0.70

phase_pat = ramp_one 0.06125
phase_pat = filter_ramp phase_pat, 0.125, 0.5
##| phase_pat = phase_pat + phase_pat.reverse

##| base_pat = [2, 14, 12, 10]

##| base_pat = [2, 13, 16, 9]
base_pat = [2, 23]

pat = fractal_arp base_pat, 128
puts pat.length
puts pat


##| pat = fractal_slice pat, 120, 122, 4
##| puts pat.length
pat = fractal_slice pat, 120, 124, 2
##| puts pat.length


puts pat
pat = pat + pat.reverse
pat = normalize_ramp pat, 56, 76

pat_two = fractal_arp [0, 7], 32
pat_two = pat_two + pat_two.reverse
pat_two = normalize_ramp pat_two, 50, 100

cutoff_pat = mult_up 1.0125, 50, 90
cutoff_pat = cutoff_pat + cutoff_pat.reverse


live_loop :pat_test do
  i = tick
  use_synth :pulse
  with_fx :rlpf, cutoff: cutoff_pat.ring[i] + 20, res: res_pat.ring[i] do
    
    ##| play pat.ring[i] - 12, pulse_width: 0.5,  attack: 0.04, decay: 1, sustain_level: 0, amp: 0.4
    ##| play pat.ring[i], pulse_width: 0.5,  attack: 0.04, decay: 1, sustain_level: 0, amp: 0.4
    ##| play pat.ring[i] + 12, pulse_width: 0.5, attack: 0.04, decay: 1, sustain_level: 0, amp: 0.3
    ##| ##| play pat.ring[i] + 31, pulse_width: 0.6, attack: 0.01, decay: 0.6, sustain_level: 0, amp: 0.3
    ##| use_synth :noise
    ##| play 60, pulse_width: 0.5,  attack: 0.04, decay: 1 - res_pat.ring[i], sustain_level: 0, amp: 0.125
  end
  
  sleep (ring 0.25)[i]
end

live_loop :bass do
  sync :pat_test
  use_synth :subpulse
  i = tick
  cycle = i % pat.length
  if cycle === 0
    puts 'test'
    n = (i * 0.25).to_i
    ##| n = (i * (1.0 / pat.length)).to_i
    with_fx :rlpf, cutoff: cutoff_pat.ring[i], res: res_pat.ring[i] do
      play base_pat.ring[0] + 48, pulse_width: 0.8, cutoff: 100, attack: 0.04, decay: pat.length * 2, release: 0, sustain_level: 0, amp: 0.7
      play base_pat.ring[0] + 72, pulse_width: 0.8, cutoff: 100, attack: pat.length, decay: pat.length * 2, release: 0, sustain_level: 0, amp: 0.4
    end
  end
end

live_loop :drum do
  sync :pat_test
  i = tick
  cycle = i % 2
  if cycle === 0
    use_synth :noise
    with_fx :rbpf, centre: 73, res: 0.1 do
      with_fx :echo, phase: phase_pat.ring[i], mix: [0].choose do
        play 60, attack: 0.01, decay: 0.02, sustain_level: 0, amp: [2.9 ].choose
      end
      
    end
  end
end

live_loop :bass_drum do
  sync :pat_test
  i = tick
  cycle = i % 2
  if cycle === 1
    with_fx :rbpf, centre: 42, res: 0.3 do
      play 42, attack: 0.01, decay: 0.01, sustain_level: 0, amp: 2.4
    end
  end
end







