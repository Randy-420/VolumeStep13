include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = volumestepprefs

volumestepprefs_FILES = vspRootListController.m
volumestepprefs_INSTALL_PATH = /Library/PreferenceBundles
volumestepprefs_FRAMEWORKS = UIKit
volumestepprefs_PRIVATE_FRAMEWORKS = Preferences
volumestepprefs_CFLAGS = -fobjc-arc

$(BUNDLE_NAME)_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/volumestepprefs.plist$(ECHO_END)
