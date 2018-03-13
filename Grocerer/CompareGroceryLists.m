#import "CompareGroceryLists.h"

@implementation CompareGroceryLists

+(NSMutableArray<GroceryListClass *> *)compare:(NSMutableArray<GroceryListClass *> *)listA and:(NSMutableArray<GroceryListClass *> *)listB
{
    NSMutableArray<GroceryListClass *>* combinedLists = [NSMutableArray new];
    
    for (GroceryListClass *a in listA)
    {
        BOOL aIsUnique = true;
        for (GroceryListClass *anyList in listB)
        {
            if ( [a.listName isEqualToString: anyList.listName])
                aIsUnique = false;
        }
        if ( aIsUnique )
            [combinedLists addObject: a];
    }
    
    for (GroceryListClass *b in listB)
    {
        BOOL bIsUnique = true;
        for (GroceryListClass *anyList in listA)
        {
            if ( [b.listName isEqualToString: anyList.listName])
                bIsUnique = false;
        }
        if ( bIsUnique )
            [combinedLists addObject: b];
    }
    
    // now remove the unique and added from each of the two lists
    for (GroceryListClass* any in combinedLists)
    {
        if ([listA containsObject: any])
            [listA removeObject: any];
        else if ([listB containsObject: any])
            [listB removeObject: any];
    }
    
    // this is comparing twi lists with the same name
    for (GroceryListClass* anyListA in listA)
    {
        NSMutableArray<ItemClass *> * thisListResultItems = [NSMutableArray new];
        GroceryListClass * counterPartList;
        
        for (GroceryListClass * anyListB in listB)
        {
            if ([anyListB.listName isEqualToString: anyListA.listName])
            {
                counterPartList = anyListB;
                break;
            }
        }
        for (ItemClass * anyItem in anyListA.listItems)
        {
            BOOL thisItemWasFound = false;
            
            for (ItemClass * counterItem in counterPartList.listItems)
            {
                if ( [anyItem.itemName isEqualToString: counterItem.itemName])
                {
                    thisItemWasFound = true;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
                    
                    NSDate* readTimeAnyItem = [formatter dateFromString:anyItem.itemTime];
                    NSDate* readTimeCounterItem = [formatter dateFromString:counterItem.itemTime];
                    
                    if (readTimeAnyItem > readTimeCounterItem)
                    {
                        [thisListResultItems addObject:anyItem];
                    }
                    else
                    {
                        [thisListResultItems addObject: counterItem];
                    }
                }
            }
            // if we reached here and the item wasn't found
            if ( thisItemWasFound == false)
            {
                [thisListResultItems addObject:anyItem];
            }
        }
        
        
        for (ItemClass* anyCounterItem in counterPartList.listItems)
        {
            BOOL thisItemIsAreadyAdded = false;
            for (ItemClass* anyItem in anyListA.listItems)
            {
                if ( [anyCounterItem.itemName isEqualToString: anyItem.itemName])
                    thisItemIsAreadyAdded = true;
            }
            if (thisItemIsAreadyAdded == false)
                [thisListResultItems addObject: anyCounterItem];
        }
        
        GroceryListClass* resList = [[GroceryListClass alloc] initWith:anyListA.listName
                                                               andItem:thisListResultItems
                                                               forUser:anyListA.listOwner];
        
        [combinedLists addObject: resList];
    }
    
    return combinedLists;
}

@end
