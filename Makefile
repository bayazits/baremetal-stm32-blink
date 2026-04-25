# Toolchain definition
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld

# Flags
CFLAGS = -mcpu=cortex-m4 -mthumb -g
# -nostdlib: Don't use standard libraries or startup files
# -lgcc: Still include low-level GCC helper functions if needed
LDFLAGS = -T linker.ld -nostdlib -lgcc


# Directories
OBJ_DIR = obj
BIN_DIR = bin

# Files
TARGET = $(BIN_DIR)/firmware.elf
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/startup.o

# Default rule
all: $(BIN_DIR) $(OBJ_DIR) $(TARGET)

# Create directories if they don't exist
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Link object files to create the final ELF
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $(TARGET)

# Compile C source files
$(OBJ_DIR)/main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o $(OBJ_DIR)/main.o

# Assemble startup code
$(OBJ_DIR)/startup.o: startup.s
	$(AS) startup.s -o $(OBJ_DIR)/startup.o

# Clean build artifacts
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean
