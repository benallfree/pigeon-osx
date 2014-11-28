//
//  BreakStarted.m
//  Timer
//
//  Created by jenkins on 6/26/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "BreakStarted.h"
#import "Appdelegate.h"

@implementation BreakStarted

/**
 *  creates window from nib
 *
 *  @return NSWindow
 */
+(BreakStarted *) getWindow
{
    NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"BreakStarted" ];
    BreakStarted * item = (BreakStarted *)controller.window;
    return item;

}

/**
 *  handler when dismiss button is pressed
 *
 *  @param sender <#sender description#>
 */
-(IBAction) dismiss:(id)sender
{
    [self close];
    [NSApp hide:self];
    
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
    [delegate.enterLog setAction:nil];

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
