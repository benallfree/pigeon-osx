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

@property (atomic, strong)  NSWindow *window;
@property (atomic, strong)  NSWindowController *windowctrl;
@property (atomic, strong)  NSTimer *timer;



//setsup status item related stuff.
- (void) setupStatusItem;
-(IBAction) menuClicked:(id)sender;
-(void) windowClosed:(id)sender;
- (void) alertMemoBox;

@end
