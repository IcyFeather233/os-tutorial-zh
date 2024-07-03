[bits 32] ; 使用32位保护模式

; 定义常量
VIDEO_MEMORY equ 0xb8000 ; 视频内存的起始地址
WHITE_ON_BLACK equ 0x0f ; 每个字符的颜色属性，白色字体黑色背景

; 打印字符串的函数
print_string_pm:
    pusha ; 保存所有通用寄存器
    mov edx, VIDEO_MEMORY ; 将视频内存的起始地址加载到edx寄存器

print_string_pm_loop:
    mov al, [ebx] ; 从ebx指向的地址读取一个字符到al寄存器
    mov ah, WHITE_ON_BLACK ; 将颜色属性加载到ah寄存器

    cmp al, 0 ; 检查是否到达字符串的末尾（以0结尾）
    je print_string_pm_done ; 如果是0，跳转到结束处理

    mov [edx], ax ; 将字符和属性存储到视频内存中
    add ebx, 1 ; 移动到下一个字符
    add edx, 2 ; 移动到视频内存中的下一个位置（每个字符占两个字节）

    jmp print_string_pm_loop ; 继续循环

print_string_pm_done:
    popa ; 恢复所有通用寄存器
    ret ; 返回