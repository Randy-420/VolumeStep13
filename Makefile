DEBUG=0
FINALPACKAGE=1
include $(THEOS)/makefiles/common.mk

export ARCHS = armv7 armv7s arm64 arm64e
INSTALL_TARGET_PROCESSES = springboard

TWEAK_NAME = VolumeStep13_14
$(TWEAK_NAME)_FILES = Tweak.xm vsSettings.m

$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += vscc
include $(THEOS_MAKE_PATH)/aggregate.mk

.PHONY: check-and-reinit-submodules
check-and-reinit-submodules: \
@if (git submodule status | egrep -q '^[-]|^[+]'); then \
echo "INFO: Need to reinitialize git submodules"; \
git submodule update --init; \
fi