#import <Foundation/Foundation.h>

@interface ItemClass : NSObject <NSCoding>

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* itemTime;
@property (nonatomic) bool itemPurchased;

-(id)initWith:(NSString *) inpName
      andTime:(NSString *) inpTime
    andStatus:(bool) inpPurchased;


@end
