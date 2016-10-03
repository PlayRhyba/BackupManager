//
//  UIApplication+Utilities.m
//  BackupManager
//


#import "UIApplication+Utilities.h"


@implementation UIApplication (Utilities)


+ (void)disableIdleTimer {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}


+ (void)enableIdleTimer {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

@end
