*你可能想事先谷歌的概念：栈*

**目标：学习如何使用栈**

栈的使用非常重要，所以我们将编写另一个引导扇区示例。

记住，`bp` 寄存器存储栈的基地址（即底部），`sp` 存储栈顶，栈从 `bp` 向下增长（即 `sp` 递减）。

这节课非常直接，所以直接跳到代码部分。

我建议你在代码的不同点尝试访问栈内存地址，看看会发生什么。

`nasm -fbin boot_sect_stack.asm -o boot_sect_stack.bin`

`qemu boot_sect_stack.bin` 或 `qemu-system-x86_64 boot_sect_stack.bin`

运行后显示 `A CBA `