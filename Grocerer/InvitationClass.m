#import "InvitationClass.h"

@implementation InvitationClass

-(id)initWith:(NSString *)inpListName andUser:(UserClass *)inpListPwner
{
    _listName = inpListName;
    _listOwner = inpListPwner;
    
    return self;
    
    // Coordinate for where the invitation is
}
@end
