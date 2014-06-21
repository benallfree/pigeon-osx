//
//  PreferenceWindow.m
//  Timer
//
//  Created by jenkins on 6/21/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "PreferenceWindow.h"

@implementation PreferenceWindow

-(void) close
{
    [[NSUserDefaults standardUserDefaults] setObject:self.value forKey:@"timeInterval"];
    [self orderOut:self];
}
@end
