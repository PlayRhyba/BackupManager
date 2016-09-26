//
//  BMBackupStorage.m
//  BackupManager
//


#import "BMBackupStorage.h"
#import <MagicalRecord/MagicalRecord.h>
#import "BMBackup+CoreDataProperties.h"


@interface BMBackupStorage ()

+ (void)setup;
+ (void)teardown;
+ (NSString *)backupsDirectoryPath;

@end


@implementation BMBackupStorage


#pragma mark - NSObject


+ (void)load {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(setup)
                          name:UIApplicationDidFinishLaunchingNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(teardown)
                          name:UIApplicationWillTerminateNotification
                        object:nil];
}


#pragma mark - Public Methods


+ (BMBackup *)createBackupWithURL:(NSURL *)localURL
                     resourceName:(NSString *)resourceName
                             user:(NSString *)user
                            error:(NSError *__autoreleasing *)error {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    NSString *userDirectoryPath = [[self backupsDirectoryPath]stringByAppendingPathComponent:user];
    
    if ([defaultManager fileExistsAtPath:userDirectoryPath isDirectory:nil] == NO) {
        [defaultManager createDirectoryAtPath:userDirectoryPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:error];
    }
    
    if (error) {
        return nil;
    }
    
    NSString *filePath = [userDirectoryPath stringByAppendingPathComponent:resourceName];
    
    [defaultManager copyItemAtURL:localURL
                            toURL:[NSURL fileURLWithPath:filePath]
                            error:error];
    if (error) {
        return nil;
    }
    
    BMBackup *backup = [BMBackup MR_createEntity];
    backup.uuid = [[NSUUID UUID]UUIDString];
    backup.name = resourceName;
    backup.path = filePath;
    backup.date = [NSDate date];
    backup.user = user;
    
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    
    return backup;
}


+ (void)removeBackup:(BMBackup *)backup error:(NSError *__autoreleasing *)error {
    if ([[NSFileManager defaultManager]removeItemAtPath:backup.path error:error]) {
        [backup MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    }
}


+ (NSArray <BMBackup *> *)backups {
    return [BMBackup MR_findAllSortedBy:NSStringFromSelector(@selector(date)) ascending:YES];
}


+ (NSArray <BMBackup *> *)backupsForUser:(NSString *)user {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ LIKE[cd] %@", NSStringFromSelector(@selector(user)), user];
    return [BMBackup MR_findAllWithPredicate:predicate];
}


+ (BMBackup *)backupWithUUID:(NSString *)uuid {
    return [BMBackup MR_findFirstByAttribute:NSStringFromSelector(@selector(uuid)) withValue:uuid];
}


#pragma mark - Internal Logic


+ (void)setup {
    [MagicalRecord setupCoreDataStack];
}


+ (void)teardown {
    [MagicalRecord cleanUp];
}


+ (NSString *)backupsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths.firstObject stringByAppendingPathComponent:@"Backups"];
}

@end
