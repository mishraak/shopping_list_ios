#import "SetTheUser.h"

@implementation SetTheUser

+(void)setWithName:(NSString *)inpName andEmail:(NSString *)inpEmail andUid:(NSString *)inpUid
{
    AppData *sharedInstance = [AppData sharedManager];
    
    UserClass* tempUser = [[UserClass alloc] initWith:inpName andEmail:inpEmail andUid:inpUid];
    
    for (GroceryListClass* any in sharedInstance.currentLST)
    {
        if (any.listOwner.uid == sharedInstance.curUser.uid)
            any.listOwner = tempUser;
    }

//    for (int i =0; i < sharedInstance.currentLST.count; i++)
//    {
//        NSLog(@"List owner is : %@", [sharedInstance.currentLST objectAtIndex:i].listOwner.name);
//        NSLog(@"cur user is : %@", sharedInstance.curUser.name);
//
//        if ( [[sharedInstance.currentLST objectAtIndex:i].listOwner.uid isEqualToString: sharedInstance.curUser.uid])
//        {
//            NSLog(@"\n\n it happened");
//            [sharedInstance.currentLST objectAtIndex:i].listOwner = tempUser;
//        }
//    }
    
    
    sharedInstance.curUser = tempUser;
    
    [WriteUserToDisk write];
}
@end
