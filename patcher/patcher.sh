#!/bin/sh

# Apply these patches before compilation:

cd ~/RR

# Clean up first
git -C packages/apps/LockClock		clean -dfqx
git -C packages/apps/LockClock		reset -q --hard
git -C packages/apps/Settings/src/com/android/settings		clean -dfqx
git -C packages/apps/Settings/src/com/android/settings		reset -q --hard

git -C system/core/liblog		clean -dfqx
git -C system/core/liblog		reset -q --hard
git -C system/core/rootdir		clean -dfqx
git -C system/core/rootdir		reset -q --hard

git -C build    clean -dfqx
git -C build    reset -q --hard

git -C frameworks/base/telephony/java/android/telephony/		clean -dfqx
git -C frameworks/base/telephony/java/android/telephony/		reset -q --hard
git -C frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles/		clean -dfqx
git -C frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles/		reset -q --hard
git -C frameworks/base/libs/androidfw/   clean -dfqx
git -C frameworks/base/libs/androidfw/   reset -q --hard

### Patches
git -C packages/apps/LockClock		apply ~/RR/device/tcl/q39/patcher/patches/packages-apps-LockClock0.patch
git -C packages/apps/Settings/src/com/android/settings		apply ~/RR/device/tcl/q39/patcher/patches/DevelopmentSettings0.patch

git -C system/core/liblog/		apply ~/RR/device/tcl/q39/patcher/patches/logprint0.patch
git -C system/core/rootdir/		apply ~/RR/device/tcl/q39/patcher/patches/init0.patch

git -C build/core/clang/    apply ~/RR/device/tcl/q39/patcher/patches/CLANG0.patch
git -C build/core/    apply ~/RR/device/tcl/q39/patcher/patches/block0.patch

git -C frameworks/base/telephony/java/android/telephony/		apply ~/RR/device/tcl/q39/patcher/patches/SignalStrength0.patch
git -C frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles/		apply ~/RR/device/tcl/q39/patcher/patches/MusicTile0.patch
git -C frameworks/base/libs/androidfw/   apply ~/RR/device/tcl/q39/patcher/patches/AssetManager0.patch
