//
//  BMCommand.h
//  BackupManager
//


#import <Foundation/Foundation.h>


extern NSString * const BMCommandBackupsListRequest;
extern NSString * const BMCommandBackupsListResponse;
extern NSString * const BMCommandRequestBackup;
extern NSString * const BMCommandError;
extern NSString * const BMCommandSuccess;


@interface BMCommand : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDictionary *payload;

+ (instancetype)errorCommandWithError:(NSError *)error;
+ (instancetype)successCommandWithMessage:(NSString *)message;

- (instancetype)initWithName:(NSString *)name
                        from:(NSString *)from
                     payload:(NSDictionary *)payload;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
