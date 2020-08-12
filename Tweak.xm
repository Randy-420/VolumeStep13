#pragma GCC diagnostic ignored "-Wunused-variable"

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

    static float VSStepValue;
    static bool enabled;
    static bool vsVibe;
    static bool vsEnabled;
    static int vsVibLevel;
    NSMutableDictionary * MutDiction;

#define prefs @ "/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"

void loader(void) {
	MutDiction = [[NSMutableDictionary alloc] initWithContentsOfFile: prefs];
	
	VSStepValue = [MutDiction objectForKey:@"prefInt"] ? [[MutDiction objectForKey:@"prefInt"] floatValue] :  3.0;
	
	VSStepValue /= 100;

	enabled = [MutDiction objectForKey:@"VSisEnabled"] ? [[MutDiction objectForKey:@"VSisEnabled"] boolValue] :  YES;

	vsEnabled = [MutDiction objectForKey:@"VSStepEnabled"] ? [[MutDiction objectForKey:@"VSStepEnabled"] boolValue] :  YES;

	vsVibe = [MutDiction objectForKey:@"vsVibEnabled"] ? [[MutDiction objectForKey:@"vsVibEnabled"] boolValue] :  YES;

	vsVibLevel = [MutDiction objectForKey:@"VSVibeLevel"] ? [[MutDiction objectForKey:@"VSVibeLevel"] intValue] :  1;
}

%hook SBVolumeControl
- (float)volumeStepUp {
	if(enabled) {
		return vsEnabled ? VSStepValue : %orig;
	}
	return %orig;
} 
- (float)volumeStepDown {
	if(enabled) {
		return vsEnabled ? VSStepValue : %orig;
	}
	return %orig;
} 
%end

%hook SBVolumeControl
- (void)_presentVolumeHUDWithVolume:(float)arg1 {
	if(enabled) {
		if(vsVibe) {
			if (vsVibLevel == 0) {
				AudioServicesPlaySystemSound(1519);
			}else if (vsVibLevel == 1) {
				AudioServicesPlaySystemSound(1520);
			}else{
				AudioServicesPlaySystemSound(1521);
			}
		}
	}
	%orig;
}
%end

%ctor {
	loader();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loader, CFSTR("com.randy420.volumestepprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);

}