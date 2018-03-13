#import "RemoveTheInvitation.h"

@implementation RemoveTheInvitation

+(void)remove:(InvitationClass *)inpInvitation
{
    if (FIRAuth.auth.currentUser == nil)
        return;
    
    NSString* invitationTitle = [NSString stringWithFormat:@"%@|%@",
                                 inpInvitation.listOwner.uid,
                                 inpInvitation.listName];
    
    AppData* sharedInstance = [AppData sharedManager];
    
    FIRDatabaseReference *invitationNode = [[[sharedInstance.usersNode
                                              child:sharedInstance.curUser.uid]
                                             child: @"myInvitations"]
                                            child:invitationTitle];
    
    [invitationNode removeValue];
}
@end
