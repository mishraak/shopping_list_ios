#import "SaveListOnCloud.h"


@implementation SaveListOnCloud


+(void)save:(GroceryListClass *)inpList
{
    if ( FIRAuth.auth.currentUser == nil )
        return;
    
    NSString* listName = inpList.listName;
    
    NSMutableDictionary* listDict = [NSMutableDictionary new];
    
    [listDict setObject:listName forKey:@"listName"];
    
    NSDictionary* ownerDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               inpList.listOwner.name, @"name",
                               inpList.listOwner.email, @"email",
                               inpList.listOwner.uid, @"uid",nil];
    
    [listDict setObject:ownerDict forKey:@"listOwner"];

    NSMutableDictionary* itemsDict = [NSMutableDictionary new];
    
    for (ItemClass* any in inpList.listItems)
    {
        NSString* itemPurchasedStr = any.itemPurchased ? @"True" : @"False";
        
        NSDictionary* thisItemDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     any.itemName, @"itemName" ,
                                      any.itemTime, @"itemTime" ,
                                      itemPurchasedStr, @"itemPurchased" ,nil];
        
        [itemsDict setObject:thisItemDict forKey:any.itemName];
    }
    
    [listDict setObject: itemsDict forKey:@"listItems"];
    
    AppData *sharedInstance = [AppData sharedManager];
    
    [[[sharedInstance.dataNode child: sharedInstance.curUser.uid] child:listName] setValue: listDict];
}


@end
