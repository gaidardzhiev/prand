CC=gcc
CFLAGS=-Wall -Wextra -std=c11 -march=native
BIN=prand
SRC=prand.c

.PHONY: all clean

all: rdrand $(BIN)

rdrand:
	@grep -q rdrand /proc/cpuinfo || \
		(printf "error: the CPU does not support RDRAND instruction...\n"; exit 1)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(BIN)
