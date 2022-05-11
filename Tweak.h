//#pragma GCC diagnostic ignored "-Wunused-variable"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface SBVolumeControl : NSObject {
	
}
-(void)changeVolumeByDelta:(float)arg1;
-(float)volumeStepUp;
-(float)volumeStepDown;
-(void)increaseVolume;
-(void)decreaseVolume;
-(float)_effectiveVolume;
-(void)setActiveCategoryVolume:(float)arg1;
@end

@interface SBVolumeControl (volumeStep) {
	
}
//@property (nonatomic) float currentVolume;
-(void)vibrate;
@end

/*
+(id)sharedInstance;
+(BOOL)_isVolumeChangeAllowedForState:(id)arg1 error:(out id*)arg2 ;
-(float)_volumeStepUp:(BOOL)arg1 ;
-(void)increaseVolume;
-(void)cancelVolumeEvent;
-(BOOL)_HUDIsDisplayableInCurrentSpringBoardContext;
-(BOOL)_isCategoryAlwaysHidden:(id)arg1 ;
-(float)_calcButtonRepeatDelay;
-(void)_updateVolumeLimitEnforced:(BOOL)arg1 ;
-(BOOL)wouldShowAtLeastAYellowWarningForVolume:(float)arg1 ;
-(void)removeAlwaysHiddenCategory:(id)arg1 ;
-(BOOL)userHasAcknowledgedEUVolumeLimit;
-(void)addAlwaysHiddenCategory:(id)arg1 ;
-(long long)_audioRouteTypeForTelephonyDeviceType:(long long)arg1 ;
-(BOOL)_isVolumeHUDVisible;
-(float)_getMediaVolumeForIAP;
-(BOOL)isEUDevice;
-(id)initWithHUDController:(id)arg1 ringerControl:(id)arg2 telephonyManager:(id)arg3 conferenceManager:(id)arg4 ;
-(void)toggleMute;
-(long long)_audioRouteTypeForOutputDevice:(id)arg1 ;
-(long long)_audioRouteTypeForActiveAudioRoute:(id)arg1 withAttributes:(id)arg2 ;
-(NSArray *)activeAudioRouteTypes;
-(void)_controlCenterDidDismiss:(id)arg1 ;
-(id)presentedVolumeHUDViewController;
-(void)cache:(id)arg1 didUpdateVolumeLimitEnforced:(BOOL)arg2 ;
-(id)existingVolumeHUDViewController;
-(void)_updateEUVolumeSettings;
-(void)handleVolumeButtonWithType:(long long)arg1 down:(BOOL)arg2 ;
-(id)_configureVolumeHUDViewControllerWithVolume:(float)arg1 ;

*/
//-(void)_dispatchAVSystemControllerSync:(/*^block*/id)arg1 ;
/*-(BOOL)isEUVolumeLimitEnforced;
-(void)clearAlwaysHiddenCategories;
-(BOOL)_isHUDDisplayable;
-(BOOL)_HUDIsDisplayableForCategory:(id)arg1 ;
-(void)_presentVolumeHUDWithVolume:(float)arg1 ;
-(void)_serverConnectionDied:(id)arg1 ;
-(void)_userAcknowledgedEUEnforcement:(float)arg1 ;
-(float)volumeStepDown;
-(float)euVolumeLimit;*/
//-(void)_dispatchAVSystemControllerAsync:(/*^block*/id)arg1 ;
/*-(void)hideVolumeHUDIfVisible;
-(void)cache:(id)arg1 didUpdateActiveAudioRoutingWithRoute:(id)arg2 routeAttributes:(id)arg3 activeOutputDevices:(id)arg4 ;
-(void)volumeHUDViewControllerRequestsDismissal:(id)arg1 ;
-(void)_sendEUVolumeLimitAcknowledgementIfNecessary;
-(NSString *)lastDisplayedCategory;
-(void)_presentVolumeHUDIfDisplayable:(BOOL)arg1 orRefreshIfPresentedWithReason:(id)arg2 ;
-(void)_updateEffectiveVolume:(float)arg1 ;
-(BOOL)_shouldRouteChangeResultInPresentingVolumeHUDWhenTransitioningFrom:(id)arg1 toAudioRoutes:(id)arg2 ;
-(void)_updateAudioRoutesIfNecessary:(BOOL)arg1 forRoute:(id)arg2 withAttributes:(id)arg3 andOutputDevices:(id)arg4 ;
-(void)cache:(id)arg1 didUpdateVolumeLimit:(float)arg2 ;
-(BOOL)_isVolumeHUDVisibleOrFading;
-(void)decreaseVolume;
-(void)_resetMediaServerConnection;
-(float)_effectiveVolume;
-(id)acquireVolumeHUDHiddenAssertionForReason:(id)arg1 ;
-(id)_audioRouteTypesForClusteredOutputDevices:(id)arg1 ;
-(void)_setMediaVolumeForIAP:(float)arg1 ;
-(BOOL)isEUVolumeLimitSet;
-(BOOL)_HUDIsDisplayableForLastEventCategory;
-(void)_updateVolumeLimit:(float)arg1 ;
-(void)changeVolumeByDelta:(float)arg1 ;
-(id)avSystemControllerDispatchQueue;
-(void)setVolume:(float)arg1 forCategory:(id)arg2 ;
-(BOOL)isEUVolumeLimitEnabled;
-(void)_controlCenterWillPresent:(id)arg1 ;
-(BOOL)_turnOnScreenIfNecessaryForEULimit:(BOOL)arg1 ;
-(void)setActiveCategoryVolume:(float)arg1 ;
-(BOOL)_outputDevicesRepresentWirelessSplitterGroup:(id)arg1 ;
-(float)volumeStepUp;
-(void)_effectiveVolumeChanged:(id)arg1 ;
-(void)settings:(id)arg1 changedValueForKey:(id)arg2 ;*/