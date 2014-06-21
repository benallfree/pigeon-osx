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
#import "CHCSVParser.h"

@implementation AppDelegate

/**
 *  application did finish notification
 *
 *  @param aNotification notification object
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //setup status item
    [self setupStatusItem];
    
    //setup default time interval for poping up memo window, if not set by user in preferences window.
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"];
    if (!number)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:10] forKey:@"timeInterval"];
    }
    
    //added esc key controller
    NSEvent* (^handler)(NSEvent*) = ^(NSEvent *theEvent) {
        NSWindow *targetWindow = theEvent.window;
        if (targetWindow == self.window) {
            if (theEvent.keyCode == 53) {
                [self.active setState:NSOnState];
                [self.window close];
                    return theEvent;
                }
            }

    
        NSEvent *result = theEvent;
        return result;
    };
    
  
    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];

    //popup the memo box.
    [self alertMemoBox];

}

/**
 *  starts the timer to relaunch memo box
 */
- (void) startTimer
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"];
    //otherewise activate the memo box
    [self.active setState:NSOnState];
    //Allocates and loads the images into the application which will be used for our NSStatusItem
    self.timerStatusImage = [NSImage imageNamed:@"red"];
    
    [self.timerStatusImage setSize:NSMakeSize(16, 16)];
    self.timerStatusHighlightImage =  self.timerStatusImage;
    
    //Sets the images in our NSStatusItem
    [self.timerStatusItem setImage:self.timerStatusImage];
    [self.timerStatusItem setAlternateImage:self.timerStatusHighlightImage];
    

    self.timer = [NSTimer scheduledTimerWithTimeInterval:[number intValue] target:self selector:@selector(alertMemoBox) userInfo:nil repeats:NO];
    
}

/**
 *  inactivate the memo box for popping up next time.
 */
- (void) uncheckActive
{
    
    [self.timer invalidate];
    [self.active setState:NSOffState];
    
    //Allocates and loads the images into the application which will be used for our NSStatusItem
    self.timerStatusImage = [NSImage imageNamed:@"timer"];
    
    [self.timerStatusImage setSize:NSMakeSize(16, 16)];
	self.timerStatusHighlightImage =  self.timerStatusImage;
    
	//Sets the images in our NSStatusItem
	[self.timerStatusItem setImage:self.timerStatusImage];
	[self.timerStatusItem setAlternateImage:self.timerStatusHighlightImage];
    
    

   
}

/**
 *  execute the active menu item
 */
-(void) handleActiveMenuItem
{
    //if it was checked, then uncheck and invalidate the timer
    if (self.active.state == NSOnState)
    {
        [self uncheckActive];
        
    }
    else
    {
        //otherewise activate the memo box
        [self.active setState:NSOnState];
        //Allocates and loads the images into the application which will be used for our NSStatusItem
        self.timerStatusImage = [NSImage imageNamed:@"red"];
        
        [self.timerStatusImage setSize:NSMakeSize(16, 16)];
        self.timerStatusHighlightImage =  self.timerStatusImage;
        
        //Sets the images in our NSStatusItem
        [self.timerStatusItem setImage:self.timerStatusImage];
        [self.timerStatusItem setAlternateImage:self.timerStatusHighlightImage];
        
        

        [self alertMemoBox];
        
    }
}

/**
 *  executes the report menu item
 */
-(void) handleReportMenuItem
{
    //popup save panel.
    NSSavePanel *save = [NSSavePanel savePanel];
    
    long result = [save runModal];
    
    //user made a selection
    if (result == NSOKButton){
        NSError *err;
        NSString *selectedFile = [[[save URL] path] stringByAppendingPathExtension:@"csv"];
        
        
        //get the CSV string from database
        NSArray *logs = [[TimerDatabase sharedInstance] getLogsAsCSV];
        
        //write to the file.
        NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:selectedFile append:NO];
         
         CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:','];
         for (NSArray *line in logs) {
             [writer writeLineOfFields:line];
         }
         [writer closeStream];
        
        //error?
        if (err)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:[NSString stringWithFormat:@"Logs couldn't be saved. %@", [err description]]];
            [alert runModal];
            return;
        }
        
        //success? clear database
        [[TimerDatabase sharedInstance] removeLogs];
        
    }
    
}
/**
 *  execute preference menu item.
 */
