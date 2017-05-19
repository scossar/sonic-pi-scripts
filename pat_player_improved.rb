define :pat_player do |pattern, i, args = {}|
  
  if args[:remove_pipes]
    pat = pattern.tr('|', '') if args[:remove_pipes]
  else
    pat = pattern
  end
  
  rate = args[:rate] ? args[:rate] : 1
  amp = args[:amp] ? args[:amp] : 1
  
  pos = i % pat.length
  
  if rev_elements = args[:reverse]
    rate *= -1 if rev_elements.include? pos
  end
  
  e = pat[pos]
  
  case e
  
  when 'x'
    sample :drum_cymbal_closed, amp: 0.7 * amp, rate: rate
  when 'X'
    sample :drum_cymbal_closed, amp: 1 * amp, rate: rate
    
  when 's'
    sample :drum_snare_hard, amp: 0.7 * amp, rate: rate
  when 'S'
    sample :drum_snare_hard, amp: 1 * amp, rate: rate
    
  when 'b'
    sample :drum_bass_hard, amp: 0.7 * amp, rate: rate
  when 'B'
    sample :drum_bass_hard, amp: 1 * amp, rate: rate
    
  when 'i'
    sample :elec_pop, amp: 0.7 * amp, rate: rate
  when 'I'
    sample :elec_pop, amp: 1 * amp, rate: rate
    
  when 'c'
    sample :drum_cowbell, amp: 0.5 * amp, rate: rate
  when 'C'
    sample :drum_cowbell, amp: 1 * amp, rate: rate
    
  when 'p'
    sample :perc_snap, amp: 0.5 * amp, rate: rate
  when 'P'
    sample :perc_snap, amp: 1 * amp, rate: rate
    
  when 'l'
    sample :elec_ping, amp: 0.5 * amp, rate: rate
  when 'L'
    sample :elec_ping, amp: 1 * amp, rate: rate
    
  when 'o'
    sample :drum_cymbal_open, amp: 0.5 * amp, rate: rate
  when 'O'
    sample :drum_cymbal_open, amp: 1 * amp, rate: rate
  end
  
end

##############################################
# Loop
##############################################

use_bpm 134

# Assign `tick` to a variable to keep the patterns in sync.
# If `remove_pipes` is set in the arguments hash, pipe characters added to the pattern will be stripped before the pattern is played.
# Adding, and then removing pipes may make the patterns easier to read, but it is also less efficient.

live_loop :drum_pat_test do
  i = tick
  pat_player '----x---|---xX---|----x---|---xX---', i, {rate: 1, amp: 3 + rand(0.2), remove_pipes: 1}
  pat_player 'B-------|b-----B-', i, {amp: 1.4, remove_pipes: 1}
  pat_player '--s-----|--s-S--s|--s----S|--s-s--S', i, {amp: 0.9, remove_pipes: 1}
  pat_player 'l---llLl|l---l---|l---l---|l---lcCc', i, {amp: 0.7, remove_pipes: 1}
  sleep 0.25
end














