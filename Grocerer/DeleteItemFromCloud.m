#import "DeleteItemFromCloud.h"

@implementation DeleteItemFromCloud

+(void)deleteItem:(ItemClass *)inpItem inList:(GroceryListClass *)inpList
{
    // a conditional for internet access
    // time out
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    AppData *sharedInstance = [AppData sharedManager];
    
    FIRDatabaseReference * itemNode;
    
    itemNode = [[[[sharedInstance.dataNode child:inpList.listOwner.uid]
                  child:inpList.listName]
                 child:@"listItems"] child:inpItem.itemName];
    
    [itemNode removeValue];
}
@end
