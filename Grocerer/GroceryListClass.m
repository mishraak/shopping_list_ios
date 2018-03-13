#import "GroceryListClass.h"

@implementation GroceryListClass

-(id)initWith:(NSString *)inpName
      andItem:(NSMutableArray <ItemClass *> *)inpItems
      forUser:(UserClass *)inpOwner
{
    _listName = inpName;
    _listItems = inpItems;
    _listOwner = inpOwner;
    
    return self;
}



- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:_listName forKey:@"listNameKey"];
    [aCoder encodeObject:_listOwner forKey:@"listOwnerKey"];
    [aCoder encodeObject:_listItems forKey:@"listItemsKey"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    NSString* thisName = [aDecoder decodeObjectForKey:@"listNameKey"];
    UserClass* thisOwner = [aDecoder decodeObjectForKey:@"listOwnerKey"];
    NSMutableArray<ItemClass *> *thisItems = [aDecoder decodeObjectForKey:@"listItemsKey"];
    
    return [self initWith:thisName andItem:thisItems forUser:thisOwner];
}

@end
