#import <UIKit/UIKit.h>
#import "AppData.h"
#import "WriteDataToDisk.h"
#import "SaveItemOnCloud.h"
#import "DeleteItemFromCloud.h"

@interface ItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) AppData* sharedInstance;

@property (nonatomic) int curListInt;


@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;


- (IBAction)shareThisAction:(id)sender;



- (IBAction)goBackAction:(id)sender;

@end
