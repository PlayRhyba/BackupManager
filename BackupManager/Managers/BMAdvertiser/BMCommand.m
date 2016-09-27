//
//  BMCommand.m
//  BackupManager
//


#import "BMCommand.h"
#import "BMBackup+CoreDataProperties.h"
#import "BMConstants.h"


NSString * const BMCommandBackupsListRequest = @"BMCommandBackupsListRequest";
NSString * const BMCommandBackupsListResponse = @"BMCommandBackupsListResponse";
NSString * const BMCommandRequestBackup = @"BMCommandRequestBackup";
NSString * const BMCommandError = @"BMCommandError";
NSString * const BMCommandSuccess = @"BMCommandSuccess";

static NSString * const kMessage = @"message";
static NSString * const kBackups = @"backups";


@implementation BMCommand


#pragma mark - Public Methods


+ (instancetype)errorCommandWithError:(NSError *)error {
    NSDictionary *payload = @{NSStringFromSelector(@selector(domain)): error.domain,
                              NSStringFromSelector(@selector(code)): @(error.code),
                              kMessage: error.localizedDescription};
    
    return [[[self class]alloc]initWithName:BMCommandError
                                       from:BMConstantsDisplayName
                                    payload:payload];
}


+ (instancetype)successCommandWithMessage:(NSString *)message {
    NSDictionary *payload = @{kMessage: message ?: @""};
    
    return [[[self class]alloc]initWithName:BMCommandSuccess
                                       from:BMConstantsDisplayName
                                    payload:payload];
}


+ (instancetype)backupsListResponseCommandWithBackups:(NSArray <BMBackup *> *)backups {
    NSMutableArray *backupDictionaries = [NSMutableArray arrayWithCapacity:backups.count];
    
    for (BMBackup *backup in backups) {
        [backupDictionaries addObject:[backup dictionary]];
    }
    
    NSDictionary *payload = @{kBackups: backupDictionaries};
    
    return [[[self class]alloc]initWithName:BMCommandBackupsListResponse
                                       from:BMConstantsDisplayName
                                    payload:payload];
}


- (instancetype)initWithName:(NSString *)name
                        from:(NSString *)from
                     payload:(NSDictionary *)payload {
    if (self = [super init]) {
        _name = name;
        _from = from;
        _payload = payload;
    }
    
    return self;
}


- (instancetype)initWithData:(NSData *)data {
    if (data) {
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        if (error) {
            NSLog(@"%@: Deserialization error: %@", NSStringFromClass([self class]), error.localizedDescription);
        }
        
        if (json) {
            NSString *name = json[NSStringFromSelector(@selector(name))];
            NSString *from = json[NSStringFromSelector(@selector(from))];
            
            if (name && from) {
                return [self initWithName:name
                                     from:from
                                  payload:json[NSStringFromSelector(@selector(payload))]];
            }
        }
    }
    
    return nil;
}


- (NSData *)data {
    NSDictionary *dictionary = @{NSStringFromSelector(@selector(name)): _name,
                                 NSStringFromSelector(@selector(from)): _from,
                                 NSStringFromSelector(@selector(payload)): _payload ?: @{}};
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        NSLog(@"%@: Serialization error: %@", NSStringFromClass([self class]), error.localizedDescription);
    }
    
    return data;
}

@end
