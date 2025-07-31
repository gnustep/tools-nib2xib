# Programmatic Attribute Extraction Enhancements for nib2xib

## Overview

This document outlines the enhancements made to the nib2xib project to make attribute extraction from nib file objects completely programmatic and comprehensive.

## Key Enhancements

### 1. Enhanced Runtime Introspection

**New Methods Added:**
- `allAttributeKeysFromMethods`: Uses classic Objective-C runtime to discover getter methods
- `dynamicAttributeKeys`: Provides a curated list of important attributes to always check

**Benefits:**
- Automatically discovers new attributes as classes evolve
- Reduces manual maintenance of attribute lists
- Ensures comprehensive coverage of object properties
- Compatible with OPENSTEP 4.2 classic runtime

### 2. Type-Aware Attribute Processing

**New AttributeType Enumeration:**
```objectivec
typedef enum {
    AttributeTypeUnknown = 0,
    AttributeTypeObject,
    AttributeTypeString,
    AttributeTypeNumber,
    AttributeTypeBoolean,
    AttributeTypeRect,
    AttributeTypeSize,
    AttributeTypePoint,
    AttributeTypeColor,
    AttributeTypeFont,
    AttributeTypeMask
} AttributeType;
```

**New Methods:**
- `attributeTypeForKey:onObject:`: Programmatically determines attribute type
- `extractValueForKey:usingType:`: Type-safe value extraction
- `shouldProcessKey:withValue:`: Intelligent filtering of attributes

**Benefits:**
- Proper handling of different data types
- Type-safe value extraction prevents runtime errors
- Intelligent filtering reduces XML bloat

### 3. Improved Processing Logic

**Enhanced `processObjectWithParser:` method:**
- Uses programmatic type detection
- Handles all attribute types systematically
- Provides better error handling and logging

**Key Improvements:**
- Automatic detection of geometric types (NSRect, NSSize, NSPoint)
- Proper handling of boolean attributes with prefix removal
- Smart processing of mask values (especially autoresizing masks)
- Comprehensive object relationship handling

### 4. OPENSTEP 4.2 Compatibility

**Classic Objective-C Runtime Support:**
- Uses only pre-2.0 Objective-C features
- Compatible with `class_nextMethodList()` and classic method introspection
- No dependency on properties or modern runtime features
- All variable declarations moved to method tops for C89/C90 compliance

## Usage Examples

### Basic Attribute Discovery

```objectivec
NSButton *button = [[NSButton alloc] init];
NSSet *keys = [button keysForObject];
NSLog(@"Found %lu attributes", (unsigned long)[keys count]);
```

### Type-Aware Processing

```objectivec
AttributeType type = [NSObject attributeTypeForKey: @"frame" onObject: myView];
id value = [myView extractValueForKey: @"frame" usingType: type];
```

### XML Generation

```objectivec
// The enhanced processObjectWithParser: method automatically:
// 1. Discovers all attributes
// 2. Determines their types
// 3. Extracts values safely
// 4. Generates appropriate XML
XMLNode *xmlNode = [myObject processObjectWithParser: parser];
```

## Technical Details

### Runtime Property Discovery

The system now uses two complementary approaches compatible with OPENSTEP 4.2:

1. **Method Analysis**: Uses `class_nextMethodList()` to find getter methods
2. **Method Scanning**: Analyzes setter methods to infer additional properties

**OPENSTEP Compatibility:**
- Uses only classic Objective-C runtime features
- No dependency on Objective-C 2.0 properties or modern runtime
- Compatible with `class_nextMethodList()` and traditional method introspection

### Type Detection Algorithm

The type detection follows this hierarchy:

1. **Name-based detection**: Analyzes attribute names for common patterns
2. **Method signature analysis**: Uses `NSMethodSignature` to determine return types
3. **Default fallback**: Treats unknown types as objects

### Performance Considerations

- Method lists are analyzed using classic runtime functions
- Type detection is performed once per attribute
- Intelligent filtering reduces processing overhead
- Compatible with OPENSTEP 4.2 performance characteristics

## Files Modified

### Core Files
- `NSObject_KeyExtraction.h`: Enhanced interface with new methods and types
- `NSObject_KeyExtraction.m`: Complete rewrite with programmatic approach
- `XMLNode.h`: Added `nodeForPoint:type:` method declaration

### Test Files
- `test_compile.m`: Simple compilation and functionality test
- `TestMakefile`: Build system for testing enhancements

## Backward Compatibility

All existing functionality is preserved:
- Original method signatures unchanged
- Existing skipped keys and classes still respected
- XML output format remains compatible

## Benefits Summary

1. **Comprehensive Coverage**: Automatically discovers all object attributes
2. **Type Safety**: Proper handling of different data types
3. **Maintainability**: Reduced manual attribute list maintenance  
4. **Extensibility**: Easy to add new attribute types and processing logic
5. **Robustness**: Better error handling and edge case management
6. **OPENSTEP Compliance**: Compatible with classic Objective-C runtime and OPENSTEP 4.2

## Future Enhancements

Potential areas for further improvement:

1. **Custom Attribute Processors**: Plugin system for specialized attribute handling
2. **Performance Optimization**: Caching of discovered attributes across sessions
3. **Enhanced Type Detection**: More sophisticated analysis of complex types
4. **Validation System**: Verification of extracted attributes against known schemas
