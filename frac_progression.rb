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

##| define :fractal_arp do |pattern, depth|
##|   output = []
##|   pat_length = pattern.length
##|   depth.times do |i|
##|     pattern.each do |p|
##|       if output.empty?
##|         prev_segment = pattern
##|       else
##|         prev_segment_start = output.length - pat_length
##|         prev_segment = output.slice(prev_segment_start..-1)
##|       end
##|       segment = prev_segment.map{|x| x + p}
##|       output += segment
##|     end
##|   end

##|   output
##| end

define :fractal_arp do |pattern, depth|
  output = []
  depth.times do |i|
    if i > 0
      ##| this is moving the pattern around. What else could be done with the pattern?
      pattern = pattern.map{|x| x + i}
    end
    output += pattern
  end
  
  output
end

define :fractal_arp_alt do |pattern, depth|
  output = pattern
  pattern.each do |i|
    pat_segment = []
    depth.times do |d|
      ##| pat_segment += pattern.map{|x| x.to_ + output}
      pat_segment.push(pattern.map{|x| x + output[d] + (! output[i].nil? ? output[i] : 0)})
      puts pat_segment
      output += pat_segment.flatten
    end
  end
  
  output
end
define :fractal_slice do |pattern, min, max, level_length|
  min_pos = min * level_length
  max_pos = (max * level_length -1)
  pattern.slice(min_pos..max_pos)
end

pat = fractal_arp_alt [0, 5, 10, 12, 0, 5, 10, 19], 12
##| pat = fractal_arp_alt [0, 7, 0], 1

pat = normalize_ramp pat, 58, 78
puts pat.length

cut_range = (0..pat.length).to_a.map{|x| x * (1.0 / pat.length)}
cut_range = cut_range.map{|x| x * x}
cut_range = cut_range + cut_range.reverse

##| live_loop :section_slicer do
##|   i = tick % (pat.length / 4)
##|   puts "#{i} and #{i + 1}"
##|   section = fractal_slice pat, i, i + 1, 4
##|   unless section.nil?
##|     play_chord section, attack: 0.03, decay: 0.5, sustain_level: 0
##|   end
##|   play section[2], attack: 0.03, decay: 0.5, sustain_level: 0
##|   sleep (ring 0.5)[i]
##| end

live_loop :player do
  i = tick
  use_synth :pulse
  with_fx :rlpf, cutoff: pat.ring[i] + 10 - rand_i(21), res: 0.96 do
    | play pat.ring[i], attack: 0.03, decay: 0.25, sustain_level: 0, amp: (ring 0.9  )[i]
    ##| play pat.ring[i] + 7, attack: 0.03, decay: 0.25, sustain_level: 0, amp: (ring 0.2)[i]
    ##| play pat.ring[i] + 12, attack: 0.03, decay: 0.25, sustain_level: 0, amp: (ring 0.1)[i]
    ##| play pat.ring[i] + 17, attack: 0.03, decay: 0.25, sustain_level: 0, amp: (ring 0.08)[i]
    # play pat.ring[i] + 24, attack: 0.03, decay: 0.25, sustain_level: 0, amp: (ring 0.08)[i]
    sleep 0.175
  end
end

live_loop :bass do
  sync :player
  i = tick
  cycle = i % 6
  use_synth :pulse
  if 0 === cycle
    with_fx :rlpf, cutoff: pat.ring[i], res: 0.95 do
      play pat.ring[i] - 12, attack: 0.03, decay: 1, sustain_level: 0, amp: (ring 0)[i]
      sleep 0.175
    end
  end
end

live_loop :cha do
  sync :player
  i = tick
  use_synth :noise
  with_fx :rlpf, cutoff: (cut_range.ring[i] * 70) + rand_i(60), res: 0.74, cutoff_slide: 0.125 do |x|
    play 60, attack: 0.01, decay: 0.05, sustain_level: 0, amp: (ring 0)[i]
    control x, cutoff: 50
  end
end






