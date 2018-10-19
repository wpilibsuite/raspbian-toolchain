#!/bin/zsh
source versions.sh

THIS_DIR="$PWD"

# clean up old files
rm -rf repack

if [[ `gcc -dumpmachine` == *apple* ]]
then
	echo "Aliasing ar and tar to use GNU variants gar and gtar..."
	alias ar=gar
	alias tar=gtar
fi

mkdir -p repack/out
mv *.deb repack/

pushd repack
	for file in *.deb; do
		ar x $file
		
		# don't need these
		rm control.tar.gz debian-binary
		pushd out
			tar xf ../data.tar.xz
		popd
		# clean up
		rm data.tar.xz
		mv $file "$THIS_DIR/"
	done
popd

# clean up
rm -rf repact/out/etc
rm -rf repack/out/bin
rm -rf repack/out/sbin
rm -rf repack/out/libexec
rm -rf repack/out/usr/bin
rm -rf repack/out/usr/sbin
rm -rf repack/out/usr/share
rm -rf repack/out/usr/libexec
rm -rf repack/out/etc
# remove all empty dirs (semi-recursive)
rm -d repack/out/*(/^F)

# move "6" to "6.3.0" directories
#rm repack/out/usr/lib/gcc/arm-linux-gnueabihf/6.3.0
mv repack/out/usr/lib/gcc/arm-linux-gnueabihf/6 repack/out/usr/lib/gcc/arm-linux-gnueabihf/6.3.0
rm repack/out/usr/include/arm-linux-gnueabihf/c++/6.3.0
mv repack/out/usr/include/arm-linux-gnueabihf/c++/6 repack/out/usr/include/arm-linux-gnueabihf/c++/6.3.0
rm repack/out/usr/include/c++/6.3.0
mv repack/out/usr/include/c++/6 repack/out/usr/include/c++/6.3.0

# move the arm-linux-gnueabihf libs to arm-raspbian9-linux-gnueabihf
mv repack/out/lib/arm-linux-gnueabihf/* repack/out/lib/
mv repack/out/usr/lib/arm-linux-gnueabihf/debug/* repack/out/usr/lib/debug/
rmdir repack/out/usr/lib/arm-linux-gnueabihf/debug
mv repack/out/usr/lib/arm-linux-gnueabihf/* repack/out/usr/lib/
mv repack/out/usr/lib/gcc/arm-linux-gnueabihf repack/out/usr/lib/gcc/arm-raspbian9-linux-gnueabihf

# copy the arm-linux-gnueabihf headers to arm-raspbian9-linux-gnueabihf
# (we copy instead of move so gdb can find the originals)
cp -Rp repack/out/usr/include/arm-linux-gnueabihf/* repack/out/usr/include/

# change absolute symlinks into relative symlinks
pushd repack/out/lib
rm ld-linux-armhf.so.3
ln -s ld-2.24.so ld-linux-armhf.so.3
popd

pushd repack/out/usr/lib
rm libanl.so
rm libBrokenLocale.so
rm libcidn.so
rm libcrypt.so
rm libdl.so
rm libm.so
rm libnsl.so
rm libnss_compat.so
rm libnss_dns.so
rm libnss_files.so
rm libnss_hesiod.so
rm libnss_nisplus.so
rm libnss_nis.so
rm libresolv.so
rm librt.so
rm libthread_db.so
rm libutil.so
ln -s ../../lib/libanl.so.1 libanl.so
ln -s ../../lib/libBrokenLocale.so.1 libBrokenLocale.so
ln -s ../../lib/libcidn.so.1 libcidn.so
ln -s ../../lib/libcrypt.so.1 libcrypt.so
ln -s ../../lib/libdl.so.2 libdl.so
ln -s ../../lib/libm.so.6 libm.so
ln -s ../../lib/libnsl.so.1 libnsl.so
ln -s ../../lib/libnss_compat.so.2 libnss_compat.so
ln -s ../../lib/libnss_dns.so.2 libnss_dns.so
ln -s ../../lib/libnss_files.so.2 libnss_files.so
ln -s ../../lib/libnss_hesiod.so.2 libnss_hesiod.so
ln -s ../../lib/libnss_nisplus.so.2 libnss_nisplus.so
ln -s ../../lib/libnss_nis.so.2 libnss_nis.so
ln -s ../../lib/libresolv.so.2 libresolv.so
ln -s ../../lib/librt.so.1 librt.so
ln -s ../../lib/libthread_db.so.1 libthread_db.so
ln -s ../../lib/libutil.so.1 libutil.so
popd

pushd repack/out/usr/lib/gcc/arm-raspbian9-linux-gnueabihf/6.3.0
rm libasan.so
rm libatomic.so
rm libgcc_s.so.1
rm libgomp.so
rm libstdc++.so
rm libubsan.so
ln -s ../../../libasan.so.3 libasan.so
ln -s ../../../libatomic.so.1 libatomic.so
ln -s ../../../../../lib/libgcc_s.so.1 libgcc_s.so.1
ln -s ../../../libgomp.so.1 libgomp.so
ln -s ../../../libstdc++.so.6 libstdc++.so
ln -s ../../../libubsan.so.0 libubsan.so
popd

pushd repack/out/usr/lib
sed -i 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libc.so
sed -i 's/\/lib\/arm-linux-gnueabihf\//..\/..\/lib\//g' libc.so
sed -i 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libpthread.so
sed -i 's/\/lib\/arm-linux-gnueabihf\//..\/..\/lib\//g' libpthread.so
popd

pushd repack
	mv out sysroot-libc-linux
	tar cjf "${THIS_DIR}/sysroot-libc-linux.tar.bz2" sysroot-libc-linux --owner=0 --group=0
popd
