#import "ItemsViewController.h"

@implementation ItemsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sharedInstance = [AppData sharedManager];
    _listNameLabel.text = _sharedInstance.currentLST[_curListInt].listName;
    
    
    
    
    
    
    
    
    
    _itemTextField.returnKeyType = UIReturnKeyDone;
    _itemTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *timeNow = [formatter stringFromDate:[NSDate date]];
    
    ItemClass* newItem = [[ItemClass alloc] initWith:textField.text
                                             andTime:timeNow
                                           andStatus:false];
    

    
    [[_sharedInstance.currentLST objectAtIndex: _curListInt].listItems addObject: newItem];
    
    

    
    [_itemsTableView reloadData];
    
    
    [SaveItemOnCloud save:newItem
                   inList:[_sharedInstance.currentLST
                           objectAtIndex: _curListInt]];
    
    
    [WriteDataToDisk write];

    textField.text = @"";
}















-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sharedInstance.currentLST objectAtIndex:_curListInt].listItems.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"itemsCell"
                                                            forIndexPath:indexPath];
    
    ItemClass* thisItem = [[_sharedInstance.currentLST objectAtIndex:_curListInt].listItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = thisItem.itemName;
    
    if ( thisItem.itemPurchased)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:thisItem.itemName];
        
        [attrStr addAttribute:NSStrikethroughStyleAttributeName
                        value:@2
                        range:NSMakeRange(0,
                                          thisItem.itemName.length)];
        
        cell.textLabel.attributedText = attrStr;
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:thisItem.itemName];
        
        [attrStr addAttribute:NSStrikethroughStyleAttributeName
                        value:@0
                        range:NSMakeRange(0,
                                          thisItem.itemName.length)];
        
        cell.textLabel.attributedText = attrStr;
    }
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[_sharedInstance.currentLST objectAtIndex:_curListInt].listItems objectAtIndex:indexPath.row].itemPurchased =
    ![[_sharedInstance.currentLST objectAtIndex:_curListInt].listItems objectAtIndex:indexPath.row].itemPurchased;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *timeNow = [formatter stringFromDate:[NSDate date]];
    
    [[_sharedInstance.currentLST objectAtIndex:_curListInt].listItems objectAtIndex:indexPath.row].itemTime = timeNow;
    
    [_itemsTableView reloadData];
    
    
    
    GroceryListClass* thisList = [_sharedInstance.currentLST objectAtIndex:_curListInt];
    ItemClass* thisItem = [thisList.listItems objectAtIndex: indexPath.row];
    [SaveItemOnCloud save:thisItem inList:thisList];
    
    
    
    [WriteDataToDisk write];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete?";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemClass* toRemove = [[_sharedInstance.currentLST objectAtIndex:_curListInt].listItems
                           objectAtIndex: indexPath.row];
    
    [[_sharedInstance.currentLST objectAtIndex: _curListInt].listItems removeObject: toRemove];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    GroceryListClass* thisList = [_sharedInstance.currentLST objectAtIndex:_curListInt];
    
    [DeleteItemFromCloud deleteItem:toRemove
                             inList:thisList];
    
    [WriteDataToDisk write];
}






- (IBAction)shareThisAction:(id)sender
{
    if (FIRAuth.auth.currentUser == nil)
    {
        [self alertShowWithTitle:@"Offline"
                         andBody:@"You are offline, you should login before using this feature"];
        return;
    }
    
    UIAlertController* alert;
    
    alert = [UIAlertController alertControllerWithTitle:@"Inviting?"
                                                message:@"Please enter the email address of the person you wish to invite"
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email address";
        textField.font = [UIFont systemFontOfSize:22];
    }];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Invite"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action)
                                                        {
                                                [self inviteThisPerson:alert.textFields[0].text];
                                                        }]];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                             handler: nil]];
 
    [self presentViewController: alert animated:true completion:nil];
}



-(void)inviteThisPerson:(NSString *)inpEmailAddress
{
    __block UserClass* inviteeUser;
    __block UserClass* ownerUser = [_sharedInstance.currentLST objectAtIndex:_curListInt].listOwner;
    
    NSString* thisListName = [_sharedInstance.currentLST objectAtIndex: _curListInt].listName;
    
    [_sharedInstance.usersNode
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
    {
        NSDictionary* content = snapshot.value;
        
        for (NSDictionary *thisOne in content.allValues)
        {
            if ([[thisOne objectForKey:@"email"] isEqualToString:inpEmailAddress])
            {
                NSString* foundName = [thisOne objectForKey:@"name"];
                NSString* foundEmail = [thisOne objectForKey:@"email"];
                NSString* foundUid = [thisOne objectForKey:@"uid"];
                
                inviteeUser = [[UserClass alloc] initWith:foundName
                                                 andEmail:foundEmail
                                                   andUid:foundUid];
                
                break;
            }
        }
        if (inviteeUser == nil)
        {
            [self alertShowWithTitle:@"No Such User"
                             andBody:@"Please double check the email address"];
            return ;
        }
        
        
        
        NSString* invitationTitle = [NSString stringWithFormat:@"%@|%@", ownerUser.uid, thisListName];
        
        NSDictionary* inviteeDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    thisListName, @"listName",
                                     ownerUser.name, @"ownerName",
                                     ownerUser.email, @"ownerEmail",
                                     ownerUser.uid, @"ownerUid", nil];

        FIRDatabaseReference *invitationNode = [[[_sharedInstance.usersNode child: inviteeUser.uid]
                                                 child:@"myInvitations"] child: invitationTitle] ;
        [invitationNode setValue: inviteeDict];
        
        [self alertShowWithTitle:@"Invitation Sent" andBody:@"You have successfully sent an invitation"];
    }];
}



- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}



-(void)alertShowWithTitle:(NSString *)titleInp andBody:(NSString *)bodyInp
{
    UIAlertController* alert;
    alert = [UIAlertController alertControllerWithTitle:titleInp
                                                message:bodyInp
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:true completion:nil];
}



@end
