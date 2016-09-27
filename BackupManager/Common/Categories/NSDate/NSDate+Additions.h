//
//  NSDate+Additions.h
//  BackupManager
//


#import <Foundation/Foundation.h>


@interface NSDate (Additions)

+ (NSDateFormatter *)formatter;
- (NSString *)stringWithFormat:(NSString *)dateFormat;
- (NSString *)string;

@end


@interface NSDateFormatter (Additions)

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)dateFormat;
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

@end


@interface NSString (DateAdditions)

- (NSDate *)dateWithFormat:(NSString *)dateFormat;
- (NSDate *)dateWithFormats:(NSArray *)formats;
- (NSDate *)date;

@end
