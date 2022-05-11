#include <Foundation/Foundation.h>

#define kPrefDomain "com.randy420.volumestepprefs"

@interface vsSettings : NSObject{
	
}
@property (nonatomic) NSMutableDictionary *preferences;

-(BOOL)VSStepEnabled;
-(BOOL)vsSeperate;
-(BOOL)vsVibEnabled;
-(BOOL)vsVibeMinMax;
-(double)prefInt;
-(double)prefIntDown;
-(int)VSVibeLevel;
@end