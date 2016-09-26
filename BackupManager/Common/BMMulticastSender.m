//
//  BMMulticastSender.m
//  BackupManager
//


#import "BMMulticastSender.h"


@interface BMMulticastSender ()

@property (nonatomic, strong, readwrite) NSHashTable *delegates;

@end


@implementation BMMulticastSender


#pragma mark - Getters/Setters


- (NSHashTable *)delegates {
    if (_delegates == nil) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    
    return _delegates;
}


#pragma mark - Public Methods


- (void)addDelegate:(id)delegate {
    if (delegate) {
        [self.delegates addObject:delegate];
    }
}


- (void)removeDelegate:(id)delegate {
    if (delegate) {
        [self.delegates removeObject:delegate];
    }
}


- (void)removeAllDelegates {
    [self.delegates removeAllObjects];
}

@end
