#import <Foundation/Foundation.h>
#import "AppData.h"

@interface CompareGroceryLists : NSObject


+(NSMutableArray<GroceryListClass *> *)compare:(NSMutableArray<GroceryListClass *> *)listA and:(NSMutableArray<GroceryListClass *> *)listB;
@end
