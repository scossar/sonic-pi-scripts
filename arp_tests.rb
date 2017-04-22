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

define :fractal_arp do |pattern, depth|
  output = []
  pat_length = pattern.length
  depth.times do |i|
    pattern.each do |p|
      if output.empty?
        prev_segment = pattern
      else
        prev_segment_start = pat_length * (i - 1)
        prev_segment = output.slice(prev_segment_start..-1)
      end
      segment = prev_segment.map{|x| x + p}
      output += segment
    end
  end
  
  output
end

##| pat = fractal_arp [2, 4], 3
##| puts pat
##| puts pat.length

##| pat = normalize_ramp pat, 50, 90
##| puts pat

##| pat.each do |p|
##|   play p
##|   sleep 0.5
##| end
