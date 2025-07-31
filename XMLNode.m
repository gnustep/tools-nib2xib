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

#import <Foundation/Foundation.h>

#import "NIBParser.h"
#import "XMLNode.h"

@implementation XMLNode

+ (id) nodeForRect: (NSRect)frame type: (NSString *)type
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	XMLNode *node = nil;

    [result setObject: [NSString stringWithFormat: @"%g", frame.origin.x] forKey: @"x"];
    [result setObject: [NSString stringWithFormat: @"%g", frame.origin.y] forKey: @"y"];
    [result setObject: [NSString stringWithFormat: @"%g", frame.size.width] forKey: @"width"];
    [result setObject: [NSString stringWithFormat: @"%g", frame.size.height] forKey: @"height"];
    [result setObject: type forKey: @"key"];
	
	node = [[XMLNode alloc] initWithName: @"rect" value: @"" attributes: result elements: nil];
	return node;
}

+ (id) nodeForSize: (NSSize)size type: (NSString *)type
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	XMLNode *node = nil;

    [result setObject: [NSString stringWithFormat: @"%g", size.width] forKey: @"width"];
    [result setObject: [NSString stringWithFormat: @"%g", size.height] forKey: @"height"];
    [result setObject: type forKey: @"key"];
	
	node = [[XMLNode alloc] initWithName: @"size" value: @"" attributes: result elements: nil];
	return node;
}

+ (id) nodeForPoint: (NSPoint)point type: (NSString *)type
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	XMLNode *node = nil;

    [result setObject: [NSString stringWithFormat: @"%g", point.x] forKey: @"x"];
    [result setObject: [NSString stringWithFormat: @"%g", point.y] forKey: @"y"];
    [result setObject: type forKey: @"key"];
	
	node = [[XMLNode alloc] initWithName: @"point" value: @"" attributes: result elements: nil];
	return node;
}

- (id) initWithName: (NSString *)name value: (NSString *)value attributes: (NSMutableDictionary *)attributes elements: (NSMutableArray *)elements
{
	self = [super init];
	if (self != nil)
	{
		[self setName: name];
		[self setAttributes: attributes];
		[self setValue: value];
		
		if (elements == nil)
		{
			elements = [[NSMutableArray alloc] init];
		}
		else
		{
			NSEnumerator *en = [elements objectEnumerator];
			id e = nil;

			while ((e = [en nextObject]) != nil)
			{
				[self addElement: e];
			}
		}
	}
	return self;
}

- (id) initWithName: (NSString *)name
{
	return [self initWithName: name value: @"" attributes: [NSMutableDictionary dictionary] elements: [NSMutableArray array]];
}

- (void) dealloc
{
	[_name release];
	[_attributes release];
	[_elements release];
	[_value release];
	[_parent release];
	[super dealloc];
}

- (NSString *) name
{
	return _name;
}

- (void) setName: (NSString *)name
{
	if (_name == nil)
	{
		_name = @"";
	}
	_name = [[name copy] retain];
}

- (NSMutableDictionary *) attributes
{
	return _attributes;
}

- (void) setAttributes: (NSMutableDictionary *) attributes
{
	if (_attributes == nil)
	{
		_attributes = [[NSMutableDictionary alloc] init];
	}
	_attributes = [attributes retain];
}

- (NSMutableArray *) elements
{
	return _elements;
}

- (void) setElements: (NSMutableArray *) elements
{
	NSEnumerator *en = nil;
	id e = nil;

	if (elements == nil)
	{
		elements = [[NSMutableArray alloc] init];
	}

	while ((e = [en nextObject]) != nil)
	{
		[e setParent: self];
	}

	_elements = [elements retain];
}

- (NSString *) value
{
	return _value;
}

- (void) setValue: (NSString *)value
{
	if (_value == nil)
	{
		_value = @"";
	}
	_value = [[value copy] retain];
}

- (XMLNode *) parent
{
	return _parent;
}

- (void) setParent: (XMLNode *)parent
{
	_parent = [parent retain];
}

- (void) addElement: (XMLNode *)element
{
	if (_elements == nil)
	{
		_elements = [[NSMutableArray alloc] init];
	}
	[_elements addObject: element];
	[element setParent: self];
}

- (void) addAttribute: (NSString *)key value: (NSString *)value
{
	if (_attributes == nil)
	{
		_attributes = [[NSMutableDictionary alloc] init];
	}
	[_attributes setObject: value forKey: key];
}

- (id) copyWithZone: (NSZone *)zone
{
	XMLNode *node = [[XMLNode allocWithZone: zone]
		initWithName: [self name]
		value: [self value]
		attributes: [self attributes]
		elements: [self elements]];

	return node;
}

- (NSString *) describeAttributes
{
	NSString *result = @"";
	NSEnumerator *en = [_attributes keyEnumerator];
	NSString *k = nil;

	while ((k = [en nextObject]) != nil)
	{
		NSString *v = [_attributes objectForKey: k];
		result = [result stringByAppendingString: [NSString stringWithFormat: @" %@=\"%@\"", k, v]];
	}

	return result;
}

- (NSString *) elementsAsString
{
	NSEnumerator *en = [_elements objectEnumerator];
	XMLNode *n = nil;
	NSString *result = @"";

	while ((n = [en nextObject]) != nil)
	{
		NSString *s = [n description];
		result = [result stringByAppendingString: s];
	}

	return result;
}

- (int) level
{
	int result = 0;
	XMLNode *node = [self parent];

	while (node != nil)
	{
		result++;
		node = [node parent]; 
	}

	return result;
}

- (NSString *) levelString
{
	int level = [self level];
	int i = 0;
	NSString *result = @"";

	if (level >= 0)
	{
		result = @"\n";
	}

	for (i = 0; i < level; i++)
	{
		result = [result stringByAppendingString: @"    "];
	}

	return result;
}

- (NSString *) description
{
	NSString *elementsString = [self elementsAsString];
	NSString *result = nil;
	NSString *levelString = [self levelString];

	if ([_elements count] > 0 || ([_value isEqualToString: @""] == NO && _value != nil))
	{
		result = [NSString stringWithFormat: @"%@<%@%@>%@%@%@</%@>", 
			levelString, _name, [self describeAttributes], _value, elementsString, levelString, _name];
	}
	else 
	{
		result = [NSString stringWithFormat: @"%@<%@%@/>",
			levelString, _name, [self describeAttributes]];	
	}

	return result;
}

@end
