//
//  BMBackup+CoreDataProperties.h
//  BackupManager
//


#import "BMBackup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BMBackup (CoreDataProperties)

+ (NSFetchRequest<BMBackup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *user;

@end

NS_ASSUME_NONNULL_END
