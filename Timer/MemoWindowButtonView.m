//
//  MemoWindowButtonView.m
//  Timer
//
//  Created by jenkins on 6/22/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "MemoWindowButtonView.h"

@implementation MemoWindowButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (BOOL) performKeyEquivalent:(NSEvent *)key
{
    if (([key modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask)
    {
        if (key.keyCode == 36) {
            [[self window] orderOut:self];
        }

    }
    
    [super performKeyEquivalent:key];
    return NO;
}
@end
