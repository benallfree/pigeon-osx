//
//  NSString+SpaceAttributes.m
//  Pigeon Timer
//
//  Created by Munir Ahmed on 19/02/2020.
//  Copyright © 2020 GreatBasinGroup. All rights reserved.
//

#import "NSString+SpaceAttributes.h"

#import <AppKit/AppKit.h>


@implementation NSString (SpaceAttributes)

- (NSAttributedString *)stringByAddingSpaceAttributes:(CGFloat)characterSpace {
    NSString *str = [self stringByAppendingString:@" "];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSKernAttributeName value:@(characterSpace) range:NSMakeRange(0, str.length)];
    [attributedString setAlignment:NSTextAlignmentLeft range:NSMakeRange(0, str.length)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:14] range:NSMakeRange(0, str.length)];
    
    return attributedString;
}

@end
