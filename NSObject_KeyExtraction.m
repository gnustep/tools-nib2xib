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

@class NSInlineCString;

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
    // @"font",
    @"textColor",
    @"backgroundColor",
    @"attributedStringValue",
    @"keyEquivalentFont",
    @"alternateObjectValue",
    @"action",
    @"target",
    @"keyEquivalentModifierMask",
    @"autoenablesItems",
    @"selectedCell",
    @"selectedCellTag",
    @"selectedCellIndex",
    @"selectedCellIndexPath",
    @"selectedCellTagPath",
    @"selectedItem",
    @"titleWithMnemonic",
    @"titleWithMnemonic:withFont:",
    @"titleWithMnemonic:withFont:withAttributes:",
    @"titleWithMnemonic:withFont:withAttributes:withColor:",
    @"titleWithMnemonic:withFont:withAttributes:withColor:withSize:",
    @"titleWithMnemonic:withFont:withAttributes:withColor:withSize:withStyle:",
    @"titleWithMnemonic:withFont:withAttributes:withColor:withSize:withStyle:withAlignment:",
    @"titleWithMnemonic:withFont:withAttributes:withColor:withSize:withStyle:withAlignment:withLineBreakMode:",
    @"titleOfSelectedItem",
    @"titleOfSelectedItemWithMnemonic",
    @"pullsDown",
    @"contentSize",
    @"cString",
    nil];
  return _skippedKeys;
}

+ (NSArray *) dynamicAttributeKeys
{
  // Keys that should be dynamically extracted from all objects
  NSArray *_dynamicKeys = [NSArray arrayWithObjects:
    @"title",
    @"stringValue", 
    @"objectValue",
    @"intValue",
    @"floatValue",
    @"doubleValue",
    @"alphaValue",
    @"minValue",
    @"maxValue",
    @"increment",
    @"isHidden",
    @"isEnabled",
    @"isOpaque",
    @"isFlipped",
    @"isBordered",
    @"isBezeled",
    @"isEditable",
    @"isSelectable",
    @"isScrollable",
    @"isContinuous",
    @"allowsEmptySelection",
    @"allowsMultipleSelection",
    @"autoresizesSubviews",
    @"drawsBackground",
    @"usesAlternatingRowBackgroundColors",
    @"gridStyleMask",
    @"columnAutoresizingStyle",
    @"allowsColumnReordering",
    @"allowsColumnResizing",
    @"allowsColumnSelection",
    @"isVertical",
    @"hasHorizontalScroller",
    @"hasVerticalScroller",
    @"autohidesScrollers",
    @"borderType",
    @"scrollElasticity",
    nil];
  return _dynamicKeys;
}

