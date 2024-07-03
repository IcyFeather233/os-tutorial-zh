[org 0x7c00] ; 设置程序的加载地址为0x7c00，这是BIOS加载bootloader的标准地址

    mov bp, 0x9000 ; 设置栈底指针
    mov sp, bp     ; 设置栈顶指针，栈从0x9000开始向下增长

    mov bx, MSG_REAL_MODE ; 将消息字符串的地址加载到bx寄存器
    call print ; 调用打印函数，打印消息字符串

    call switch_to_pm ; 调用函数切换到32位保护模式
    jmp $ ; 无限循环，实际上这段代码永远不会被执行，因为切换到保护模式后会跳转到BEGIN_PM

%include "../05-bootsector-functions-strings/boot_sect_print.asm" ; 包含16位模式下的打印函数
%include "../09-32bit-gdt/32bit-gdt.asm" ; 包含32位保护模式的全局描述符表（GDT）设置
%include "../08-32bit-print/32bit-print.asm" ; 包含32位模式下的打印函数
%include "32bit-switch.asm" ; 包含切换到32位保护模式的函数

[bits 32] ; 切换到32位模式
BEGIN_PM: ; 切换到保护模式后跳转到这里
    mov ebx, MSG_PROT_MODE ; 将消息字符串的地址加载到ebx寄存器
    call print_string_pm ; 调用32位模式下的打印函数，打印消息字符串
    jmp $ ; 无限循环

MSG_REAL_MODE db "Started in 16-bit real mode", 0 ; 定义消息字符串，表示启动在16位实模式
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0 ; 定义消息字符串，表示加载到32位保护模式

; bootsector
times 510-($-$$) db 0 ; 填充剩余的bootsector空间为0，直到510字节
dw 0xaa55 ; 设置bootsector的最后两个字节为0xaa55，这是BIOS识别引导扇区的标志