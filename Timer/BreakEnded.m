//
//  BreakEnded.m
//  Timer
//
//  Created by jenkins on 6/26/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "BreakEnded.h"
#import "AppDelegate.h"

@implementation BreakEnded


/**
 *  creates window from nib
 *
 *  @return NSWindow
 */
+(BreakEnded *) getWindow
{
    NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"BreakEnded" ];
    BreakEnded * item = (BreakEnded *)controller.window;
    return item;
    
}
/**
 *  handler when stop button is pressed
 *
 *  @param sender <#sender description#>
 */
-(IBAction) stop:(id)sender
{
    
    AppDelegate *delegate = (AppDelegate *)[NSApp delegate];
    
    [delegate uncheckActive];
    [delegate resetPomoTimer];
    [self close];
    [NSApp hide:self];
    
}
/**
 *  handler when start Next Pomodoro is pressed
 *
 *  @param sender <#sender description#>
 */
-(IBAction) startNextPomodoro:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[NSApp delegate];
    [delegate.long_timer invalidate];
    [delegate.short_timer invalidate];

    [delegate startNextPomo:YES];
    [self close];
    [NSApp hide:self];
    
}

@end
