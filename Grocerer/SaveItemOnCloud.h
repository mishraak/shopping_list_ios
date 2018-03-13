#import <Foundation/Foundation.h>
#import "ItemClass.h"
#import "GroceryListClass.h"
#import "AppData.h"
#import <Firebase.h>

@interface SaveItemOnCloud : NSObject

+(void)save:(ItemClass *)inpItem inList:(GroceryListClass *)inpList;

@end
