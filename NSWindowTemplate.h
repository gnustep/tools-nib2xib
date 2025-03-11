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

#import "XMLParsing.h"
#import "NSObject_KeyExtraction.h"

@class XMLNode;

typedef struct _GSWindowTemplateFlags
{
    unsigned int isHiddenOnDeactivate:1;
    unsigned int isNotReleasedOnClose:1;
    unsigned int isDeferred:1;
    unsigned int isOneShot:1;
    unsigned int isVisible:1;
    unsigned int wantsToBeColor:1;
    unsigned int dynamicDepthLimit:1;
    unsigned int autoPositionMask:6;
    unsigned int savePosition:1;
    unsigned int style:2;
    unsigned int _unused2:3;
    unsigned int isNotShadowed:1;
    unsigned int autorecalculatesKeyViewLoop:1;
    unsigned int _unused:11;
} GSWindowTemplateFlags;


@interface NSWindowTemplate : NSObject
{
    NSRect windowRect;
    int windowStyleMask;
    int windowBacking;
    NSString *windowTitle;
    NSString *viewClass;
    NSString *windowClass;
    id windowView;
    NSWindow *realObject;
    id extension;
    NSSize minSize;
    GSWindowTemplateFlags wtFlags;
    NSRect screenRect;
}
@end

@interface NSWindowTemplate (Methods)

- (int) interfaceStyle;
- (void) setInterfaceStyle:(int)fp16;

- (NSRect) windowRect;
- (int) windowStyleMask;
- (int) windowBacking;
- (NSString *) windowTitle;
- (NSString *) viewClass;
- (NSString *) windowClass;
- (id) windowView;
- (id) realObject;
- (NSSize) minSize;
- (GSWindowTemplateFlags) wtFlags;
- (NSRect) screenRect;

@end