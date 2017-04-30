load '~/Desktop/sonic_pi/files/rand_frac.rb'

use_bpm 134

r_pat = rand_pat(4, 78, 62)
arp_template = [0, 4, 7, 11]
initial_pat = rand_arp arp_template, r_pat, 0, 78, 62

initial_pat = initial_pat.flatten
pass = 0

live_loop :frac_pat do
  i = tick
  durr = 0.25
  # durr = i > 0 ?  (((i  / (initial_pat.length * 24.0)) * (i / (initial_pat.length * 24.0))) * 0.5) + 0.08 : 0.08
  @current_pat = @current_pat || initial_pat.dup
  cycle = i % initial_pat.length
  # Find the start of the cycle
  if cycle === 0
    pass += 1
    if pass <= 10
      @current_pat = rand_arp arp_template, r_pat, pass, 78, 62
    else
      @current_pat = simple_normalize_pat @current_pat
      # Find some way of knowing when the pattern has been normalized.
      uncomment do
        if pass > 20
          @current_pat = flatten_pat @current_pat
        end
      end
    end
  end
  
  single_notes = @current_pat.flatten.ring
  use_synth :pulse
  with_fx :rlpf, cutoff: single_notes[i], res: 0.6 do
    play single_notes[i] - 12, pulse_width: 0.6, attack: 0.03, decay: durr, sustain_level: 0, amp: 0.9
    play single_notes[i], pulse_width: 0.6, attack: 0.03, decay: durr, sustain_level: 0, amp: 0.9
  end

  sleep durr
end

