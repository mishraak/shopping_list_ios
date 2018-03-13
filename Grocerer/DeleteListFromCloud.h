#import <Foundation/Foundation.h>
#import "GroceryListClass.h"
#import "AppData.h"
#import <Firebase.h>

@interface DeleteListFromCloud : NSObject

+(void)deleteList:(GroceryListClass *)inpList;

@end
