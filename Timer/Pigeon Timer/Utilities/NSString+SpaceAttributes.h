//
//  NSString+SpaceAttributes.h
//  Pigeon Timer
//
//  Created by Munir Ahmed on 19/02/2020.
//  Copyright © 2020 GreatBasinGroup. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SpaceAttributes)

- (NSAttributedString *)stringByAddingSpaceAttributes:(CGFloat)characterSpace;

@end

NS_ASSUME_NONNULL_END
