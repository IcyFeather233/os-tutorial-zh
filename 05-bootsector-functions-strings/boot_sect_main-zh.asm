[org 0x7c00] ; 告诉汇编器我们的偏移地址是引导扇区代码的起始地址

; 主程序确保参数准备好，然后调用函数
mov bx, HELLO ; 将字符串 "Hello, World" 的地址存入 bx 寄存器
call print ; 调用打印函数，打印 "Hello, World"

call print_nl ; 调用打印换行函数

mov bx, GOODBYE ; 将字符串 "Goodbye" 的地址存入 bx 寄存器
call print ; 调用打印函数，打印 "Goodbye"

call print_nl ; 调用打印换行函数

mov dx, 0x12fe ; 将十六进制数 0x12fe 存入 dx 寄存器
call print_hex ; 调用打印十六进制数函数，打印 0x12fe

; 完成所有操作，可以挂起了
jmp $ ; 无限循环，挂起

; 记得在挂起后包含子程序
%include "boot_sect_print.asm" ; 包含打印字符串的子程序
%include "boot_sect_print_hex.asm" ; 包含打印十六进制数的子程序

; 数据段
HELLO:
    db 'Hello, World', 0 ; 定义字符串 "Hello, World"，以 0 结尾

GOODBYE:
    db 'Goodbye', 0 ; 定义字符串 "Goodbye"，以 0 结尾

; 填充和魔数
times 510-($-$$) db 0 ; 填充剩余的引导扇区空间，使其达到 510 字节
dw 0xaa55 ; 添加魔数 0xaa55，表示这是一个有效的引导扇区