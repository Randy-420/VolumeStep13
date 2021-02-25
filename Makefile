include $(THEOS)/makefiles/common.mk

INSTALL_TARGET_PROCESSES = springboard

TWEAK_NAME = VolumeStep13
VolumeStep13_FILES = Tweak.xm

VolumeStep13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk