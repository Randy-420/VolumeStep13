TARGET = iphone:clang:11.2:11.0
ARCHS = arm64 arm64e
BUNDLE_NAME = vscc

$(BUNDLE_NAME)_FILES = vscc.m
$(BUNDLE_NAME)_CFLAGS += -fobjc-arc
$(BUNDLE_NAME)_INSTALL_PATH = /Library/ControlCenter/Bundles/
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = ControlCenterUIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"