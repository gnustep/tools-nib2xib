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

@class NSString;
@class NSArray;
@class XMLNode;

@protocol OidProvider

// These methods are used to process OIDs in the NIB file.
- (NSString *) oidForObject: (id)obj;
- (NSString *) oidString;

// These methods are used to process connections in the NIB file.
- (NSArray *) connectionsWithSource: (id)src;
- (NSArray *) connectionsWithDestination: (id)dst;
- (NSArray *) connectionsWithObject: (id)obj;
- (void) addConnectionsForObject: (id)obj
						  toNode: (XMLNode *)node;

// These methods are used to process objects in the NIB file.						  
- (void) addProcessedObject: (id)object withNode: (XMLNode *)node;
- (NSArray *) objectsProcessed;
- (XMLNode *) processedObject: (id)object;
- (BOOL) isObjectProcessed: (id)object;

@end