-(void) handlePreferenceMenuItem
{
    if (!self.pref_window)
    {
        NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"Preferences" ];
        self.pref_window = (NSWindow *)controller.window;
    }
    [self.pref_window center];
    self.pref_window.value = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeInterval"];
    [self.pref_window makeKeyAndOrderFront:self];
    [self.pref_window setLevel:NSFloatingWindowLevel];
    [NSApp activateIgnoringOtherApps:YES];

}
/**
 *  action listener for menu items
 *
 *  @param sender Object that trigger this function
 */
-(void) menuClicked:(id)sender
{
    //when clicked on active menu item
    if (sender == self.active)
    {
        [self handleActiveMenuItem];
    }
    //user clicked on report menu item.
    else if (sender == self.report)
    {
        [self handleReportMenuItem];
    }
    //if user hit enter log
    else if (sender == self.enterLog)
    {
        [self alertMemoBox];
    }
    //handle preference
    else if (sender == self.Preferences)
    {
        [self handlePreferenceMenuItem];
    }
    //quit
    else
    {
        [[NSApplication sharedApplication] terminate:self];
    }
}

/**
 *  when a window is closed.
 *
 *  @param sender <#sender description#>
 */

-(void) windowClosed:(id)sender
{
    if (sender == self.window)
    {
        self.window = nil;
    }
}


/**
 *  function to popup memo box.
 */
- (void) alertMemoBox
{
    [self.timer invalidate];
    self.timer = nil;
    
        if (!self.window)
        {
            self.windowctrl =  [MemoWindow loadMemoWindow];
            
            self.window = self.windowctrl.window;
        }
        ((MemoWindow *)self.window).clients = (NSMutableArray *) [[TimerDatabase sharedInstance] getClients];
    if (((MemoWindow *)self.window).selectedClient &&
        [((MemoWindow *)self.window).selectedClient length] > 0)
    {
        ((MemoWindow *)self.window).previousLogs = (NSMutableArray *) [[TimerDatabase sharedInstance] getLogsForClient:((MemoWindow *)self.window).selectedClient];
    }

    ((MemoWindow *)self.window).memoStr = [[NSAttributedString alloc] initWithString:@""];
        [self.window center];
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSFloatingWindowLevel];
     
}

/**
 *  function to handle click on status icon 
 *
 *  @param sender <#sender description#>
 */
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
    self.timerStatusImage = [NSImage imageNamed:@"red"];
    
    [self.timerStatusImage setSize:NSMakeSize(16, 16)];
	self.timerStatusHighlightImage =  self.timerStatusImage;
    
	//Sets the images in our NSStatusItem
	[self.timerStatusItem setImage:self.timerStatusImage];
	[self.timerStatusItem setAlternateImage:self.timerStatusHighlightImage];
    
    
 	//Tells the NSStatusItem what menu to load
	[self.timerStatusItem setMenu:self.timerStatusMenu];
    
 	//Sets the tooptip for our item
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
	[self.timerStatusItem setToolTip:[NSString stringWithFormat:@"Timer v.%@", version]];
	//Enables highlighting
	[self.timerStatusItem setHighlightMode:YES];
    
    [self.active setState:NSOnState];

    
}



/**
 *  remove status bar and other deallocation.
 *
 *  @param sender sender
 *
 *  @return status either to terminate or delay the termination.
 */

- (NSApplicationTerminateReply) applicationShouldTerminate:(id)sender
{
    
    
        [[NSStatusBar systemStatusBar] removeStatusItem:self.timerStatusItem];
        
        return NSTerminateNow;
  
}


@end
