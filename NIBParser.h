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
#import "OidProvider.h"

@class NSArray;
@class NSDictionary;
@class NSMutableDictionary;
@class NSMutableArray;
@class NSString;
@class XMLDocument;

@interface NIBParser : NSObject <OidProvider>
{
	NSMutableDictionary *_objectsDictionary;
	NSMutableDictionary *_classesDictionary;
	NSArray *_connections;
	id _object;
	id _rootObject;
	NSMapTable *_oidTable;
	NSMapTable *_nameTable;
	NSMapTable *_objectTable;

	XMLDocument *_document;
}

- (id) initWithNibNamed: (NSString *)nibNamed;
- (id) parse;

@end