[org 0x7c00]  ; 设置程序的起始地址为 0x7c00，这是BIOS加载引导扇区的地址

mov ah, 0x0e  ; 设置AH寄存器为0x0e，表示BIOS的TTY输出功能

; attempt 1
; 尝试1：无论是否使用'org'，都会失败，因为我们仍然在处理指针而不是它指向的数据
mov al, "1"  ; 将字符'1'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'1'
mov al, the_secret  ; 尝试将the_secret的值（一个标签）放入AL寄存器，但这会失败，因为the_secret是一个内存地址
int 0x10     ; 调用BIOS中断0x10，尝试输出AL中的内容，但此时AL中是一个内存地址，不是字符

; attempt 2
; 尝试2：通过'org'解决了内存偏移问题，这是正确的答案
mov al, "2"  ; 将字符'2'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'2'
mov al, [the_secret]  ; 通过内存寻址获取the_secret标签处的数据（字符'X'），并放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'X'

; attempt 3
; 尝试3：正如预期的那样，我们两次添加了0x7c00，所以这不会起作用
mov al, "3"  ; 将字符'3'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'3'
mov bx, the_secret  ; 将the_secret的地址放入BX寄存器
add bx, 0x7c00  ; 错误地再次添加0x7c00到BX寄存器，导致地址错误
mov al, [bx]  ; 尝试通过BX寄存器中的错误地址获取数据，并放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，尝试输出AL中的内容，但此时AL中是错误的数据

; attempt 4
; 尝试4：这仍然有效，因为没有内存引用指针，而是直接传的地址，所以'org'模式从未应用。直接通过字节计数寻址内存总是有效，但不够方便
mov al, "4"  ; 将字符'4'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'4'
mov al, [0x7c2d]  ; 直接通过内存地址0x7c2d获取数据，并放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，输出字符'X'

jmp $  ; 无限循环，跳转到当前指令

the_secret:
    ; ASCII码0x58 ('X')存储在零填充之前。
    ; 在这个代码中，它在字节0x2d处（使用'xxd file.bin'检查）
    db "X"

; 零填充和BIOS魔数
times 510-($-$$) db 0  ; 填充剩余的字节为0，直到510字节
dw 0xaa55  ; 添加BIOS魔数0xaa55，表示这是一个有效的引导扇区