#import "vscc.h"

static BOOL GetBool(NSString *key, BOOL defaultValue) {
	Boolean exists;
	Boolean result = CFPreferencesGetAppBooleanValue((CFStringRef)key, PREFS, &exists);
	return exists ? result : defaultValue;
}

@implementation vscc
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:(68.0/255.0) green:(220.0/255.0) blue:(75.0/255.0) alpha:1.0];
}

- (bool)isSelected {
	return GetBool(MYCC, NO);
}

- (void)setSelected:(bool)selected {
	[super refreshState];
	NSMutableDictionary *Dict = /*[NSMutableDictionary dictionaryWithDictionary:*/[NSMutableDictionary dictionaryWithContentsOfFile:PLIST];//];
	[Dict setValue:[NSNumber numberWithBool:selected] forKey:MYCC];
	[Dict writeToFile:PLIST atomically:YES];
	CFPreferencesSetAppValue((CFStringRef)MYCC, (CFPropertyListRef)@(selected), PREFS);
	CFPreferencesAppSynchronize(PREFS);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), SETTINGS_CHANGED, NULL, NULL, TRUE);
}
@end