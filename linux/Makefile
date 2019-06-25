include ../versions.sh

all: clean sysroot binutils gcc gdb tree tarpkg


sysroot:
	rm -rf sysroot-*
	tar xf ../sysroot-libc-linux.tar.bz2
	makes/sysroot

binutils:
	tar xf ../binutils-$(V_BINUTILS).tar.bz2
	V_BINUTILS=$(V_BINUTILS) makes/binutils

gdb:
	tar xf ../gdb-$(V_GDB).tar.gz
	V_GDB=$(V_GDB) makes/gdb

gcc:
	@# gcc does its own extraction
	makes/gcc

tree:
	V_GCC=$(V_GCC) makes/tree

tarpkg:
	cd tree-install/usr/local && mv raspbian10-toolchain raspbian10 && tar czf ../../../Raspbian10-Linux-Toolchain-$(V_GCC).tar.gz raspbian10

clean:
	rm -rf binutils* raspbian* sysroot* gcc* tree-install gdb* *-Toolchain-*.tar.gz

