//
//  BMBackup+CoreDataClass.h
//  BackupManager
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMBackup : NSManagedObject

- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#import "BMBackup+CoreDataProperties.h"
