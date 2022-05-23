SUBPROJECTS += source/cctoggle
SUBPROJECTS += source/extension

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 backboardd"