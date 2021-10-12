#include "Tweak.h"

	static float VSStepValue;
	static float vsStepDown;
	static bool vsVibe;
	static bool vsEnabled;
	static bool vsSeperate;
	static int vsVibLevel;

#define PREFS @"/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"

static float GetFloat(NSString *key, float defaultValue) {
	NSMutableDictionary *MutDiction = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFS];

	return [MutDiction objectForKey:key] ? [[MutDiction objectForKey:key] floatValue] :  defaultValue;
}

static BOOL GetBool(NSString *key, BOOL defaultValue) {
	NSMutableDictionary *MutDiction = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFS];

	return [MutDiction objectForKey:key] ? [[MutDiction objectForKey:key] boolValue] :  defaultValue;
}

static int GetInt(NSString *key, int defaultValue) {
	NSMutableDictionary *MutDiction = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFS];

	return [MutDiction objectForKey:key] ? [[MutDiction objectForKey:key] intValue] :  defaultValue;
}

void loader() {
	VSStepValue = GetFloat(@"prefInt", 3.0)/100;
	vsStepDown = GetFloat(@"prefIntDown", 3.0)/100;

	vsSeperate = GetBool(@"vsSeperate", NO);
	vsEnabled = GetBool(@"VSStepEnabled", YES);
	vsVibe = GetBool(@"vsVibEnabled", NO);

	vsVibLevel = GetInt(@"VSVibeLevel", 1);
}

static void vibrate(){
	if (vsVibe){
		if (vsVibLevel == 0){
			AudioServicesPlaySystemSound(1519);
		}else if (vsVibLevel == 1){
			AudioServicesPlaySystemSound(1520);
		}else if (vsVibLevel == 2){
			AudioServicesPlaySystemSound(1521);
		}
	}
}

%group thirteen
%hook SBVolumeControl
-(void)changeVolumeByDelta:(float)step{
	//////~VOLUME~HANDLING~//////
	if (step >= 0) {
		step = vsEnabled ? VSStepValue : step;
	} else {
		step = vsSeperate ? (vsStepDown * -1) : (VSStepValue * -1);
	}
	//////~VIBRATION~HANDLING~//////
	vibrate();
	%orig(step);
}
	////~ALT~VOLUME~HANDLING~////
/*- (float)volumeStepUp {
	vibrate();
	return vsEnabled ? VSStepValue : %orig;
}

- (float)volumeStepDown {
	vibrate();
	return vsSeperate ? vsStepDown : VSStepValue;
}*/
%end
%end

%group fourteen
%hook SBVolumeControl
- (void)decreaseVolume {
	%orig;
	vibrate();
	if (vsEnabled){
		if (vsSeperate){
			if ([self _effectiveVolume]-vsStepDown >= 0){
				[self setActiveCategoryVolume:[self _effectiveVolume]-vsStepDown];
			}else{
				[self setActiveCategoryVolume:0];
			}
		} else {
			if ([self _effectiveVolume]-VSStepValue >= 0){
				[self setActiveCategoryVolume:[self _effectiveVolume]-VSStepValue];
			}else{
				[self setActiveCategoryVolume:0];
			}
		}
	}
}
- (void)increaseVolume {
	%orig;
	vibrate();
	if (vsEnabled){
		if ([self _effectiveVolume]+VSStepValue <= 1){
			[self setActiveCategoryVolume:[self _effectiveVolume]+VSStepValue];
		} else {
			[self setActiveCategoryVolume:1];
		}
	}
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