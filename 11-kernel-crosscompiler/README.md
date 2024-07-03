*你可能想事先谷歌的概念：交叉编译器*

**目标：创建一个开发环境来构建你的内核**

如果你使用的是Mac，你需要立即进行这个过程。否则，它可能会等到几节课后再进行。无论如何，一旦我们跳到使用更高级别的语言（即C语言）进行开发，你将需要一个交叉编译器。[阅读为什么](http://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F)

我将改编[OSDev wiki上的说明](http://wiki.osdev.org/GCC_Cross-Compiler)。

所需包
--------

首先，安装所需的包。在Linux上，使用你的包分发工具。在Mac上，如果你在第00课中没有安装[brew](http://brew.sh/)，请安装它，并使用`brew install`获取这些包：

- gmp
- mpfr
- libmpc
- gcc

是的，我们将需要`gcc`来构建我们的交叉编译`gcc`，特别是在Mac上，gcc已经被弃用，取而代之的是`clang`。

安装完成后，找到你的包`gcc`的位置（记住，不是`clang`）并导出它。例如：

```
export CC=/usr/local/bin/gcc-4.9
export LD=/usr/local/bin/gcc-4.9
```

我们需要构建binutils和一个交叉编译的gcc，并将它们放入`/usr/local/i386elfgcc`，所以现在让我们导出一些路径。你可以随意更改它们。

```
export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
export PATH="$PREFIX/bin:$PATH"
```

binutils
--------

记住：在从互联网粘贴大段文本之前，一定要小心。我建议逐行复制。

```sh
mkdir /tmp/src
cd /tmp/src
curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz # 如果链接404，请寻找更新的版本
tar xf binutils-2.24.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.24/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
make all install 2>&1 | tee make.log
```

gcc
---
```sh
cd /tmp/src
curl -O https://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2
tar xf gcc-4.9.1.tar.bz2
mkdir gcc-build
cd gcc-build
../gcc-4.9.1/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-headers
make all-gcc 
make all-target-libgcc 
make install-gcc 
make install-target-libgcc 
```

就是这样！你应该在`/usr/local/i386elfgcc/bin`中拥有所有的GNU binutils和编译器，前缀为`i386-elf-`，以避免与系统编译器和binutils发生冲突。

你可能想将`$PATH`添加到你的`.bashrc`中。从现在开始，在本教程中，我们将明确使用前缀来使用交叉编译的gcc。