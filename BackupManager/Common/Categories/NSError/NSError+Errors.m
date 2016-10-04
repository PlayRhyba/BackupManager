//
//  NSError+Errors.m
//  BackupManager
//


#import "NSError+Errors.h"


NSString * const NSError_Errors_InternalErrorDomain = @"NSError_Errors_InternalErrorDomain";


@implementation NSError (Errors)


+ (NSError *)internalError {
    return [NSError errorWithDomain:NSError_Errors_InternalErrorDomain
                               code:NSError_Errors_InternalErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Internal error."}];
}


+ (NSError *)backupNotFoundError {
    return [NSError errorWithDomain:NSError_Errors_InternalErrorDomain
                               code:NSError_Errors_BackupNotFoundErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Backup hasn't been found."}];
}

@end
