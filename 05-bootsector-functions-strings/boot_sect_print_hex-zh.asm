; 接收数据到 'dx' 寄存器
; 假设我们调用时 dx=0x1234
print_hex:
    pusha ; 保存所有通用寄存器的值

    mov cx, 0 ; 初始化索引变量 cx 为 0

; 策略：获取 'dx' 的最后一个字符，然后转换为 ASCII
; 数字 ASCII 值：'0' (ASCII 0x30) 到 '9' (0x39)，所以只需将字节 N 加上 0x30。
; 对于字母字符 A-F：'A' (ASCII 0x41) 到 'F' (0x46)，我们将字节 N 加上 0x40
; 然后，将 ASCII 字节移动到结果字符串的正确位置
hex_loop:
    cmp cx, 4 ; 循环 4 次
    je end ; 如果 cx 等于 4，跳转到 end
    
    ; 1. 将 'dx' 的最后一个字符转换为 ASCII
    mov ax, dx ; 使用 'ax' 作为工作寄存器
    and ax, 0x000f ; 通过掩码将前三个字节置零，0x1234 -> 0x0004
    add al, 0x30 ; 将 N 加上 0x30 转换为 ASCII "N"
    cmp al, 0x39 ; 如果大于 9，则需要额外加上 8 以表示 'A' 到 'F'
    jle step2 ; 如果小于等于 9，跳转到 step2
    add al, 7 ; 'A' 的 ASCII 值是 65 而不是 58，所以 65-58=7

step2:
    ; 2. 获取字符串中放置 ASCII 字符的正确位置
    ; bx <- 基地址 + 字符串长度 - 字符索引
    mov bx, HEX_OUT + 5 ; 基地址 + 长度
    sub bx, cx ; 减去索引变量 cx
    mov [bx], al ; 将 'al' 中的 ASCII 字符复制到 'bx' 指向的位置
    ror dx, 4 ; 右移 4 位，0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; 增加索引并循环
    add cx, 1
    jmp hex_loop

end:
    ; 准备参数并调用函数
    ; 记住 print 函数接收参数在 'bx' 中
    mov bx, HEX_OUT
    call print

    popa ; 恢复所有通用寄存器的值
    ret

HEX_OUT:
    db '0x0000',0 ; 为新字符串保留内存