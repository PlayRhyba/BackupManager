//
//  MCSession+Utilities.m
//  BluetoothBackupDemo
//


#import "MCSession+Utilities.h"


@implementation MCSession (Utilities)


+ (MCSession *)sessionWithDelegate:(id<MCSessionDelegate>)delegate
                       displayName:(NSString *)displayName {
    displayName = displayName ?: [UIDevice currentDevice].name;
    MCPeerID *peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    MCSession *session = [[MCSession alloc]initWithPeer:peerID];
    session.delegate = delegate;
    
    return session;
}


+ (NSString *)stringWithSessionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected: return @"CONNECTED";
        case MCSessionStateConnecting: return @"CONNECTING";
        case MCSessionStateNotConnected: return @"DISCONNECTED";
    }
}

@end
