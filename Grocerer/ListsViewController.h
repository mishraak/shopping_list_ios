#import <UIKit/UIKit.h>
#import "AppData.h"
#import "PrepareFirstLists.h"
#import "ReadUserFromDisk.h"
#import "ReadDataFromDisk.h"
#import "WriteUserToDisk.h"
#import "WriteDataToDisk.h"
#import "ItemsViewController.h"
#import "SetTheUser.h"
#import "SaveListOnCloud.h"
#import "ReadDataFromCloud.h"
#import "CompareGroceryLists.h"
#import "DeleteListFromCloud.h"


#import "ReadInvitations.h"
#import "FetchInvitations.h"

#import "RemoveTheInvitation.h"



@interface ListsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, retain) AppData* sharedInstance;


@property (weak, nonatomic) IBOutlet UITableView *listsTableView;

@property (weak, nonatomic) IBOutlet UIButton *profileButton;

- (IBAction)newListAction:(id)sender;

- (IBAction)profileAction:(id)sender;

-(void)alertShowWithTitle:(NSString *)titleInp andBody:(NSString *)bodyInp;

@end

