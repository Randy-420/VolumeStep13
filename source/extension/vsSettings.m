#import "vsSettings.h"
#import <notify.h>

@interface vsSettings ()
@property (nonatomic, readonly) int token;
@end

@implementation vsSettings
@synthesize preferences = _preferences;

-(instancetype)init {
	if(self = [super init]) {

		[self registerDefaults];

		int token = 0;
		__block vsSettings *blockSelf = self;
		notify_register_dispatch("com.randy420.volumestepprefs", &token, dispatch_get_main_queue(), ^(int token) {
			blockSelf->_preferences = nil;
		});
		_token = token;
	}
	return self;
}

-(void)dealloc {
	notify_cancel(self.token);
}

-(void)registerDefaults {
	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("VSStepEnabled"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"VSStepEnabled", (CFPropertyListRef)@1, CFSTR(kPrefDomain));
	}

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("vsSeperate"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"vsSeperate", (CFPropertyListRef)@0, CFSTR(kPrefDomain));
	}

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("vsVibEnabled"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"vsVibEnabled", (CFPropertyListRef)@1, CFSTR(kPrefDomain));
	}
	
	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("VSVibeLevel"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"VSVibeLevel", (CFPropertyListRef)[NSNumber numberWithInt:1], CFSTR(kPrefDomain));
	}

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("vsVibeMinMax"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"vsVibeMinMax", (CFPropertyListRef)@1, CFSTR(kPrefDomain));
	}

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("prefInt"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"prefInt", (CFPropertyListRef)([NSNumber numberWithFloat:3.0/100.0]), CFSTR(kPrefDomain));
	}

	if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("prefIntDown"), CFSTR(kPrefDomain)))) {
		CFPreferencesSetAppValue((CFStringRef)@"prefIntDown", ((CFPropertyListRef)[NSNumber numberWithFloat:3.0/100.0]), CFSTR(kPrefDomain));
	}
}

-(NSMutableDictionary *)preferences {
	if (!_preferences) {
		CFStringRef appID = CFSTR(kPrefDomain);
		CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (!keyList) return nil;
		_preferences = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	}

	return _preferences;
}

-(BOOL)VSStepEnabled {
	return (self.preferences[@"VSStepEnabled"] ? [self.preferences[@"VSStepEnabled"] boolValue] : YES);
}

-(BOOL)vsSeperate {
	return (self.preferences[@"vsSeperate"] ? [self.preferences[@"vsSeperate"] boolValue] : NO);
}

-(BOOL)vsVibEnabled {
	return (self.preferences[@"vsVibEnabled"] ? [self.preferences[@"vsVibEnabled"] boolValue] : YES);
}

-(BOOL)vsVibeMinMax {
	return (self.preferences[@"vsVibeMinMax"] ? [self.preferences[@"vsVibeMinMax"] boolValue] : YES);
}

-(double)prefInt {
	return (self.preferences[@"prefInt"] ? [self.preferences[@"prefInt"] floatValue] : 3.0)/100.0;
}

-(double)prefIntDown {
	return (self.preferences[@"prefIntDown"] ? [self.preferences[@"prefIntDown"] floatValue] : 3.0)/100;
}

-(int)VSVibeLevel {
	return self.preferences[@"VSVibeLevel"] ? [self.preferences[@"VSVibeLevel"] intValue] : 1;
}
@end