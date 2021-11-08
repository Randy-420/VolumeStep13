#pragma GCC diagnostic ignored "-Wunused-variable"

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface UIDevice()
@end

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface SBVolumeControl:NSObject
-(void)changeVolumeByDelta:(float)arg1;
-(float)volumeStepUp;
-(float)volumeStepDown;
-(void)increaseVolume;
-(void)decreaseVolume;
-(float)_effectiveVolume;
-(void)setActiveCategoryVolume:(float)arg1;
@end