+ (AttributeType) attributeTypeForKey: (NSString *)key onObject: (id)object
{
  SEL selector;
  NSMethodSignature *signature;
  const char *returnType;
  
  selector = NSSelectorFromString(key);

  // Determine the type of attribute based on key name and object properties
  if ([key hasSuffix: @"Rect"] || [key isEqualToString: @"frame"] || [key isEqualToString: @"bounds"])
  {
    return AttributeTypeRect;
  }
  else if ([key hasSuffix: @"Size"])
  {
    return AttributeTypeSize;  
  }
  else if ([key hasSuffix: @"Point"] || [key hasSuffix: @"Origin"])
  {
    return AttributeTypePoint;
  }
  else if ([key hasSuffix: @"Color"] || [key isEqualToString: @"backgroundColor"] || [key isEqualToString: @"textColor"])
  {
    return AttributeTypeColor;
  }
  else if ([key isEqualToString: @"font"])
  {
    return AttributeTypeFont;
  }
  else if ([key hasSuffix: @"Mask"])
  {
    return AttributeTypeMask;
  }
  else if ([key hasPrefix: @"is"] || [key hasPrefix: @"has"] || [key hasPrefix: @"allows"] || [key hasPrefix: @"draws"] || [key hasPrefix: @"uses"])
  {
    return AttributeTypeBoolean;
  }
  else if ([key isEqualToString: @"title"] || [key isEqualToString: @"stringValue"] || [key hasSuffix: @"String"])
  {
    return AttributeTypeString;
  }
  else if ([key hasSuffix: @"Value"] || [key hasSuffix: @"Count"] || [key hasSuffix: @"Index"] || [key hasSuffix: @"Tag"])
  {
    return AttributeTypeNumber;
  }
  
  // Try to determine from the actual object's method signature
  if (selector && [object respondsToSelector: selector])
  {
    signature = [object methodSignatureForSelector: selector];
    if (signature)
    {
      returnType = [signature methodReturnType];
      if (strcmp(returnType, "@") == 0) // Object
      {
        return AttributeTypeObject;
      }
      else if (strcmp(returnType, "c") == 0 || strcmp(returnType, "B") == 0) // BOOL
      {
        return AttributeTypeBoolean;
      }
      else if (strcmp(returnType, "i") == 0 || strcmp(returnType, "l") == 0 || strcmp(returnType, "q") == 0) // Integer types
      {
        return AttributeTypeNumber;
      }
      else if (strcmp(returnType, "f") == 0 || strcmp(returnType, "d") == 0) // Float/Double
      {
        return AttributeTypeNumber;
      }
    }
  }
  
  return AttributeTypeUnknown;
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
    @"font",
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
    @"matchesOnMultipleResolution",
    @"prefersColorMatch",
    @"size",
    @"isContinuous",
    @"knobThickness",
    @"knobProportion",
    @"knobStyle",
    @"knobTrackingMode",
    @"knobTrackingMode",
    @"smartInsertDeleteEnabled",
    @"containerSize",
    @"containerOrigin",
    @"containerFrame",
    @"containerBounds",
    @"containerRect",
    @"containerFrameRotation",
    @"containerBoundsRotation",
    @"containerFrameSize",
    @"containerBoundsSize",
    @"containerFrameOrigin",
    @"containerBoundsOrigin",
    @"containerContentSize",
    @"containerContentOrigin",
    @"containerContentFrame",
    @"containerContentBounds",
    @"containerContentRect",
    @"widthTracksTextView",
    @"heightTracksTextView",
    @"textViewWidthTracksTextView",
    @"textViewHeightTracksTextView",
    @"textViewContentSize",
    @"textViewContentOrigin",
    @"textViewContentFrame",
    @"textViewContentBounds",
    @"textViewContentRect",
    @"textViewContainerSize",
    @"textViewContainerOrigin",
    @"textViewContainerFrame",
    @"textViewContainerBounds",
    @"textViewContainerRect",
    @"textViewContainerFrameRotation",
    @"textViewContainerBoundsRotation",
    @"textViewContainerFrameSize",
    @"textViewContainerBoundsSize",
    @"textViewContainerFrameOrigin",
    @"textViewContainerBoundsOrigin",
    @"textViewContainerContentSize",
    @"textViewContainerContentOrigin",
    @"textViewContainerContentFrame",
    @"textViewContainerContentBounds",
    @"textViewContainerContentRect",
    @"textViewContainerContentFrameRotation",
    @"textViewContainerContentBoundsRotation",
    @"textViewContainerContentFrameSize",
    @"textViewContainerContentBoundsSize",
    @"textViewContainerContentFrameOrigin",
    @"textViewContainerContentBoundsOrigin",
    @"textViewContainerContentRectRotation",
    @"textViewContainerContentRectSize",
    @"textViewContainerContentRectOrigin",
    @"textViewContainerContentRect",
    @"textViewContainerContentRectRotation",
    @"textViewContainerContentRectSize",
    @"textViewContainerContentRectOrigin",
    @"textViewContainerContentRect",
    @"usesScreenFonts",
    @"backgroundLayoutEnabled",
    @"maxSize",
    @"minSize",
    @"contentSize",
    @"contentOrigin",
    @"contentFrame",
    @"contentBounds",
    @"contentRect",
    @"usesFontPanel",
    @"usesFindPanel",
    @"usesRuler",
    @"usesInspectorBar",
    @"usesInspectorBarForText",
    @"usesInspectorBarForTextView",
    @"intefaceStyle",
    @"menuChangedMessagesEnabled",
    @"isReleasedWhenClosed",
    @"isFlipped",
    @"isOpaque",
    @"isMovable",
    @"isMovableByWindowBackground",
    @"isVisible",
    @"isHidden",
    @"isMiniaturizable",
    @"isMiniaturized",
    @"isResizable",
    @"isZoomable",
    @"isZoomed",
    @"isFullScreen",
    @"isFullScreenCapable",
    @"isRestorable",
    @"isRestorationEnabled",
    @"isRestorationDisabled",
    @"isRestorationDisabledForWindow",
    @"isRestorationDisabledForView",
    @"isRestorationDisabledForViewController",
    @"isRestorationDisabledForController",
    @"aspectRatio",
    @"aspectRatioEnabled",
    @"aspectRatioDisabled",
    @"aspectRatioDisabledForWindow",
    @"aspectRatioDisabledForView",
    @"aspectRatioDisabledForViewController",
    @"aspectRatioDisabledForController",
    @"contentSize",
    @"contentOrigin",
    @"contentFrame",
    @"contentBounds",
    @"contentRect",
    @"contentRectRotation",
    @"contentRectSize",
    @"contentRectOrigin",
    @"drawsBackground",
    @"isOpaque",
    @"isFlipped",
    @"isMovable",
    @"isMovableByWindowBackground",
    @"isVisible",
    @"isHidden",
    @"isMiniaturizable",
    @"isMiniaturized",
    @"isResizable",
    @"isZoomable",
    @"isZoomed",
    @"isFullScreen",
    @"isFullScreenCapable",
    @"isRestorable",
    @"isRestorationEnabled",
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

- (NSSet *) allAttributeKeysFromMethods
{
  NSMutableSet *methodKeys;
  NSArray *methods;
  NSEnumerator *en;
  NSString *methodName;
  NSString *keyName;
  SEL getterSel;
  NSString *isKeyName;
  
  methodKeys = [NSMutableSet set];
  
  /*
   * OPENSTEP has no ObjC 2.0 properties, so treat a setter/getter pair as
   * the runtime declaration that a value is an attribute.
   */
  methods = [NSObject recursiveGetAllMethodsForClass: [self class]];
  en = [methods objectEnumerator];
  
  while ((methodName = [en nextObject]) != nil)
  {
    if ([methodName hasPrefix: @"set"] &&
        [methodName hasSuffix: @":"] &&
        [methodName isEqualToString: @"settings"] == NO)
    {
      keyName = [methodName substringWithRange:
        NSMakeRange(3, [methodName length] - 4)];

      if ([keyName length] == 0 || [keyName characterAtIndex: 0] == '_')
      {
        continue;
      }

      keyName = [keyName lowercaseFirstCharacter];
      getterSel = NSSelectorFromString(keyName);
      if ([self respondsToSelector: getterSel])
      {
        [methodKeys addObject: keyName];
        
#ifdef DEBUG
        NSLog(@"Found attribute method pair: %@ / %@", methodName, keyName);
#endif
        continue;
      }

      keyName = [methodName substringWithRange:
        NSMakeRange(3, [methodName length] - 4)];
      isKeyName = [NSString stringWithFormat: @"is%@", keyName];
      getterSel = NSSelectorFromString(isKeyName);
      if ([self respondsToSelector: getterSel])
      {
        [methodKeys addObject: isKeyName];

#ifdef DEBUG
        NSLog(@"Found boolean attribute method pair: %@ / %@", methodName, isKeyName);
#endif
      }
    }
  }
  
  return methodKeys;
}

- (id) extractValueForKey: (NSString *)key usingType: (AttributeType)type
{
  SEL selector;
  BOOL (*boolFunc)(id, SEL);
  BOOL boolValue;
  NSMethodSignature *signature;
  const char *returnType;
  float (*floatFunc)(id, SEL);
  float floatValue;
  double (*doubleFunc)(id, SEL);
  double doubleValue;
  int (*intFunc)(id, SEL);
  int intValue;
  NSRect (*rectFunc)(id, SEL);
  NSRect rect;
  NSSize (*sizeFunc)(id, SEL);
  NSSize size;
  NSPoint (*pointFunc)(id, SEL);
  NSPoint point;
  unsigned int (*maskFunc)(id, SEL);
  unsigned int mask;
  
  selector = NSSelectorFromString(key);
  if (!selector || ![self respondsToSelector: selector])
  {
    return nil;
  }
  
  switch (type)
  {
    case AttributeTypeString:
    case AttributeTypeObject:
      return [self performSelector: selector];
      
    case AttributeTypeBoolean:
      boolFunc = (BOOL (*)(id, SEL))[self methodForSelector: selector];
      boolValue = boolFunc(self, selector);
      return [NSNumber numberWithBool: boolValue];
    
    case AttributeTypeNumber:
      // Try different numeric types
      signature = [self methodSignatureForSelector: selector];
      returnType = [signature methodReturnType];
      
      if (strcmp(returnType, "f") == 0) // float
      {
        floatFunc = (float (*)(id, SEL))[self methodForSelector: selector];
        floatValue = floatFunc(self, selector);
        return [NSNumber numberWithFloat: floatValue];
      }
      else if (strcmp(returnType, "d") == 0) // double
      {
        doubleFunc = (double (*)(id, SEL))[self methodForSelector: selector];
        doubleValue = doubleFunc(self, selector);
        return [NSNumber numberWithDouble: doubleValue];
      }
      else // integer types
      {
        intFunc = (int (*)(id, SEL))[self methodForSelector: selector];
        intValue = intFunc(self, selector);
        return [NSNumber numberWithInt: intValue];
      }
    
    case AttributeTypeRect:
      rectFunc = (NSRect (*)(id, SEL))[self methodForSelector: selector];
      rect = rectFunc(self, selector);
      return [NSValue valueWithRect: rect];
    
    case AttributeTypeSize:
      sizeFunc = (NSSize (*)(id, SEL))[self methodForSelector: selector];
      size = sizeFunc(self, selector);
      return [NSValue valueWithSize: size];
    
    case AttributeTypePoint:
      pointFunc = (NSPoint (*)(id, SEL))[self methodForSelector: selector];
      point = pointFunc(self, selector);
      return [NSValue valueWithPoint: point];
    
    case AttributeTypeMask:
      maskFunc = (unsigned int (*)(id, SEL))[self methodForSelector: selector];
      mask = maskFunc(self, selector);
      return [NSNumber numberWithUnsignedInt: mask];
    
    default:
      return nil; // [self performSelector: selector];
  }
}

- (BOOL) shouldProcessKey: (NSString *)key withValue: (id)value
{
  NSArray *meaningfulWhenNonZero;
  
  // Skip nil values
  if (!value)
  {
    return NO;
  }
  
  // Skip keys in the skip list
  if ([[NSObject skippedKeys] containsObject: key])
  {
    return NO;
  }
  
  // Skip empty strings
  if ([value isKindOfClass: [NSString class]] && [(NSString *)value length] == 0)
  {
    return NO;
  }
  
  // Skip zero numeric values for certain keys that are typically meaningful when non-zero
  if ([value isKindOfClass: [NSNumber class]])
  {
    meaningfulWhenNonZero = [NSArray arrayWithObjects: @"tag", @"intValue", @"floatValue", @"doubleValue", nil];
    if ([meaningfulWhenNonZero containsObject: key] && [(NSNumber *)value doubleValue] == 0.0)
    {
      return NO;
    }
  }
  
  return YES;
}

- (NSSet *) keysForObject
{
  NSMutableSet *allKeys;
  NSSet *methodKeys;
  
  allKeys = [NSMutableSet set];
  
  // Get keys from ObjC 1.0 method analysis.
  methodKeys = [self allAttributeKeysFromMethods];
  [allKeys unionSet: methodKeys];
  
#ifdef DEBUG
  NSLog(@"Class %@ has %lu total attribute keys", [self class], (unsigned long)[allKeys count]);
#endif

  return allKeys;
}


- (NSString *) classNameForParser
{
  NSString *className = NSStringFromClass([self class]);    
  return className;
}

- (XMLNode *) processObjectWithParser: (id<OidProvider>)parser
{
  NSSet *allKeys;
  NSEnumerator *e;
  id k;
  NSString *className;
  NSString *name;
  XMLNode *result;
  NSString *oid;
  BOOL usesObjectIdentity;
  AttributeType attrType;
  id value;
  NSRect rect;
  XMLNode *node;
  NSSize size;
  NSPoint point;
  unsigned int mask;
  BOOL boolValue;
  NSString *attrName;
  NSString *filteredString;
  NSDictionary *dict;
  NSString *mappedKey;
  NSEnumerator *aen;
  id obj;
  XMLNode *arrayObject;
  XMLNode *xmlObject;
  id textValue;
  
  allKeys = [self keysForObject];
  e = [allKeys objectEnumerator];
  className = [self classNameForParser];    
  name = [className classNameToTagName];
  result = [[XMLNode alloc] initWithName: name];
  usesObjectIdentity = [self isKindOfClass: [NSImage class]] == NO;
  oid = usesObjectIdentity ? [parser oidForObject: self] : [parser oidString];

  if (usesObjectIdentity && [parser isObjectProcessed: self])
  {
    return [parser processedObject: self];
  }

  if (usesObjectIdentity)
  {
    [parser addProcessedObject: self withNode: result];
  }
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

  if ([self isKindOfClass: [NSTextFieldCell class]] &&
      [self respondsToSelector: @selector(stringValue)])
  {
    textValue = [self performSelector: @selector(stringValue)];
    if ([textValue isKindOfClass: [NSString class]] &&
        [(NSString *)textValue length] > 0)
    {
      filteredString = [(NSString *)textValue stringByReplacingOccurrencesOfString: @"\n"
                                                                        withString: @""];
      [result addAttribute: @"title" value: filteredString];
    }
  }
  
  // Process each key programmatically
  while ( (k = [e nextObject]) != nil )
  { 
    // Determine the attribute type programmatically
    attrType = [NSObject attributeTypeForKey: k onObject: self];
    
    // Extract the value using the appropriate method
    value = [self extractValueForKey: k usingType: attrType];
    
    // Check if we should process this key/value combination
    if (![self shouldProcessKey: k withValue: value])
    {
      continue;
    }
    
#ifdef DEBUG
    NSLog(@"Processing key: %@ (type: %d) with value: %@", k, attrType, value);
#endif
    
    // Process the value based on its type
    if (attrType == AttributeTypeRect)
    {
      rect = [(NSValue *)value rectValue];
      node = [XMLNode nodeForRect: rect type: k];
      if (node != nil)
      {
        [result addElement: node];
      }
    }
    else if (attrType == AttributeTypeSize)
    {
      size = [(NSValue *)value sizeValue];
      node = [XMLNode nodeForSize: size type: k];
      if (node != nil)
      {
        [result addElement: node];
      }
    }
    else if (attrType == AttributeTypePoint)
    {
      point = [(NSValue *)value pointValue];
      node = [XMLNode nodeForPoint: point type: k];
      if (node != nil)
      {
        [result addElement: node];
      }
    }
    else if (attrType == AttributeTypeMask)
    {
      mask = [(NSNumber *)value unsignedIntValue];
      node = [[XMLNode alloc] initWithName: k];
      [node addAttribute: @"key" value: k];
      
      if ([k isEqualToString: @"autoresizingMask"])
      {
        if (mask & NSViewMaxXMargin)
        {
          [node addAttribute: @"flexibleMaxX" value: @"YES"];
        }
        if (mask & NSViewMaxYMargin)
        {
          [node addAttribute: @"flexibleMaxY" value: @"YES"];        
        }
        if (mask & NSViewMinXMargin)
        {
          [node addAttribute: @"flexibleMinX" value: @"YES"];           
        }
        if (mask & NSViewMinYMargin)
        {
          [node addAttribute: @"flexibleMinY" value: @"YES"]; 
        }
        if (mask & NSViewWidthSizable)
        {
          [node addAttribute: @"flexibleWidth" value: @"YES"];
        }
        if (mask & NSViewHeightSizable)
        {
          [node addAttribute: @"flexibleHeight" value: @"YES"];
        }
      }
      else
      {
        [node addAttribute: @"value" value: [NSString stringWithFormat: @"%u", mask]];
      }
      
      [result addElement: node];
    }
    else if (attrType == AttributeTypeBoolean)
    {
      boolValue = [(NSNumber *)value boolValue];
      
      if ([k isEqualToString: @"isBezeled"])
      {
        if (boolValue == YES)
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
        if (boolValue == YES)
        {
          [result addAttribute: @"borderStyle" value: @"border"];
        }
      }
      else if ([k hasPrefix: @"is"])
      {
        attrName = [k stringByReplacingOccurrencesOfString: @"is" withString: @""];
        attrName = [attrName lowercaseFirstCharacter];
        if (boolValue == YES)
        {
          [result addAttribute: attrName value: @"YES"];
        }
      }
      else if ([k hasPrefix: @"has"] || [k hasPrefix: @"allows"] || [k hasPrefix: @"draws"] || [k hasPrefix: @"uses"])
      {
        if (boolValue == YES)
        {
          [result addAttribute: k value: @"YES"];
        }
      }
    }
    else if (attrType == AttributeTypeString)
    {
      if ([value isKindOfClass: [NSString class]])
      {
        filteredString = [value stringByReplacingOccurrencesOfString: @"\n" withString: @""];
        dict = [[NSObject keyMappings] objectForKey: className];

        if (dict != nil)
        {
          mappedKey = [dict objectForKey: k];
          if (mappedKey != nil)
          {
            k = mappedKey;
          }
        }
        [result addAttribute: k value: filteredString];
      }
    }
    else if (attrType == AttributeTypeNumber)
    {
      [result addAttribute: k value: [value stringValue]];
    }
    else if (attrType == AttributeTypeObject)
    {
      // Handle complex objects
      if ([[NSObject keyObjects] containsObject: k])
      {
        node = [value processObjectWithParser: parser];

        if(node != nil)
        {
          if ([value isKindOfClass: [NSCell class]])
          {
            [node addAttribute: @"key" value: @"cell"];
          }
          else
          {
            [node addAttribute: @"key" value: k];
          }

          [result addElement: node];
        }
      }
      else if ([value isKindOfClass: [NSArray class]])
      {
        aen = [value objectEnumerator];
        arrayObject = [[XMLNode alloc] initWithName: k];

        while ((obj = [aen nextObject]) != nil)
        {
          xmlObject = [obj processObjectWithParser: parser];
          if (xmlObject != nil)
          {
            [arrayObject addElement: xmlObject];
            [parser addConnectionsForObject: obj toNode: xmlObject];
          }
        }

        if ([value count] > 0)
        {
          [result addElement: arrayObject];
        }
      }
      else if ([value isKindOfClass: [NSString class]] == NO && value != nil)
      {
        node = [value processObjectWithParser: parser];
        if (node != nil)
        {
          [node addAttribute: @"key" value: k];
          [result addElement: node];
          [parser addConnectionsForObject: value toNode: node];
        }
      }
    }
  }

  return result;
}

@end
