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

// This file is part of GNUstep

#import <Foundation/Foundation.h>

#import "NSIBConnector.h"
#import "OidProvider.h"
#import "XMLNode.h"

@implementation NSIBOutletConnector (toXML)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)p
{
	XMLNode *node = [[XMLNode alloc] initWithName: @"outlet"];

	[node addAttribute: @"property" value: [self label]];
	[node addAttribute: @"target" value: [p oidForObject: [self source]]];
	[node addAttribute: @"id" value: [p oidString]];

	return node;
}

@end

@implementation NSIBControlConnector (toXML)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)p
{
	XMLNode *node = [[XMLNode alloc] initWithName: @"action"];

	[node addAttribute: @"selector" value: [self label]];
	[node addAttribute: @"target" value: [p oidForObject: [self source]]];
	[node addAttribute: @"id" value: [p oidString]];
	
	return node;
}

@end

@implementation NSIBConnector (toXML)

- (id) source
{
	return source;
}

- (id) destination
{
	return destination;
}

- (NSString *) label
{
	return label;
}

@end