#import "SaveItemOnCloud.h"

@implementation SaveItemOnCloud


+(void)save:(ItemClass *)inpItem inList:(GroceryListClass *)inpList
{
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    NSString* itemPurchasedStr = inpItem.itemPurchased ? @"True" : @"False";
    
    NSDictionary* itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              inpItem.itemName, @"itemName",
                              inpItem.itemTime, @"itemTime",
                              itemPurchasedStr, @"itemPurchased", nil];
    
    AppData* sharedInstance = [AppData sharedManager];
    
    [[[[[sharedInstance.dataNode child:inpList.listOwner.uid]
        child:inpList.listName]
       child:@"listItems"]
      child:inpItem.itemName]
     setValue:itemDict];
}


@end
