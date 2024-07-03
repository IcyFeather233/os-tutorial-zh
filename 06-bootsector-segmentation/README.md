*你可能想在之前谷歌的概念：分段*

**目标：学习如何在16位实模式下使用分段处理内存**

如果你对分段很熟悉，可以跳过这一课。

我们在第三课中使用了`[org]`进行了分段。分段意味着你可以为所有引用的数据指定一个偏移量。

这是通过使用特殊寄存器来完成的：`cs`、`ds`、`ss`和`es`，分别用于代码、数据、堆栈和额外（即用户定义的）。

注意：它们是由CPU*隐式*使用的，所以一旦你为某个寄存器设置了某个值，比如`ds`，那么你所有的内存访问都会被`ds`偏移。[阅读更多这里](http://wiki.osdev.org/Segmentation)

此外，为了计算实际地址，我们不仅仅是将两个地址连接起来，而是*重叠*它们：`segment << 4 + address`。例如，如果`ds`是`0x4d`，那么`[0x20]`实际上指的是`0x4d0 + 0x20 = 0x4f0`。

理论足够了。看看代码并稍微玩一下。

`nasm -fbin boot_sect_segmentation.asm -o boot_sect_segmentation.bin`

`qemu boot_sect_segmentation.bin` 或 `qemu-system-x86_64 boot_sect_segmentation.bin`

提示：我们不能直接将字面量移动到这些寄存器中，必须先使用一个通用寄存器。