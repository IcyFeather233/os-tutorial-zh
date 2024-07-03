gdt_start: ; 不要移除这些标签，它们用于计算大小和跳转
    ; GDT 以一个空的 8 字节开始
    dd 0x0 ; 4 字节
    dd 0x0 ; 4 字节

; GDT 用于代码段。基址 = 0x00000000，长度 = 0xfffff
; 对于标志位，请参考 os-dev.pdf 文档，第 36 页
gdt_code: 
    dw 0xffff    ; 段长度，位 0-15
    dw 0x0       ; 段基址，位 0-15
    db 0x0       ; 段基址，位 16-23
    db 10011010b ; 标志位（8 位）
    db 11001111b ; 标志位（4 位） + 段长度，位 16-19
    db 0x0       ; 段基址，位 24-31

; GDT 用于数据段。基址和长度与代码段相同
; 一些标志位改变了，再次参考 os-dev.pdf
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT 描述符
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; 大小（16 位），总是比实际大小少 1
    dd gdt_start ; 地址（32 位）

; 定义一些常量供以后使用
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start