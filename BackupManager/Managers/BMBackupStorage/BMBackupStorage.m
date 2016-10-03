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


+ (void)createBackupWithURL:(NSURL *)localURL
               resourceName:(NSString *)resourceName
                       user:(NSString *)user
                      error:(NSError *__autoreleasing *)error {
    NSError *c_error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *userDirectoryPath = [[self backupsDirectoryPath]stringByAppendingPathComponent:user];
    
    if ([fileManager fileExistsAtPath:userDirectoryPath] == NO) {
        [fileManager createDirectoryAtPath:userDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&c_error];
    }
    
    if (c_error) {
        if (error) *error = c_error;
        return;
    }
    
    NSString *uuidStr = [[NSUUID UUID]UUIDString];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", uuidStr, resourceName];
    NSString *filePath = [userDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [fileManager copyItemAtURL:localURL
                         toURL:[NSURL fileURLWithPath:filePath]
                         error:&c_error];
    if (c_error) {
        if (error) *error = c_error;
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        BMBackup *backup = [BMBackup MR_createEntityInContext:localContext];
        backup.uuid = uuidStr;
        backup.name = resourceName;
        backup.path = filePath;
        backup.date = [NSDate date];
        backup.user = user;
    }];
}


+ (void)removeBackup:(BMBackup *)backup error:(NSError *__autoreleasing *)error {
    if ([[NSFileManager defaultManager]removeItemAtPath:backup.path error:error]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            [backup MR_deleteEntityInContext:localContext];
        }];
    }
}


+ (NSArray <BMBackup *> *)backups {
    return [BMBackup MR_findAllSortedBy:NSStringFromSelector(@selector(date)) ascending:NO];
}


+ (NSArray <BMBackup *> *)backupsForUser:(NSString *)user {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@", NSStringFromSelector(@selector(user)), user];
    return [BMBackup MR_findAllWithPredicate:predicate];
}


+ (BMBackup *)backupWithUUID:(NSString *)uuid {
    return [BMBackup MR_findFirstByAttribute:NSStringFromSelector(@selector(uuid)) withValue:uuid];
}


#pragma mark - Internal Logic


+ (void)setup {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@: Documents Directory path: %@",
          NSStringFromClass([self class]),
          [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject);
#endif
    
    [MagicalRecord setupCoreDataStack];
}


+ (void)teardown {
    [MagicalRecord cleanUp];
}


+ (NSString *)backupsDirectoryPath {
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectoryURL.path stringByAppendingPathComponent:@"Backups"];
}

@end
