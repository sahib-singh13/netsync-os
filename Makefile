# Path to your cross-compiler
CC = ./toolchain/install/bin/i686-elf-gcc
AS = nasm
LD = ./toolchain/install/bin/i686-elf-gcc

# Compilation Flags
# -ffreestanding: Tells GCC there is no OS
# -nostdlib: Don't link the standard C library
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -ffreestanding -nostdlib -T linker.ld -lgcc

# The final output file name
TARGET = myos.bin
OBJS = boot.o kernel.o 

all: $(TARGET)

# Compile C code
kernel.o: kernel.c
	$(CC) -c kernel.c -o kernel.o $(CFLAGS)

# Assemble bootloader
boot.o: boot.asm
	$(AS) -f elf32 boot.asm -o boot.o

# Link everything together
$(TARGET): $(OBJS)
	$(LD) -o $(TARGET) $(LDFLAGS) $(OBJS)

clean:
	rm -f *.o $(TARGET)

run: $(TARGET)
	qemu-system-i386 -kernel $(TARGET)
