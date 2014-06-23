//
//  PreferenceWindow.m
//  Timer
//
//  Created by jenkins on 6/21/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "PreferenceWindow.h"
#import "AppDelegate.h"

@implementation PreferenceWindow

-(void) OK:(id)sender
{
    AppDelegate *app = (AppDelegate *)[NSApp delegate];
    
    self.value = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"];
    if ([app.active state] == NSOnState)
    {
        if (app.timer){
            [app.timer invalidate];
            app.timer = [NSTimer scheduledTimerWithTimeInterval:[self.value  intValue] target:app selector:@selector(alertMemoBox) userInfo:nil repeats:NO];
        }
    }
    [self orderOut:self];
    [app alertMemoBox];
}

-(void) close
{
    [[NSUserDefaults standardUserDefaults] setObject:self.value forKey:@"timeInterval"];
    [self orderOut:self];
}
@end
 