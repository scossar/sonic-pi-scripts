use_bpm 134

define :ramp_one do |mult|
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

define :mult_up do |mult, min, max|
  pat = []
  curr_inc = min
  while curr_inc < max
    pat.push(curr_inc)
    curr_inc *= mult
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

define :normalize_ramp do |arr, min, max|
  pat = []
  arr.each do |x|
    if x < min
      diff = min - x
      num_octaves = (diff / 12.0).ceil
      puts "NUM OCTAVES #{num_octaves}"
      ##| pat.push(x + (12 * (1 + (diff % 12))))
      pat.push(x + (12 * num_octaves))
    elsif x > max
      diff = x - max
      num_octaves = (diff / 12.0).ceil
      puts "NUM OCTAVES #{num_octaves}"
      ##| pat.push(x - (12 * (1 + (diff % 12))))
      pat.push(x - (12 * num_octaves))
    else
      pat.push(x)
    end
  end
  pat
end

pat = mult_up 1.1225, 44, 70
pat = pat + pat.reverse
pat = normalize_ramp pat, 50, 70

res_pat = ramp_one 0.07
res_pat = filter_ramp res_pat, 0.125, 0.90
res_pat = res_pat + res_pat.reverse

filter_pat = res_pat.map{|x| (x * 50) + 70}

live_loop :arp_test do
  i = tick
  play pat.ring[i], duration: 0.2, release: 0, amp: 1
  play pat.ring[i] + 4, duration: 0.2, release: 0, amp: 0.4
  play pat.ring[i] + 7, duration: 0.2, release: 0, amp: 0.4
  play pat.ring[i] + 10, duration: 0.2, release: 0, amp: 0.4
  play pat.ring[i] + 12, duration: 0.2, release: 0, amp: 0.4
  play pat.ring[i] + [14, 19].choose, duration: 0.2, release: 0, amp: 0.4
  sleep 0.25
end


live_loop :bass do
  sync :bass_drum
  use_synth :subpulse
  i = tick
  bass_opts = {
    attack: 0.1,
    decay: 0.125,
    sustain_level: 0.5,
    release: 0.5,
    pulse_width: 0.5,
    sub_amp: 0.8,
    sub_detune: -0.1,
    cutoff: 44,
    cutoff_slide: 0.0125
  }
  
  s = play (ring :r, 44)[i], bass_opts, duration: 1, amp: 5
  control s, cutoff: 100
  sleep 1
  t = play (ring :r, 46)[i], bass_opts, duration: 1, amp: 5
  control t, cutoff: 100
  sleep 1.5
  u = play 34, bass_opts, duration: 0.5, amp: 5
  control u, cutoff: 100
  sleep 0.5
  v = play 38, bass_opts, duration: (ring 1, 1)[i], amp: 5
  control v, cutoff: 90
  sleep 0.5
  control v, note: (ring 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 36)[i]
  sleep 0.5
end

live_loop :bass_drum do
  sample :bd_haus, amp: (ring 4, 3)[tick]
  sleep 1
end

##| live_loop :snare do
##|   sync :bass_drum
##|   use_synth :noise
##|   with_fx :echo, phase: res_pat.ring[tick], mix: [0, 0, 0.9].choose do
##|     with_fx :rlpf, cutoff: filter_pat.ring[tick], res: res_pat.ring[tick] do
##|       play (ring :r, 60)[tick], attack: 0, decay: (ring 0.03, 0.05)[tick], sustain_level: 0, amp: 42
##|     end
##|   end
##|   sleep 1.5
##| end

##| live_loop :snap do
##|   sync :bass_drum
##|   use_synth :noise
##|   4.times do
##|     sleep 1.0
##|     with_fx :rbpf, centre: 63, res: res_pat.ring[tick] do
##|       play 60, attack: 0, decay: (ring 0.03, 0.03)[tick], sustain_level: 0, amp: 40
##|     end
##|   end

##| end





