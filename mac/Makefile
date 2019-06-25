include ../versions.sh

export PATH:="${PWD}/gcc-install/usr/bin:${PWD}/binutils-install/usr/bin:${PATH}"
export CC=/usr/local/bin/gcc-6
export CXX=/usr/local/bin/g++-6
export CPP=/usr/local/bin/cpp-6
export LD=/usr/local/bin/gcc-6
alias c++=/usr/local/bin/c++-6
alias g++=/usr/local/bin/g++-6
alias gcc=/usr/local/bin/gcc-6
alias cpp=/usr/local/bin/cpp-6
alias ld=/usr/local/bin/gcc-6
alias cc=/usr/local/bin/gcc-6


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
	cd tree-install/usr/local && mv raspbian10-toolchain raspbian10 && tar czf ../../../Raspbian10-Mac-Toolchain-$(V_GCC).tar.gz raspbian10

clean:
	rm -rf binutils* roborio* sysroot* gcc* tree-install gdb* makes/pkg/build *.pkg.tar.gz *-Toolchain-*.tar.gz

