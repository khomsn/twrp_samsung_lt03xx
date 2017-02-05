#!/bin/sh
#
# applypatch.sh
# apply patches
#

dir=`cd $(dirname $0) && pwd`
top=$dir/../../../..

if [ -n "$(find $dir -name \*.patch -type f)" ]; then
    echo "*** Patching ***"
    for patch in `ls $dir/*.patch` ; do
        echo ""
        echo "==> patch file: ${patch##*/}"
        patch -p1 -N -i $patch -r - -d $top
    done

    echo "*** Patching Done ***"
    find . -name "*.orig" -delete
else
    echo "*** No patches ***"
fi

cp -f $dir/OswaldCondensed-Regular.ttf $top/bootable/recovery/gui/theme/common/fonts/RobotoCondensed-Regular.ttf
cp -f $dir/ru.xml $top/bootable/recovery/gui/theme/common/languages/ru.xml
