
#import "ReadInvitations.h"

@implementation ReadInvitations

+(void) readCoordinates;
{
    AppData *sharedInstance = [AppData sharedManager];
    
    sharedInstance.invitationsCoords = [NSMutableArray new];
    
    
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    NSString* userId = FIRAuth.auth.currentUser.uid;
    
    [[sharedInstance.usersNode child:userId]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         NSDictionary* value = snapshot.value;
         
         
         
         if ( value[@"myInvitations"] == nil)
         {
             return;
         }
         
         NSDictionary* allCoordData = value[@"myInvitations"];
         
         
         for (NSDictionary* eachCoordAllVals in allCoordData.allValues)
         {
             NSString* foundListName = eachCoordAllVals[@"listName"];
             
             NSString* foundOwnerUid = eachCoordAllVals[@"ownerUid"];
             NSString* foundOwnerName = eachCoordAllVals[@"ownerName"];
             NSString* foundOwnerEmail = eachCoordAllVals[@"ownerEmail"];
             
             InvitationClass* thisInvite = [[InvitationClass alloc] initWith:foundListName
                                                                     andUser:[[UserClass alloc] initWith:foundOwnerName andEmail:foundOwnerEmail andUid:foundOwnerUid]];
             
             [sharedInstance.invitationsCoords addObject: thisInvite];
         }
     }];
}

@end
