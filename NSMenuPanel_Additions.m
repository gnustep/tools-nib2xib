// NSMenuPanel implementation for the NSMenuPanel category

#import "NSMenuPanel_Additions.h"
#import "XMLNode.h"
#import "NIBParser.h"
#import "NSMenuTemplate.h"
#import "NSIBConnector.h"
#import "OidProvider.h"

@implementation NSMenuPanel (Additions)
- (XMLNode *) toXMLWithParser: (id<OidProvider>)p
{
    XMLNode *node = [[XMLNode alloc] initWithName: @"menu"];
    
    [node addAttribute: @"title" value: [self title]];
    [node addAttribute: @"class" value: [self menuClassName]];
    [node addAttribute: @"id" value: [p oidString]];
    
    if ([self supermenu])
        [node addAttribute: @"supermenu" value: [p oidForObject: [self supermenu]]];
    
    if ([self view])
        [node addAttribute: @"view" value: [p oidForObject: [self view]]];
    
    if ([self extension])
        [node addAttribute: @"extension" value: [p oidForObject: [self extension]]];
    
    if (!NSEqualPoints([self location], NSZeroPoint))
        [node addAttribute: @"location" value: NSStringFromPoint([self location])];
    
    if ([self isWindowsMenu])
        [node addAttribute: @"windowsMenu" value:@"YES"];
    
    if ([self isRequestMenu])
        [node addAttribute: @"requestMenu" value:@"YES"];
    
    if ([self isFontMenu])
        [node addAttribute: @"fontMenu" value:@"YES"];
    
    if ([self interfaceStyle] != 0)
        [node addAttribute: @"interfaceStyle" value:[NSString stringWithFormat:@"%d", [self interfaceStyle]]];
    
    return node;
}

// Initialize the NSMenuPanel with default values
- (id) initWithTitle:(NSString *)t 
                menuClassName:(NSString *)mc
                view:(id)v
                supermenu:(id)sm
                extension:(id)ext
                location:(NSPoint)loc
                pullsDown:(BOOL)pd
                isWindowsMenu:(BOOL)wm
                isRequestMenu:(BOOL)rm
                isFontMenu:(BOOL)fm
                interfaceStyle:(int)style
{
    if ((self = [super init])) 
    {
        title = [t copy];
        menuClassName = [mc copy];
        view = [v retain];
        supermenu = [sm retain];
        extension = [ext retain];
        location = loc;
        pullsDown = pd;
        isWindowsMenu = wm;
        isRequestMenu = rm;
        isFontMenu = fm;
        interfaceStyle = style;
    }
    return self;
}

// Convenience initializer for the NSMenuPanel
- (id) initWithTitle:(NSString *)t
{
       return [self initWithTitle:t
                menuClassName:@"NSMenu"
                view:nil
                supermenu:nil
                extension:nil
                location:NSZeroPoint
                pullsDown:NO
                isWindowsMenu:NO
                isRequestMenu:NO
                isFontMenu:NO
                interfaceStyle:0];
}

// Setters and getters
- (void) setTitle: (NSString *)aTitle
{
    title = aTitle;
}

- (NSString *) title
{
    return title;
}

- (void) setMenuClassName: (NSString *)aMenuClassName
{
    menuClassName = aMenuClassName;
}

- (NSString *) menuClassName
{
    return menuClassName;
}

- (void) setView: (id)aView
{
    view = aView;
}

- (id) view
{
    return view;
}

- (void) setExtension: (id)aExtension
{
    extension = aExtension;
}

- (id) extension
{
    return extension;
}

- (void) setSupermenu: (id)aSupermenu
{
    supermenu = aSupermenu;
}

- (id) supermenu
{
    return supermenu;
}

- (void) setLocation: (NSPoint)aLocation
{
    location = aLocation;
}

- (NSPoint) location
{
    return location;
}

- (void) setPullsDown: (BOOL)flag
{
    pullsDown = flag; // isPullsDown = pullsDown;
}

- (BOOL) isPullsDown
{
    return pullsDown;
}

- (void) setIsWindowsMenu: (BOOL)flag
{
    isWindowsMenu = flag;
}

- (BOOL) isWindowsMenu
{
    return isWindowsMenu;
}

- (void) setIsRequestMenu: (BOOL)flag
{
    isRequestMenu = flag;
}

- (BOOL) isRequestMenu
{
    return isRequestMenu;
}

- (void) setIsFontMenu: (BOOL)flag
{
    isFontMenu = flag;
}

- (BOOL) isFontMenu
{
    return isFontMenu;
}

- (void) setInterfaceStyle: (int)style
{
    interfaceStyle = style;
}

- (int) interfaceStyle
{
    return interfaceStyle;
}

- (void) setRealObject: (id)object
{
    realObject = object;
}

- (id) realObject
{
    return realObject;
}

- (void) dealloc
{
    [title release];
    [menuClassName release];
    [view release];
    [supermenu release];
    [extension release];
    
    [super dealloc];
}
@end