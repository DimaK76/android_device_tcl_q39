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

### Patches
git -C packages/apps/LockClock		apply ~/RR/device/tcl/q39/patcher/patches/packages-apps-LockClock0.patch
git -C packages/apps/Settings/src/com/android/settings		apply ~/RR/device/tcl/q39/patcher/patches/DevelopmentSettings0.patch

git -C system/core/liblog/		apply ~/RR/device/tcl/q39/patcher/patches/logprint0.patch
git -C system/core/rootdir/		apply ~/RR/device/tcl/q39/patcher/patches/init0.patch
