CC=gcc
CFLAGS=-Wall -Wextra -std=c11
BIN=prand
SRC=prand.c

.PHONY: all clean

all: check_rdrand $(BIN)

check_rdrand:
	@grep -q rdrand /proc/cpuinfo || \
		(printf "error: the CPU does not support RDRAND instruction...\n"; exit 1)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -march=native -o $@ $<

clean:
	rm -f $(TARGET)
