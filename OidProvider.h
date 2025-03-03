#import <Foundation/NSObject.h>

@class NSString;
@class NSArray;

@protocol OidProvider

- (NSString *) oidForObject: (id)obj;
- (NSString *) oidString;

- (NSArray *) connectionsWithSource: (id)src;
- (NSArray *) connectionsWithDestination: (id)dst;

@end