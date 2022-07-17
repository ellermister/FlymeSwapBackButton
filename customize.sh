#MYTMPDIR=/data/local/tmp/FlymeSwapBack
MYTMPDIR=$TMPDIR/FlymeSwapBack
#MYMODDIR=/data/adb/modules/FlymeSwapBack
MYMODDIR=$MODPATH

ui_print "[*]开始制作系统UI文件"
ui_print "[*] 清理缓存"
rm -rf $MYTMPDIR 2>/dev/null
mkdir -p $MYTMPDIR

ui_print "[*] 开始获取系统文件"

cp /system_ext/priv-app/SystemUI/SystemUI.apk SystemUI.apk

ui_print "[*] 解压修改系统资源文件"
unzip SystemUI.apk "res/layout/back.xml"
unzip SystemUI.apk "res/layout/recent_apps.xml" 

mv res/layout/recent_apps.xml res/layout/back_tmp.xml
mv res/layout/back.xml res/layout/recent_apps.xml
mv res/layout/back_tmp.xml res/layout/back.xml


ui_print "[*] 打包系统资源文件"
cp $MYMODDIR/zip zip && chmod 777 ./zip
cp $MYMODDIR/zipalign zipalign && chmod 777 ./zipalign

./zip SystemUI.apk -r res
./zipalign -f 4 SystemUI.apk aligned_SystemUI.apk
cp -rf aligned_SystemUI.apk $MYMODDIR/system/system_ext/priv-app/SystemUI/SystemUI.apk

rm -rf $MYTMPDIR 2>/dev/null

if [ ! -f $MYMODDIR"/system/system_ext/priv-app/SystemUI/SystemUI.apk" ]; then
  ui_print "[*] 制作系统UI资源文件失败"
  exit 1
else
  ui_print "[*] 制作系统UI资源文件成功"
fi
