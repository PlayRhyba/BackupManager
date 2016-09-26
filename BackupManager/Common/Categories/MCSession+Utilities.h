//
//  MCSession+Utilities.h
//  BluetoothBackupDemo
//


#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MCSession (Utilities)

+ (MCSession *)sessionWithDelegate:(id<MCSessionDelegate>)delegate;
+ (NSString *)stringWithSessionState:(MCSessionState)state;
+ (UIColor *)colorWithSessionState:(MCSessionState)state;

@end
