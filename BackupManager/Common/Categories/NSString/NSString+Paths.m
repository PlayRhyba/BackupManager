//
//  NSString+Paths.m
//  BackupManager
//


#import "NSString+Paths.h"


@implementation NSString (Paths)


+ (NSString *)documentsDirectoryPath {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject.path;
}

@end
