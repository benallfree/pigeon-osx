//
//  TimerApplication.m
//  Pigeon Timer
//
//  Created by jenkins on 7/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "TimerApplication.h"

@implementation TimerApplication

-(void) hide:(id)sender
{
    AXUIElementRef frontWindow = NULL;
    // it failed -- maybe no main window (yet)
    if (frontWindow)
    {
        NSLog(@"window found");
        CFRelease(frontWindow);
    }
    else
    {
        NSLog(@"no window found");
        [super hide:self];
    }

}
@end
