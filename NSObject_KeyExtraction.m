/*
   Copyright (C) 2024 Free Software Foundation, Inc.

   Written by: Gregory John Casamento <greg.casamento@gmail.com>
   Date: 2024

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110 USA.
*/

#import <objc/objc.h>
#import <objc/objc-class.h>

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "NSObject_KeyExtraction.h"
#import "NSString_Additions.h"
#import "XMLNode.h"
#import "OidProvider.h"

#define DEBUG

@implementation NSObject (KeyExtraction)

+ (void) getAllMethodsForClass: (Class)cls
		     intoArray: (NSMutableArray *)methodsArray
{
	void *iterator = 0;
  struct objc_method_list *mlist;
  struct objc_class *superclass;

#ifdef DEBUG
  NSLog(@"class = %@", cls);
#endif
  if (cls == nil || cls == [NSObject class])
  {
    return;
  }
  
#ifdef DEBUG
  NSLog(@"Processing method list...");
#endif
  while ( mlist = class_nextMethodList( cls, &iterator ) )
  {
  	unsigned int count = 0; 
  	unsigned int i = 0;

  	count = mlist->method_count;
#ifdef DEBUG    
    // NSLog(@"count = %d", count);
#endif

  	for (i = 0; i < count; i++)
  	{
    	struct objc_method method = mlist->method_list[i];
    	SEL method_name = method.method_name;
      NSString *methodName = NSStringFromSelector(method_name);

    	[methodsArray addObject: methodName];
#ifdef DEBUG
      NSLog(@"i = %d, methodName = %@", i, methodName);
#endif
  	}
  }
#ifdef DEBUG
  NSLog(@"Done processing");
#endif

  // Recursively call this method for the superclass
  superclass = cls->super_class;
  [self getAllMethodsForClass:superclass intoArray:methodsArray];
}

+ (NSArray *) recursiveGetAllMethodsForClass: (Class)cls
{
  NSMutableArray *methodsArray = [NSMutableArray array];
  [self getAllMethodsForClass: cls
		    intoArray: methodsArray];
  return [methodsArray copy];
}

+ (NSArray *) skippedClasses
{
  NSArray *_skippedClasses = [NSArray arrayWithObjects: 
    @"NSDynamicSystemColor",
    @"NSNamedColorSpace",
    @"NSAttributedString",
    @"NSConcreteAttributedString",
    nil];  
  return _skippedClasses;
}

+ (NSArray *) skippedKeys
{
  NSArray *_skippedKeys = [NSArray arrayWithObjects: 
    @"needsDisplay",
    @"needsDisplayInRect",
    @"upGState",
    @"allowsEditingTextAttributes", 
    @"importsGraphics", 
    @"delegate", 
    @"errorAction", 
    @"postsBoundsChangedNotifications", 
    @"postsFrameChangedNotifications", 
    @"nextKeyView",
    @"prevKeyView",
    @"nextResponder",
    @"boundsOrigin", // not defined on some objects...
    @"frameOrigin", // not defined on some objects...
    @"floatValue", 
    @"doubleValue",
    @"intValue",
    @"objectValue", // usually the same as stringValue
    @"mnemonicLocation", // mnemonics are no longer used...
    @"state",
    @"font",
    @"textColor",
    @"backgroundColor",
    @"keyEquivalentFont",
    @"alternateObjectValue",
    nil];
  return _skippedKeys;
}

+ (NSArray *) keyObjects
{
  NSArray *_keyObjects = [NSArray arrayWithObjects:
    @"contentView",
    @"cell",
    @"contentRect",
    @"screenRect",
    @"frame",
    @"autoresizingMask",
    @"windowStyleMask",
    @"bounds",
    nil];
  return _keyObjects;
}

+ (NSArray *) nonObjects
{
  NSArray *_nonObjects = [NSArray arrayWithObjects:
    @"contentRect",
    @"screenRect",
    @"frame",
    @"autoresizingMask",
    @"windowStyleMask",
    @"windowPositionMask",
    @"interfaceStyle", 
    @"boundsRotation", 
    @"boundsSize", 
    @"bounds",
    @"frameRotation", 
    @"frame", 
    @"frameSize", 
    @"autoresizesSubviews",
    @"minSize",
    @"drawsBackground",
    @"alignment", 
    @"tag", 
    @"type",
    @"wraps",
    @"imageDimsWhenDisabled",
    @"highlightsBy",
    @"showsStateBy",
    @"refusesFirstResponder",
    @"isBezeled", 
    @"isEnabled",
    @"isScrollable",
    @"isSelectable",
    @"isEditable",
    @"isBordered",
    @"imagePosition",
    @"imageScaling",
    @"imageAlignment",
    @"imageFrame",
    @"alternateImage",
    @"alternateImageScaling",
    @"alternateImagePosition",
    @"alternateImageFrame",
    @"alternateImageAlignment",
    @"alternateImageDimsWhenDisabled",
    nil];
  return _nonObjects;
}

