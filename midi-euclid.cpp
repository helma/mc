#include <MidiEuclidSketch.h>

PitchEuclidSketch sketch;

void setup() {
  sketch.setup();
  GUI.setSketch(&sketch);
  MidiClock.mode = MidiClock.EXTERNAL_MIDI;
  MidiClock.start();
}

void loop() {
}

#include <main.cxx>
