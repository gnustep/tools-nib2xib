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
#import <AppKit/AppKit.h>

#import "NSWindowTemplate.h"

#import "XMLNode.h"
#import "NSString_Additions.h"
#import "NSObject_KeyExtraction.h"

@implementation NSWindowTemplate (Methods)

- (int) interfaceStyle
{
    return wtFlags.style;
}

- (void) setInterfaceStyle:(int)fp16
{
    wtFlags.style = fp16;
}

- (NSRect) windowRect
{
    return windowRect;
}

- (int) windowStyleMask
{
    return windowStyleMask;
}

- (int) windowBacking
{
    return windowBacking;
}

- (NSString *) windowTitle
{
    return windowTitle;
}

- (NSString *) viewClass
{
    return viewClass;
}

- (NSString *) windowClass
{
    return windowClass;
}

- (id) windowView
{
    return windowView;
}

- (id) realObject
{
    return realObject;
}

- (NSSize) minSize
{
    return minSize;
}

- (GSWindowTemplateFlags) wtFlags
{
    return wtFlags;
}

- (NSRect) screenRect
{
    return screenRect;
}

- (NSMutableDictionary *) attributesFromProperties
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    // Title and other string properties...
    [result setObject: windowTitle forKey: @"title"];
    [result setObject: windowClass forKey: @"customClass"];

    // Flags...

    return result;
}

/*
- (NSSet *) keysForObject
{
    return [NSSet setWithObjects: @"interfaceStyle", 
        @"windowRect", @"windowStyleMask",
        @"windowTitle", @"minSize", @"screenRect", nil];
}
*/

- (NSString *) classNameForParser
{
    return @"NSWindow";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser 
{
    NSMutableDictionary *attributes = [self attributesFromProperties];
    XMLNode *windowViewXml = [windowView processObjectWithParser: parser]; 
    NSMutableArray *elements = [NSMutableArray arrayWithObject: windowViewXml];
    XMLNode *node = [[XMLNode alloc] initWithName: @"window" value: @"" attributes: attributes elements: elements];
    XMLNode *frame = [XMLNode nodeForRect: windowRect type: @"contentRect"];
    NSString *oid = [parser oidForObject: self];

    if (windowTitle != nil)
    {
        XMLNode *styleMask = [[XMLNode alloc] initWithName: @"windowStyleMask"];        
    
        [styleMask addAttribute: @"key" value: @"styleMask"];
        [styleMask addAttribute: @"titled" value: @"YES"];
        [node addElement: styleMask];
    }

    [windowViewXml addAttribute: @"key" value: @"contentView"];
    [node addAttribute: @"customClass" value: windowClass];
    [node addAttribute: @"id" value: oid];
    [node addElement: frame];
    // [node addElement: windowViewXml];
    
    return node;
}

@end