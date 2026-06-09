/* Copyright (C) 2026 Free Software Foundation, Inc.
 *
 * This file is part of GNUstep.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "NSArchivedClasses.h"
#import "NSObject_KeyExtraction.h"
#import "NSString_Additions.h"
#import "OidProvider.h"
#import "XMLNode.h"

static BOOL NSClassSwapperIsInInterfaceBuilder = NO;

@implementation NSClassSwapper

+ (void) setIsInInterfaceBuilder: (BOOL)flag
{
    NSClassSwapperIsInInterfaceBuilder = flag;
}

+ (BOOL) isInInterfaceBuilder
{
    return NSClassSwapperIsInInterfaceBuilder;
}

- (NSString *) className
{
    return className;
}

- (NSString *) originalClassName
{
    return originalClassName;
}

- (id) template
{
    return template;
}

- (id) realObject
{
    if ([template respondsToSelector: @selector(realObject)])
    {
        return [template performSelector: @selector(realObject)];
    }
    return template;
}

- (NSString *) classNameForParser
{
    if (className != nil)
    {
        return className;
    }
    if (originalClassName != nil)
    {
        return originalClassName;
    }
    return @"NSClassSwapper";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node;

    if (template != nil)
    {
        if ([template respondsToSelector: @selector(toXMLWithParser:)])
        {
            node = [template performSelector: @selector(toXMLWithParser:)
                                  withObject: parser];
        }
        else
        {
            node = [template processObjectWithParser: parser];
        }

        if (node != nil)
        {
            if (className != nil)
            {
                [node addAttribute: @"customClass" value: className];
            }
            return node;
        }
    }

    return [self processObjectWithParser: parser];
}

@end

@implementation NSViewTemplate

- (NSString *) className
{
    return className;
}

- (id) realObject
{
    return realObject;
}

- (NSString *) classNameForParser
{
    if (className != nil)
    {
        return className;
    }
    return @"NSView";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node;

    if (realObject != nil)
    {
        if ([realObject respondsToSelector: @selector(toXMLWithParser:)])
        {
            node = [realObject performSelector: @selector(toXMLWithParser:)
                                    withObject: parser];
        }
        else
        {
            node = [realObject processObjectWithParser: parser];
        }

        if (node != nil && className != nil)
        {
            [node addAttribute: @"customClass" value: className];
        }
        return node;
    }

    return [self processObjectWithParser: parser];
}

@end

@implementation NSTextTemplate
@end

@implementation NSTextViewTemplate
@end

@implementation NSCustomView

- (NSString *) className
{
    return className;
}

- (NSString *) extension
{
    return extension;
}

- (id) realObject
{
    if (view != nil)
    {
        return view;
    }
    return self;
}

- (id) view
{
    return view;
}

- (NSString *) classNameForParser
{
    return @"NSCustomView";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node;

    if (view != nil && view != self)
    {
        if ([view respondsToSelector: @selector(toXMLWithParser:)])
        {
            node = [view performSelector: @selector(toXMLWithParser:)
                              withObject: parser];
        }
        else
        {
            node = [view processObjectWithParser: parser];
        }
    }
    else
    {
        node = [self processObjectWithParser: parser];
    }

    if (node != nil && className != nil)
    {
        [node addAttribute: @"customClass" value: className];
    }
    return node;
}

@end

@implementation NSCustomResource

- (NSString *) className
{
    return className;
}

- (NSString *) resourceName
{
    return resourceName;
}

- (NSString *) classNameForParser
{
    return @"NSCustomResource";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"customResource"];

    [node addAttribute: @"id" value: [parser oidForObject: self]];
    if (className != nil)
    {
        [node addAttribute: @"customClass" value: className];
    }
    if (resourceName != nil)
    {
        [node addAttribute: @"resourceName" value: resourceName];
    }
    return node;
}

@end

@implementation NSButtonImageSource

- (NSString *) imageName
{
    return imageName;
}

- (NSString *) classNameForParser
{
    return @"NSImage";
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"image"];

    [node addAttribute: @"id" value: [parser oidString]];
    if (imageName != nil)
    {
        [node addAttribute: @"name" value: imageName];
    }
    return node;
}

@end

@implementation NSPSMatrix

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    return nil;
}

@end

@implementation NSNibAXAttributeConnector

- (NSString *) attributeType
{
    return attributeType;
}

- (NSString *) attributeValue
{
    return attributeValue;
}

- (id) destination
{
    return destination;
}

- (id) source
{
    return source;
}

- (NSString *) label
{
    return label;
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"accessibilityConnection"];

    [node addAttribute: @"id" value: [parser oidString]];
    if (label != nil)
    {
        [node addAttribute: @"property" value: label];
    }
    if (attributeType != nil)
    {
        [node addAttribute: @"attributeType" value: attributeType];
    }
    if (attributeValue != nil)
    {
        [node addAttribute: @"attributeValue" value: attributeValue];
    }
    if (destination != nil)
    {
        [node addAttribute: @"destination" value: [parser oidForObject: destination]];
    }
    return node;
}

@end

@implementation NSNibAXRelationshipConnector
@end

@implementation NSNibBindingConnector

- (NSDictionary *) options
{
    return options;
}

- (NSString *) binding
{
    return binding;
}

- (NSString *) keyPath
{
    return keyPath;
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"binding"];

    [node addAttribute: @"id" value: [parser oidString]];
    if (binding != nil)
    {
        [node addAttribute: @"name" value: binding];
    }
    if (keyPath != nil)
    {
        [node addAttribute: @"keyPath" value: keyPath];
    }
    if (destination != nil)
    {
        [node addAttribute: @"destination" value: [parser oidForObject: destination]];
    }
    return node;
}

@end

@implementation NSIBUserDefinedRuntimeAttributesConnector

- (id) object
{
    return object;
}

- (NSArray *) keyPaths
{
    return keyPaths;
}

- (NSArray *) values
{
    return values;
}

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"userDefinedRuntimeAttributes"];
    NSEnumerator *keyEnum;
    NSEnumerator *valueEnum;
    NSString *keyPath;
    id value;

    [node addAttribute: @"id" value: [parser oidString]];
    if (object != nil)
    {
        [node addAttribute: @"destination" value: [parser oidForObject: object]];
    }

    keyEnum = [keyPaths objectEnumerator];
    valueEnum = [values objectEnumerator];
    while ((keyPath = [keyEnum nextObject]) != nil)
    {
        XMLNode *attribute = [[XMLNode alloc] initWithName: @"userDefinedRuntimeAttribute"];

        value = [valueEnum nextObject];
        [attribute addAttribute: @"keyPath" value: keyPath];
        if (value != nil)
        {
            [attribute addAttribute: @"value" value: [value description]];
        }
        [node addElement: attribute];
    }

    return node;
}

@end
