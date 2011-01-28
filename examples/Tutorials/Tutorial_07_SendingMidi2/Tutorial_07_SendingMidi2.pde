RangeEncoder param1(0, 127, "P1");
RangeEncoder param2(0, 127, "P2");
EncoderPage page(&param1, &param2);

void setup() {
  GUI.setPage(&page);
}

void loop() {
  if (param1.hasChanged()) {
    MidiUart.sendCC(1, param1.getValue());
  }
  if (param2.hasChanged()) {
    MidiUart.sendCC(2, param2.getValue());
  }
}

bool handleEvent(gui_event_t *evt) {
  if (EVENT_PRESSED(evt, Buttons.BUTTON1)) {
    MidiUart.sendNoteOn(1, 100);
    return true;
  }
  if (EVENT_RELEASED(evt, Buttons.BUTTON1)) {
    MidiUart.sendNoteOff(1);
    return true;
  }
  
  return false;
}

