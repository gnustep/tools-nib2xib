// NSBox Additions implementation
// 
//
// Author:      Gregory John Casamento
// Date:        2024
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "NSBox_Additions.h"
#import "NSString_Additions.h"
#import "NIBParser.h"
#import "NSObject_KeyExtraction.h"
#import "NSView_Additions.h"

#import "XMLNode.h"

@implementation NSBox (toXML)

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser
{
    NSString *className = NSStringFromClass([self class]);
    NSString *tagName = [className classNameToTagName];
    XMLNode *boxNode = [[XMLNode alloc] initWithName: tagName];
    NSView *contentView = [self contentView]; 
    XMLNode *contentViewNode = [contentView toXMLWithParser: parser];
    XMLNode *contentNodeContainer = [[XMLNode alloc] initWithName: @"contentView"];

    [boxNode addAttribute: @"id" value: [parser oidForObject: self]];
    [boxNode addAttribute: @"title" value: [self title]];
    // [boxNode addAttribute: @"borderType" value: [self borderType]];
    // [boxNode addAttribute: @"boxType" value: [self boxType]];
    [boxNode addElement: contentNodeContainer];
    [contentNodeContainer addElement: contentViewNode];
    
    return boxNode;
}

@end