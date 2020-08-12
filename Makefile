DEBUG=0
FINALPACKAGE=1
include $(THEOS)/makefiles/common.mk

export ARCHS = armv7 armv7s arm64 arm64e
INSTALL_TARGET_PROCESSES = springboard

TWEAK_NAME = VolumeStep13
VolumeStep13_FILES = Tweak.xm

$(BUNDLE_NAME)_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += volumestepprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
