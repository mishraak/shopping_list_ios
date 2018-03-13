#import "DeleteListFromCloud.h"

@implementation DeleteListFromCloud

+(void)deleteList:(GroceryListClass *)inpList
{
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    AppData *sharedInstance = [AppData sharedManager];
    
    FIRDatabaseReference * listNode;
    listNode = [[sharedInstance.dataNode child:inpList.listOwner.uid] child:inpList.listName];
    
    [listNode removeValue];
}
@end
