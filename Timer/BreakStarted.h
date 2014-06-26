//
//  BreakStarted.h
//  Timer
//
//  Created by jenkins on 6/26/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BreakStarted : NSWindow

+(BreakStarted *) getWindow;
-(IBAction) dismiss:(id)sender;
-(IBAction) stop:(id)sender;
-(IBAction) startNextPomodoro:(id)sender;
@end
