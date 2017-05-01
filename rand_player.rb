load '~/Desktop/sonic_pi/files/rand_frac.rb'

use_bpm 134

r_pat = rand_pat(4, 78, 62)
arp_template = [0, 2, 4, 7, 10, 12]
initial_pat = rand_arp arp_template, r_pat, 0, 72, 52

initial_pat = initial_pat.flatten
pass = 0
repeats = 0
pat_set = false

uncomment do
live_loop :frac_pat do
  i = tick
  # durr = 0.25
  durr = i > 0 ?  (((i / (6 * 24.0)) * (i / (6 * 24.0))) * 0.5) + 0.25 : 0.25
  @current_pat = @current_pat || initial_pat.dup
  cycle = i % 6
  # Find the start of the cycle
  if cycle === 0
    pass += 1
    if pass <= 10
      @current_pat = rand_arp arp_template, r_pat, pass, 72, 52
    else
      pat_set = true
      @current_pat = normalize_pat @current_pat
      uncomment do
        if @current_pat == normalize_pat(@current_pat)
          repeats += 1
          if repeats === 16
            pat_set = false
            @current_pat = rand_arp arp_template, r_pat, pass, 78, 52
            pass = 0
            repeats = 0
            tick_set 0
          end
        end
      end
    end
  end
  
  single_notes = @current_pat.flatten.ring
  use_synth :pulse
  amp = 1
  with_fx :rlpf, cutoff: single_notes[i] + 20, res: 0.6 do
    with_fx :distortion, distort: 0.7, mix: 0.7 do
      play single_notes[i] + 12, pulse_width: 0.2, attack: 0.01, decay: durr * 2, sustain_level: 0, amp: amp
    end

    if pat_set === true && i % 6 === 0
      play single_notes[i] - 12, attack: 0.01, pulse_width: 0.2, decay: 3, sustain_level: 0, amp: 0.4
      play single_notes[i], attack: 0.01, pulse_width: 0.2, decay: 3, sustain_level: 0, amp: 0.4
    end
  end

  sleep durr
end
end

