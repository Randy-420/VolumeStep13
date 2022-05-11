#include "Tweak.h"
#import "vsSettings.h"

	static float VSStepValue;
	static float vsStepDown;
	static bool vsVibe;
	static bool vsVibeMinMax;
	static bool vsEnabled;
	static bool vsSeperate;
	static int vsVibLevel;
	static float currentVolume;

static void loader() {
	vsSettings *_settings = [[vsSettings alloc] init];

	vsEnabled = [_settings VSStepEnabled];
	vsSeperate = [_settings vsSeperate];
	vsVibe = [_settings vsVibEnabled];
	vsVibeMinMax = [_settings vsVibeMinMax];

	VSStepValue = [_settings prefInt];
	vsStepDown = [_settings prefIntDown];

	vsVibLevel = [_settings VSVibeLevel];
}

%group thirteen
%hook SBVolumeControl
-(void)changeVolumeByDelta:(float)step{
	//////~VOLUME~STEP~HANDLING~//////
	if (step >= 0) {
		step = vsEnabled ? VSStepValue : step;
	} else {
		step = vsEnabled ? (vsSeperate ? (vsStepDown * -1) : (VSStepValue * -1)) : step;
	}
	//////~VIBRATION~HANDLING~//////
	[self vibrate];
	/////Continue changeVolumeByDelta/////
	%orig(step);
}
	////~ALT~VOLUME~HANDLING~////
/*- (float)volumeStepUp {
	[self vibrate];
	return vsEnabled ? VSStepValue : %orig;
}

- (float)volumeStepDown {
	[self vibrate];
	return vsEnabled ? (vsSeperate ? vsStepDown : VSStepValue) : %orig;
}*/
%end
%end

%group fourteen
%hook SBVolumeControl
- (void)decreaseVolume {
	%orig;
	if (vsEnabled){
		if (vsSeperate){
			currentVolume = ([self _effectiveVolume]-vsStepDown);
			if (currentVolume >= 0){
				[self setActiveCategoryVolume:[self _effectiveVolume]-vsStepDown];
			}else{
				[self setActiveCategoryVolume:0];
			}
		} else {
			currentVolume = ([self _effectiveVolume]-VSStepValue);
			if (currentVolume >= 0){
				[self setActiveCategoryVolume:[self _effectiveVolume]-VSStepValue];
			}else{
				[self setActiveCategoryVolume:0];
			}
		}
	}
	[self vibrate];
}

- (void)increaseVolume {
	%orig;
	if (vsEnabled){
		currentVolume = ([self _effectiveVolume]+VSStepValue);
		if (currentVolume <= 1){
			[self setActiveCategoryVolume:[self _effectiveVolume]+VSStepValue];
		} else {
			[self setActiveCategoryVolume:1];
		}
	}
	[self vibrate];
}

- (void)changeVolumeByDelta:(float)arg1 {
	if (vsEnabled)
		return;
	%orig;
}

- (float)volumeStepUp {
	return vsEnabled ? 0 : %orig;
}

- (float)volumeStepDown {
	return vsEnabled ? 0 : %orig;
}

%new
-(void)vibrate{
	if (vsVibe){
		if (vsVibeMinMax && !(currentVolume >= 1 || currentVolume <= 0))
			return;

		if (vsVibLevel == 0){
			AudioServicesPlaySystemSound(1519);
		}else if (vsVibLevel == 1){
			AudioServicesPlaySystemSound(1520);
		}else if (vsVibLevel == 2){
			AudioServicesPlaySystemSound(1521);
		}
	}
}
%end
%end

%ctor {
	loader();

	if (SYSTEM_VERSION_LESS_THAN(@"14.0"))
		%init(thirteen);

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0"))
		%init(fourteen);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loader, CFSTR("com.randy420.volumestepprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}