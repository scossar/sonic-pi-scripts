@test = 'this is a test'

define :fractal_arp do |pattern, depth|
  output = []
  depth.times do |i|
    if i > 0
      pattern = pattern.map{|x| x + output[i - 1]}
    end
    output += pattern
  end
  
  output
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
res_pat = filter_ramp res_pat, 0.125, 0.90

##| base_pat = [2, 7, 12, 7]
base_pat = [2, 12]

pat = fractal_arp base_pat, 16
pat = pat + pat.reverse
pat = normalize_ramp pat, 54, 70
puts pat

pat_two = fractal_arp [0, 12, 0], 32
pat_two = pat_two + pat_two.reverse
pat_two = normalize_ramp pat_two, 40, 90

cutoff_pat = mult_up 1.0123, 40, 100
cutoff_pat = cutoff_pat + cutoff_pat.reverse


live_loop :pat_test do
  i = tick
  use_synth :pulse
  with_fx :rlpf, cutoff: cutoff_pat.ring[i], res: res_pat.ring[i] do
    
    play pat.ring[i], pulse_width: 0.6,  attack: 0.01, decay: 1, sustain_level: 0, amp: 1
    play pat.ring[i] + 12, pulse_width: 0.6,  attack: 0.01, decay: 1, sustain_level: 0, amp: 0.5
    play pat.ring[i] + 24, pulse_width: 0.6, attack: 0.01, decay: 1, sustain_level: 0, amp: 0.7
    play pat.ring[i] + 31, pulse_width: 0.6, attack: 0.01, decay: 0.6, sustain_level: 0, amp: 0.3
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
    play base_pat.ring[n] + 48, pulse_width: 0.8, cutoff: 60, attack: 0.04, decay: pat.length - 1, release: 0, sustain_level: 0, amp: 0.7
  end
  
end






