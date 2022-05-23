#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

#define SETTINGS_CHANGED CFSTR("com.randy420.volumestepprefs.settingschanged")
#define PREFS CFSTR("com.randy420.volumestepprefs")
#define PLIST @"/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"
#define MYCC @"VSStepEnabled"

@interface vscc : CCUIToggleModule {
}
@end