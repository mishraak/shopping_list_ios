#import <Foundation/Foundation.h>
#import "UserClass.h"
#import "ItemClass.h"

@interface GroceryListClass : NSObject <NSCoding>

@property (nonatomic, retain) NSString* listName;
@property (nonatomic, retain) UserClass* listOwner;
@property (nonatomic, retain) NSMutableArray<ItemClass *> * listItems;
           

-(id)initWith:(NSString *)inpName
      andItem:(NSMutableArray <ItemClass *> *)inpItems
      forUser:(UserClass *)inpOwner;

@end
