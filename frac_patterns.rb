load '~/Desktop/sonic_pi/files/frac_arp.rb'

class FracPatterns
  attr_accessor :pat_one, :pat_two, :noise

  def initialize
    @pat_one = frac_arp_alt [0, 5, 0, 5],[2, 0, 3, 0], 32, 72, 58
    @pat_two = frac_arp_alt [7, 5, 5, 5],[0, 2, 7, 11], 64, 76, 58
    @noise = self.rand_pat 124, 50, 100
  end

  def rand_pat(l, min, max)
    output = []
    l.times do
      output.push(Random.rand(min...max))
    end

    output
  end
end
