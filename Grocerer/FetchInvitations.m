#import "FetchInvitations.h"

@implementation FetchInvitations


+(void)fetchInvitations
{
    AppData *sharedInstance = [AppData sharedManager];
    
    sharedInstance.invitationLST = [NSMutableArray new];
    
    
    if (FIRAuth.auth.currentUser == nil || sharedInstance.invitationsCoords.count == 0)
        return;
    
    
    for ( InvitationClass * anyCoord in sharedInstance.invitationsCoords)
    {
        NSString* listName = anyCoord.listName;
        NSString* ownerUid = anyCoord.listOwner.uid;
        
        [[sharedInstance.dataNode child:ownerUid]
         observeSingleEventOfType:FIRDataEventTypeValue
         withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
             
             
             NSDictionary* lists = snapshot.value;
             

             if ( lists == nil)
                 return ;
             
             NSDictionary* thisListAllData = [lists valueForKey: listName];
             

             
             NSMutableArray <ItemClass *> * thisListItems = [NSMutableArray new];
             
//             if ( [thisListAllData objectForKey: @"listItems"] == nil)
//                 return;
             
             NSDictionary* listItems = [thisListAllData objectForKey:@"listItems"];
             for (NSDictionary *item in listItems.allValues)
             {
                 NSString* readItemName = item[@"itemName"];
                 NSString* readItemPurchasedStr = item[@"itemPurchased"];
                 
                 BOOL readItemPurchased  = false;
                 
                 if ([readItemPurchasedStr isEqualToString: @"True"] ||
                     [readItemPurchasedStr isEqualToString: @"true"])
                 {
                     readItemPurchased = true;
                 }
                 
                 NSString* readItemTime = item[@"itemTime"];
                 
                 ItemClass* thisItem = [[ItemClass alloc] initWith:readItemName
                                                           andTime:readItemTime
                                                         andStatus:readItemPurchased];
                 
                 [thisListItems addObject: thisItem];
             }
             
             GroceryListClass* thisList = [[GroceryListClass alloc]  initWith:listName
                                                                      andItem:thisListItems
                                                                      forUser:anyCoord.listOwner];
             

             
             [sharedInstance.invitationLST addObject: thisList];
         }];
    }
}
@end
