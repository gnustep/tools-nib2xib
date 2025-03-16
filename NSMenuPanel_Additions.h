// Header for NSMenuPanel_Additions.m
// Project: NSMenuPanel
// Created by: Your Name
// Date: 2023-10-01
// Description: This file contains the interface for NSMenuPanel and its methods.

//  * This file is part of GNUstep.
//  *
//  * This program is free software; you can redistribute it and/or modify
//  * it under the terms of the GNU General Public License as published by
//  * the Free Software Foundation; either version 3 of the License, or
//  * (at your option) any later version.

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "XMLNode.h"
#import "XMLParsing.h"
#import "OidProvider.h"
#import "NSMenuTemplate.h"
#import "NSView_Additions.h"

@interface NSMenuPanel : NSObject <XMLParsing>
{  
  NSString *title;
  NSMenuTemplate *menuTemplate;
  NSString *menuClassName;
  id view;
  id supermenu;
  id realObject;
  id extension;     
  NSPoint location;
  BOOL isWindowsMenu;
  BOOL isRequestMenu;
  BOOL isFontMenu;
  int interfaceStyle;
  BOOL pullsDown;
}

- (id) initWithTitle:(NSString *)t 
        menuClassName:(NSString *)menuClassName
        view:(id)view
        supermenu:(id)supermenu
        extension:(id)extension
        location:(NSPoint)location
        pullsDown:(BOOL)pullsDown
        isWindowsMenu:(BOOL)isWindowsMenu
        isRequestMenu:(BOOL)isRequestMenu
        isFontMenu:(BOOL)isFontMenu
        interfaceStyle:(int)interfaceStyle;
- (id) initWithTitle: (NSString *)t;
- (void) setTitle: (NSString *)title;
- (NSString *) title;
- (void) setMenuTemplate: (NSMenuTemplate *)menuTemplate;
- (NSMenuTemplate *) menuTemplate;
- (void) setMenuClassName: (NSString *)className;
- (NSString *) menuClassName;
- (void) setView: (id)view;
- (id) view;
- (void) setSupermenu: (id)supermenu;
- (id) supermenu;
- (void) setRealObject: (id)realObject;
- (id) realObject;
- (void) setExtension: (id)extension;
- (id) extension;
- (void) setLocation: (NSPoint)location;
- (NSPoint) location;
- (void) setIsWindowsMenu: (BOOL)flag;
- (BOOL) isWindowsMenu;
- (void) setIsRequestMenu: (BOOL)flag;
- (BOOL) isRequestMenu;
- (void) setIsFontMenu: (BOOL)flag;
- (BOOL) isFontMenu;
- (void) setInterfaceStyle: (int)style;
- (int) interfaceStyle;
- (void) setPullsDown: (BOOL)flag;
- (BOOL) pullsDown;

@end
// End of NSMenuPanel_Additions.h