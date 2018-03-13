#import <Foundation/Foundation.h>
#import "UserClass.h"
#import "GroceryListClass.h"
#import <Firebase.h>
#import "InvitationClass.h"

@interface AppData : NSObject

@property (nonatomic, retain) UserClass* curUser;
@property (nonatomic, retain) NSMutableArray<GroceryListClass *> * currentLST;


@property (nonatomic, retain) NSMutableArray<GroceryListClass *> * offlineLST;


+(id)sharedManager;


#pragma mark firebase
@property (nonatomic, retain) NSMutableArray<GroceryListClass *> * onlineLST;

@property (nonatomic) FIRDatabaseReference *rootNode;
@property (nonatomic) FIRDatabaseReference *dataNode;
@property (nonatomic) FIRDatabaseReference *usersNode;



@property (nonatomic, retain) NSMutableArray <InvitationClass *> * invitationsCoords;
@property (nonatomic, retain) NSMutableArray <GroceryListClass *> * invitationLST;


@end
