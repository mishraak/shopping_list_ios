#import <Foundation/Foundation.h>

@interface UserClass : NSObject <NSCoding>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * uid;

-(id)initWith:(NSString *)inpName
     andEmail:(NSString *)inpEmail
       andUid:(NSString *)inpUid;

@end
