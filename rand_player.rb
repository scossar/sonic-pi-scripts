load '~/Desktop/sonic_pi/files/rand_frac.rb'

use_bpm 134

r_pat = rand_pat(8, 78, 62)
arp_template = [0, 6, 4, 10]
initial_pat = rand_arp arp_template, r_pat, 0, 78, 62

initial_pat = initial_pat.flatten
pass = 0
repeats = 0

rand_rev_template = rand_pat(32, 12, 0)
rev_pat = reverse_rand_arp arp_template, rand_rev_template, 5, 53, 0
rev_pat = rev_pat.flatten

comment do
live_loop :reverse do
  i = tick
  @current_rev_pat = @current_rev_pat || rev_pat.dup
  durr = i > 0 ?  (((i  / (initial_pat.length * 24.0)) * (i / (initial_pat.length * 24.0))) * 0.5) + 0.08 : 0.08
  cycle = i % 8
  if cycle === 0
    pass += 1
    if pass <= 10
      @current_rev_pat = reverse_rand_arp arp_template, rand_rev_template, 5, 60, pass
    else
      @current_rev_pat = simple_normalize_pat @current_rev_pat
    end
  end
  play @current_rev_pat.flatten.ring[i], attack: 0.02, decay: durr, sustain_level: 0
 sleep durr
end
end

uncomment do
live_loop :frac_pat do
  i = tick
  durr = 0.25
  # durr = i > 0 ?  (((i  / (8 * 24.0)) * (i / (8 * 24.0))) * 0.5) + 0.08 : 0.08
  @current_pat = @current_pat || initial_pat.dup
  cycle = i % 4
  # Find the start of the cycle
  if cycle === 0
    pass += 1
    if pass <= 10
      @current_pat = rand_arp arp_template, r_pat, pass, 78, 62
    else
      @current_pat = normalize_pat @current_pat
      # Find some way of knowing when the pattern has been normalized.
      uncomment do
        # if pass > 20
          # @current_pat = flatten_pat @current_pat
          # if @current_pat.uniq.length === 1
          if @current_pat == normalize_pat(@current_pat)
            repeats += 1
            puts "repeats #{repeats}"
            if repeats === 4
              @current_pat = rand_arp arp_template, r_pat, pass, 78, 62
              pass = 0
              repeats = 0
            end
          end
        # end
      end
    end
  end
  
  single_notes = @current_pat.flatten.ring
  use_synth :pulse
  amp = [0.5, 0.5, 0.9, 0.5].ring[i]
  with_fx :rlpf, cutoff: single_notes[i], res: 0.4 do
    play single_notes[i] - 12, pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp
    play single_notes[i], pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp
    play single_notes[i] + 12, pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp
    play single_notes[i] + 16, pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp * 0.7
    play single_notes[i] + 19, pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp * 0.5
    play single_notes[i] + 22, pulse_width: 0.2, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp * 0.4
    play single_notes[i] + 26, pulse_width: 0.7, attack: 0.06, decay: durr * 2, sustain_level: 0, amp: amp * 0.3
  end

  sleep durr
end
end
