# sonic-pi-scripts

Learning how to use Sonic Pi. These scripts are being altered while live-coding,
so they're a bit of a mess.

There are a few different versions of the `fractal_arp` function. The basic idea
is to apply a pattern repeatedly to a list and then listen to it to see if something
interesting comes out.

To creates notes in the midi range, the function `normalize_ramp` needs to be
applied to the result of the `fractal_arp` function.
