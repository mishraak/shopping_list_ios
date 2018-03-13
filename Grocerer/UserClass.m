#import "UserClass.h"

@implementation UserClass

-(id)initWith:(NSString *)inpName
     andEmail:(NSString *)inpEmail
       andUid:(NSString *)inpUid
{
    _name = inpName;
    _email = inpEmail;
    _uid = inpUid;
    return self;
}


- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeObject:_name forKey:@"nameKey"];
    [aCoder encodeObject:_email forKey:@"emailKey"];
    [aCoder encodeObject:_uid forKey:@"uidKey"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    NSString* thisName = [aDecoder decodeObjectForKey:@"nameKey"];
    NSString* thisEmail = [aDecoder decodeObjectForKey:@"emailKey"];
    NSString* thisUid = [aDecoder decodeObjectForKey:@"uidKey"];
    
    return [self initWith:thisName andEmail:thisEmail andUid:thisUid];
}

@end
