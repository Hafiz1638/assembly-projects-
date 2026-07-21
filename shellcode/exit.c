#include <stdio.h>
#include <string.h>

__attribute__((section(".text")))
unsigned char code[] = "\x48\x31\xc0\xb0\x3c\x48\x31\xff\x0f\x05";

int main() {
    printf("shellcode length %ld\n", strlen(code));
    int (*ret)() = (int (*)())code;
    ret();
    return 0;
}
