//
//  BMBackup+CoreDataClass.m
//  BackupManager
//


#import "BMBackup+CoreDataClass.h"
#import "NSDate+Additions.h"

@implementation BMBackup

- (NSDictionary *)dictionary {
    return @{NSStringFromSelector(@selector(uuid)): self.uuid ?: @"",
             NSStringFromSelector(@selector(name)): self.name ?: @"",
             NSStringFromSelector(@selector(path)): self.path ?: @"",
             NSStringFromSelector(@selector(date)): self.date ? [self.date string] : @"",
             NSStringFromSelector(@selector(user)): self.user ?: @""};
}

@end
