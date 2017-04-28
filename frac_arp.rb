
# On each iteration, adds the pattern to the previous iteration.
def frac_arp(pattern, depth, max, min)
  output = []
  pattern = pattern.map{|x| normalize_val x, max, min}
  output.push(pattern)
  depth.times do |i|
    # pattern = pattern.each_with_index.map do |x, pi|
    pattern = pattern.each_with_index.map do |x, pi|
      val = x  + output[i - 1][pi]

      normalize_val val, max, min
    end
    output.push(pattern)
  end

  # output.flatten
  output.shift(1)
  output
end

def frac_arp_alt(pattern, alt, depth, max, min)
  output = []
  pattern = pattern.map{|x| normalize_val x, max, min}
  alt = alt.map{|x| normalize_val x, max, min}
  output.push(pattern)
  (depth).times do |i|
    pattern = pattern.each_with_index.map do |x, ai|
      val = x + output[i - 1][ai] + alt[ai]

      normalize_val val, max, min
    end
    output.push(pattern)
  end

  # output.flatten
  output.shift(1)
  output
end


def normalize_val(val, max, min)
  if val < min
    diff = min - val
    num_octaves = (diff / 12.0).ceil
    val + (12 * num_octaves)
    # val
  elsif val > max
    diff = val - max
    num_octaves = (diff / 12.0).ceil
    val - (12 * num_octaves)
    # val
  else
    val
  end
end

