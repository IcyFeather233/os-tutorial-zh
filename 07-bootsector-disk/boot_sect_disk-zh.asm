; 加载从驱动器 'dl' 读取的 'dh' 个扇区到 ES:BX
disk_load:
    pusha           ; 保存所有通用寄存器的状态
    ; 从磁盘读取需要设置特定的寄存器值，因此我们会覆盖 'dx' 中的输入参数。
    ; 让我们将其保存到堆栈中以便稍后使用。
    push dx

    mov ah, 0x02    ; ah <- int 0x13 函数。0x02 = '读取'
    mov al, dh      ; al <- 要读取的扇区数量 (0x01 .. 0x80)
    mov cl, 0x02    ; cl <- 扇区 (0x01 .. 0x11)
                    ; 0x01 是我们的引导扇区，0x02 是第一个 '可用' 扇区
    mov ch, 0x00    ; ch <- 柱面 (0x0 .. 0x3FF, 高2位在 'cl' 中)
    ; dl <- 驱动器号。调用者将其作为参数设置并从 BIOS 获取
    ; (0 = 软盘, 1 = 软盘2, 0x80 = 硬盘, 0x81 = 硬盘2)
    mov dh, 0x00    ; dh <- 磁头号 (0x0 .. 0xF)

    ; [es:bx] <- 数据将被存储的缓冲区指针
    ; 调用者为我们设置了这个指针，实际上这是 int 13h 的标准位置
    int 0x13        ; BIOS 中断
    jc disk_error   ; 如果发生错误（存储在进位标志中）

    pop dx
    cmp al, dh      ; BIOS 还将 'al' 设置为读取的扇区数量。比较它。
    jne sectors_error
    popa            ; 恢复所有通用寄存器的状态
    ret

disk_error:
    mov bx, DISK_ERROR ; 将错误信息字符串的地址加载到 bx
    call print         ; 调用打印函数
    call print_nl      ; 调用打印换行函数
    mov dh, ah         ; ah = 错误代码, dl = 发生错误的磁盘驱动器
    call print_hex     ; 打印十六进制错误代码
    jmp disk_loop      ; 跳转到无限循环

sectors_error:
    mov bx, SECTORS_ERROR ; 将错误信息字符串的地址加载到 bx
    call print            ; 调用打印函数

disk_loop:
    jmp $                 ; 无限循环

DISK_ERROR: db "Disk read error", 0 ; 磁盘读取错误信息字符串
SECTORS_ERROR: db "Incorrect number of sectors read", 0 ; 扇区数量错误信息字符串