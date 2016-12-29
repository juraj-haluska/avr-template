DEVICE     = atmega328
PROGRAMMER = usbasp
CLOCK      = 1
FILENAME   = main
#LIB1	   = uart/uart
#LIB2	   = ad7542/ad7542
COMPILE    = avr-gcc -Wall -Os -Wstrict-prototypes -g -mmcu=$(DEVICE)

all: build upload clean
	
build:
	# compile and don't link
	$(COMPILE) -c $(FILENAME).c -o $(FILENAME).o
	#$(COMPILE) -c $(LIB1).c -o $(LIB1).o
	#$(COMPILE) -c $(LIB2).c -o $(LIB2).o

	# link to binary .elf
	$(COMPILE) -o $(FILENAME).elf $(FILENAME).o 

	# convert .elf to .hex
	avr-objcopy -j .text -j .data -O ihex $(FILENAME).elf $(FILENAME).hex
	avr-size --format=avr --mcu=$(DEVICE) $(FILENAME).elf

upload:
	avrdude -v -p $(DEVICE) -c $(PROGRAMMER) -F -B $(CLOCK) -U flash:w:$(FILENAME).hex:i 

clean:
	rm main.o
	rm main.elf
	rm main.hex
