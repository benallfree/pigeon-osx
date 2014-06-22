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
    NSLog(@"%d", key.keyCode);
     if (key.keyCode == 36) {
         return NO;
     }
    [super performKeyEquivalent:key];
    return YES;
}
@end
