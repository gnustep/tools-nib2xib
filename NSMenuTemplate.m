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

#import "NSMenuTemplate.h"
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <AppKit/NSMatrix.h>

#import "XMLNode.h"
#import "NIBParser.h"

@implementation NSMenuTemplate (Methods)

- (NSString *) title
{
	return title;
}

- (NSString *) menuClassName
{
	return menuClassName;
}

- (id) view
{
	return view;
}

- (id) supermenu
{
	return supermenu;
}

- (id) realObject
{
	return realObject;
}

- (id) extension
{
	return extension;
}

- (NSPoint) location
{
	return location;
}

- (BOOL) isWindowsMenu
{
	return isWindowsMenu;
}

- (BOOL) isRequestMenu
{
	return isRequestMenu;
}

- (BOOL) isFontMenu
{
	return isFontMenu;
}

- (int) interfaceStyle
{
	return interfaceStyle;
}

- (void) setPullsDown: (BOOL) flag
{
	pullsDown = flag; // isPullsDown = pullsDown;
}

- (BOOL) pullsDown
{
	return pullsDown;
}

- (NSString *) classNameForParser
{
    return @"NSMenu";
}

- (id) selectedItem
{
	return nil;
}
- (void) setSelectedItem: (id)item
{
	// Do nothing.
}

- (NSMutableDictionary *) attributesFromProperties: (id<OidProvider>) op
{
	NSString *ident = [op oidForObject: self];
	return [NSMutableDictionary dictionaryWithObjectsAndKeys: /* @"Main Menu", @"title", @"main", @"systemMenu", */ 
				ident, @"id", (pullsDown)?@"YES":@"NO", @"pullsDown", nil];
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser 
{
    NSMutableDictionary *attributes = [self attributesFromProperties: parser];
    XMLNode *node = [[XMLNode alloc] initWithName: @"menu" value: @"" attributes: attributes elements: nil];
    NSMatrix *matrix = [self supermenu];
    NSArray *array = [matrix cells];
    NSEnumerator *en = [array objectEnumerator];
    id o = nil;
	XMLNode *itemsNode = [[XMLNode alloc] initWithName: @"items"];
	XMLNode *rootItem = [[XMLNode alloc] initWithName: @"menuItem"];
	XMLNode *rootMenu = [[XMLNode alloc] initWithName: @"menu"];
	XMLNode *rootItems = [[XMLNode alloc] initWithName: @"items"];
	XMLNode *keyMod = [[XMLNode alloc] initWithName: @"modifierMask"];

	// NSLog(@"supermenu = %@", supermenu);

	// Create structure...
	[keyMod addAttribute: @"key" value: @"keyEquivalentModifierMask"];
	[rootItem addElement: keyMod];

	[node addElement: itemsNode];
	[itemsNode addElement: rootItem];
	[rootItem addAttribute: @"id" value: [parser oidString]];
	[rootItem addAttribute: @"title" value: [self title]];
	[rootItem addElement: rootMenu];
	[rootMenu addElement: rootItems];	
	[rootMenu addAttribute: @"id" value: [parser oidString]];
	[rootMenu addAttribute: @"title" value: [self title]];
	[rootMenu addAttribute: @"key" value: @"submenu"];

    while ((o = [en nextObject]) != nil)
    {
    	XMLNode *itemNode = [o toXMLWithParser: parser];
    	NSString *ident = [parser oidForObject: o];

#ifdef DEBUG    	
    	NSLog(@"o = %@", o);
#endif
    	[itemNode addAttribute: @"id" value: ident];
		[rootItems addElement: itemNode];    	
    }

    // Add connections...
    [parser addConnectionsForObject: self
					    	 toNode: node];
    
    return node;
}

@end