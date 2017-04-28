load '~/Desktop/sonic_pi/files/frac_patterns.rb'
use_bpm 138

frac_patterns = FracPatterns.new


##| pat_one = frac_arp_alt [0, 5],[5, 0], 16, 72, 58
pat_one = frac_patterns.pat_one
pat_one = pat_one.flatten

pat_two = frac_patterns.pat_two
chord_pat = frac_patterns.pat_one
pat_two = pat_two.flatten

# pat_noise = frac_patterns.noise
# pat_noise = pat_two

##| pat_one = pat_one + pat_one.reverse
##| filt_pat = (0..64).to_a.map{|x| (60 * (x / 64.0)) + 64}
filt_pat = (0..200).to_a.map{|x| ((((x / 200.0)) * (x / 200.0)) * 60) + 50}
filt_pat = filt_pat.flatten
filt_pat = filt_pat + filt_pat.reverse

live_loop :drums do
  i = tick
  n =  pat_two.ring[i]
  sample :bd_fat, amp: 3 if i % 4 === 0
  with_fx :echo, phase: 0.5, mix: 0.125 do
    sample :drum_snare_hard, amp: 2 if n === pat_two[0]
  end
  sample :drum_cymbal_open, amp: 1.4 if n === pat_two[1]
  sample :drum_cymbal_closed, amp: 2 if n === pat_two[2]
  sample :tabla_tas2, amp: 1.4 if n === pat_two[3]
  sleep 0.5
end

live_loop :frac do
  sync :drums
  i = tick
  n = pat_one.ring[i]
  use_synth :pulse
  uncomment do
    play n - 24, pulse_width: 0.2, attack: 0.01, decay: 0.4, sustain_level: 0, amp: 1.2
    play n - 12, pulse_width: 0.2, attack: 0.02, decay: 0.4, sustain_level: 0, amp: 1.2
     uncomment do
      with_fx :rlpf, cutoff: filt_pat.ring[i], res: n === pat_one[2] ? 0.98 : 0.5 do
        play n + 19, pulse_width: 0.2, attack: 0, dcay: 0.4, sustain_level: 0, amp: 0.6
        play n + 12, pulse_width: 0.2, attack: 0, decay: 0.125, sustain_level: 0, amp: 0.7
      end
    end
    
  end
end

live_loop :frac_lead do
  sync :drums
  i = tick
  n = chord_pat.ring[i]
  use_synth :pulse
  with_fx :rlpf, cutoff: 70, res: 0.7 do
    play_chord n, pulse_width: 0.3, attack:16, decay: 16, sustain_level: 0, amp: 0.7 if i % 16 === 7
  end
end
