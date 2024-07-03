[bits 16]
; 切换到保护模式（16位模式）
switch_to_pm:
    cli ; 1. 禁用中断
    lgdt [gdt_descriptor] ; 2. 加载全局描述符表（GDT）描述符
    mov eax, cr0
    or eax, 0x1 ; 3. 在cr0寄存器中设置32位模式位
    mov cr0, eax
    jmp CODE_SEG:init_pm ; 4. 使用不同的段进行远跳转

[bits 32]
; 初始化保护模式（32位模式）
init_pm:
    mov ax, DATA_SEG ; 5. 更新段寄存器
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. 将堆栈指针更新到自由空间顶部
    mov esp, ebp

    call BEGIN_PM ; 7. 调用一个已知的标签，其中包含有用的代码