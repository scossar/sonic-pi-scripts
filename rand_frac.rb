def rand_pat(len, max, min)
  output = []
  len.times do
    output.push(Random.rand(min...max + 1))
  end

  output
end

def normalize_val(val, max, min) 
  if val < min
    diff = min - val
    num_octaves = (diff / 12).ceil
    val + (12 * num_octaves)
  elsif val > max
    diff = val - max
    num_octaves = (diff / 12).ceil
    val - (12 * num_octaves)
  else
    val
  end
end

def normalize_pat(pat)
  pat.each_with_index.map do |seg, i|
    if i > 0
      if seg[0] > pat[i - 1][0] + 2
        seg = seg.map{|x| x - 1}
      elsif seg[0] < pat[i - 1][0] + 2
        seg = seg.map{|x| x + 1}
      end
    end
    seg
  end
end

def simple_normalize_pat(pat)
  initial = pat[0][0]
  pat.each_with_index.map do |seg, i|
    if i > 0
      if seg[0] > initial
        seg = seg.map{|x| x - 1}
      elsif seg[0] < initial
        seg = seg.map{|x| x + 1}
      end
    end

    seg
  end
end

def flatten_pat(pat)
  pat.map do |seg|
    seg = seg.each_with_index.map do |e, i|
      if i > 0
        if e < seg[0]
          e += 1
        elsif e > seg[0]
          e -= 1
        end
      end
      e
    end
    seg 
  end
end

def rand_arp(pat, r_pat, prob, max, min)
  output = []
  r_pat.each do |e|
    if prob > rand(10)
      segment = pat.map{|x| normalize_val(x + e, max, min)}
      # segment = segment + segment.reverse
    else
      segment = pat.map{Random.rand(min...max + 1)}
      # segment = segment + segment.reverse
    end
    output.push(segment)
  end

  output
end

