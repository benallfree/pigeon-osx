//
//  AppDelegate.h
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kShortBreak 1
#define kLongBreak  2
#define kPomoInProgress 3
#define kDoingNothing 4

@interface AppDelegate : NSObject <NSApplicationDelegate>


// status item stuff
@property (atomic, strong) NSStatusItem         *timerStatusItem;
@property (atomic, strong) NSImage              *timerStatusImage;
@property (atomic, strong) NSImage              *timerStatusHighlightImage;
@property (atomic, strong) IBOutlet NSMenu               *timerStatusMenu;
@property (atomic, strong) IBOutlet NSMenuItem               *mute;
@property (atomic, strong) IBOutlet NSMenuItem               *active;
@property (atomic, strong) IBOutlet NSMenuItem               *report;
@property (atomic, strong) IBOutlet NSMenuItem               *enterLog;
@property (atomic, strong) IBOutlet NSMenuItem               *Preferences;
@property (atomic, strong) IBOutlet NSMenuItem               *quit;

@property (atomic, strong)  NSWindow *window;
@property (atomic, strong)  NSWindow *pref_window;
@property (atomic, strong)  NSWindow *break_started;
@property (atomic, strong)  NSWindow *break_ended;
@property (atomic, strong)  NSWindowController *windowctrl;
@property (atomic, strong)  NSTimer *timer;
@property (atomic, strong)  NSTimer *pomo_timer;
@property (atomic, strong)  NSTimer *short_timer;
@property (atomic, strong)  NSTimer *long_timer;
@property (atomic, strong)  NSTimer *timer_updater;
@property (atomic, strong)  NSWindow *moreClient;
@property (atomic, strong)  NSString *breakTimerStr;
@property (atomic, strong)  NSString *pomodoroTimerStr;
@property (atomic, readwrite)  NSInteger minutes;
@property (atomic, readwrite)  NSInteger seconds;
@property (atomic, readwrite)  NSInteger totalPomodoro;
@property (atomic, readwrite)  NSInteger currentStatus;

@property (retain) id eventMonitor;


//setsup status item related stuff.
- (void) setupStatusItem;
- (IBAction) menuClicked:(id)sender;
- (void) windowClosed:(id)sender;
- (void) alertMemoBox;
- (void) startTimer;
- (void) resetPomoTimer;
- (void) startNextPomo:(BOOL)startMemo;
- (void) shortBreakStarted;
- (void) BreakEnded;
- (void) longBreakStarted;
- (void) uncheckActive;
- (void) loadPreferences;
@end
