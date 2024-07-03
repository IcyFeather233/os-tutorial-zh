[org 0x7c00]  ; 设置程序的起始地址为 0x7c00，这是 BIOS 加载引导扇区的地址

    mov bp, 0x8000  ; 设置基址指针（bp）为 0x8000，确保栈远离我们的代码区域
    mov sp, bp      ; 设置栈指针（sp）为 bp 的值，即 0x8000

    mov bx, 0x9000  ; 设置 bx 寄存器为 0x9000，这是我们将要读取的内存地址
    mov dh, 2       ; 设置 dh 寄存器为 2，表示要读取 2 个扇区
    ; BIOS 会设置 'dl' 寄存器为我们的启动磁盘号
    ; 如果你遇到问题，可以使用 '-fda' 标志：'qemu -fda file.bin'
    call disk_load  ; 调用 disk_load 函数，从磁盘读取数据到内存

    mov dx, [0x9000]  ; 将内存地址 0x9000 处的值加载到 dx 寄存器，这是第一个加载的字，值为 0xdada
    call print_hex    ; 调用 print_hex 函数，打印 dx 寄存器中的十六进制值

    call print_nl     ; 调用 print_nl 函数，打印换行符

    mov dx, [0x9000 + 512]  ; 将内存地址 0x9000 + 512 处的值加载到 dx 寄存器，这是第二个加载扇区的第一个字，值为 0xface
    call print_hex          ; 调用 print_hex 函数，打印 dx 寄存器中的十六进制值

    jmp $  ; 无限循环，$ 表示当前地址

%include "../05-bootsector-functions-strings/boot_sect_print.asm"  ; 包含打印字符串的函数
%include "../05-bootsector-functions-strings/boot_sect_print_hex.asm"  ; 包含打印十六进制值的函数
%include "boot_sect_disk.asm"  ; 包含从磁盘加载数据的函数

; Magic number
times 510 - ($-$$) db 0  ; 填充剩余的 510 字节为 0，确保引导扇区大小为 512 字节
dw 0xaa55  ; 设置引导扇区的 magic number，表示这是一个有效的引导扇区

; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...
times 256 dw 0xdada  ; 填充 sector 2 的 512 字节，每个字为 0xdada
times 256 dw 0xface  ; 填充 sector 3 的 512 字节，每个字为 0xface