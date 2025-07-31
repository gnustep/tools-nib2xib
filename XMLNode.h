/* Copyright (C) 2024 Free Software Foundation, Inc.
 *
 * Author:      Gregory John Casamento <greg.casamento@gmail.com>
 * Date:        2024
 *
 * This file is part of GNUstep.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111
 * USA.
 */

#import <Foundation/NSObject.h>
#import <Foundation/NSGeometry.h>

@class NSString;
@class NSMutableArray;
@class NSMutableDictionary;
@class XIBParser;

@interface XMLNode : NSObject <NSCopying>
{
	NSString *_name;
	NSString *_value;
	NSMutableDictionary *_attributes;
	NSMutableArray *_elements;

	XMLNode *_parent;
	XIBParser *_parser;
}

+ (id) nodeForRect: (NSRect)frame type: (NSString *)type;
+ (id) nodeForSize: (NSSize)size type: (NSString *)type;
+ (id) nodeForPoint: (NSPoint)point type: (NSString *)type;
+ (id) nodeForPoint: (NSPoint)point type: (NSString *)type;

- (id) initWithName: (NSString *)name;
- (id) initWithName: (NSString *)name value: (NSString *)value attributes: (NSMutableDictionary *)attributes elements: (NSMutableArray *)elements;

- (NSString *) name;
- (void) setName: (NSString *)name;

- (NSMutableDictionary *) attributes;
- (void) setAttributes: (NSMutableDictionary *) attributes;

- (NSMutableArray *) elements;
- (void) setElements: (NSMutableArray *) elements;

- (NSString *) value;
- (void) setValue: (NSString *)value;

- (XMLNode *) parent;
- (void) setParent: (XMLNode *)parent;

- (void) addElement: (XMLNode *)element;
- (void) addAttribute: (NSString *)key value: (NSString *)value;

- (NSString *) description;

@end
