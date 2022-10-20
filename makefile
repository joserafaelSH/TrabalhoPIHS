all: $(f) clean
	as -32 $(f) -o arq.o
	ld -m elf_i386 arq.o -l c -dynamic-linker /lib/ld-linux.so.2 -o arq
	./arq

debug: $(f) clean
	as -32 $(f) -o arq.o -gstabs
	ld -m elf_i386 arq.o -l c -dynamic-linker /lib/ld-linux.so.2 -o arq
	gdb arq

clean:
	if [ -f arq ]; then rm arq; fi;
	if [ -f *.o ]; then rm *.o; fi;
