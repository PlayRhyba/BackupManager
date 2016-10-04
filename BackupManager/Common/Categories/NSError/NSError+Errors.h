//
//  NSError+Errors.h
//  BackupManager
//


#import <Foundation/Foundation.h>


extern NSString * const NSError_Errors_InternalErrorDomain;


typedef NS_ENUM(NSInteger, NSError_Errors) {
    NSError_Errors_InternalErrorCode = 5000,
    NSError_Errors_BackupNotFoundErrorCode = 5001,
    NSError_Errors_ConnectionErrorCode = 5002,
    NSError_Errors_ArchivingError = 5003,
    NSError_Errors_UnarchivingError = 5004,
};


@interface NSError (Errors)

+ (NSError *)internalError;
+ (NSError *)backupNotFoundError;

@end
