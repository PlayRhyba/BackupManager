//
//  BMBackupStorage.h
//  BackupManager
//


#import <UIKit/UIKit.h>


@class BMBackup;


@interface BMBackupStorage : NSObject

+ (BMBackup *)createBackupWithURL:(NSURL *)localURL
                     resourceName:(NSString *)resourceName
                             user:(NSString *)user
                            error:(NSError *__autoreleasing *)error;

+ (void)removeBackup:(BMBackup *)backup
               error:(NSError *__autoreleasing *)error;

+ (NSArray <BMBackup *> *)backups;
+ (NSArray <BMBackup *> *)backupsForUser:(NSString *)user;
+ (BMBackup *)backupWithUUID:(NSString *)uuid;

@end
