#import <Foundation/Foundation.h>
#import "AppData.h"
#import "WriteUserToDisk.h"

@interface SetTheUser : NSObject

+(void)setWithName:(NSString *)inpName andEmail:(NSString *)inpEmail andUid:(NSString *)inpUid;

@end
