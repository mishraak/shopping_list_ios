#import "PrepareFirstLists.h"

@implementation PrepareFirstLists

+(void)prepare
{
    // 2 lists, each with 2 items. Milk, Bread, Pen, Pencil
    
    AppData * sharedInstance = [AppData sharedManager];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *timeNow = [formatter stringFromDate:[NSDate date]];
    
    
    ItemClass* item1 = [[ItemClass alloc] initWith:@"Milk"
                                           andTime:timeNow
                                         andStatus:false];
    
    ItemClass* item2 = [[ItemClass alloc] initWith:@"Bread"
                                           andTime:timeNow
                                         andStatus:true];
    
    NSMutableArray* itemsOfList_1 = [[NSMutableArray alloc] initWithObjects: item1, item2, nil];

    GroceryListClass* listA = [[GroceryListClass alloc] initWith:@"Sample List"
                                                         andItem:itemsOfList_1
                                                         forUser:sharedInstance.curUser];
    [sharedInstance.currentLST addObject: listA];
    
    
    
    ItemClass* item3 = [[ItemClass alloc] initWith:@"Pens"
                                           andTime:timeNow
                                         andStatus:false];
    
    ItemClass* item4 = [[ItemClass alloc] initWith:@"Pencils"
                                           andTime:timeNow
                                         andStatus:true];
    
    NSMutableArray* itemsOfList_2 = [[NSMutableArray alloc] initWithObjects: item3, item4, nil];
    
    GroceryListClass* listB = [[GroceryListClass alloc] initWith:@"Office Stuff"
                                                         andItem:itemsOfList_2
                                                         forUser:sharedInstance.curUser];
    [sharedInstance.currentLST addObject: listB];
}

@end
