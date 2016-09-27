//
//  MCSession+Utilities.h
//  BluetoothBackupDemo
//


#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MCSession (Utilities)

+ (MCSession *)sessionWithDelegate:(id<MCSessionDelegate>)delegate
                       displayName:(NSString *)displayName;

+ (NSString *)stringWithSessionState:(MCSessionState)state;

@end
