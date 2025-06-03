# Makefile based on RISC-V In a Nutshell course (RVVIAN) examples

# RISC-V C Compiler
# available options (the version used must support RVV intrinsics)
# GNU Compiler Collection (GCC)
RISCVCC=riscv64-unknown-elf-gcc
CFLAGS=-O2 -march=rv64gcv

# architectural parameters for the simulation
# width of vector registers (VLEN)
VLEN?=128

# path to proxy-kernel (pk)
PK_PATH=/opt/riscv/riscv64-unknown-elf/bin/pk64

# SIMULATOR
# Available options in the Docker (uncomment one)
SIMULATOR=spike --isa=rv64gcv_zicntr_zihpm_zvl$(VLEN)b_zve32f $(PK_PATH)

# Version (uncomment one)
# Assembler version:
OBJS=vector_saxpy.o saxpy_vec.o
# Intrinsics version:
#OBJS=vector_saxpy.o
#CFLAGS+= -DINTRINSICS

# Rules
all: sim_vector_saxpy

saxpy_vec.o: saxpy_vec.s
	 $(RISCVCC) $(CFLAGS) $^ -c

vector_saxpy.o: vector_saxpy.c
	 $(RISCVCC) $(CFLAGS) $^ -c

vector_saxpy: $(OBJS)
	 $(RISCVCC) $(CFLAGS) $(OBJS) -o $@

sim_vector_saxpy: vector_saxpy
	$(SIMULATOR) $^

clean:
	rm -f *.o vector_saxpy

.PHONY: sim_vector_saxpy clean