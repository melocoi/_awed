# _awed
a harmonic series aggregator 

for norns w/grid

<img src="https://github.com/melocoi/_awed/blob/main/cover.png"></img>


<a href="https://youtu.be/SwtadkessjA?si=uh_lT5BKscTG2Giv"> video performance/tutorial </a>

here are some of the key combos that are not in the video, but may be helpful

* K1 + Enc 2 = main buffer Record amplitude
  
  [ indicated on screen by the bg square color ]
  
  will effect how loud the harmonics will be recorded to the buffer.

* K1 + Enc 3 = buffer Preserve amplitude
  
  [ indicated on screen by the size of the circle ]

  will efffect how long the decay of the delay is

* K1 + Enc 1 = main buffer Amplitude

  [ indicated on screen by the color inside the circle ]

  control the overall volume of the recorded buffers



the following allows for quick controls over the buffer length, ( performed in video around 8:06 )

* K2 = set Loop start

* K3 = set Loop end

* K2 (long press > 1 sec) = clears loop length and restores default length set in params menu

* K3 (long press > 1 sec) = clear loop contents, total erasure

for quick reference here are some controls mentioned in the video

* Enc 1 = buffer playback rate
  
  [ indicated on screen by the size of the bg square ]
  
  the rate is quantized to the scale selected for the synth, set in the params menu. Can also adjust the rate slew.

* Enc 2 = synth filter Q factor
  
  [ indicated on screen by thickness of randomly drawn lines ]

  defaults to max value (highets Q factor) turn CW to reduce Q factor

* Enc 3 = softcut filter cutoff frequency of main buffer

  [ indicated on screen by the thickness of the circles border ]

  This filter is quantized to the scale selected for the synth, set in the params menu. This means you will get stepped filter sweeps. Which is an effect I enjoy.

Here is a map of the grid layout

<img src="https://ululo.co/image/_awed_grid_map.png" width=300></img>

Now some info on the different parts of the script...

The script comprises 2 major sections. the Synth and the Tape loop.

.................................................................................

.................................................................................

.................................................................................

# the Synth

The synth engine is based on a band pass filtered saw wave. 

There are two modes available. Percussion mode and Long Tone mode. Selected by the PERC/LONG TOGGLE (displayed above).

Control of the synth is available by using the grid sections ENVELOPE GRID, HARMONICS, and ROOT NOTE (displayed above). As well as a filter resonance control using Enc 2.

The premises of this synth and the way to make sounds and pitches is intimately related to the <a href="https://en.wikipedia.org/wiki/Harmonic_series_(music)">harmonic series</a>. An understanding of which, while not required, can open up some of the possibilities and limitations that are present in this interface. The most basic thing to understand is how a harmonic is a multiple of a root pitch. 

So, the 12th harmonic of a pitch of C2 (65.41Hz) is 784.92Hz (65.41 * 12). You may, or may not, realize that this pitch is not a 'real' note in the equal tempered scale, you can't find this on a piano. But it is a real pitch, and these are the kinds of tones that we get to explore with this interface. 

With this in mind, when playing this synth, we select our pitch, or pitches, through a combination of the ROOT NOTE section, and the HARMONICS section. It is possible to have more than one harmonic selected. But only one root note can be selected. Every time we launch a synth, by pressing one of the ENVELOPE GRID keys, it will randomly pick a harmonic that is activated and multiply it by the root note that is selected. 

synth(FREQ) = (ROOT NOTE) * (random(HARMONIC))


<img src="https://ululo.co/image/_awed_root.png" width=300></img>
root note

<img src="https://ululo.co/image/_awed_harmonics.png" width=300></img>
harmonics


TUNING

_awed has a tuning system that allows you to set the ROOT FREQ directly, entering a number in Hz, or by selecting a ROOT NAME, such as C2 or E3. You also have two modes of temperament, JUST INTONATION and EQUAL TEMPERAMENT. You can refer to other resources for more information on this topic, it is quite a deep rabbit hole, and utterly fascinating. However, for a more immediate and functional understanding, if you want to be in tune with a "traditional" synth, or a piano, or guitar, stick to the ET mode and choosing a ROOT NAME. To be more adventorous, Choose your ROOT FREQ directly and set it to JI. 

You can further customize the 'flavor' of Just Intonation by going into _awed.lua directly, using Maiden, and editing the <i>justI</i> table. it looks like this...


```
-- to change your flavor of Just Intonation
-- Comment and Uncomment the lines to select which JI intervals you want.
-- Or make your own!!!
-------------------------------------------------------------------------------------------------------------
justI = { 1/1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8 } -- "normal"
--justI = { 1/1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 9/5, 15/8 } --"Ptolemy"
--justI = { 1/1, 17/16, 9/8, 19/16, 5/4, 21/16, 11/8, 3/2, 13/8, 27/16, 7/4, 15/8 } --"overtone"
--justI = { 1/1, 16/15, 8/7, 32/27, 16/13, 4/3, 16/11, 32/21, 8/5, 32/19, 16/9, 32/17 } -- "undertone"
```
The final step to the tuning process is to choose your SCALE. At this point you will be ready to play all the notes you could ever dream of, and then some.






