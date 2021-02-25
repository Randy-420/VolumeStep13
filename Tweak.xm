#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

static BOOL GetBool(NSString *key, BOOL defaultValue) {
	Boolean exists;
	Boolean result = CFPreferencesGetAppBooleanValue((CFStringRef)key, CFSTR("com.randy420.volumestepprefs"), &exists);
	return exists ? result : defaultValue;
}

static float GetFloat(NSString *key, float defaultValue) {
	id value = (id)CFPreferencesCopyAppValue((CFStringRef)key, CFSTR("com.randy420.volumestepprefs"));
	float result = [value respondsToSelector:@selector(floatValue)] ? [value floatValue] : defaultValue;
	[value release];
	return result;
}

static int GetInt(NSString *key, int defaultValue) {
	id value = (id)CFPreferencesCopyAppValue((CFStringRef)key, CFSTR("com.randy420.volumestepprefs"));
	int result = [value respondsToSelector:@selector(intValue)] ? [value intValue] : defaultValue;
	[value release];
	return result;
}

%hook SBVolumeControl
-(void)changeVolumeByDelta:(float)step{
	bool vsEnabled = GetBool(@"VSStepEnabled", NO);
	bool vsSeperate = GetBool(@"vsSeperate", NO);
	bool vsVibe = GetBool(@"vsVibEnabled", NO);

	float vsStepValue = (GetFloat(@"prefInt", 3.0))/100;
	float vsStepDown = (GetFloat(@"prefIntDown", 3.0))/100;

	int vsVibLevel = GetInt(@"VSVibeLevel", 1);
	//////~VOLUME~HANDLING~//////
	if (step >= 0) {
		step = vsEnabled ? vsStepValue : step;
	} else {
		step = vsSeperate ? (vsEnabled ? vsStepDown * -1 : step) : (vsEnabled ? vsStepValue * -1 : step);
	}
	//////~VIBRATION~HANDLING~//////
	if(vsVibe) {
		if (vsVibLevel == 0) {
			AudioServicesPlaySystemSound(1519);
		} else if (vsVibLevel == 1) {
			AudioServicesPlaySystemSound(1520);
		} else {
			AudioServicesPlaySystemSound(1521);
		}
	}
	%orig(step);
}
%end

static void PreferencesCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	CFPreferencesAppSynchronize(CFSTR("com.randy420.volumestepprefs"));
}

%ctor {
		%init();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesCallback, CFSTR("com.randy420.volumestepprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}