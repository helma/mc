//#include "midi-seq.h"
#include <GUI.h>

bool record = true;
uint8_t track = 1;
uint8_t volume = 100;
bool noteon[16];
uint8_t pitch[16];
uint8_t idx32 = 0;
uint8_t idx16 = 0;

bool handleEvent(gui_event_t *event) {
  if (EVENT_PRESSED(event, Buttons.BUTTON1)) {
    record != record;
  } 
}

void onNoteOn(uint8_t *msg) {
  if (record) {
    pitch[idx16] = msg[1];
  }
}

void on32Callback(uint32_t counter)  {
  idx32 = (idx32 + 1) % 32;
  if ((idx32 % 2) == 1) { idx16 = idx16 + 1; }
}
/*
  //if !record {
    MidiUart.sendNoteOn(track,notes[idx],volume);
    lastPitch = notes[idx];
  }
}
*/

void setup() {
  MidiClock.mode = MidiClock.EXTERNAL_MIDI;
  MidiClock.start();
}

void loop() {}

/*
void record() {
  NoteHandler noteHandler;
  //uint8_t note = MIDI_NOTE_ON ;
  //noteHandler.onNoteOnCallback(note);
  //uint8_t num = noteHandler.getLastPressedNotes(pitches, velocities, countof(pitches));

};

void play() {
};

//MidiSeq midiSeq;
//midiSeq.record();
//

void ArpeggiatorClass::onNoteOffCallback(uint8_t *msg) {
  removeNote(msg[1]);
}

void ArpeggiatorClass::onNoteOnCallback(uint8_t *msg) {
  if (msg[2] != 0) {
    addNote(msg[1], msg[2]);
  } else {
    removeNote(msg[1]);
  }
}
*/

#include <main.cxx>
