mov ah, 0x0e  ; 设置AH寄存器为0x0e，表示BIOS的TTY模式，用于在屏幕上打印字符

; attempt 1
; 尝试打印字符'1'和内存地址'the_secret'的内容
; 失败的原因是它试图打印内存地址（即指针），而不是实际内容
mov al, "1"  ; 将字符'1'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印字符'1'
mov al, the_secret  ; 将'the_secret'的内存地址放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，尝试打印内存地址（失败）

; attempt 2
; 尝试打印内存地址'the_secret'的内容
; 这是正确的方法，但BIOS将我们的引导扇区二进制文件放在地址0x7c00
; 所以我们需要事先添加这个偏移量。我们将在尝试3中这样做
mov al, "2"  ; 将字符'2'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印字符'2'
mov al, [the_secret]  ; 将'the_secret'内存地址的内容放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，尝试打印内容（失败，因为缺少偏移量）

; attempt 3
; 将BIOS起始偏移量0x7c00添加到'the_secret'的内存地址
; 然后解引用该指针的内容
; 我们需要使用不同的寄存器'bx'，因为'mov al, [ax]'是非法的
; 一个寄存器不能同时作为源和目标
mov al, "3"  ; 将字符'3'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印字符'3'
mov bx, the_secret  ; 将'the_secret'的内存地址放入BX寄存器
add bx, 0x7c00  ; 添加偏移量0x7c00到BX寄存器
mov al, [bx]  ; 将BX寄存器指向的内存地址的内容放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印内容（成功）

; attempt 4
; 我们尝试一个捷径，因为我们知道'X'存储在我们的二进制文件的第0x2d字节
; 这很聪明但效率低下，我们不想每次更改代码时都重新计算标签偏移量
mov al, "4"  ; 将字符'4'的ASCII码放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印字符'4'
mov al, [0x7c2d]  ; 将地址0x7c2d的内容放入AL寄存器
int 0x10     ; 调用BIOS中断0x10，打印内容（成功，但不推荐）

jmp $  ; 无限循环，防止程序继续执行

the_secret:
    ; ASCII码0x58 ('X')存储在零填充之前
    ; 在这个代码中，它在第0x2d字节（使用'xxd file.bin'检查）
    db "X"

; 零填充和BIOS魔数
times 510-($-$$) db 0  ; 填充零，直到文件大小为512字节减去2字节
dw 0xaa55  ; 添加BIOS魔数0xaa55，表示这是一个有效的引导扇区