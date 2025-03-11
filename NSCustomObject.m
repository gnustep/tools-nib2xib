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

#include <Foundation/Foundation.h>
#import <Foundation/NSString.h>
#import "NSCustomObject.h"

#import "XMLNode.h"
#import "NSString_Additions.h"

@implementation NSCustomObject (Methods)

- (NSString *) className
{
    return className;
}

- (id) realObject
{
    return realObject;
}

- (id) extension
{
    return extension;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@ - <className = %@, realObject = %@, extension = %@>", 
        [super description], className, realObject, extension];
}

- (NSMutableDictionary *) attributesFromProperties
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: className forKey: @"customClass"];
    return dict;
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>) parser 
{
    NSString *cn = NSStringFromClass([self class]);
    NSString *tagName = [cn classNameToTagName];
    NSMutableDictionary *attrs = [self attributesFromProperties];
    XMLNode *node = [[XMLNode alloc] initWithName: tagName value: @"" attributes: attrs elements: [NSMutableArray array]];
    NSString *oid = [parser oidForObject: self];
    [node addAttribute: @"id" value: oid];

    return node;
}
@end