/* Copyright (C) 2026 Free Software Foundation, Inc.
 *
 * This file is part of GNUstep.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 */

#import <Foundation/NSObject.h>
#import <Foundation/NSGeometry.h>
#import <AppKit/NSView.h>

#import "XMLParsing.h"

@class NSArray;
@class NSDictionary;
@class NSString;

@interface NSClassSwapper : NSObject <XMLParsing>
{
    NSString *className;
    NSString *originalClassName;
    id template;
}

+ (void) setIsInInterfaceBuilder: (BOOL)flag;
+ (BOOL) isInInterfaceBuilder;
- (NSString *) className;
- (NSString *) originalClassName;
- (id) template;
- (id) realObject;

@end

@interface NSViewTemplate : NSView <XMLParsing>
{
    NSString *className;
    id realObject;
}

- (NSString *) className;
- (id) realObject;

@end

@interface NSTextTemplate : NSViewTemplate
@end

@interface NSTextViewTemplate : NSViewTemplate
@end

@interface NSCustomView : NSView <XMLParsing>
{
    NSString *className;
    NSString *extension;
    NSView *superview;
    NSView *view;
}

- (NSString *) className;
- (NSString *) extension;
- (id) realObject;
- (id) view;

@end

@interface NSCustomResource : NSObject <XMLParsing>
{
    NSString *className;
    NSString *resourceName;
}

- (NSString *) className;
- (NSString *) resourceName;

@end

@interface NSButtonImageSource : NSObject <XMLParsing>
{
    NSString *imageName;
}

- (NSString *) imageName;

@end

@interface NSPSMatrix : NSObject <XMLParsing>
@end

@interface NSNibAXAttributeConnector : NSObject <XMLParsing>
{
    NSString *attributeType;
    NSString *attributeValue;
    id destination;
    id source;
    NSString *label;
}

- (NSString *) attributeType;
- (NSString *) attributeValue;
- (id) destination;
- (id) source;
- (NSString *) label;

@end

@interface NSNibAXRelationshipConnector : NSNibAXAttributeConnector
@end

@interface NSNibBindingConnector : NSNibAXAttributeConnector
{
    NSDictionary *options;
    NSString *binding;
    NSString *keyPath;
    BOOL hasEstablishedConnection;
}

- (NSDictionary *) options;
- (NSString *) binding;
- (NSString *) keyPath;

@end

@interface NSIBUserDefinedRuntimeAttributesConnector : NSObject <XMLParsing>
{
    id object;
    NSArray *keyPaths;
    NSArray *values;
}

- (id) object;
- (NSArray *) keyPaths;
- (NSArray *) values;

@end
