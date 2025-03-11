/*
   Copyright (C) 2024 Free Software Foundation, Inc.

   Written by: Gregory John Casamento <greg.casamento@gmail.com>
   Date: 2024

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110 USA.
*/

#import <Foundation/Foundation.h>
#import <AppKit/NSCell.h>

#import "XMLNode.h"
#import "OidProvider.h"
#import "NSString_Additions.h"
#import "NSCell_Additions.h"

// NSCell+Additions.m
// Add method toXMLWithParser: to NSCell+Additions.m
// Method name: toXMLWithParser:
// Return type: XMLNode *
// Arguments: id<OidProvider> parser
// Code:
@implementation NSCell (Additions)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
     NSString *className = NSStringFromClass([self class]);
     NSString *tagName = [className classNameToTagName];
     XMLNode *cellNode = [[XMLNode alloc] initWithName: tagName];

     // [cellNode addAttribute: @"title" value: [self title]];
     // [cellNode addAttribute: @"type" value: [self type]];
     [cellNode addAttribute: @"id" value: [parser oidForObject: self]];

     [parser addConnectionsForObject: self
                              toNode: cellNode]; 
     return cellNode;
}

// Test in NSCell+AdditionsTests.m
@end