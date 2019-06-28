#!/bin/zsh
source versions.sh

THIS_DIR="$PWD"

# clean up old files
rm -rf repack

if [[ `gcc -dumpmachine` == *apple* ]]
then
	echo "Aliasing ar and tar to use GNU variants gar and gtar..."
	alias ar=/usr/local/opt/binutils/bin/gar
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
rm -rf repack/out/etc
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

# move "6" to "8.3.0" directories
#rm repack/out/usr/lib/gcc/arm-linux-gnueabihf/8.3.0
mv repack/out/usr/lib/gcc/arm-linux-gnueabihf/8 repack/out/usr/lib/gcc/arm-linux-gnueabihf/8.3.0
rm repack/out/usr/include/arm-linux-gnueabihf/c++/8.3.0
mv repack/out/usr/include/arm-linux-gnueabihf/c++/8 repack/out/usr/include/arm-linux-gnueabihf/c++/8.3.0
rm repack/out/usr/include/c++/8.3.0
mv repack/out/usr/include/c++/8 repack/out/usr/include/c++/8.3.0

# change absolute symlinks into relative symlinks
pushd repack/out/usr/lib/arm-linux-gnueabihf
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
ln -s ../../../lib/arm-linux-gnueabihf/libanl.so.1 libanl.so
ln -s ../../../lib/arm-linux-gnueabihf/libBrokenLocale.so.1 libBrokenLocale.so
ln -s ../../../lib/arm-linux-gnueabihf/libcidn.so.1 libcidn.so
ln -s ../../../lib/arm-linux-gnueabihf/libcrypt.so.1 libcrypt.so
ln -s ../../../lib/arm-linux-gnueabihf/libdl.so.2 libdl.so
ln -s ../../../lib/arm-linux-gnueabihf/libm.so.6 libm.so
ln -s ../../../lib/arm-linux-gnueabihf/libnsl.so.1 libnsl.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_compat.so.2 libnss_compat.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_dns.so.2 libnss_dns.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_files.so.2 libnss_files.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_hesiod.so.2 libnss_hesiod.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_nisplus.so.2 libnss_nisplus.so
ln -s ../../../lib/arm-linux-gnueabihf/libnss_nis.so.2 libnss_nis.so
ln -s ../../../lib/arm-linux-gnueabihf/libresolv.so.2 libresolv.so
ln -s ../../../lib/arm-linux-gnueabihf/librt.so.1 librt.so
ln -s ../../../lib/arm-linux-gnueabihf/libthread_db.so.1 libthread_db.so
ln -s ../../../lib/arm-linux-gnueabihf/libutil.so.1 libutil.so
popd

pushd repack/out/usr/lib/gcc/arm-linux-gnueabihf/8.3.0
rm libasan.so
rm libatomic.so
rm libgcc_s.so.1
rm libgomp.so
rm libstdc++.so
rm libubsan.so
ln -s ../../../arm-linux-gnueabihf/libasan.so.3 libasan.so
ln -s ../../../arm-linux-gnueabihf/libatomic.so.1 libatomic.so
ln -s ../../../../../lib/arm-linux-gnueabihf/libgcc_s.so.1 libgcc_s.so.1
ln -s ../../../arm-linux-gnueabihf/libgomp.so.1 libgomp.so
ln -s ../../../arm-linux-gnueabihf/libstdc++.so.6 libstdc++.so
ln -s ../../../arm-linux-gnueabihf/libubsan.so.0 libubsan.so
popd

cp patches/libpthread.so usr/lib/arm-linux-gnueabihf/libpthread.so

pushd repack/out/usr/lib/arm-linux-gnueabihf
if [[ `gcc -dumpmachine` == *apple* ]]
then
sed -i '' -e 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libc.so
sed -i '' -e 's/\/lib\//..\/..\/..\/lib\//g' libc.so
sed -i '' -e 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libpthread.so
sed -i '' -e 's/\/lib\//..\/..\/..\/lib\//g' libpthread.so
else
sed -i 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libc.so
sed -i 's/\/lib\//..\/..\/..\/lib\//g' libc.so
sed -i 's/\/usr\/lib\/arm-linux-gnueabihf\///g' libpthread.so
sed -i 's/\/lib\//..\/..\/..\/lib\//g' libpthread.so
fi
popd

pushd repack
	mv out sysroot-libc-linux
	tar cjf "${THIS_DIR}/sysroot-libc-linux.tar.bz2" sysroot-libc-linux --owner=0 --group=0
popd
