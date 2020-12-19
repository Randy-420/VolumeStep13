#import "vspRootListController.h"

@implementation AppearanceSettings

-(UIColor *)tintColor {
    return [UIColor colorWithRed: 0.00 green: 0.20 blue: 0.31 alpha: 1.00];
}

-(UIColor *)statusBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}

-(UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed: 0.00 green: 0.20 blue: 0.31 alpha: 1.00];
}

-(BOOL)translucentNavigationBar {
    return NO;
}

/*- (NSUInteger)largeTitleStyle {
    return 2;
}*/

@end
