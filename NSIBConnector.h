// This file is part of GNUstep

#import <Foundation/NSObject.h>

@class NSString;

@interface NSIBConnector : NSObject

- (id) source;
- (id) destination;
- (NSString *) label;

@end

@interface NSIBOutletConnector : NSIBConnector
@end

@interface NSIBControlConnector : NSIBConnector
@end