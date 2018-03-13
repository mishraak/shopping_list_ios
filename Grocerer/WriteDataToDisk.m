#import "WriteDataToDisk.h"

@implementation WriteDataToDisk


+(void)write
{
    AppData *sharedInstance = [AppData sharedManager];
    
    sharedInstance.offlineLST = [NSMutableArray new];
    
    for (GroceryListClass *any in sharedInstance.currentLST)
    {
        if ([any.listOwner.uid isEqualToString: sharedInstance.curUser.uid])
            [sharedInstance.offlineLST addObject: any];
    }
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString* docsDir = [paths objectAtIndex:0];
    NSString* dataPath = [NSString stringWithFormat:@"%@/data.plist", docsDir];
    
//    NSLog(dataPath);
    
    [NSKeyedArchiver archiveRootObject:sharedInstance.offlineLST toFile:dataPath];
}

@end
