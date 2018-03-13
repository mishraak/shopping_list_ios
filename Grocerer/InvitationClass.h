#import <Foundation/Foundation.h>
#import "UserClass.h"

@interface InvitationClass : NSObject

@property (nonatomic, retain) NSString *listName;
@property (nonatomic, retain) UserClass* listOwner;

-(id)initWith:(NSString *)inpListName andUser:(UserClass *)inpListPwner;

@end
