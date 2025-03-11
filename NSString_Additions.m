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

#import "NSString_Additions.h"
#import <Foundation/NSCharacterSet.h>

@implementation NSString (Additions)

- (NSString *) classNameToTagName
{
    NSString *modifiedString = self;

    // Check if the string starts with "NS"
    if ([self hasPrefix:@"NS"]) 
    {
        modifiedString = [self substringFromIndex: 2];
    }

    // Lowercase the first letter
    if ([modifiedString length] > 0) 
    {
        NSString *firstLetter = [[modifiedString substringToIndex: 1] lowercaseString];
        NSString *remainingString = [modifiedString substringFromIndex: 1];
        modifiedString = [firstLetter stringByAppendingString: remainingString];
    }

    return modifiedString;
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement 
{
    NSMutableString *result = [NSMutableString string];
    unsigned int searchLength = [self length];
    NSRange searchRange = NSMakeRange(0, searchLength);
    NSRange foundRange;

    if ([target length] == 0) 
    {
        // If target is an empty string, just return a copy of the original string
        return [self copy];
    }

    // Continue searching and replacing while the target is found
    while ((foundRange = [self rangeOfString:target options:0 range:searchRange]).location != NSNotFound) 
    {
        unsigned int newLocation = 0;

        // Append the part before the found target
        [result appendString:[self substringWithRange:NSMakeRange(searchRange.location, foundRange.location - searchRange.location)]];
        // Append the replacement string
        [result appendString:replacement];

        // Update the search range to the part after the found target
        newLocation = NSMaxRange(foundRange);
        searchRange = NSMakeRange(newLocation, searchLength - newLocation);
    }

    // Append the remaining part of the string after the last occurrence
    [result appendString:[self substringWithRange:searchRange]];

    return [NSString stringWithString:result];
}

- (NSString *)lowercaseFirstCharacter {
    // Extract the first character as a substring
    NSRange firstCharRange = NSMakeRange(0, 1);
    NSString *firstChar = [self substringWithRange:firstCharRange];

    if ([self length] == 0) {
        // Return an empty string if the input string is empty
        return [self copy];
    }

    // Check if the first character is uppercase
    if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:0]]) {
        // Convert to lowercase
        NSString *lowercasedFirstChar = [firstChar lowercaseString];

        // Append the rest of the string after the first character
        NSString *remainingString = [self substringFromIndex:1];

        // Return the newly constructed string
        return [lowercasedFirstChar stringByAppendingString:remainingString];
    }

    // If the first character is not uppercase, return the original string
    return [self copy];
}

@end