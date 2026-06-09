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
    return [self processObjectWithParser: parser];
}

@end
