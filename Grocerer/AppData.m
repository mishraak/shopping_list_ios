

#import "AppData.h"

@implementation AppData

-(id)init
{
    if (self = [super init])
    {
        _currentLST = [NSMutableArray new];
        
        _onlineLST = [NSMutableArray new];
        [FIRApp configure];
        _rootNode = [[FIRDatabase database] reference];
        _usersNode = [_rootNode child:@"users"];
        _dataNode = [_rootNode child:@"data"];
    }
    
    return self;
}





+(id)sharedManager
{
    static AppData *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

@end
