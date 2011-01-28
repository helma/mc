#include <NoteHandler.h>
#include <MidiClock.h>


//class MidiSeq : public ClockCallback NoteHandler {
class MidiSeq {

  public:

    uint8_t notes[16];

    void record();
    void play();
};
