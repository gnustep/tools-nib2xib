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

#import "NSMenuItem_Additions.h"
#import "NSString_Additions.h"
#import "NIBParser.h"
#import "NSObject_KeyExtraction.h"

@implementation NSMenu (toXML)

- (NSSet *) keysForObject
{
    NSSet *keys = [self keysForObject];
    NSMutableSet *set = [NSMutableSet setWithSet: keys];
    [set addObject: @"subviews"];
    return set;
}

- (NSNode *) toXMLWithParser: (id<OidProvider>)parser
{
    
}

- (NSSize) contentSize
{
    // NSSize size = [self contentSize];
    return NSZeroSize;
}

- (void) setContentSize: (NSSize)size
{
    // [self setContentSize: size];
}

@end