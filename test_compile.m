/*
 * Simple compilation test for the enhanced programmatic attribute extraction
 * Compatible with OPENSTEP 4.2 classic Objective-C runtime
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NSObject_KeyExtraction.h"

int main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool;
    NSButton *button;
    NSSet *keys;
    AttributeType titleType;
    AttributeType enabledType;
    id titleValue;
    id enabledValue;
    
    pool = [[NSAutoreleasePool alloc] init];
    
    // Test the programmatic attribute extraction
    button = [[NSButton alloc] init];
    [button setTitle: @"Test Button"];
    [button setEnabled: YES];
    
    // Test the new methods
    keys = [button keysForObject];
    NSLog(@"Found %lu keys for NSButton", (unsigned long)[keys count]);
    
    // Test attribute type detection
    titleType = [NSObject attributeTypeForKey: @"title" onObject: button];
    enabledType = [NSObject attributeTypeForKey: @"isEnabled" onObject: button];
    
    NSLog(@"Title attribute type: %d", titleType);
    NSLog(@"IsEnabled attribute type: %d", enabledType);
    
    // Test value extraction
    titleValue = [button extractValueForKey: @"title" usingType: titleType];
    enabledValue = [button extractValueForKey: @"isEnabled" usingType: enabledType];
    
    NSLog(@"Title value: %@", titleValue);
    NSLog(@"Enabled value: %@", enabledValue);
    
    [button release];
    [pool release];
    
    return 0;
}
