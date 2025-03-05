// This file is part of GNUstep

#import <Foundation/Foundation.h>

#import "NSIBConnector.h"
#import "OidProvider.h"
#import "XMLNode.h"

@implementation NSIBOutletConnector (toXML)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)p
{
	XMLNode *node = [[XMLNode alloc] initWithName: @"outlet"];

	[node addAttribute: @"property" value: [self label]];
	[node addAttribute: @"target" value: [p oidForObject: [self source]]];
	[node addAttribute: @"id" value: [p oidString]];
	NSLog(@"outlet = %@", node);

	return node;
}

@end

@implementation NSIBControlConnector (toXML)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)p
{
	XMLNode *node = [[XMLNode alloc] initWithName: @"action"];

	[node addAttribute: @"selector" value: [self label]];
	[node addAttribute: @"target" value: [p oidForObject: [self source]]];
	[node addAttribute: @"id" value: [p oidString]];
	
	// NSLog(@"keys = %@", [super keysForObject]);
	NSLog(@"action = %@", node);
	
	return node;
}

@end

@implementation NSIBConnector (toXML)

- (id) source
{
	return source;
}

- (id) destination
{
	return destination;
}

- (NSString *) label
{
	return label;
}

@end