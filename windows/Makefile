include ../versions.sh

all: clean sysroot binutils gcc gdb tree zip


sysroot:
	rm -rf sysroot-*
	tar xf ../sysroot-libc-linux.tar.bz2
	makes/sysroot

binutils:
	tar xf ../binutils-$(V_BINUTILS).tar.bz2
	V_BINUTILS=$(V_BINUTILS) makes/binutils

expat-install: expat
expat:
	tar xf ../expat-$(Vw_EXPAT).tar.bz2
	Vw_EXPAT=$(Vw_EXPAT) makes/expat

gdb: expat-install
	tar xf ../gdb-$(V_GDB).tar.gz
	V_GDB=$(V_GDB) makes/gdb

gcc:
	@# gcc does its own extraction
	makes/gcc

tree:
	V_GCC=$(V_GCC) makes/tree

zip:
	cd tree-install/c/Users/Public && zip -r ../../../../Raspbian10-Windows-Toolchain-$(V_GCC).zip .

clean:
	rm -rf binutils* roborio* sysroot* gcc* tree-install expat* gdb* *-Toolchain-*.zip

