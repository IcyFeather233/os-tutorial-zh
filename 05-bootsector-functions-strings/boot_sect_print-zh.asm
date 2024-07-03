; 打印字符串的汇编代码
; 这段代码通过BIOS中断0x10来打印字符串

print:
    pusha  ; 保存所有通用寄存器的状态

; 记住这个逻辑：
; while (string[i] != 0) { print string[i]; i++ }

; 字符串结束的比较（空字节）
start:
    mov al, [bx] ; 将字符串的当前字符（位于地址bx）加载到al寄存器
    cmp al, 0    ; 比较al寄存器中的字符是否为0（即字符串结束）
    je done      ; 如果是0，跳转到done标签

    ; 使用BIOS中断0x10来打印字符
    mov ah, 0x0e ; 设置ah寄存器为0x0e，表示TTY模式
    int 0x10     ; 调用BIOS中断0x10，打印al寄存器中的字符

    ; 增加指针并进行下一次循环
    add bx, 1    ; 增加bx寄存器的值，指向下一个字符
    jmp start    ; 跳转到start标签，继续循环

done:
    popa         ; 恢复所有通用寄存器的状态
    ret          ; 返回调用者

; 打印换行符的汇编代码
print_nl:
    pusha        ; 保存所有通用寄存器的状态
    
    mov ah, 0x0e ; 设置ah寄存器为0x0e，表示TTY模式
    mov al, 0x0a ; 将换行符（LF）加载到al寄存器
    int 0x10     ; 调用BIOS中断0x10，打印换行符
    mov al, 0x0d ; 将回车符（CR）加载到al寄存器
    int 0x10     ; 调用BIOS中断0x10，打印回车符
    
    popa         ; 恢复所有通用寄存器的状态
    ret          ; 返回调用者