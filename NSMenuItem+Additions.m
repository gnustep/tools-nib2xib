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
#import <AppKit/NSMenu.h>

#import "NSMenuItem+Additions.h"
#import "NSString+Additions.h"
#import "NIBParser.h"
#import "NSObject+KeyExtraction.h"

#import "XMLNode.h"

@implementation NSMenuItem (toXML)

- (NSSet *) keysForObject
{
    NSSet *keys = [super keysForObject];
    NSMutableSet *set = [NSMutableSet setWithSet: keys];
    return set;
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    NSString *className = NSStringFromClass([self class]);
    NSString *tagName = [className classNameToTagName];
    XMLNode *itemNode = [[XMLNode alloc] initWithName: tagName];
    id submenu = [self target];
    // NSArray *srcs = [parser connectionsWithSource: self];
    // NSArray *dsts = [parser connectionsWithDestination: self];

    // NSLog(@"srcs = %@", srcs);
    // NSLog(@"dsts = %@", dsts);
    
    // NSLog(@"keys = %@", [self keysForObject]);
    [itemNode addAttribute: @"title" value: [self title]];
    if ([[self keyEquivalent] isEqualToString: @""] == NO)
    {
        [itemNode addAttribute: @"keyEquivalent" value: [self keyEquivalent]];
    }

    if (submenu != nil)
    {
        XMLNode *submenuNode = [submenu toXMLWithParser: parser];

        [submenuNode addAttribute: @"title" value: [self title]];
        [submenuNode addAttribute: @"key" value: @"submenu"];
        // NSLog(@"target = %@", [self target]);
        [itemNode addElement: submenuNode];
    }

    [parser addConnectionsForObject: self
                             toNode: itemNode];

    return itemNode;
}

@end