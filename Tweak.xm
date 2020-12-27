#pragma GCC diagnostic ignored "-Wunused-variable"

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

	static float VSStepValue;
	static float vsStepDown;
	static bool vsVibe;
	static bool vsEnabled;
	static bool vsSeperate;
	static int vsVibLevel;
	NSMutableDictionary * MutDiction;

#define prefs @ "/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"

void loader(void) {
	MutDiction = [[NSMutableDictionary alloc] initWithContentsOfFile: prefs];

	VSStepValue = [MutDiction objectForKey:@"prefInt"] ? [[MutDiction objectForKey:@"prefInt"] floatValue] :  3.0;

	vsStepDown = [MutDiction objectForKey:@"prefIntDown"] ? [[MutDiction objectForKey:@"prefIntDown"] floatValue] :  3.0;

	VSStepValue /= 100;
	vsStepDown /= 100;

	vsSeperate = [MutDiction objectForKey:@"vsSeperate"] ? [[MutDiction objectForKey:@"vsSeperate"] boolValue] :  NO;

	vsEnabled = [MutDiction objectForKey:@"VSStepEnabled"] ? [[MutDiction objectForKey:@"VSStepEnabled"] boolValue] :  NO;

	vsVibe = [MutDiction objectForKey:@"vsVibEnabled"] ? [[MutDiction objectForKey:@"vsVibEnabled"] boolValue] :  NO;

	vsVibLevel = [MutDiction objectForKey:@"VSVibeLevel"] ? [[MutDiction objectForKey:@"VSVibeLevel"] intValue] :  1;
}

%hook SBVolumeControl
- (float)volumeStepUp {
	return vsEnabled ? VSStepValue : %orig;
}

- (float)volumeStepDown {
	return vsSeperate ? (vsEnabled ? vsStepDown : %orig) : (vsEnabled ? VSStepValue : %orig);
	/*if(vsSeperate) {
		return vsEnabled ? vsStepDown : %orig;
	}else{
		return vsEnabled ? VSStepValue : %orig;
	}*/
}
%end

%hook SBVolumeControl
- (void)_presentVolumeHUDWithVolume:(float)arg1 {
	if(vsVibe) {
		if (vsVibLevel == 0) {
			AudioServicesPlaySystemSound(1519);
		}else if (vsVibLevel == 1) {
			AudioServicesPlaySystemSound(1520);
		}else{
			AudioServicesPlaySystemSound(1521);
		}
	}
	%orig;
}
%end

%ctor {
	loader();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loader, CFSTR("com.randy420.volumestepprefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
