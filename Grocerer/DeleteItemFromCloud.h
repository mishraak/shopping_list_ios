#import <Foundation/Foundation.h>
#import "GroceryListClass.h"
#import "AppData.h"
#import <Firebase.h>

@interface DeleteItemFromCloud : NSObject

+(void)deleteItem:(ItemClass *)inpItem inList:(GroceryListClass *)inpList;


@end
