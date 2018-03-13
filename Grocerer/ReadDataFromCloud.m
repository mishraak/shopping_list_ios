#import "ReadDataFromCloud.h"

@implementation ReadDataFromCloud

+(void)read
{
    AppData *sharedInstance = [AppData sharedManager];
    
    sharedInstance.onlineLST = [NSMutableArray new];
    
    
    
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    NSString* userId = FIRAuth.auth.currentUser.uid;
    
    [[sharedInstance.dataNode child:userId]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
    {
        if (![snapshot.value isKindOfClass: [NSDictionary class]])
            return ;
        
        NSDictionary* lists = snapshot.value;

         if ( lists != nil)
         {
             for (NSDictionary* any in lists.allValues)
             {
                 NSString* readListName = [any objectForKey:@"listName"];

                 NSDictionary* readListOwner = [any objectForKey:@"listOwner"];
                 UserClass* thisListUser = [[UserClass alloc] initWith:[readListOwner objectForKey:@"name"]
                                                              andEmail:[readListOwner objectForKey:@"email"]
                                                                andUid:[readListOwner objectForKey:@"uid"]];

                 NSMutableArray<ItemClass* >* thisListItems = [NSMutableArray new];
                 if ([any objectForKey:@"listItems"] != nil)
                 {
                     NSDictionary* listItems = [any objectForKey:@"listItems"];

                     for (NSDictionary * eachItem in listItems.allValues)
                     {
                         NSDictionary* item = eachItem;
                         NSString* readItemName = [item objectForKey:@"itemName"];
                         NSString* readItemPurchasedStr = [item objectForKey:@"itemPurchased"];

                         BOOL readItemPurchased = false;

                         if ([readItemPurchasedStr isEqualToString: @"True"] ||
                             [readItemPurchasedStr isEqualToString: @"true"])
                         {
                             readItemPurchased = true;
                         }

                         NSString* readItemTime = [item objectForKey:@"itemTime"];

                         ItemClass* thisItem = [[ItemClass alloc] initWith:readItemName
                                                                   andTime:readItemTime
                                                                 andStatus:readItemPurchased];

                         [thisListItems addObject: thisItem];
                     }
                 }

                 GroceryListClass* thisList = [[GroceryListClass alloc] initWith:readListName
                                                                         andItem:thisListItems
                                                                         forUser:thisListUser];

                 [sharedInstance.onlineLST addObject: thisList];
             }
         }
     }];
}

@end
