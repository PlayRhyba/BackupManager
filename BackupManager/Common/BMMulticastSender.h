//
//  BMMulticastSender.h
//  BackupManager
//


#import <Foundation/Foundation.h>


@interface BMMulticastSender : NSObject

@property (nonatomic, strong, readonly) NSHashTable *delegates;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

@end
