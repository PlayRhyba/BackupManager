//
//  BMBackup+CoreDataProperties.m
//  BackupManager
//


#import "BMBackup+CoreDataProperties.h"

@implementation BMBackup (CoreDataProperties)

+ (NSFetchRequest<BMBackup *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"BMBackup"];
}

@dynamic uuid;
@dynamic name;
@dynamic path;
@dynamic date;
@dynamic user;

@end
