//
//  MemoWindowButtonView.m
//  Timer
//
//  Created by jenkins on 6/22/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "MemoWindowButtonView.h"
#import "MemoWindow.h"

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

int count = 0;
- (BOOL) performKeyEquivalent:(NSEvent *)key
{
    NSLog(@"%d", key.type);
    if (([key modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask)
    {
        if (key.keyCode == 36) {
            [(MemoWindow *)[self window] OK:self];
        }
        return YES;

    }
    
    [super performKeyEquivalent:key];
    return NO;
}
@end
