//
//  LaunchUpWindow.m
//  Pigeon Timer
//
//  Created by jenkins on 6/28/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "LaunchUpWindow.h"
#import "AppDelegate.h"
#import "NSBundle+LoginItem.h"

@implementation LaunchUpWindow

- (IBAction)doYES:(id)sender
{
    AppDelegate *del = [NSApp delegate];
    [[NSBundle mainBundle] addToLoginItems];
    if ([[NSBundle mainBundle] isLoginItem])
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"load_onStart"];
    [del setupApp];
    [NSApp hide:self];
    
}
- (IBAction)doNO:(id)sender
{
    [self close];
    AppDelegate *del = [NSApp delegate];
    [del setupApp];
    [NSApp hide:self];
    
}

@end
