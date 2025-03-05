// This file is part of GNUstep

#import <Foundation/NSObject.h>
#import "XMLParsing.h"

@class NSString;

@interface NSIBConnector : NSObject <XMLParsing>
{
	id source;
	id destination;
	NSString *label;
}

- (id) source;
- (id) destination;
- (NSString *) label;

@end

@interface NSIBOutletConnector : NSIBConnector
@end

@interface NSIBControlConnector : NSIBConnector
@end

@interface NSIBOutletConnector (toXML) <XMLParsing>
@end

@interface NSIBControlConnector (toXML) <XMLParsing>
@end
