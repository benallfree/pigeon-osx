//
//  AppDelegate.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "AppDelegate.h"
#import "MemoWindow.h"
#import "TimerDatabase.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self setupStatusItem];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(alertMemoBox) userInfo:nil repeats:YES];
    [self alertMemoBox];

}


-(void) menuClicked:(id)sender
{
    if (sender == self.active)
    {
        if (self.active.state == NSOnState)
        {
            [self.timer invalidate];
            [self.active setState:NSOffState];
        }
        else
        {
            [self.active setState:NSOnState];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(alertMemoBox) userInfo:nil repeats:YES];
            [self alertMemoBox];

        }
    }
    else
    {
        NSSavePanel *save = [NSSavePanel savePanel];
      
        int result = [save runModal];
        if (result == NSOKButton){
            NSError *err;
         NSString *selectedFile = [save filename];
            NSString *logs = [[TimerDatabase sharedInstance] getLogsAsCSV];
            [logs writeToFile:selectedFile atomically:YES encoding:NSUTF8StringEncoding error:&err];
            
            if (err)
            {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:[NSString stringWithFormat:@"Logs couldn't be saved. %@", [err description]]];
                 [alert runModal];
                 return;
            }
            [[TimerDatabase sharedInstance] removeLogs];
        
        }

    }
}


-(void) windowClosed:(id)sender
{
    if (sender == self.window)
    {
        self.window = nil;

    }
}

- (void) alertMemoBox
{
    if ([self.active state] == NSOnState)
    {
        if (!self.window)
        {
            self.windowctrl =  [MemoWindow loadMemoWindow];
            
            self.window = self.windowctrl.window;
        }
        [self.window center];
        [self.window makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];

    }
}

-(void) popup:(id)sender
{
    self.window = nil;
   [self.timerStatusItem popUpStatusItemMenu:self.timerStatusMenu];
   
}
//setsup status item related stuff.
- (void) setupStatusItem
{
    
    //Create the NSStatusBar and set its length
	self.timerStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	
	
	//Allocates and loads the images into the application which will be used for our NSStatusItem
    self.timerStatusImage = [NSImage imageNamed:@"timer"];
    
    //[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EgnyteDrive" ofType:@"icns"]];
    [self.timerStatusImage setSize:NSMakeSize(16, 16)];
	self.timerStatusHighlightImage =  self.timerStatusImage;
    
	//Sets the images in our NSStatusItem
	[self.timerStatusItem setImage:self.timerStatusImage];
	[self.timerStatusItem setAlternateImage:self.timerStatusHighlightImage];
    
    
 	//Tells the NSStatusItem what menu to load
	[self.timerStatusItem setMenu:self.timerStatusMenu];
    
    //[self.egnyteStatusItem setAction:@selector(iconClicked:)];
    //[self.egnyteStatusItem setTarget:self];
	//Sets the tooptip for our item
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
	[self.timerStatusItem setToolTip:[NSString stringWithFormat:@"Timer v.%@", version]];
	//Enables highlighting
	[self.timerStatusItem setHighlightMode:YES];
    
    [self.active setState:NSOnState];

    
}


@end
