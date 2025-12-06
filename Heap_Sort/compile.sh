nasm -f elf64 heap_sort.asm -o heap_sort.o
ld heap_sort.o -o heap_sort