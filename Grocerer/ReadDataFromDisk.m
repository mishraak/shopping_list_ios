#import "ReadDataFromDisk.h"

@implementation ReadDataFromDisk

+(void)read
{
    AppData* sharedInstance = [AppData sharedManager];
    
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* docsDir = [paths objectAtIndex:0];
    NSString* dataPath = [NSString stringWithFormat:@"%@/data.plist", docsDir];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    sharedInstance.offlineLST = [NSMutableArray new];
    
    if ([fileManager fileExistsAtPath: dataPath])
        sharedInstance.offlineLST = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
}

@end
