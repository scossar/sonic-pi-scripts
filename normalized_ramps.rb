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

pat = mult_up 1.25, 44, 200
pat = normalize_ramp pat, 50, 70
puts pat

live_loop :arp_test do
  i = tick
  play pat.ring[i], duration: 0.2, release: 0, amp: 1
  play pat.ring[i] + 4, duration: 0.2, release: 0, amp: 0.3
  play pat.ring[i] + 7, duration: 0.2, release: 0, amp: 0.3
  play pat.ring[i] + 10, duration: 0.2, release: 0, amp: 0.3
  play pat.ring[i] + 12, duration: 0.2, release: 0, amp: 0.3
  play pat.ring[i] + [14, 19].choose, duration: 0.2, release: 0, amp: 0.4
  sleep 0.25
end


live_loop :bass do
  use_synth :subpulse
  bass_opts = {
    attack: 0.1,
    decay: 0.125,
    sustain_level: 0.5,
    release: 0.5,
    pulse_width: 0.5,
    sub_amp: 0.8,
    sub_detune: -0.1,
    cutoff: 44,
    cutoff_slide: 0.125
  }
  
  s = play 44, bass_opts, duration: 1, amp: 4
  control s, cutoff: 80
  sleep 1
  t = play 46, bass_opts, duration: 1, amp: 4
  control t, cutoff: 72
  sleep 1.5
  u = play 32, bass_opts, duration: 0.5, amp: 4
  control u, cutoff: 68
  sleep 0.5
  v = play 38, bass_opts, duration: 1, amp: 4
  control v, cutoff: 60
  sleep 1
end

live_loop :bass_drum do
  sample :bd_haus, amp: 3
  sleep 1
end
