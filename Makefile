ARDUINO_PATH = /home/rigidus/build/arduino-1.8.6
PROJECT_PATH = /home/rigidus/repo/ardn
AVRTOOLS_PATH = hardware/tools/avr
PROGRAM = blnk
MCU = attiny13
CC = $(ARDUINO_PATH)/$(AVRTOOLS_PATH)/bin/avr-gcc
OBJCOPY = avr-objcopy
CFLAGS += -Wall -g -Os -mmcu=$(MCU) -I$(ARDUINO_PATH)/$(AVRTOOLS_PATH)/avr/include
LDFLAGS +=
OBJS = $(PROGRAM).o

all: $(PROGRAM).hex

$(PROGRAM).elf: $(PROGRAM).o
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(PROGRAM).hex: $(PROGRAM).elf
	$(Q)$(OBJCOPY) -O ihex $< $@

%.o: %.c
	$(Q)$(CC) $(CFLAGS) -o $@ -c $<

flash: $(PROGRAM).hex
	$(ARDUINO_PATH)/$(AVRTOOLS_PATH)/bin/avrdude \
	-C$(ARDUINO_PATH)/$(AVRTOOLS_PATH)/etc/avrdude.conf \
	-v               \
	-pattiny13       \
	-carduino        \
	-P/dev/ttyUSB0   \
	-b19200 -Uflash:w:$(PROJECT_PATH)/$(PROGRAM).hex:i

clean:
	$(Q)rm -f $(OBJS)
	$(Q)rm -f *.elf
	$(Q)rm -f *.hex
