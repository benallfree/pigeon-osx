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
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"];
    if (!number)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:10] forKey:@"timeInterval"];
    }
    [self alertMemoBox];

}

- (void) startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(alertMemoBox) userInfo:nil repeats:NO];
    
}
- (void) uncheckActive
{
    
    [self.timer invalidate];
    [self.active setState:NSOffState];
   
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
            [self alertMemoBox];

        }
    }
    else if (sender == self.report)
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
    else if (sender == self.enterLog)
    {
        [self alertMemoBox];
    }
    else if (sender == self.Preferences)
    {
        if (!self.pref_window)
        {
            
            NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"Preferences" ];
            self.pref_window = (NSWindow *)controller.window;
        }
        [self.pref_window center];
        [self.pref_window makeKeyAndOrderFront:self];
        [self.pref_window setLevel:NSFloatingWindowLevel];
        [NSApp activateIgnoringOtherApps:YES];

    }
    else
    {
        [[NSApplication sharedApplication] terminate:self];
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
        if (!self.window)
        {
            self.windowctrl =  [MemoWindow loadMemoWindow];
            
            self.window = self.windowctrl.window;
        }
        ((MemoWindow *)self.window).clients = (NSMutableArray *) [[TimerDatabase sharedInstance] getClients];
        [self.window center];
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSFloatingWindowLevel];
        [NSApp activateIgnoringOtherApps:YES];

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
