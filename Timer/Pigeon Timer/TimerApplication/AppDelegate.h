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
#define kPomoPaused 5
#define kDoingNothing 4

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>


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
@property (atomic, strong) IBOutlet NSMenuItem               *breakNow;
@property (atomic, strong) IBOutlet NSMenuItem               *pause;
@property (atomic, strong) IBOutlet NSTableView              *reportTable;
@property (atomic, strong)  NSWindow *window;
@property (atomic, strong)  NSWindow *pref_window;
@property (atomic, strong)  NSWindow *break_started;
@property (atomic, strong)  NSWindow *break_ended;
@property (atomic, strong)  NSWindow *check_loginItem;
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
@property (atomic, readwrite)  NSInteger totalSecondsToStay;
@property (atomic, readwrite)  NSInteger totalPomodoro;
@property (atomic, readwrite)  NSInteger currentStatus;
@property (atomic, readwrite)  NSInteger oldStatus;
@property (atomic, readwrite)  BOOL countdown_music;
@property (atomic, readwrite)  int countdown_playcount;
@property (atomic, readwrite)  BOOL preferencesWindowClosed;
@property (atomic, readwrite)  int countdown_minutes;
@property (atomic, readwrite)  BOOL playpopupSound;
@property (atomic, strong)  NSMutableArray *clientFromDB;
@property (atomic, strong)  IBOutlet NSWindow *reportWindow;
@property (retain) id eventMonitor;


-(IBAction) ReportOK:(id)sender;
-(IBAction) ReportCancel:(id)sender;

- (void) update;
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
- (void) addToLoginItem;
- (BOOL) itemExistsinLoginList;
- (void) setupApp;

@end
