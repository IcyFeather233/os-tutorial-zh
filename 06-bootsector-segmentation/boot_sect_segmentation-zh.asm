; 设置AH寄存器为0x0e，表示BIOS的TTY模式
mov ah, 0x0e

; 将the_secret地址处的字符加载到AL寄存器
mov al, [the_secret]
; 调用BIOS中断0x10，显示字符，但此时DS段寄存器未设置，无法正确寻址
int 0x10

; 设置BX寄存器为0x7c0，这是引导扇区的默认段地址
mov bx, 0x7c0
; 将BX的值加载到DS段寄存器
mov ds, bx
; 警告：从此以后，所有内存引用都将隐式地偏移'ds'
mov al, [the_secret]
; 再次调用BIOS中断0x10，显示字符，这次DS段寄存器已设置，可以正确寻址
int 0x10

; 尝试从ES段寄存器指向的地址加载字符到AL寄存器
mov al, [es:the_secret]
; 调用BIOS中断0x10，显示字符，但此时ES段寄存器未设置，默认为0x000，无法正确寻址
int 0x10

; 设置BX寄存器为0x7c0
mov bx, 0x7c0
; 将BX的值加载到ES段寄存器
mov es, bx
; 从ES段寄存器指向的地址加载字符到AL寄存器
mov al, [es:the_secret]
; 调用BIOS中断0x10，显示字符，这次ES段寄存器已设置，可以正确寻址
int 0x10

; 无限循环，防止程序继续执行
jmp $

; 定义一个标签the_secret，并存储字符"X"
the_secret:
    db "X"

; 填充剩余的510字节，确保引导扇区大小为512字节
times 510 - ($-$$) db 0
; 添加引导扇区的标志，表示这是一个有效的引导扇区
dw 0xaa55