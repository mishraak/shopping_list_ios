#import "ItemClass.h"

@implementation ItemClass

-(id)initWith:(NSString *) inpName
      andTime:(NSString *) inpTime
    andStatus:(bool) inpPurchased
{
    _itemName = inpName;
    _itemTime = inpTime;
    _itemPurchased = inpPurchased;
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:_itemName forKey:@"itemNameKey"];
    [aCoder encodeObject:_itemTime forKey:@"itemTimeKey"];
    [aCoder encodeBool:_itemPurchased forKey:@"itemPurchasedKey"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    NSString* thisName = [aDecoder decodeObjectForKey:@"itemNameKey"];
    NSString* thisTime = [aDecoder decodeObjectForKey:@"itemTimeKey"];
    bool thisPurchased = [aDecoder decodeBoolForKey:@"itemPurchasedKey"];
    
    return [self initWith:thisName andTime:thisTime andStatus:thisPurchased];
}

@end
