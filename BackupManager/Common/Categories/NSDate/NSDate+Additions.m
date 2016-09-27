//
//  NSDate+Additions.m
//  BackupManager
//


#import "NSDate+Additions.h"


static NSString * const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";


@implementation NSDate (Additions)


static NSDateFormatter *_storedFormatter = nil;


+ (NSDateFormatter *)formatter {
    if (_storedFormatter == nil) {
        _storedFormatter = [[NSDateFormatter alloc]init];
        _storedFormatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _storedFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    return _storedFormatter;
}


- (NSString *)stringWithFormat:(NSString *)dateFormat {
    NSString *dateStr = [[NSDate formatter]stringFromDate:self withFormat:dateFormat];
    return dateStr;
}


- (NSString *)string {
    return [self stringWithFormat:kDefaultDateFormat];
}

@end


@implementation NSDateFormatter (Additions)


- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)dateFormat {
    self.dateFormat = dateFormat;
    return [self dateFromString:string];
}


- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    self.dateFormat = dateFormat;
    return [self stringFromDate:date];
}

@end


@implementation NSString (DateAdditions)


- (NSDate *)dateWithFormat:(NSString *)dateFormat {
    return [[NSDate formatter] dateFromString:self withFormat:dateFormat];
}


- (NSDate *)dateWithFormats:(NSArray *)formats {
    for (NSString *format in formats) {
        NSDate *date = [self dateWithFormat:format];
        
        if (date) {
            return date;
        }
    }
    
    return nil;
}


- (NSDate *)date {
    return [self dateWithFormat:kDefaultDateFormat];
}

@end
