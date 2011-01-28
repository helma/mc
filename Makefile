CC=avr-gcc
CXX=avr-g++
OBJCOPY =avr-objcopy
UISP=uisp
AVR_ARCH = atmega64
F_CPU = 16000000L

CORE = minicommand2
#BASE_DIR = $(HOME)/src/mididuino
BASE_DIR = .
LBASE_DIR = $(BASE_DIR)/libraries

OPTIM=-Os

CFLAGS = -c -g $(OPTIM) -w -ffunction-sections -fdata-sections -mmcu=atmega64 -DF_CPU=16000000L -Wl,--section-start=.bss=0x802000,--defsym=__heap_end=0x80ffff
CXXFLAGS = -c -g $(OPTIM) -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega64 -DF_CPU=16000000L -Wl,--section-start=.bss=0x802000,--defsym=__heap_end=0x80ffff
CLDFLAGS =  $(OPTIM) -Wl,--gc-sections -mmcu=atmega64 -o profileTest.elf -Wl,--section-start=.bss=0x802000,--defsym=__heap_end=0x80ffff

#DIRS = CommonTools Midi GUI SDCard MNM MD MidiTools Elektron
DIRS = CommonTools Midi MidiTools MidiSketches GUI PageTools Sequencer SDCard #Elektron MNMSketches MNM MNMPages LFO 
LDIRS = $(foreach dir,$(DIRS),$(LBASE_DIR)/$(dir)) $(BASE_DIR)/cores/$(CORE)
INCS = $(foreach dir,$(LDIRS),-I$(dir))
OBJS = $(foreach dir,$(LDIRS),$(foreach file,$(wildcard $(dir)/*.cpp),$(subst .cpp,.o,$(file))))
OBJS += $(foreach dir,$(LDIRS),$(foreach file,$(wildcard $(dir)/*.c),$(subst .c,.o,$(file))))

CFLAGS += $(INCS)
CXXFLAGS += $(INCS)

all: main.hex

%.elf: %.o $(OBJS)
	$(CC) $(CLDFLAGS) -o $@ $^ -lm

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp Makefile
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.s Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.s: %.c
	$(CC) -S $(CFLAGS) -fverbose-asm $< -o $@

%.s: %.cpp
	$(CXX) -S $(CXXFLAGS) -fverbose-asm $< -o $@

%.os: %.o
	avr-objdump -S $< > $@

%.elfs: %.elf
	avr-objdump -S $< > $@

%.o: %.S
	$(CC) $(CFLAGS) -Wa,-adhlns=$@.lst -c $< -o $@

%.d:%.c
	set -e; $(CC) -MM $(CFLAGS) $< \
	| sed 's/\($*\)\.o[ :]*/\1.o $@ : /g' > $@ ; \
	[ -s $@ ] || rm -f $@

%.srec: %.elf
	$(OBJCOPY) -j .text -j .data -O srec $< $@

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

%.ee_srec: %.elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O srec $< $@


libclean:
	rm -rf $(OBJS)

clean:
	rm -rf *.os *.o *.elf *.elfs *.lst *.hex
