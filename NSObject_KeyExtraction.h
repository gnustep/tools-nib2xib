/*
   Copyright (C) 2024 Free Software Foundation, Inc.

   Written by: Gregory John Casamento <greg.casamento@gmail.com>
   Date: 2024

   This file is part of the GNUstep XCode Library

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

#import <Foundation/Foundation.h>
#import "OidProvider.h"

@class XMLNode;

typedef enum {
    AttributeTypeUnknown = 0,
    AttributeTypeObject,
    AttributeTypeString,
    AttributeTypeNumber,
    AttributeTypeBoolean,
    AttributeTypeRect,
    AttributeTypeSize,
    AttributeTypePoint,
    AttributeTypeColor,
    AttributeTypeFont,
    AttributeTypeMask
} AttributeType;

@interface NSObject (KeyExtraction)

+ (NSArray *) skippedKeys;
+ (NSArray *) dynamicAttributeKeys;
+ (AttributeType) attributeTypeForKey: (NSString *)key onObject: (id)object;
- (XMLNode *) processObjectWithParser: (id<OidProvider>)parser;
- (NSSet *) keysForObject;
- (NSSet *) allAttributeKeysFromMethods;
- (NSString *) classNameForParser;
- (id) extractValueForKey: (NSString *)key usingType: (AttributeType)type;
- (BOOL) shouldProcessKey: (NSString *)key withValue: (id)value;

@end