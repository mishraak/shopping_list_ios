#import "ReadUserFromDisk.h"

@implementation ReadUserFromDisk

+(void)read
{
    AppData* sharedInstance = [AppData sharedManager];
    
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* docsDir = [paths objectAtIndex:0];
    NSString* userPath = [NSString stringWithFormat:@"%@/user.plist", docsDir];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: userPath])
        sharedInstance.curUser = [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
}


@end
