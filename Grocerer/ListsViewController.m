#import "ListsViewController.h"


@implementation ListsViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    
    [_listsTableView reloadData];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sharedInstance = [AppData sharedManager];

    
    [self readData];
    

    
    
}



-(void)readData
{
    [ReadUserFromDisk read];
    
    if (_sharedInstance.curUser != nil)
    {
        [ReadDataFromDisk read];
        _sharedInstance.currentLST = _sharedInstance.offlineLST;
    }
    else
    {
        _sharedInstance.curUser = [[UserClass alloc] initWith:@"Me"
                                                     andEmail:@"defEmail"
                                                       andUid:@"defUid"];
        [PrepareFirstLists prepare];
        
        [WriteUserToDisk write];
        [WriteDataToDisk write];
    }
    
    [_listsTableView reloadData];
     [self setProfileButton:@"Offline!" andColor:[UIColor orangeColor]];
    
    
    
    if ( FIRAuth.auth.currentUser != nil)
    {
        [self setProfileButton:@"Online!" andColor:[UIColor greenColor]];
        
        [ReadDataFromDisk read];
        
        
        [ReadDataFromCloud read];
        [ReadInvitations readCoordinates];
        

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
       {
           _sharedInstance.currentLST = [CompareGroceryLists compare:_sharedInstance.offlineLST
                                                                 and:_sharedInstance.onlineLST];
           
           for (GroceryListClass* any in _sharedInstance.currentLST)
           {
               any.listOwner = _sharedInstance.curUser;
               [SaveListOnCloud save:any];
           }
           [WriteDataToDisk write];

           [FetchInvitations fetchInvitations];
           
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
           {
           
               for (GroceryListClass *any in _sharedInstance.invitationLST)
               {
                   [_sharedInstance.currentLST addObject: any];
               }
               
               [_listsTableView reloadData];
           });
           
       });
    }
}

-(void)setProfileButton:(NSString *)status andColor:(UIColor *)bgColor
{
    [_profileButton setTitle:status forState:UIControlStateNormal];
    _profileButton.backgroundColor = bgColor;
}




-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sharedInstance.currentLST.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listsCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = _sharedInstance.currentLST[indexPath.row].listName;
    
    NSString* subText = [NSString stringWithFormat:@"%lu items for %@",
                         (unsigned long)_sharedInstance.currentLST[indexPath.row].listItems.count,
                         _sharedInstance.currentLST[indexPath.row].listOwner.name];
    
    cell.detailTextLabel.text = subText;
    
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroceryListClass* toRemove = [_sharedInstance.currentLST objectAtIndex:indexPath.row];

    if ( [toRemove.listOwner.uid isEqualToString: _sharedInstance.curUser.uid] )
        return @"Delete?";
    else
        return @"Reject?";
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroceryListClass* toRemove = [_sharedInstance.currentLST objectAtIndex:indexPath.row];
    [_sharedInstance.currentLST removeObject: toRemove];
    
    if ( [toRemove.listOwner.uid isEqualToString: _sharedInstance.curUser.uid] )
    {
        // this is our list
        [WriteDataToDisk write];
        [DeleteListFromCloud deleteList: toRemove];
    }
    else
    {
        // this is someome else's list
        InvitationClass* toRemoveInvitation = [[InvitationClass alloc] initWith:toRemove.listName
                                                                        andUser:toRemove.listOwner];
        [RemoveTheInvitation remove:toRemoveInvitation];
    }
    
    if ( _sharedInstance.currentLST.count == 0 && FIRAuth.auth.currentUser != nil)
        [[_sharedInstance.dataNode child: _sharedInstance.curUser.uid]  setValue: 0];

    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
}











-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toItemsSegue_id" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemsViewController* itemsCtrl = [segue destinationViewController];
    
    itemsCtrl.curListInt = (int)((NSIndexPath *)sender).row;
}



- (IBAction)newListAction:(id)sender {
    UIAlertController* alert;
    
    alert = [UIAlertController alertControllerWithTitle:@"New List"
                                                message:@"Enter the name of your new shopping list"
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"new list name";
        textField.font = [UIFont systemFontOfSize:20];
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Ok"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action)
                                               {
                                                   [self newListAlertOkAction:alert.textFields[0].text];
                                               }]];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];

    [self presentViewController: alert animated:true completion:nil];
}


