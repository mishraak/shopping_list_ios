#import <Foundation/Foundation.h>
#import "GroceryListClass.h"
#import <Firebase.h>
#import "AppData.h"

@interface SaveListOnCloud : NSObject

+(void)save:(GroceryListClass *)inpList;

@end
