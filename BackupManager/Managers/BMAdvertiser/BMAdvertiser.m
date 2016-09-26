//
//  BMAdvertiser.m
//  BackupManager
//


#import "BMAdvertiser.h"
#import "MCSession+Utilities.h"
#import "BMCommand.h"
#import "BMBackupStorage.h"


static NSString * const kServiceType = @"vis-backup";


@interface BMAdvertiser () <MCSessionDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (void)processCommand:(BMCommand *)command
           withSession:(MCSession *)session
              fromPeer:(MCPeerID *)peer;

- (void)sendData:(NSData *)data toPeers:(NSArray <MCPeerID *> *)peers;
- (void)sendError:(NSError *)error toPeers:(NSArray <MCPeerID *> *)peers;
- (void)sendSuccessWithMessage:(NSString *)message toPeers:(NSArray <MCPeerID *> *)peers;

@end


@implementation BMAdvertiser


#pragma mark - BBSMulticastSender


- (void)addDelegate:(id)delegate {
    if ([delegate conformsToProtocol:@protocol(BMAdvertiserDelegate)]) {
        [super addDelegate:delegate];
    }
}


- (void)removeDelegate:(id)delegate {
    if ([delegate conformsToProtocol:@protocol(BMAdvertiserDelegate)]) {
        [super removeDelegate:delegate];
    }
}


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static BMAdvertiser *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BMAdvertiser alloc]init];
    });
    
    return _sharedInstance;
}


- (void)start {
    if ([self isStarted]) {
        [self stop];
    }
    
    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:kServiceType
                                                          discoveryInfo:nil
                                                                session:[MCSession sessionWithDelegate:self]];
    [_advertiser start];
    
    NSLog(@"%@: STARTED", NSStringFromClass([self class]));
}


- (void)stop {
    [_advertiser stop];
    self.advertiser = nil;
    
    NSLog(@"%@: STOPPED", NSStringFromClass([self class]));
}


- (BOOL)hasConnectedPeers {
    return _advertiser.session.connectedPeers > 0;
}


- (BOOL)isStarted {
    return _advertiser != nil;
}


#pragma mark - MCSessionDelegate


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"%@: SESSION STATE CHANGED TO %@", NSStringFromClass([self class]), [MCSession stringWithSessionState:state]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<BMAdvertiserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(advertiser:didChangeState:session:peer:)]) {
                [delegate advertiser:self didChangeState:state session:session peer:peerID];
            }
        }
    });
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    BMCommand *command = [[BMCommand alloc]initWithData:data];
    
    if (command) {
        [self processCommand:command withSession:session fromPeer:peerID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id<BMAdvertiserDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(advertiser:didReceiveCommand:session:peer:)]) {
                    [delegate advertiser:self didReceiveCommand:command session:session peer:peerID];
                }
            }
        });
        
        NSLog(@"%@: RECEIVED COMMAND WITH NAME: %@, FROM: %@, PAYLOAD: %@",
              NSStringFromClass([self class]),
              command.name,
              command.from,
              command.payload);
    }
}


- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID {}


- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress {
    NSLog(@"%@: START RECEIVING RESOURCE WITH NAME: %@", NSStringFromClass([self class]), resourceName);
}


- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error {
    NSLog(@"%@: FINISH RECEIVING RESOURCE WITH NAME: %@. ERROR: %@", NSStringFromClass([self class]), resourceName, error.localizedDescription);
    
    if (error) {
        [self sendError:error toPeers:@[peerID]];
    }
    else {
        [BMBackupStorage createBackupWithURL:localURL
                                resourceName:resourceName
                                        user:peerID.displayName
                                       error:&error];
        if (error) {
            [self sendError:error toPeers:@[peerID]];
        }
        else {
            [self sendSuccessWithMessage:@"Backup has been successfully saved" toPeers:@[peerID]];
        }
    }
}


#pragma mark - Internal Logic


- (void)processCommand:(BMCommand *)command
           withSession:(MCSession *)session
              fromPeer:(MCPeerID *)peer {
    if ([command.name isEqualToString:BMCommandBackupsListRequest]) {
        //        NSString *backupDirectoryPath = [self backupDirectoryPath];
        //
        //        NSArray<NSString *> *files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:backupDirectoryPath
        //                                                                                        error:nil];
        //
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'backup'"];
        //        files = [files filteredArrayUsingPredicate:predicate];
        //
        //        NSMutableArray *filesInfo = [NSMutableArray arrayWithCapacity:files.count];
        //
        //        for (NSString *fileName in files) {
        //            BBSFileInfo *info = [[BBSFileInfo alloc]initWithPath:[backupDirectoryPath stringByAppendingPathComponent:fileName]];
        //
        //            if (info) {
        //                [filesInfo addObject:info];
        //            }
        //        }
        //
        //        BBSCommand *command = [BBSCommand backupsListResponseCommandWithFiles:filesInfo];
        //
        //        NSError *error = nil;
        //
        //        [_advertiser.session sendData:[command data]
        //                              toPeers:_advertiser.session.connectedPeers
        //                             withMode:MCSessionSendDataReliable
        //                                error:&error];
        //        if (error) {
        //            NSLog(@"ADVERTISER: SEND BACKUP LIST RESPONSE ERROR: %@", error.localizedDescription);
        //        }
    }
    else if ([command.name isEqualToString:BMCommandRequestBackup]) {
        //        BBSFileInfo *fileInfo = (BBSFileInfo *)command.payload;
        //
        //        [_advertiser.session sendResourceAtURL:[NSURL fileURLWithPath:fileInfo.path]
        //                                      withName:fileInfo.name
        //                                        toPeer:_advertiser.session.connectedPeers.firstObject
        //                         withCompletionHandler:^(NSError * _Nullable error) {
        //                             if (error) {
        //                                 NSLog(@"ADVERTISER: BACKUP SENDING ERROR: %@", error.localizedDescription);
        //                             }
        //                         }];
    }
}


- (void)sendData:(NSData *)data toPeers:(NSArray <MCPeerID *> *)peers {
    NSError *error = nil;
    
    [_advertiser.session sendData:data
                          toPeers:peers
                         withMode:MCSessionSendDataReliable
                            error:&error];
    if (error) {
        NSLog(@"%@: SENDING DATA ERROR: %@", NSStringFromClass([self class]), error.localizedDescription);
    }
}


- (void)sendError:(NSError *)error toPeers:(NSArray <MCPeerID *> *)peers {
    NSLog(@"%@: SENDING ERROR: %@", NSStringFromClass([self class]), error.localizedDescription);
    
    BMCommand *command = [BMCommand errorCommandWithError:error];
    [self sendData:[command data] toPeers:peers];
}


- (void)sendSuccessWithMessage:(NSString *)message toPeers:(NSArray <MCPeerID *> *)peers {
    NSLog(@"%@: SENDING SUCCESS: %@", NSStringFromClass([self class]), message);
    
    BMCommand *command = [BMCommand successCommandWithMessage:message];
    [self sendData:[command data] toPeers:peers];
}

@end
