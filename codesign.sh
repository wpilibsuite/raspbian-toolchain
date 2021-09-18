#!/bin/bash
source versions.sh

sign_directory()
{
    find $1 | while read fname; do
        if [[ -f $fname ]]; then
            echo "[INFO] Signing $fname"
            codesign --force --strict --timestamp --options=runtime -s $2 $fname
        fi
    done
}

cd mac
tar -pxvzf Raspbian10-Mac-Toolchain-${V_GCC}.tar.gz
sign_directory "raspbian10/bin" $1
sign_directory "raspbian10/arm-linux-gnueabihf/bin" $1
sign_directory "raspbian10/libexec/gcc/arm-linux-gnueabihf/${V_GCC}" $1
tar -pcvzf Raspbian10-Mac-Toolchain-${V_GCC}.tar.gz raspbian10
rm -rf raspbian10
