//
//  AppDelegate.h
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


// status item stuff
@property (atomic, strong) NSStatusItem         *timerStatusItem;
@property (atomic, strong) NSImage              *timerStatusImage;
@property (atomic, strong) NSImage              *timerStatusHighlightImage;
@property (atomic, strong) IBOutlet NSMenu               *timerStatusMenu;
@property (atomic, strong) IBOutlet NSMenuItem               *active;
@property (atomic, strong) IBOutlet NSMenuItem               *report;
@property (atomic, strong) IBOutlet NSMenuItem               *enterLog;
@property (atomic, strong) IBOutlet NSMenuItem               *Preferences;
@property (atomic, strong) IBOutlet NSMenuItem               *quit;

@property (atomic, strong)  NSWindow *window;
@property (atomic, strong)  NSWindow *pref_window;
@property (atomic, strong)  NSWindowController *windowctrl;
@property (atomic, strong)  NSTimer *timer;
@property (atomic, strong)  NSWindow *moreClient;
@property (retain) id eventMonitor;


//setsup status item related stuff.
- (void) setupStatusItem;
- (IBAction) menuClicked:(id)sender;
- (void) windowClosed:(id)sender;
- (void) alertMemoBox;
- (void) startTimer;
- (void) uncheckActive;
@end
