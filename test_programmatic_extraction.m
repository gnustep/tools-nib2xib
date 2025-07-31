/* Test program to demonstrate programmatic attribute extraction
 * Copyright (C) 2024 Free Software Foundation, Inc.
 * 
 * This file is part of GNUstep.
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "NSObject_KeyExtraction.h"
#import "XMLNode.h"

@interface TestOidProvider : NSObject <OidProvider>
{
  int _oidCounter;
}
@end

@implementation TestOidProvider

- (id) init
{
  self = [super init];
  if (self != nil)
  {
    _oidCounter = 1000;
  }
  return self;
}

- (NSString *) oidForObject: (id)obj
{
  return [NSString stringWithFormat: @"test-%d", _oidCounter++];
}

- (NSString *) oidString
{
  return [NSString stringWithFormat: @"test-%d", _oidCounter++];
}

- (BOOL) isObjectProcessed: (id)object
{
  return NO; // For testing, don't cache
}

- (void) addProcessedObject: (id)object withNode: (XMLNode *)node
{
  // Do nothing for test
}

- (XMLNode *) processedObject: (id)object
{
  return nil;
}

- (void) addConnectionsForObject: (id)obj toNode: (XMLNode *)node
{
  // Do nothing for test
}

@end

void testObjectExtraction(id object, NSString *description)
{
  printf("\n=== Testing %s ===\n", [description UTF8String]);
  
  TestOidProvider *provider = [[TestOidProvider alloc] init];
  
  // Test the new programmatic key extraction
  NSSet *keys = [object keysForObject];
  printf("Found %lu attributes:\n", (unsigned long)[keys count]);
  
  NSEnumerator *en = [keys objectEnumerator];
  NSString *key = nil;
  
  while ((key = [en nextObject]) != nil)
  {
    AttributeType type = [NSObject attributeTypeForKey: key onObject: object];
    id value = [object extractValueForKey: key usingType: type];
    BOOL shouldProcess = [object shouldProcessKey: key withValue: value];
    
    printf("  %s (type: %d) = %s [process: %s]\n", 
           [key UTF8String], 
           type, 
           [[value description] UTF8String], 
           shouldProcess ? "YES" : "NO");
  }
  
  // Test full XML generation
  XMLNode *xmlNode = [object processObjectWithParser: provider];
  printf("\nGenerated XML:\n%s\n", [[xmlNode description] UTF8String]);
  
  [provider release];
}

int main(int argc, const char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  printf("=== Programmatic Attribute Extraction Test ===\n");
  
  // Test with various objects
  NSButton *button = [[NSButton alloc] initWithFrame: NSMakeRect(10, 10, 100, 30)];
  [button setTitle: @"Test Button"];
  [button setTag: 42];
  testObjectExtraction(button, @"NSButton");
  [button release];
  
  NSTextField *textField = [[NSTextField alloc] initWithFrame: NSMakeRect(20, 20, 150, 25)];
  [textField setStringValue: @"Test Text"];
  [textField setEditable: YES];
  testObjectExtraction(textField, @"NSTextField");
  [textField release];
  
  NSWindow *window = [[NSWindow alloc] initWithContentRect: NSMakeRect(100, 100, 400, 300)
                                                 styleMask: NSTitledWindowMask | NSClosableWindowMask
                                                   backing: NSBackingStoreBuffered 
                                                     defer: NO];
  [window setTitle: @"Test Window"];
  testObjectExtraction(window, @"NSWindow");
  [window release];
  
  [pool release];
  return 0;
}
