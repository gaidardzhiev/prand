# High Quality Hardware Based Pseudo Random String Generator

Prand is a lightweight C utility that produces high quality randomness by leveraging the **RDRAND** CPU instruction, which generates entropy directly from the processor's hardware random number generator. This hardware RNG draws entropy from physical phenomena such as thermal noise within the CPU silicon, providing cryptographically strong random values efficiently and securely.

## Features

- Utilizes Intel (and compatible AMD) CPUs’ RDRAND instruction for true hardware based randomness.
- Bypasses software only pseudorandom number generators by obtaining entropy directly from the CPU's built in entropy source.
- Produces randomness compliant with standards such as NIST SP 800-90A, FIPS 140-2, and ANSI X9.82 via the underlying hardware RNG design.
- Suitable for cryptographic applications, secure key generation, and any context requiring high quality entropy.
- Simple and fast, relying on a hardware entropy source operating asynchronously at gigabit speeds.
- Automatically handles reseeding and mixing internally within the CPU hardware.
- Generates human readable random printable strings without spaces for easy usage in passwords or tokens.
- Detects and reports failures of the underlying RDRAND instruction to ensure reliability.

## Background

The RDRAND instruction, introduced by Intel starting from Ivy Bridge processors and supported by AMD Zen and newer CPUs, invokes a hardware random number generator seeded by nondeterministic entropy sources like thermal noise and ring oscillator jitter.

This hardware RNG uses dedicated circuits and cryptographic conditioning (AES-based CBC-MAC extractors combined with AES-CTR deterministic random bit generators) to produce statistically strong and unpredictable random numbers. Because the entropy source and conditioning are embedded in the processor hardware, software can directly access high quality entropy without relying entirely on external or slower entropy sources.

The RDSEED instruction complements RDRAND by exposing raw entropy for seeding other PRNGs, though at a lower throughput. RDRAND is the recommended instruction for most applications needing immediate random values.

## Example Usage

Build and run `prand` to generate a 32 character pseudo random printable string directly from hardware entropy:

```
git clone https://github.com/gaidardzhiev/prand
cd prand
make
./prand
```

## How It Works

The program uses the `_rdrand32_step()` intrinsic to get 32 bit hardware generated random values. It fills a buffer with random printable characters (excluding spaces) by:

- Calling RDRAND repeatedly to obtain 32 bit random numbers.
- Mapping those numbers to bytes and checking if they are printable characters.
- Ignoring non printable characters or spaces to produce a clean, readable string.
- Printing the resulting null terminated string of length 32.

If the RDRAND instruction fails, the program prints an error message and exits, ensuring the user is aware of hardware RNG issues.

## Requirements

- Intel Ivy Bridge or newer CPU, or AMD Zen or newer CPU, supporting the `RDRAND` instruction.
- Compiler that supports `<x86intrin.h>` and the `_rdrand32_step()` intrinsic (e.g., `GCC` or `Clang` on `x86_64`).
- Compatible operating system.

## Disclaimer

Although RDRAND provides strong hardware entropy, it is recommended to combine multiple entropy sources and apply defense in depth strategies, especially in highly sensitive cryptographic applications.

## References & Further Reading

- Intel Digital Random Number Generator (DRNG) Software Implementation Guide  
- Linux kernel usage of RDRAND for entropy  
- [RDRAND on Wikipedia](https://en.wikipedia.org/wiki/RDRAND)  
- NIST SP 800-90A compliance and cryptographic validation  

## License

This project is provided under the GPL3 License.
