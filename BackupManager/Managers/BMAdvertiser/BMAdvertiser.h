//
//  BMAdvertiser.h
//  BackupManager
//


#import "BMMulticastSender.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@class BMAdvertiser;
@class BMCommand;


@protocol BMAdvertiserDelegate <NSObject>

@optional

- (void)advertiser:(BMAdvertiser *)advertiser
    didChangeState:(MCSessionState)state
           session:(MCSession *)session
              peer:(MCPeerID *)peerID;

- (void)advertiser:(BMAdvertiser *)advertiser
 didReceiveCommand:(BMCommand *)command
           session:(MCSession *)session
              peer:(MCPeerID *)peerID;
@end


@interface BMAdvertiser : BMMulticastSender

+ (instancetype)sharedInstance;
- (void)start;
- (void)stop;
- (BOOL)hasConnectedPeers;
- (BOOL)isStarted;

@end