+ (NSDictionary *) keyMappings
{
  NSMutableDictionary *_keyMappings = [NSMutableDictionary dictionary];
  [_keyMappings setObject: [NSDictionary dictionaryWithObjectsAndKeys: @"title", @"stringValue", nil] 
                   forKey: @"NSTextFieldCell"];
  return _keyMappings;
}

- (NSSet *) keysForObject
{
  NSArray *methods = [NSObject recursiveGetAllMethodsForClass: [self class]];
  NSEnumerator *en = [methods objectEnumerator];
  NSString *selectorName = nil;
  NSMutableSet *result = [NSMutableArray arrayWithCapacity: [methods count]];
  
  while ((selectorName = [en nextObject]) != nil)
  {
    if ([selectorName hasPrefix: @"set"] && [selectorName isEqualToString: @"settings"] == NO)
		{
	  	NSString *keyName = [selectorName substringFromIndex: 3];
      SEL s = NULL;
      NSString *lowerKeyName = nil;

		  keyName = [keyName stringByReplacingOccurrencesOfString: @":" withString: @""];
		  lowerKeyName = [keyName lowercaseFirstCharacter];
      
      // if the object responds, add it... this way we know it's a key.
      s = NSSelectorFromString(lowerKeyName);
      if (s != NULL)
      {
	  	  [result addObject: lowerKeyName];
      }
      else
      {
        NSString *isKeyName = [NSString stringWithFormat: @"is%@", keyName];
        s = NSSelectorFromString(isKeyName);

        if(s != NULL)
        {
          [result addObject: isKeyName];
        }
      }
		}
  } 

  return result;
}

- (NSString *) classNameForParser
{
  NSString *className = NSStringFromClass([self class]);    
  return className;
}

