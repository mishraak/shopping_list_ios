#import "WriteUserToDisk.h"

@implementation WriteUserToDisk

+(void)write
{
    AppData *sharedInstance = [AppData sharedManager];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* docsDir = [paths objectAtIndex:0];
    NSString* userPath = [NSString stringWithFormat:@"%@/user.plist", docsDir];
    
    [NSKeyedArchiver archiveRootObject:sharedInstance.curUser toFile:userPath];
}

@end