-(void)newListAlertOkAction:(NSString *)inpListName
{
    GroceryListClass* newList;
    newList = [[GroceryListClass alloc] initWith:inpListName
                                         andItem:[NSMutableArray new]
                                         forUser:_sharedInstance.curUser];
    
    [_sharedInstance.currentLST addObject: newList];
    [_listsTableView reloadData];
    
    [WriteDataToDisk write];
    
    [SaveListOnCloud save: newList];
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



- (IBAction)profileAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Profile"
                                                                   message:@"What would you like to do?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *regAction = [UIAlertAction actionWithTitle:@"Register"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action){
                                                          [self registerAlert];
                                                      }];
    [alert addAction: regAction];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action){
                                                          [self loginAlert];
                                                      }];
    [alert addAction: loginAction];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Logout"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)    {
                                                          [self logoutAction];
                                                      }];
    [alert addAction: logoutAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    [alert addAction: cancelAction];
    
    [self presentViewController:alert animated:true completion:nil];
    
}


-(void)logoutAction
{
    NSError *signoutError;
    BOOL status = [[FIRAuth auth] signOut:&signoutError];
    if ( status)
    {
        [self alertShowWithTitle:@"Logged Out" andBody:@"You can still work offline"];
        [self readData];
    }
    else
        [self alertShowWithTitle:@"Sign Out Error" andBody:@"something happened"];
}


-(void)loginAlert
{
    UIAlertController* loginAlert;
    loginAlert = [UIAlertController alertControllerWithTitle:@"Login"
                                                     message:@"Please enter email and password"
                                              preferredStyle:UIAlertControllerStyleAlert];

    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
        textField.font = [UIFont systemFontOfSize:20];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.font = [UIFont systemFontOfSize:20];
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.secureTextEntry = true;
    }];
    
    [loginAlert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action)
                {
                    [self loginMethod:loginAlert.textFields[0].text
                              andPass:loginAlert.textFields[1].text];
                }]];
    
    [loginAlert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self presentViewController: loginAlert animated:true completion:nil];
}

-(void)loginMethod:(NSString *)inpEmail andPass:(NSString *)inpPassword
{
    [FIRAuth.auth signInWithEmail:inpEmail
                         password:inpPassword
                       completion:^(FIRUser * _Nullable user,
                                    NSError * _Nullable error)
            {
                if (error != nil)
                    return;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(0.5 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^
                   {
                       [SetTheUser setWithName:user.displayName
                                      andEmail:user.email
                                        andUid:user.uid];
                       
                       [self readData]; // we have to edit this
                       
                       [self alertShowWithTitle:@"Logged In!" andBody:@"Welcome Back"];
                   });
            }];
}



-(void)registerAlert
{
    UIAlertController* registerAlert;
    registerAlert = [UIAlertController alertControllerWithTitle:@"Register"
                                                        message:@"Please enter name, email and password"
                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [registerAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
        textField.font = [UIFont systemFontOfSize:20];
         textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    
    [registerAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
        textField.font = [UIFont systemFontOfSize:20];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [registerAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.font = [UIFont systemFontOfSize:20];
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.secureTextEntry = true;
    }];
    
    [registerAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self registerMethod:registerAlert.textFields[0].text
                    andEmail:registerAlert.textFields[1].text
                     andPass:registerAlert.textFields[2].text];
        
    }]];
    
    [registerAlert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
    
    [self presentViewController: registerAlert animated:true completion:nil];
}

-(void)registerMethod:(NSString *)name andEmail:(NSString *)email andPass:(NSString *)password
{
    [FIRAuth.auth createUserWithEmail:email
                             password:password
                           completion:^(FIRUser * _Nullable user,
                                        NSError * _Nullable error)
     {
         if (error != nil)
             return;
         
         FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
         changeRequest.displayName = name;
         [changeRequest commitChangesWithCompletion:^(NSError * _Nullable profError)
          {
              if (profError != nil)
                  return;
              
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
              {
                  [SetTheUser setWithName:name
                                 andEmail:email
                                   andUid:user.uid];
                  
                  NSDictionary* userDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            name, @"name",
                                            email, @"email",
                                            user.uid, @"uid",nil];
                  
                  [[_sharedInstance.usersNode child:user.uid] setValue:userDict];
                  
                  if (_sharedInstance.currentLST.count > 0)
                  {
                      for (GroceryListClass* any in _sharedInstance.currentLST)
                      {
                          [SaveListOnCloud save:any];
                      }
                  }
                  else
                  {
                      [[_sharedInstance.dataNode child: _sharedInstance.curUser.uid]  setValue: [NSNumber numberWithInt:0]];
                  }
                  
                  [self readData];
                  
                  [self alertShowWithTitle:@"Success"
                                   andBody:@"You have successfully registered on the cloud"];
                  
              });
          }];
     }];
}










@end