- (XMLNode *) processObjectWithParser: (id<OidProvider>)parser
{
  NSSet *allKeys = [self keysForObject];
  NSEnumerator *e = [allKeys objectEnumerator];
  id k = nil;
  NSString *className = [self classNameForParser];    
  NSString *name = [className classNameToTagName];
  XMLNode *result = [[XMLNode alloc] initWithName: name];
  NSString *oid = [parser oidForObject: self];

  if ([[NSObject skippedClasses] containsObject: className])
  {
    return nil;
  }

#ifdef DEBUG
  if ([self isKindOfClass: [NSView class]])
  {
    NSLog(@"class = %@, keys = %@", className, allKeys);
  }
#endif

  [result addAttribute: @"id" value: oid];
  while ( (k = [e nextObject]) != nil )
  { 
    if ([[NSObject skippedKeys] containsObject: k] == NO)
    {
      SEL s = NSSelectorFromString(k);
      NSMethodSignature *signature = [NSMethodSignature methodSignatureForSelector: s];
      IMP imp = NULL;

      // If the selector is NULL, skip it...
      if (s == NULL && signature != nil)
      {
        NSLog(@"ERROR getting the selector/signature %@", k);
        break;
      }
      else
      {
        imp = [self methodForSelector: s];
      }

      if ([[NSObject nonObjects] containsObject: k]) // frames, sizes, flags...
      {
#ifdef DEBUG
        NSLog(@"Current NON-Object = %@", k);
#endif        
        if ([[NSObject keyObjects] containsObject: k])
        {
          XMLNode *node = nil;

          // rect/frame, etc... non objects
          if ([k hasSuffix: @"Rect"] || [k isEqualToString: @"frame"] || [k isEqualToString: @"bounds"])
          {
            NSRect (*func)(id, SEL) = (NSRect (*)(id, SEL))imp;
            NSRect rect = (func)(self, s);
            node = [XMLNode nodeForRect: rect type: k];
          }
          else if ([k hasSuffix: @"Size"])
          {
            NSSize (*func)(id, SEL) = (NSSize (*)(id, SEL))imp;
            NSSize size = (func)(self, s);
            node = [XMLNode nodeForSize: size type: k];
          }
          else if ([k hasSuffix: @"Mask"])
          {
            if ([k isEqualToString: @"autoresizingMask"])
            {
              unsigned int mask = [(NSView *)self autoresizingMask];

              node = [[XMLNode alloc] initWithName: k];
              [node addAttribute: @"key" value: k];
              if (mask | NSViewMaxXMargin)
              {
                [node addAttribute: @"flexibleMaxX" value: @"YES"];
              }
              else if (mask | NSViewMaxYMargin)
              {
                [node addAttribute: @"flexibleMaxY" value: @"YES"];        
              }
              else if (mask | NSViewMinXMargin)
              {
                [node addAttribute: @"flexibleMinY" value: @"YES"];           
              }
              else if (mask | NSViewMinYMargin)
              {
                [node addAttribute: @"flexibleMinY" value: @"YES"]; 
              }
            }
          }

          // If the node was set above, add it...
          if (node != nil)
          {
            [result addElement: node];
          }
        }
        else
        {
          BOOL (*func)(id, SEL) = (BOOL (*)(id, SEL))imp;
          BOOL f = (func)(self, s);

          if ([k isEqualToString: @"isBezeled"])
          {
            if (f == YES)
            {
              if ([self isKindOfClass: [NSTextFieldCell class]])
              {
                [result addAttribute: @"borderStyle" value: @"bezel"];
              }
              else
              {
                [result addAttribute: @"type" value: @"bevel"];
              }
            }
          }
          else if ([k isEqualToString: @"isBordered"])
          {
            if (f == YES)
            {
              [result addAttribute: @"borderStyle" value: @"border"];
#ifdef DEBUG              
              NSLog(@"Bordered = %@", result);
#endif
            }
          }
          else if ([k hasPrefix: @"is"])
          {
            NSString *name = [k stringByReplacingOccurrencesOfString: @"is" withString: @""];

            name = [name lowercaseFirstCharacter];
            if (f == YES)
            {
              [result addAttribute: name value: @"YES"];
            }
          }
        }
      }
      else // Objects...
      {
        id o = [self performSelector: s];
        
        if (o == nil)
        {
          continue;
        }

        if ([[NSObject keyObjects] containsObject: k])
        {
          XMLNode *node = [o processObjectWithParser: parser];

          if(node != nil)
          {
            if ([o isKindOfClass: [NSCell class]])
            {
              [node addAttribute: @"key" value: @"cell"];
            }

            [result addElement: node];
            // [parser addConnectionsForObject: o toNode: node];
          }
        }
        else
        {
#ifdef DEBUG        
          NSLog(@"Current object = %@", k);
#endif
          if ([o isKindOfClass: [NSArray class]])
          {
            NSEnumerator *aen = [o objectEnumerator];
            id obj = nil;
            XMLNode *arrayObject = [[XMLNode alloc] initWithName: k];

            while ((obj = [aen nextObject]) != nil)
            {
              XMLNode *xmlObject = [obj processObjectWithParser: parser];
              if (xmlObject != nil)
              {
                [arrayObject addElement: xmlObject];
                [parser addConnectionsForObject: obj toNode: xmlObject];
              }
            }

            // if count is greater than 0, then add the array, otherwise...
            if ([o count] > 0)
            {
              [result addElement: arrayObject];
            }
          }
          else if ([o isKindOfClass: [NSString class]] 
		   && [o isKindOfClass: [NSAttributedString class]] == NO)
          {
            NSString *filteredString = [o stringByReplacingOccurrencesOfString: @"\n" withString: @""];
            NSDictionary *dict = [[NSObject keyMappings] objectForKey: className];

            if (dict != nil)
            {
              NSString *mappedKey = [dict objectForKey: k];
              if (mappedKey != nil)
              {
                k = mappedKey;
              }
            }
            [result addAttribute: k value: filteredString];
            // [parser addConnectionsForObject: o toNode: result];
          }
          else if ([o isKindOfClass: [NSString class]] == NO) // don't parse into these types...
          {
            XMLNode *node = [o processObjectWithParser: parser];
            if (node != nil)
            {
              [result addElement: node];
              [parser addConnectionsForObject: o toNode: node];
            }
          }
        }
      }
    }
  }

  return result;
}

@end